
class Reason {
    [DscProperty()]
    [string] $Code

    [DscProperty()]
    [string] $Phrase
}

<#
   Functions
#>

function Get-LocalUserDSC {
    param(
        [String]$Exclude
    )
    $Reason = [reason]::new()
    $Reason.code = 'LocalUser:LocalUser:Accounts'

    $excludedUserNames = $Exclude.trim().split(';').trim()

    if ($IsWindows) {
        $Users = PowerShell.exe { Get-LocalUser }
        $compliantUsers = $Users | Where-Object { $excludedUserNames -contains $_.Name -and $_.Enabled -eq $true }
        $nonCompliantUsers = $Users | Where-Object { $excludedUserNames -notcontains $_.Name -and $_.Enabled -eq $true }
    } # isWindows

    if ($IsLinux) {
        $Users = @()
        foreach ($userDetail in (get-content /etc/passwd -Delimiter "`n")) {
            if ($userDetail -notmatch "^[#_]") {
                $User = New-Object -type psobject -property @{
                    Name        = $userDetail.split(':')[0]
                    UID         = $userDetail.split(':')[2]
                    GroupID     = $userDetail.split(':')[3]
                    Description = $userDetail.split(':')[4]
                    Home        = $userDetail.split(':')[5]
                    Shell       = $userDetail.split(':')[6]
                }
                $Users += $User
            } # if
        } # foreach
        $compliantUsers = $Users | Where-Object { $excludedUserNames -contains $_.Name -and [int]$_.UID -ge 1000 -and $_.Shell -ne '/sbin/nologin' } | ForEach-Object { $_.Name }
        $nonCompliantUsers = $Users | Where-Object { $excludedUserNames -notcontains $_.Name -and [int]$_.UID -ge 1000 -and $_.Shell -ne '/sbin/nologin' } | ForEach-Object { $_.Name }
    } # isLinux

    $Compliant = "`tCompliant:`n"
    foreach ($compliantUser in $compliantUsers) { $Compliant += "`t`t[+] $compliantUser`n" }
    
    $nonCompliant = "`tNon-Compliant:`n"
    foreach ($nonCompliantUser in $nonCompliantUsers) { $nonCompliant += "`t`t[-] $nonCompliantUser`n" }
    
    $Reason.phrase = "The machine has the following enabled user accounts.`n$nonCompliant$Compliant"

    return @{
        Reasons           = @($Reason)
        CompliantUsers    = $compliantUsers
        NonCompliantUsers = $nonCompliantUsers
        Exclude           = $Exclude
    }
}

function Test-LocalUserDSC {
    param(
        [String]$Exclude
    )

    $return = $true
    $userDetails = Get-LocalUserDSC -Exclude $Exclude
    if ($userDetails.NonCompliantUsers.count -gt 0) { $return = $false }
    return $return
}

<#
   DSC Resource
#>

[DscResource()]
class LocalUser {
    
    [DscProperty(Key)]
    [string] $Exclude

    [DscProperty()]
    [string]$NonCompliantUsers

    [DscProperty()]
    [string]$CompliantUsers

    [DscProperty()]
    [reason[]]$Reasons

    [LocalUser] Get() {
        $get = Get-LocalUserDSC -Exclude $this.Exclude
        return $get
    }
    
    [void] Set() {
        throw 'The LocalUser module does not support DSC Set operations'
    }

    [bool] Test() {
        $test = Test-LocalUserDSC -Exclude $this.Exclude
        return $test
    }
}
