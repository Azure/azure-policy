$errorActionPreference = 'Stop'
Set-StrictMode -Version 'Latest'

$script:resourceModuleName = 'MachineUptime'

Describe "$script:resourceModuleName Tests" {
    BeforeAll {        
        $modulePath = Split-Path -Path $PSScriptRoot -Parent
        $moduleResourcesPath = Join-Path -Path $modulePath -ChildPath 'DscResources'
        $resourceFolderPath = Join-Path -Path $moduleResourcesPath -ChildPath $script:resourceModuleName
        $resourceModulePath = Join-Path -Path $resourceFolderPath -ChildPath "$script:resourceModuleName.psm1"
        Import-Module -Name $resourceModulePath -Force
    }

    InModuleScope $script:resourceModuleName {
        function Run-MachineUptimeComplianceTest
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
                [int]
                $ActualDaysSinceLastStart
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

                    It 'Test-TargetResource should call Get-CimInstance' {
                        Assert-MockCalled -CommandName 'Get-CimInstance' -Scope 'Context'
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

                    It 'Get-TargetResource should call Get-CimInstance' {
                        Assert-MockCalled -CommandName 'Get-CimInstance' -Scope 'Context'
                    }

                    It 'Get-TargetResource should return the actual number of days since last start' {
                        $getTargetResourceResult.NumberOfDays | Should -Be $ActualDaysSinceLastStart
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

        $reasonCodePrefix = "MachineUptime:MachineUptime:"

        $currentDate = Get-Date
        $actualDaysSinceLastStart = 7
        $mockOSObject = @{
            LastBootUpTime = $currentDate.AddDays($actualDaysSinceLastStart * -1)
        }
        
        Context "MOCK DAYS SINCE LAST START - $actualDaysSinceLastStart" {
            Mock -CommandName 'Get-CimInstance' -ParameterFilter { return $ClassName -eq 'Win32_Operatingsystem' } -MockWith { return $mockOSObject }

            $complianceTestParameters = @{
                ResourceParameters = @{
                    NumberOfDays = $actualDaysSinceLastStart - 3
                }
                ShouldBeCompliant = $false
                ExpectedReasonCodes = @($reasonCodePrefix + "MachineUptimeGreaterThanExpected")
                ActualDaysSinceLastStart = $actualDaysSinceLastStart
            }

            Run-MachineUptimeComplianceTest @complianceTestParameters

            $complianceTestParameters = @{
                ResourceParameters = @{
                    NumberOfDays = $actualDaysSinceLastStart + 3
                }
                ShouldBeCompliant = $true
                ExpectedReasonCodes = @()
                ActualDaysSinceLastStart = $actualDaysSinceLastStart
            }

            Run-MachineUptimeComplianceTest @complianceTestParameters
        }
    }
}
