$errorActionPreference = 'Stop'
Set-StrictMode -Version 'Latest'

$script:resourceModuleName = 'DomainMembership'

Describe "$script:resourceModuleName Tests" {
    BeforeAll {        
        $modulePath = Split-Path -Path $PSScriptRoot -Parent
        $moduleResourcesPath = Join-Path -Path $modulePath -ChildPath 'DscResources'
        $resourceFolderPath = Join-Path -Path $moduleResourcesPath -ChildPath $script:resourceModuleName
        $resourceModulePath = Join-Path -Path $resourceFolderPath -ChildPath "$script:resourceModuleName.psm1"
        Import-Module -Name $resourceModulePath -Force
    }

    InModuleScope $script:resourceModuleName {
        function Run-DomainMembershipComplianceTest
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
                $ActualDomainName
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

                    It 'Test-TargetResource should call Get-MachineDomainName' {
                        Assert-MockCalled -CommandName 'Get-MachineDomainName' -Scope 'Context'
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

                    It 'Get-TargetResource should call Get-MachineDomainName' {
                        Assert-MockCalled -CommandName 'Get-MachineDomainName' -Scope 'Context'
                    }

                    It 'Get-TargetResource should return the actual DomainName' {
                        $getTargetResourceResult.DomainName | Should -Be $ActualDomainName
                    }

                    if ($ShouldBeCompliant)
                    {
                        It 'Get-TargetResource should return 1 property' {
                            $getTargetResourceResult.Count | Should -Be 1
                        }

                        It 'Get-TargetResource should not return Reasons' {
                            $getTargetResourceResult.ContainsKey('Reasons') | Should -BeFalse
                        }
                    }
                    else
                    {
                        It 'Get-TargetResource should return 2 properties' {
                            $getTargetResourceResult.Count | Should -Be 2
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

        $reasonCodePrefix = "DomainMembership:DomainMembership:"

        $actualDomainName = 'ActualDomainName'
        Context "MOCK DOMAIN NAME - $actualDomainName" {
            Mock -CommandName 'Get-MachineDomainName' -MockWith { return $actualDomainName }

            $complianceTestParameters = @{
                ResourceParameters = @{
                    DomainName = 'ExpectedDomainName'
                }
                ShouldBeCompliant = $false
                ExpectedReasonCodes = @($reasonCodePrefix + "MachineDomainNameDoesNotMatchSpecified")
                ActualDomainName = $actualDomainName
            }

            Run-DomainMembershipComplianceTest @complianceTestParameters

            $complianceTestParameters = @{
                ResourceParameters = @{
                    DomainName = $actualDomainName
                }
                ShouldBeCompliant = $true
                ExpectedReasonCodes = @()
                ActualDomainName = $actualDomainName
            }

            Run-DomainMembershipComplianceTest @complianceTestParameters
        }
    }
}