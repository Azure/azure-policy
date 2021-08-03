import-module PSDesiredStateConfiguration
Configuration LocalUser_Windows
{
    Import-DSCResource -module LocalUser
    Node 'LocalUser_Windows'
    {
        LocalUser UserAccounts {
            exclude = 'mySampleAccount'
        }
    }
}
LocalUser_Windows -Out ./