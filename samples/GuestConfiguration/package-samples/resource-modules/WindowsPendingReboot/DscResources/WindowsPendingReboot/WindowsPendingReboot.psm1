<#
    .SYNOPSIS
        Retrieves the Complaince Status of the Node based on whether a Reboot is pending on the Windows VM.
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
    
    $PendingRebootInfo = @{
        IsSingleInstance = 'Yes'
    }
    
    if ($null -ne $reasons -and $reasons.Count -gt 0)
    {
        $PendingRebootInfo['Reasons'] = $reasons
    }
    
    return $PendingRebootInfo
}
<#
    .SYNOPSIS
        Test whether or not the Node is complaint based on whether a Reboot is pending on the Windows VM.

    .DESCRIPTION
        Returns false if some application requested a reboot.
        Returns true otherwise.

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
        Get all the application which requested a reboot.

    .DESCRIPTION
        Get all the application which requested a reboot.
    
#>
function Get-ReasonsPendingRebootNotComplaint
{
    [CmdletBinding()]
    [OutputType([Hashtable[]])]
    param
    ()
    $reasons = @()
    $reasonCodePrefix = 'WindowsPendingReboot:WindowsPendingReboot'
   
    $status = Get-PendingRebootStatus
    if($null -ne $status)
    {
            if($status.ComponentBasedServicing)
            {
                Write-Verbose 'Pending component based servicing reboot found.'
                $reasons += @{
                    Code   = '{0}:{1}' -f $reasonCodePrefix, 'ComponentBasedServiceReboot'
                    Phrase = ("This machine has a pending reboot due to component-based servicing.")
                }
            }

            if($status.WindowsUpdate)
            {
                Write-Verbose 'Pending Windows Update reboot found.'
                $reasons += @{
                    Code   = '{0}:{1}' -f $reasonCodePrefix, 'WindowUpdateReboot'
                    Phrase = ("This machine has a pending reboot due to Windows Update.")
                }
            }

            if($status.PendingFileRename)
            {
                Write-Verbose 'Pending file rename reboot found.'
                $reasons += @{
                    Code   = '{0}:{1}' -f $reasonCodePrefix, 'FileRenameReboot'
                    Phrase = ("This machine has a pending reboot due to a file rename.")
                }
            }

            if($status.PendingComputerRename)
            {
                Write-Verbose 'Pending computer rename reboot found.'
                $reasons += @{
                    Code   = '{0}:{1}' -f $reasonCodePrefix, 'ComputerRenameReboot'
                    Phrase = ("This machine has a pending reboot due to a computer rename.")
                }
            }

            if($status.CcmClientSDK)
            {
                Write-Verbose 'Pending SCCM ClientUtilities reboot found.'
                $reasons += @{
                    Code   = '{0}:{1}' -f $reasonCodePrefix, 'CCM_ClientUtilitiesReboot'
                    Phrase = ("This machine has a pending reboot due to Configuration Manager.")
                }
            }

            Write-Verbose 'No pending reboots found.'
                
    }
    return $reasons
}
function Get-PendingRebootStatus
{
    [CmdletBinding()]
    [OutputType([Hashtable])]
    param
    ()
    
    $ComponentBasedServicingKeys = (Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\').Name
    if ($ComponentBasedServicingKeys)
    {
        $ComponentBasedServicing = $ComponentBasedServicingKeys.Split("\") -contains "RebootPending"
    }
    else
    {
        $ComponentBasedServicing = $false
    }

    $WindowsUpdateKeys = (Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\').Name
    if ($WindowsUpdateKeys)
    {
        $WindowsUpdate = $WindowsUpdateKeys.Split("\") -contains "RebootRequired"
    }
    else
    {
        $WindowsUpdate = $false
    }

    $PendingFileRename = (Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\').PendingFileRenameOperations.Length -gt 0
    $ActiveComputerName = (Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\ComputerName\ActiveComputerName').ComputerName
    $PendingComputerName = (Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName').ComputerName
    $PendingComputerRename = $ActiveComputerName -ne $PendingComputerName

    $CCMSplat = @{
        NameSpace='ROOT\ccm\ClientSDK'
        Class='CCM_ClientUtilities'
        Name='DetermineIfRebootPending'
        ErrorAction='Stop'
    }

    Try
    {
        $CCMClientSDK = Invoke-WmiMethod @CCMSplat
    }
    Catch
    {
        Write-Warning "Unable to query CCM_ClientUtilities: $_"
    }

    $SCCMSDK = ($CCMClientSDK.ReturnValue -eq 0) -and ($CCMClientSDK.IsHardRebootPending -or $CCMClientSDK.RebootPending)

    return @{
    ComponentBasedServicing = $ComponentBasedServicing
    WindowsUpdate = $WindowsUpdate
    PendingFileRename = $PendingFileRename
    PendingComputerRename = $PendingComputerRename
    CcmClientSDK = $SCCMSDK
    }
}