import-module PSDesiredStateConfiguration
Configuration LocalUser_Linux
{
    Import-DSCResource -module LocalUser
    Node 'LocalUser_Linux'
    {
        LocalUser UserAccounts {
            exclude = 'mySampleAccount'
        }
    }
}
LocalUser_Linux -Out ./