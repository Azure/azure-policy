Import-Module $PSScriptRoot/../LocalUser.psd1 -Force
Describe 'LocalUser Module' {
    Context 'Get function' {
        It 'Returns a hashtable' {
            Get-LocalUserDSC | Should -BeOfType Hashtable
        }
        It 'Has correct properties' {
            (Get-LocalUserDSC -Exclude 'myAccount').Keys | Should -Be @('NonCompliantUsers', 'Exclude', 'CompliantUsers', 'Reasons')
        }
    }
    Context 'Test function' {
        It 'Execution with no parameter' {
            Test-LocalUserDSC | Should -BeOfType Boolean
        }
        It 'Execution with parameter' {
            Test-LocalUserDSC -Exclude 'myAccount' | Should  -BeOfType Boolean
        }
    }
    Context 'Invoke DSC Get' {
        It 'Returns a LocalUser type' {
            #Invoke-DSCResource -Name LocalUser -ModuleName LocalUser -Method Get -Property @{Exclude = 'mySampleAccount'} | Should -BeOfType 'LocalUser'
        }
        It 'Has correct properties' {
            Invoke-DSCResource -Name LocalUser -ModuleName LocalUser -Method Get -Property @{Exclude = 'mySampleAccount'} | gm -MemberType Properties | % Name | Should -Be @('CompliantUsers', 'Exclude', 'NonCompliantUsers', 'Reasons')
        }
        It 'Execution with empty parameter' {
            Invoke-DSCResource -Name LocalUser -ModuleName LocalUser -Method Get -Property @{Exclude = ''} | % Exclude | Should -BeNullOrEmpty
        }
        It 'Returns a Reasons code' {
            Invoke-DSCResource -Name LocalUser -ModuleName LocalUser -Method Get -Property @{Exclude = 'mySampleAccount'}  | % Reasons | % Code | Should -Be 'LocalUser:LocalUser:Accounts'
        }
    }
    Context 'Invoke DSC Test' {
        It 'Execution with empty parameter' {
            Invoke-DSCResource -Name LocalUser -ModuleName LocalUser -Method Test -Property @{Exclude = ''} | % Exclude | Should -BeNullOrEmpty
        }
        It 'Execution with parameter' {
            Invoke-DSCResource -Name LocalUser -ModuleName LocalUser -Method Test -Property @{Exclude = 'mySampleAccount'} | % InDesiredState | Should -BeOfType Boolean
        }
    }
}