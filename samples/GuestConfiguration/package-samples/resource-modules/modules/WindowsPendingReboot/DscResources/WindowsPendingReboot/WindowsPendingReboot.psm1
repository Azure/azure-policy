<#
    .SYNOPSIS
        Retrieves information on the pending reboot status of the current machine.
#>
function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [String]
        $IsSingleInstance
    )

    $reasons = @(Get-ReasonsPendingRebootNotComplaint)
    
    $pendingRebootInfo = @{
        IsSingleInstance = 'Yes'
    }
    
    if ($null -ne $reasons -and $reasons.Count -gt 0)
    {
        $pendingRebootInfo['Reasons'] = $reasons
    }
    
    return $pendingRebootInfo
}

<#
    .SYNOPSIS
        Tests whether or not there is a pending reboot on the current machine.
#>
function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [String]
        $IsSingleInstance
    )

    $reasons = @(Get-ReasonsPendingRebootNotComplaint)

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
        [ValidateSet('Yes')]
        [String]
        $IsSingleInstance
    )

    throw 'Set functionality is not supported in this version of the DSC resource.'
}

<#
    .SYNOPSIS
        Retrieves the reasons why the current machine has a pending reboot.
#>
function Get-ReasonsPendingRebootNotComplaint
{
    [CmdletBinding()]
    [OutputType([Hashtable[]])]
    param ()

    $reasons = @()
    $reasonCodePrefix = 'WindowsPendingReboot:WindowsPendingReboot'
   
    $status = Get-PendingRebootStatus

    if ($status.ComponentBasedServicing)
    {
        Write-Verbose -Message 'Pending component-based servicing reboot found.'
        $reasons += @{
            Code   = '{0}:{1}' -f $reasonCodePrefix, 'ComponentBasedServicingReboot'
            Phrase = ("This machine has a pending reboot due to component-based servicing.")
        }
    }

    if ($status.WindowsUpdate)
    {
        Write-Verbose -Message 'Pending Windows Update reboot found.'
        $reasons += @{
            Code   = '{0}:{1}' -f $reasonCodePrefix, 'WindowsUpdateReboot'
            Phrase = ("This machine has a pending reboot due to Windows Update.")
        }
    }

    if ($status.PendingFileRename)
    {
        Write-Verbose -Message 'Pending file rename reboot found.'
        $reasons += @{
            Code   = '{0}:{1}' -f $reasonCodePrefix, 'FileRenameReboot'
            Phrase = ("This machine has a pending reboot due to a file rename.")
        }
    }

    if ($status.PendingComputerRename)
    {
        Write-Verbose -Message 'Pending computer rename reboot found.'
        $reasons += @{
            Code   = '{0}:{1}' -f $reasonCodePrefix, 'ComputerRenameReboot'
            Phrase = ("This machine has a pending reboot due to a computer rename.")
        }
    }

    if ($status.ConfigurationManagerPendingReboot)
    {
        Write-Verbose -Message 'Pending System Center Configuration Manager reboot found.'
        $reasons += @{
            Code   = '{0}:{1}' -f $reasonCodePrefix, 'ConfigurationManagerReboot'
            Phrase = ("This machine has a pending reboot due to System Center Configuration Manager.")
        }
    }

    return $reasons
}

<#
    .SYNOPSIS
        Retrieves the reboot status of the current machine.
#>
function Get-PendingRebootStatus
{
    [CmdletBinding()]
    [OutputType([Hashtable])]
    param ()

    $pendingRebootStatus = @{
        ComponentBasedServicing = Get-ComponentBasedServicingPendingRebootStatus
        WindowsUpdate = Get-WindowsUpdatePendingRebootStatus
        PendingFileRename = Get-FileRenamePendingRebootStatus
        PendingComputerRename = Get-ComputerRenamePendingRebootStatus
        ConfigurationManagerPendingReboot = Get-ConfigurationManagerPendingRebootStatus
    }

    return $pendingRebootStatus
}

function Get-ComponentBasedServicingPendingRebootStatus
{
    [CmdletBinding()]
    [OutputType([Boolean])]
    param ()

    $componentBasedServicingPendingReboot = $false
    $componentBasedServicingRegistryKey = Get-ChildItem -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\'

    if ($null -eq $componentBasedServicingRegistryKey)
    {
        Write-Verbose -Message "Failed to find the component-based servicing registry key."
    }
    else
    {
        $componentBasedServicingRegistryKeyName = $componentBasedServicingRegistryKey.Name

        if ([String]::IsNullOrEmpty($componentBasedServicingRegistryKeyName))
        {
            Write-Verbose -Message "The component-based servicing registry key name is null or empty."
        }
        else
        {
            $componentBasedServicingPendingReboot = $componentBasedServicingRegistryKeyName.ToLower().Contains("rebootpending")
        }
    }

    return $componentBasedServicingPendingReboot
}

function Get-WindowsUpdatePendingRebootStatus
{
    [CmdletBinding()]
    [OutputType([Boolean])]
    param ()

    $windowsUpdatePendingReboot = $false
    $windowsUpdateRegistryKey = Get-ChildItem -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\'

    if ($null -eq $windowsUpdateRegistryKey)
    {
        Write-Verbose -Message "Failed to find the Windows Update Auto Update registry key."
    }
    else
    {
        $windowsUpdateRegistryKeyName = $windowsUpdateRegistryKey.Name

        if ([String]::IsNullOrEmpty($windowsUpdateRegistryKeyName))
        {
            Write-Verbose -Message "The Windows Update Auto Update registry key name is null or empty."
        }
        else
        {
            $windowsUpdatePendingReboot = $windowsUpdateRegistryKeyName.ToLower().Contains("rebootpending")
        }
    }

    return $windowsUpdatePendingReboot
}

function Get-FileRenamePendingRebootStatus
{
    [CmdletBinding()]
    [OutputType([Boolean])]
    param ()

    $fileRenamePendingReboot = $false

    $sessionManagerRegistryKeyProperties = Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\'
    if ($null -eq $sessionManagerRegistryKeyProperties)
    {
        Write-Verbose -Message "Failed to find the session manager registry key properties."
    }
    else
    {
        $fileRenamePendingOperations = @($sessionManagerRegistryKeyProperties.PendingFileRenameOperations)

        # Filter out null or empty strings
        $fileRenamePendingOperations = $fileRenamePendingOperations | Where-Object {-not ([String]::IsNullOrEmpty($_))}

        # Filter out files renamed in the system temp location
        $fileRenamePendingOperations = $fileRenamePendingOperations | Where-Object {-not ($_.ToLower().Contains(([System.Environment]::GetEnvironmentVariable('TEMP','Machine')).ToLower()))}

        # Filter out files renamed in the Windows Defender temp location
        $fileRenamePendingOperations = $fileRenamePendingOperations | Where-Object {-not ($_.ToLower().Contains('C:\ProgramData\Microsoft\Windows Defender Advanced Threat Protection\Temp'.ToLower()))}

        if ($null -eq $fileRenamePendingOperations -or $fileRenamePendingOperations.Length -eq 0)
        {
            Write-Verbose -Message "There are no current file rename pending operations."
        }
        else
        {
            $fileRenamePendingReboot = $true
        }
    }

    return $fileRenamePendingReboot
}

function Get-ComputerRenamePendingRebootStatus
{
    [CmdletBinding()]
    [OutputType([Boolean])]
    param ()

    $pendingComputerName = $false

    $activeComputerKey = Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\ComputerName\ActiveComputerName'
    $pendingComputerKey = Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName'

    if ($null -eq $activeComputerKey)
    {
        Write-Verbose -Message "The active computer rename registry key is null."
    }
    elseif ($null -eq $pendingComputerKey)
    {
        Write-Verbose -Message "The pending computer rename registry key is null."
    }
    else
    {
        $activeComputerName = $activeComputerKey.ComputerName
        $pendingComputerName = $pendingComputerKey.ComputerName
        $pendingComputerRename = $activeComputerName -ne $pendingComputerName
    }

    return $pendingComputerRename
}

function Get-ConfigurationManagerPendingRebootStatus
{
    [CmdletBinding()]
    [OutputType([Boolean])]
    param ()

    $getRebootPendingFromCCMParameters = @{
        NameSpace = 'ROOT\ccm\ClientSDK'
        Class = 'CCM_ClientUtilities'
        Name = 'DetermineIfRebootPending'
        ErrorAction = 'Stop'
    }

    try
    {
        $ccmRebootPending = Invoke-WmiMethod @getRebootPendingFromCCMParameters
    }
    catch
    {
        Write-Verbose -Message "Failed to determine if reboot is pending from Computer Confiuration Manager. Error message: $_"
    }

    $configurationManagerPendingRebootStatus = ($ccmRebootPending.ReturnValue -eq 0) -and ($ccmRebootPending.IsHardRebootPending -or $ccmRebootPending.RebootPending)

    return $configurationManagerPendingRebootStatus
}
