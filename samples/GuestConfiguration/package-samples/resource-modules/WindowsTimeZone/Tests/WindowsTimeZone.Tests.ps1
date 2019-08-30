$errorActionPreference = 'Stop'
Set-StrictMode -Version 'Latest'

$script:resourceModuleName = 'WindowsTimeZone'

Describe "$script:resourceModuleName Tests" {
    BeforeAll {        
        $modulePath = Split-Path -Path $PSScriptRoot -Parent
        $moduleResourcesPath = Join-Path -Path $modulePath -ChildPath 'DscResources'
        $resourceFolderPath = Join-Path -Path $moduleResourcesPath -ChildPath $script:resourceModuleName
        $resourceModulePath = Join-Path -Path $resourceFolderPath -ChildPath "$script:resourceModuleName.psm1"
        Import-Module -Name $resourceModulePath -Force
    }

    InModuleScope $script:resourceModuleName {
        function Run-WindowsTimeZoneComplianceTest
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
                [String]
                $ActualTimeZone
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

                    It 'Test-TargetResource should call Get-CurrentTimeZoneDisplayName' {
                        Assert-MockCalled -CommandName 'Get-CurrentTimeZoneDisplayName' -Scope 'Context'
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

                    It 'Get-TargetResource should call Get-CurrentTimeZoneDisplayName' {
                        Assert-MockCalled -CommandName 'Get-CurrentTimeZoneDisplayName' -Scope 'Context'
                    }

                    It 'Get-TargetResource should return the IsSingleInstnace property with the specified value' {
                        $getTargetResourceResult.IsSingleInstnace | Should -Be $ResourceParameters.IsSingleInstnace
                    }

                    It 'Get-TargetResource should return the actual time zone' {
                        $getTargetResourceResult.TimeZone | Should -Be $ActualTimeZone
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

        $reasonCodePrefix = "WindowsTimeZone:WindowsTimeZone:"

        $actualTimeZone = 'ActualTimeZone'
        Context "MOCK DOMAIN NAME - $actualTimeZone" {
            Mock -CommandName 'Get-CurrentTimeZoneDisplayName' -MockWith { return $actualTimeZone }

            $complianceTestParameters = @{
                ResourceParameters = @{
                    IsSingleInstance = 'Yes'
                    TimeZone = 'ExpectedTimeZone'
                }
                ShouldBeCompliant = $false
                ExpectedReasonCodes = @($reasonCodePrefix + "UnexpectedTimeZone")
                ActualTimeZone = $actualTimeZone
            }

            Run-WindowsTimeZoneComplianceTest @complianceTestParameters

            $complianceTestParameters = @{
                ResourceParameters = @{
                    IsSingleInstance = 'Yes'
                    TimeZone = $actualTimeZone
                }
                ShouldBeCompliant = $true
                ExpectedReasonCodes = @()
                ActualTimeZone = $actualTimeZone
            }

            Run-WindowsTimeZoneComplianceTest @complianceTestParameters
        }
    }
}