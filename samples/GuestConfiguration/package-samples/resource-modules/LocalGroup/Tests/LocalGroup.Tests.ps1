$errorActionPreference = 'Stop'
Set-StrictMode -Version 'Latest'

$script:resourceModuleName = 'LocalGroup'

Describe "$script:resourceModuleName Tests" {
    BeforeAll {        
        $modulePath = Split-Path -Path $PSScriptRoot -Parent
        $moduleResourcesPath = Join-Path -Path $modulePath -ChildPath 'DscResources'
        $resourceFolderPath = Join-Path -Path $moduleResourcesPath -ChildPath $script:resourceModuleName
        $resourceModulePath = Join-Path -Path $resourceFolderPath -ChildPath "$script:resourceModuleName.psm1"
        Import-Module -Name $resourceModulePath -Force
    }

    InModuleScope $script:resourceModuleName {
        function Run-LocalGroupComplianceTest
        {
            param
            (
                [Parameter(Mandatory = $true)]
                [Hashtable]
                $ResourceParameters,

                [Parameter(Mandatory = $true)]
                [Boolean]
                $ShouldBeCompliant,

                [Parameter()]
                [String[]]
                $ExpectedReasonCodes,

                [Parameter()]
                [String[]]
                $ActualMembers
            )

            $contextTitle = "PARAMETERS - "
            $resourceParameterStrings = @()

            foreach ($resourceParameterName in $ResourceParameters.Keys)
            {
                $resourceParameterStrings += ($resourceParameterName + ": $($ResourceParameters[$resourceParameterName])")
            }

            $contextTitle += $resourceParameterStrings -join ", "

            Context $contextTitle {
                Context 'Test-TargetResource' {
                    It 'Test-TargetResource should not throw' {
                        { $null = Test-TargetResource @ResourceParameters } | Should -Not -Throw
                    }

                    $testTargetResourceResult = Test-TargetResource @ResourceParameters

                    It 'Test-TargetResource should call Get-LocalGroupMembers' {
                        Assert-MockCalled -CommandName 'Get-LocalGroupMembers' -Scope 'Context'
                    }

                    It "Test-TargetResource should return $ShouldBeCompliant" {
                        $testTargetResourceResult | Should -Be $ShouldBeCompliant
                    }
                }

                Context 'Get-TargetResource' {
                    It 'Get-TargetResource should not throw' {
                        { $null = Get-TargetResource @ResourceParameters } | Should -Not -Throw
                    }

                    $getTargetResourceResult = Get-TargetResource @ResourceParameters

                    It 'Get-TargetResource should call Get-LocalGroupMembers' {
                        Assert-MockCalled -CommandName 'Get-LocalGroupMembers' -Scope 'Context'
                    }

                    It 'Get-TargetResource should return the specified GroupName' {
                        $getTargetResourceResult.GroupName | Should -Be $ResourceParameters.GroupName
                    }

                    It 'Get-TargetResource should return the names of the actual members in the group as a semicolon-separated string' {
                        $getTargetResourceResult.Members | Should -Be ($ActualMembers -join '; ')
                    }

                    if ($ShouldBeCompliant)
                    {
                        It 'Get-TargetResource should return 2 properties' {
                            $getTargetResourceResult.Count | Should -Be 2
                        }

                        It 'Get-TargetResource should not return Reasons' {
                            $getTargetResourceResult.ContainsKey('Reasons') | Should -BeFalse
                        }
                    }
                    else
                    {
                        It 'Get-TargetResource should return 3 properties' {
                            $getTargetResourceResult.Count | Should -Be 3
                        }

                        It 'Get-TargetResource should return Reasons' {
                            $getTargetResourceResult.Reasons | Should -Not -Be $null
                        }

                        It "Get-TargetResource should return $($ExpectedReasonCodes.Count) Reasons" {
                            $getTargetResourceResult.Reasons.Count | Should -Be $ExpectedReasonCodes.Count
                        }

                        It "Get-TargetResource should return only the expected Reason Codes" {
                            $getTargetResourceResult.Reasons.Code | Should -Be $ExpectedReasonCodes
                        }
                    }
                }
            }
        }

        $reasonCodePrefix = "LocalGroup:LocalGroup:"
        $userList = @('User1', 'User2', 'User3')

        for ($numberActualUsers = 0; $numberActualUsers -le $userList.Count; $numberActualUsers++)
        {
            $actualMembers = @( $userList | Select-Object -First $numberActualUsers )

            $contextTitle = "MOCK GROUP MEMBERS - "

            if ($numberActualUsers -eq 0)
            {
                $contextTitle += "None"
            }
            else
            {
                $contextTitle += ($actualMembers -join ", ")
            }

            Context $contextTitle {
                Mock -CommandName 'Get-LocalGroupMembers' -MockWith { return $actualMembers }

                for ($numberExpectedUsers = 0; $numberExpectedUsers -le $userList.Count; $numberExpectedUsers++)
                {
                    $expectedMembers = @( $userList | Select-Object -First $numberExpectedUsers )

                    # Members
                    $complianceTestParameters = @{
                        ResourceParameters = @{
                            GroupName = 'Administrators'
                            Members = ($expectedMembers -join '; ')
                        }
                        ShouldBeCompliant = $true
                        ExpectedReasonCodes = @()
                        ActualMembers = $actualMembers
                    }

                    if ($numberActualUsers -eq 0 -and $numberExpectedUsers -ne 0)
                    {
                        $complianceTestParameters['ShouldBeCompliant'] = $false
                        $complianceTestParameters['ExpectedReasonCodes'] += ($reasonCodePrefix + "GroupEmptyWhenMembersExpected")
                    }
                    elseif ($numberActualUsers -ne 0 -and $numberExpectedUsers -eq 0)
                    {
                        $complianceTestParameters['ShouldBeCompliant'] = $false
                        $complianceTestParameters['ExpectedReasonCodes'] += ($reasonCodePrefix + "GroupNotEmptyWhenNoMembersExpected")
                    }
                    elseif ($numberActualUsers -ne $numberExpectedUsers)
                    {
                        $complianceTestParameters['ShouldBeCompliant'] = $false
                        $numUsersDifferent = $numberActualUsers - $numberExpectedUsers

                        if ($numUsersDifferent -gt 0)
                        {
                            for ($numReasonsToAdd = 0; $numReasonsToAdd -lt $numUsersDifferent; $numReasonsToAdd++)
                            {
                                $complianceTestParameters['ExpectedReasonCodes'] += ($reasonCodePrefix + "UnexpectedMemberFound")
                            }
                        }
                        else
                        {
                            $numUsersDifferent = $numUsersDifferent * -1
                            for ($numReasonsToAdd = 0; $numReasonsToAdd -lt $numUsersDifferent; $numReasonsToAdd++)
                            {
                                $complianceTestParameters['ExpectedReasonCodes'] += ($reasonCodePrefix + "ExpectedMemberMissing")
                            }
                        }
                    }

                    Run-LocalGroupComplianceTest @complianceTestParameters

                    # MembersToInclude
                    $complianceTestParameters = @{
                        ResourceParameters = @{
                            GroupName = 'Administrators'
                            MembersToInclude = ($expectedMembers -join '; ')
                        }
                        ShouldBeCompliant = $true
                        ExpectedReasonCodes = @()
                        ActualMembers = $actualMembers
                    }

                    if ($numberActualUsers -eq 0 -and $numberExpectedUsers -ne 0)
                    {
                        $complianceTestParameters['ShouldBeCompliant'] = $false
                        $complianceTestParameters['ExpectedReasonCodes'] += ($reasonCodePrefix + "GroupEmptyWhenMembersExpected")
                    }
                    elseif ($numberExpectedUsers -gt $numberActualUsers)
                    {
                        $complianceTestParameters['ShouldBeCompliant'] = $false
                        $numUsersDifferent = $numberExpectedUsers - $numberActualUsers
                        for ($numReasonsToAdd = 0; $numReasonsToAdd -lt $numUsersDifferent; $numReasonsToAdd++)
                        {
                            $complianceTestParameters['ExpectedReasonCodes'] += ($reasonCodePrefix + "IncludedMemberMissing")
                        }
                    }

                    Run-LocalGroupComplianceTest @complianceTestParameters

                    # MembersToExclude
                    $complianceTestParameters = @{
                        ResourceParameters = @{
                            GroupName = 'Administrators'
                            MembersToExclude = ($expectedMembers -join '; ')
                        }
                        ShouldBeCompliant = $true
                        ExpectedReasonCodes = @()
                        ActualMembers = $actualMembers
                    }

                    if ($numberActualUsers -ne 0 -and $numberExpectedUsers -gt 0)
                    {
                        $complianceTestParameters['ShouldBeCompliant'] = $false

                        if ($numberActualUsers -gt $numberExpectedUsers)
                        {
                            $numReasons = $numberExpectedUsers
                        }
                        else
                        {
                            $numReasons = $numberActualUsers
                        }
                        
                        for ($numReasonsToAdd = 0; $numReasonsToAdd -lt $numReasons; $numReasonsToAdd++)
                        {
                            $complianceTestParameters['ExpectedReasonCodes'] += ($reasonCodePrefix + "ExcludedMemberFound")
                        }
                    }

                    Run-LocalGroupComplianceTest @complianceTestParameters
                }
            }
        }
    }
}