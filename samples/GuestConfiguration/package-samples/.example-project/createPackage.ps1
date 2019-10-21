
<#PSScriptInfo

.VERSION 1.0.0

.GUID 47d9e9ee-b4de-4cbc-beb4-b7ddd9a5311a

.AUTHOR Michael Greene

.TAGS 'Guest Configuration'

#>

#Requires -Module GuestConfiguration

<# 

.DESCRIPTION 
 Creates Guest Configuration package to audit members of the Windows local group named Administrators 

 This script should be executed in the .example-project folder.
#> 
$env:PSModulePath = $env:PSModulePath+":$pwd/Modules"

New-GuestConfigurationPackage -Name 'AdministratorsGroupMembers' `
    -Configuration "$pwd/AdministratorsGroupMembers.mof" `
    -Path "$pwd/package" `
    -Verbose
    
Test-GuestConfigurationPackage -Path "$pwd/package/AdministratorsGroupMembers/AdministratorsGroupMembers.zip" `
    -Verbose | Format-List *
