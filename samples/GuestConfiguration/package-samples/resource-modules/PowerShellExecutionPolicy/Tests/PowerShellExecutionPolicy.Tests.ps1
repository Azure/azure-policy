$errorActionPreference = 'Stop'
Set-StrictMode -Version 'Latest'

Describe 'PowerShellExecutionPolicy Tests' {
    BeforeAll {
        $script:resourceModuleName = 'PowerShellExecutionPolicy'

        $modulePath = Split-Path -Path $PSScriptRoot -Parent
        $moduleResourcesPath = Join-Path -Path $modulePath -ChildPath 'DscResources'
        $resourceFolderPath = Join-Path -Path $moduleResourcesPath -ChildPath $script:resourceModuleName
        $resourceModulePath = Join-Path -Path $resourceFolderPath -ChildPath "$script:resourceModuleName.psm1"
        Import-Module -Name $resourceModulePath -Force
    }

    AfterAll {}

    InModuleScope $script:resourceModuleName {
        $reasonCodePrefix = "PowerShellExecutionPolicy:PowerShellExecutionPolicy:"
        $executionPolicyValues = @('AllSigned', 'Bypass', 'Default', 'RemoteSigned', 'Restricted', 'Undefined', 'Unrestricted')
        
        foreach ($expectedExecutionPolicyValue in $executionPolicyValues)
        {
            foreach ($actualExecutionPolicyValue in $executionPolicyValues)
            {
                Context "Expected execution policy is '$expectedExecutionPolicyValue'. Actual execution policy is '$actualExecutionPolicyValue'." {
                    Mock -CommandName 'Get-CurrentPowerShellExecutionPolicy' -MockWith { return $actualExecutionPolicyValue }

                    $resourceParameters = @{
                        IsSingleInstance = 'Yes'
                        ExecutionPolicy = $expectedExecutionPolicyValue
                    }

                    $shouldBeCompliant = $expectedExecutionPolicyValue -eq $actualExecutionPolicyValue

                    Context 'Test-TargetResource' {
                        It 'Test-TargetResource should not throw' {
                            { $null = Test-TargetResource @resourceParameters } | Should -Not -Throw
                        }
    
                        $testTargetResourceResult = Test-TargetResource @resourceParameters
    
                        It 'Test-TargetResource should call Get-CurrentPowerShellExecutionPolicy' {
                            Assert-MockCalled -CommandName 'Get-CurrentPowerShellExecutionPolicy' -Scope 'Context'
                        }
    
                        It "Test-TargetResource should return $shouldBeCompliant" {
                            $testTargetResourceResult | Should -Be $shouldBeCompliant
                        }
                    }

                    Context 'Get-TargetResource' {
                        It 'Get-TargetResource should not throw' {
                            { $null = Get-TargetResource @resourceParameters } | Should -Not -Throw
                        }
    
                        $getTargetResourceResult = Get-TargetResource @resourceParameters
    
                        It 'Get-TargetResource should call Get-CurrentPowerShellExecutionPolicy' {
                            Assert-MockCalled -CommandName 'Get-CurrentPowerShellExecutionPolicy' -Scope 'Context'
                        }
    
                        It 'Get-TargetResource should return the specified IsSingleInstance value' {
                            $getTargetResourceResult.IsSingleInstance | Should -Be $resourceParameters.IsSingleInstance
                        }
    
                        It 'Get-TargetResource should return the actual execution policy' {
                            $getTargetResourceResult.ExecutionPolicy | Should -Be $actualExecutionPolicyValue
                        }
    
                        if ($shouldBeCompliant)
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
    
                            It "Get-TargetResource should return 1 Reason" {
                                $getTargetResourceResult.Reasons.Count | Should -Be 1
                            }
    
                            It "Get-TargetResource should return only the expected Reason Codes" {
                                $getTargetResourceResult.Reasons.Code | Should -Be ($reasonCodePrefix + 'ExecutionPolicyDoesNotMatchExpected')
                            }
                        }
                    }
                }
            }
        }
    }
}