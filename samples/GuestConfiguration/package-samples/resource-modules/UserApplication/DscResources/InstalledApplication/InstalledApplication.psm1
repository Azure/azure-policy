
<#
    .SYNOPSIS
        Formats the specified installed and not installed applications into the application info
        objects expected as an output property of this DSC resource.

    .PARAMETER InstalledApplications
        The list of metadata for applications that were found to be installed in the current
        environment.

    .PARAMETER NotInstalledApplications
         The list of metadata for applications that were found not to be installed in the current
         environment.
#>
function Get-InstalledApplicationInfo
{
    [OutputType([System.Collections.Hashtable[]])]
    param
    (
        [Parameter()]
        [Microsoft.Win32.RegistryKey[]]
        $InstalledApplications,

        [Parameter()]
        [System.String[]]
        $NotInstalledApplications
    )

    [System.Collections.Hashtable[]] $applicationInfo = @()

    foreach ($installedApplication in $InstalledApplications)
    {
        $applicationInfo += @{
            Name           = $installedApplication.Name
            Ensure         = 'Present'
            DisplayName    = $installedApplication.GetValue('DisplayName')
            Version        = $installedApplication.GetValue('Version')
            DisplayVersion = $installedApplication.GetValue('DisplayVersion')
            InstallDate    = $installedApplication.GetValue('InstallDate')
            InstallSource  = $installedApplication.GetValue('InstallSource')
            Publisher      = $installedApplication.GetValue('Publisher')
        }
    }

    foreach ($notInstalledApplication in $NotInstalledApplications)
    {
        $applicationInfo += @{
            Name   = $notInstalledApplication
            Ensure = 'Absent'
        }
    }

    return $applicationInfo
}

<#
    .SYNOPSIS
        Retrieves the metadata of the application with the specified name from the specified list
        of all applications.

    .PARAMETER Name
        The name of the application to find in the specified list of all applications.

    .PARAMETER AllInstalledApplications
        A list of the metadata of all installed applications in which to search for the application
        with the specified name.

        This should be the output of the cmdlet 'Get-AllInstalledApplications'.

    .EXAMPLE
        Find-InstalledApplication -Name 'Google Chrome' -AllInstalledApplications $(Get-AllInstalledApplications)
#>
function Find-InstalledApplication
{
    [OutputType([Microsoft.Win32.RegistryKey[]])]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $Name,

        [Parameter(Mandatory = $true)]
        [Microsoft.Win32.RegistryKey[]]
        $AllInstalledApplications
    )

    $foundApplications = @()

    $foundApplications += $AllInstalledApplications | Where-Object { $_.PSChildName -ilike $Name}
    $foundApplications += $AllInstalledApplications | Where-Object { $_.GetValue('DisplayName') -ilike $Name}

    # Remove duplicates
    $foundApplicationsNoDuplicates = $foundApplications | Select-Object -Unique

    return $foundApplicationsNoDuplicates
}

<#
    .SYNOPSIS
        Retrieves the metadata of all installed applications in the current environment.

    .DESCRIPTION
        Installed applications are searched for under the following 3 paths:
            - HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall
            - HKLM:SOFTWARE\Wow6432node\Microsoft\Windows\CurrentVersion\Uninstall
            - HKCU:Software\Microsoft\Windows\CurrentVersion\Uninstall

        The child items of these three paths are returned as the meta data for all currently
        installed applications in the current environment.

    .EXAMPLE
        Get-AllInstalledApplications
#>
function Get-AllInstalledApplications
{
    [OutputType([Microsoft.Win32.RegistryKey[]])]
    param()

    # Installed applications can be found under 2 system paths and the current user path
    $applicationPaths = @(
        "HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall",
        "HKLM:SOFTWARE\Wow6432node\Microsoft\Windows\CurrentVersion\Uninstall",
        "HKCU:Software\Microsoft\Windows\CurrentVersion\Uninstall"
    )

    $applicationMetaData = @()
    foreach ($applicationPath in $applicationPaths)
    {
        if (Test-Path -Path $applicationPath)
        {
            $applicationMetaData += Get-ChildItem -Path $applicationPath
        }
    }

    return $applicationMetaData
}

function Get-ReasonsApplicationInstallationDoesNotMatch
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $Name,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [String]
        $Ensure = 'Present'
    )

    $reasons = @()
    $reasonCodePrefix = 'UserApplication:InstalledApplication'

    $applicationsInstalled = @()
    $applicationsNotInstalled = @()
    
    $allInstalledApplications = Get-AllInstalledApplications

    if ($Name.Contains(';'))
    {
        $applicationNames = $Name.Split(';')
    }
    else
    {
        $applicationNames = $Name.Split(',')
    }
    
    # Find the installation status of the applications with the specified names
    foreach ($applicationName in $applicationNames)
    {
        $applicationName = $applicationName.Trim()
        $installedApplication = Find-InstalledApplication -Name $applicationName -AllInstalledApplications $allInstalledApplications 
        if ($installedApplication.Count -eq 0)
        {
            Write-Verbose -Message "Specified application '$applicationName' is not installed." -Verbose
            $applicationsNotInstalled += $applicationName
        }
        else
        {
            Write-Verbose -Message "Specified application '$applicationName' is installed." -Verbose
            $applicationsInstalled += $installedApplication
        }
    }

    if (($Ensure -ieq 'Present') -and ($applicationsNotInstalled.Count -gt 0))
    {
        # Set Ensure = Absent if originally Ensure was Present and at least one app is not found
        $Ensure = 'Absent'

        $reasons += @{
            Code   = '{0}:{1}' -f $reasonCodePrefix, 'ApplicationNotInstalled'
            Phrase = ("The following applications are not installed: '{0}'." -f ($applicationsNotInstalled -join "', '"))
        }
    }
    elseif (($Ensure -ieq 'Absent') -and ($applicationsInstalled.Count -gt 0))
    {
        # Set Ensure = Present if originally Ensure was Absent and at least one app is found
        $Ensure = 'Present'

        $installedApplicationNames = @()

        foreach ($applicationInstalled in $applicationsInstalled)
        {
            $displayName = $applicationInstalled.GetValue('DisplayName')
            if ($null -eq $displayName -or [String]::IsNullOrEmpty($displayName))
            {
                $installedApplicationNames += $applicationInstalled.PSChildName
            }
            else
            {
                $installedApplicationNames += $displayName  
            }
        }

        $installedApplicationNames = $installedApplicationNames | Select-Object -Unique

        $reasons += @{
            Code   = '{0}:{1}' -f $reasonCodePrefix, 'ApplicationInstalled'
            Phrase = ("The following applications are installed: '{0}'." -f ($installedApplicationNames -join "', '"))
        }
    }

    return $reasons
}

<#
    .SYNOPSIS
        Retrieves the installation status and information of the applications with the specified
        names.

    .PARAMETER Name
        The name(s) of the application(s) of which to check the installation status.
        Multiple entries should be seperated by a comma.
        Example: 'Google Chrome, .Net Core*, Firefox'

    .PARAMETER Ensure
        Specifies whether or not the applications with the specified names should be installed or
        not installed.

        The value 'Present' indicates that the specified applications should be installed.
        The value 'Absent' indicates that the specified applications should not be installed.
        The default value is 'Present.
#>
function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $Name,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [String]
        $Ensure = 'Present'
    )

    $applicationInstallationInfo = @{
        Name = $Name
        Ensure = $Ensure
        ApplicationInfo = @()
    }

    $reasons = @(Get-ReasonsApplicationInstallationDoesNotMatch -Name $Name -Ensure $Ensure)

    if ($null -ne $reasons -and $reasons.Count -gt 0)
    {
        $applicationInstallationInfo['Reasons'] = $reasons

        if ($Ensure -eq 'Absent')
        {
            $applicationInstallationInfo['Ensure'] = 'Present'
        }
        else
        {
            $applicationInstallationInfo['Ensure'] = 'Absent'
        }
    }

    # Retrieve the desired application installation information
    # $applicationInfo = @(Get-InstalledApplicationInfo -InstalledApplications $applicationsInstalled -NotInstalledApplications $applicationsNotInstalled)

    return $applicationInstallationInfo
}

<#
    .SYNOPSIS
        Tests whether or not the applications with the specified names are installed or not
        installed in the current environment.

    .DESCRIPTION
        Returns false if the Ensure property is specified as 'Present' and at least one specified
        application is not installed.
        Returns false if the Ensure property is specified as 'Absent' and at least one specified
        application is installed.
        Returns true otherwise.

    .PARAMETER Name
        The name(s) of the application(s) of which to check the installation status.
        Multiple entries should be seperated by a comma.
        Example: 'Google Chrome, .Net Core*, Firefox'

    .PARAMETER Ensure
        Specifies whether or not the applications with the specified names should be installed or
        not installed.

        The value 'Present' indicates that the specified applications should be installed.
        The value 'Absent' indicates that the specified applications should not be installed.
        The default value is 'Present.
#>
function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $Name,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [String]
        $Ensure = 'Present'
    )

    $reasons = @(Get-ReasonsApplicationInstallationDoesNotMatch -Name $Name -Ensure $Ensure)

    if ($null -ne $reasons -and $reasons.Count -gt 0)
    {
        return $false
    }

    return $true
}

<#
    .SYNOPSIS
        Not supported for Azure Policy.
#>
function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $Name,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [String]
        $Ensure = 'Present'
    )

    throw 'Set functionality is not supported in this version of the DSC resource.'
}
