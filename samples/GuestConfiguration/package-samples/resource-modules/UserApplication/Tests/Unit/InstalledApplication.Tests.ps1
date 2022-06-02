$repositoryRoot = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent
Import-Module -Name "$repositoryRoot/Configurations/Ignite/Windows/InstalledApplication_1_0/V1.0.0.0/Unsigned/Modules/UserApplication_1.0.0.1/DSCResources/InstalledApplication/InstalledApplication.psm1" -Force

InModuleScope 'InstalledApplication' {
    Describe 'InstalledApplication\Set-TargetResource' {
        It 'Should always throw' {
            { Set-TargetResource -Name 'Mock' } | Should -Throw
        }
    }

    Describe 'InstalledApplication\Get-TargetResource' {
        BeforeAll {
            $applicationItemsWithGuidName = Get-ChildItem -Path 'HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall' | Where-Object -FilterScript { $_.Name -match '{.+}$'}

            # Get the first correct application registry item that suits to be mocked.
            foreach ($application in $applicationItemsWithGuidName)
            {
                $mockExistingApplication = $application
                $mockExistingApplicationName = $application.GetValue('DisplayName')

                if (-not [System.String]::IsNullOrEmpty($mockExistingApplicationName))
                {
                    break
                }
            }

            $mockUnknownApplication = 'Unknown_55288e75-111d-4afa-a114-50f5d23e3674_MockedApplication'
        }

        Context 'When the system is in the desired state' {
            It 'Should return the state as present' {
                $result = Get-TargetResource -Name $mockExistingApplicationName
                $result.Ensure | Should -Be 'Present'
            }

            It 'Should return the same values as passed as parameters' {
                $result = Get-TargetResource -Name $mockExistingApplicationName
                $result.Name | Should -Be $mockExistingApplicationName
            }

            It 'Should return the correct values for the rest of the properties' {
                $result = Get-TargetResource -Name $mockExistingApplicationName
                $result.ApplicationInfo.Count | Should -Be 1
                $result.ApplicationInfo[0].DisplayName | Should -Be $mockExistingApplicationName
                $result.Reasons | Should -BeNullOrEmpty
            }
        }

        Context 'When the system is not in the desired state' {
            BeforeAll {
                Mock -CommandName Get-InstalledSoftware -MockWith {
                    return @($mockExistingApplication)
                }
            }

            Context 'When application should be installed' {
                It 'Should return the state as absent' {
                    $result = Get-TargetResource -Name $mockUnknownApplication
                    $result.Ensure | Should -Be 'Absent'
                }

                It 'Should return the same values as passed as parameters' {
                    $result = Get-TargetResource -Name $mockUnknownApplication
                    $result.Name | Should -Be $mockUnknownApplication
                }

                It 'Should return the correct values for the rest of the properties' {
                    $result = Get-TargetResource -Name $mockUnknownApplication
                    $result.ApplicationInfo.Count | Should -Be 1
                    $result.ApplicationInfo[0].DisplayName | Should -BeNullOrEmpty
                    $result.Reasons.Count | Should -Be 1
                    $result.Reasons[0].Code | Should -Be 'UserApplication:InstalledApplication:ApplicationMissing'
                    $result.Reasons[0].Phrase | Should -Be 'The following application(s) was not installed: ''Unknown_55288e75-111d-4afa-a114-50f5d23e3674_MockedApplication''.'
                }
            }

            Context 'When application should not be installed' {
                It 'Should return the state as present' {
                    $result = Get-TargetResource -Name $mockExistingApplicationName -Ensure 'Absent'
                    $result.Ensure | Should -Be 'Present'
                }

                It 'Should return the same values as passed as parameters' {
                    $result = Get-TargetResource -Name $mockExistingApplicationName -Ensure 'Absent'
                    $result.Name | Should -Be $mockExistingApplicationName
                }

                It 'Should return the correct values for the rest of the properties' {
                    $result = Get-TargetResource -Name $mockExistingApplicationName -Ensure 'Absent'
                    $result.ApplicationInfo.Count | Should -Be 1
                    $result.ApplicationInfo[0].DisplayName | Should -Be $mockExistingApplicationName
                    $result.Reasons.Count | Should -Be 1
                    $result.Reasons[0].Code | Should -Be 'UserApplication:InstalledApplication:ApplicationFound'
                    $result.Reasons[0].Phrase | Should -Be ('The following application(s) was installed: ''{0}''.' -f $mockExistingApplicationName)
                }
            }
        }

        Describe 'InstalledApplication\Test-TargetResource' {
            BeforeAll {
                $applicationItemsWithGuidName = Get-ChildItem -Path 'HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall' | Where-Object -FilterScript { $_.Name -match '{.+}$'}

                # Get the first correct application registry item that suits to be mocked.
                foreach ($application in $applicationItemsWithGuidName)
                {
                    $mockExistingApplication = $application
                    $mockExistingApplicationName = $application.GetValue('DisplayName')

                    if (-not [System.String]::IsNullOrEmpty($mockExistingApplicationName))
                    {
                        break
                    }
                }

                $mockUnknownApplication = 'Unknown_55288e75-111d-4afa-a114-50f5d23e3674_MockedApplication'
            }

            Context 'When the system is in the desired state' {
                It 'Should return the state as present' {
                    $result = Test-TargetResource -Name $mockExistingApplicationName
                    $result | Should -Be $true
                }
            }

            Context 'When the system is not in the desired state' {
                BeforeAll {
                    Mock -CommandName Get-InstalledSoftware -MockWith {
                        return @($mockExistingApplication)
                    }
                }

                Context 'When application should be installed' {
                    It 'Should return the state as absent' {
                        $result = Test-TargetResource -Name $mockUnknownApplication
                        $result | Should -Be $false
                    }
                }

                Context 'When application should not be installed' {
                    It 'Should return the state as present' {
                        $result = Test-TargetResource -Name $mockExistingApplicationName -Ensure 'Absent'
                        $result | Should -Be $false
                    }
                }
            }
        }
    }
}
