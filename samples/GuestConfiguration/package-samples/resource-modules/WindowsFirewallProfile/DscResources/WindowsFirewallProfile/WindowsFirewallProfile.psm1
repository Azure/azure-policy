<#
    .SYNOPSIS
        Retrieves the compliance status of the node based on whether the machine firewall profile match those specified.

    .Parameter IsSingleInstance
        Specifies the resource is a single instance

    .PARAMETER profileDomainEnabled
        Specifies if the domain firewall profile is expected to be enabled or not.

    .PARAMETER profilePrivateEnabled
        Specifies if the private firewall profile is expected to be enabled or not.
    
    .PARAMETER profilePublicEnabled
        Specifies if the public firewall profile is expected to be enabled or not.
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
        $IsSingleInstance,
        
        [Parameter(Mandatory = $true)]
        [ValidateSet('True', 'False')]
        [String]
        $profileDomainEnabled,

        [Parameter(Mandatory = $true)]
        [ValidateSet('True', 'False')]
        [String]
        $profilePrivateEnabled,

        [Parameter(Mandatory = $true)]
        [ValidateSet('True', 'False')]
        [String]
        $profilePublicEnabled
    )

    $reasons = @(Get-ReasonsWindowsFirewallProfileNotCompliant -ProfileDomainEnabled $profileDomainEnabled -ProfilePrivateEnabled $profilePrivateEnabled -ProfilePublicEnabled $profilePublicEnabled)
    $machineProfileDomainStatus = Get-FirewallProfileStatus -ProfileName 'Domain'
    $machineProfilePrivateStatus = Get-FirewallProfileStatus -ProfileName 'Private'
    $machineProfilePublicStatus = Get-FirewallProfileStatus -ProfileName 'Public'

    $WindowsFirewallProfileInfo = @{
        IsSingleInstance = 'Yes'
        profileDomainEnabled = $machineProfileDomainStatus
        profilePrivateEnabled = $machineProfilePrivateStatus
        profilePublicEnabled = $machineProfilePublicStatus
    }
    
    if ($null -ne $reasons -and $reasons.Count -gt 0)
    {
        $WindowsFirewallProfileInfo['Reasons'] = $reasons
    }
    
    return $WindowsFirewallProfileInfo
}
<#
    .SYNOPSIS
        Retrieves the compliance status of the node based on whether the machine firewall profile match those specified.

    .Parameter IsSingleInstance
        Specifies the resource is a single instance

    .PARAMETER profileDomainEnabled
        Specifies if the domain firewall profile is expected to be enabled or not.

    .PARAMETER profilePrivateEnabled
        Specifies if the private firewall profile is expected to be enabled or not.
    
    .PARAMETER profilePublicEnabled
        Specifies if the public firewall profile is expected to be enabled or not.
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
        $IsSingleInstance,
        
        [Parameter(Mandatory = $true)]
        [ValidateSet('True', 'False')]
        [String]
        $profileDomainEnabled,

        [Parameter(Mandatory = $true)]
        [ValidateSet('True', 'False')]
        [String]
        $profilePrivateEnabled,

        [Parameter(Mandatory = $true)]
        [ValidateSet('True', 'False')]
        [String]
        $profilePublicEnabled
    )

    $reasons = @(Get-ReasonsWindowsFirewallProfileNotCompliant -ProfileDomainEnabled $profileDomainEnabled -ProfilePrivateEnabled $profilePrivateEnabled -ProfilePublicEnabled $profilePublicEnabled)

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
    [OutputType([Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [String]
        $IsSingleInstance,
        
        [Parameter(Mandatory = $true)]
        [ValidateSet('True', 'False')]
        [String]
        $profileDomainEnabled,

        [Parameter(Mandatory = $true)]
        [ValidateSet('True', 'False')]
        [String]
        $profilePrivateEnabled,

        [Parameter(Mandatory = $true)]
        [ValidateSet('True', 'False')]
        [String]
        $profilePublicEnabled
    )

    throw 'Set functionality is not supported in this version of the DSC resource.'
}
<#
    .SYNOPSIS
        Get the reasons why the node is non-compliant.

    .PARAMETER EMSPortNumber
        The expected value of the EMS setting 'emsportnumber' on the machine.

    .PARAMETER EMSBaudRate
        The expected value of the EMS setting 'emsbaudrate' on the machine.
#>
function Get-ReasonsWindowsFirewallProfileNotCompliant
{
    [CmdletBinding()]
    [OutputType([Hashtable[]])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('True', 'False')]
        [String]
        $ProfileDomainEnabled,

        [Parameter(Mandatory = $true)]
        [ValidateSet('True', 'False')]
        [String]
        $ProfilePrivateEnabled,

        [Parameter(Mandatory = $true)]
        [ValidateSet('True', 'False')]
        [String]
        $ProfilePublicEnabled
    )
    $reasons = @()
    $reasonCodePrefix = 'WindowsFirewallProfile:WindowsFirewallProfile'
    
    
    $machineProfileDomainStatus = Get-FirewallProfileStatus -ProfileName 'Domain'
    $machineProfilePrivateStatus = Get-FirewallProfileStatus -ProfileName 'Private'
    $machineProfilePublicStatus = Get-FirewallProfileStatus -ProfileName 'Public'
    
    $currentDomainStatus = if($machineProfileDomainStatus -eq 'True') {'Enabled'} else {'Disabled'}
    $expectedDomainStatus = if($ProfileDomainEnabled -eq 'True') {'Enabled'} else {'Disabled'}
   
    $currentPrivateStatus = if($machineProfilePrivateStatus -eq 'True') {'Enabled'} else {'Disabled'}
    $expectedPrivateStatus = if($ProfilePrivateEnabled -eq 'True') {'Enabled'} else {'Disabled'}

    $currentPublicStatus = if($machineProfilePublicStatus -eq 'True') {'Enabled'} else {'Disabled'}
    $expectedPublicStatus = if($ProfilePublicEnabled -eq 'True') {'Enabled'} else {'Disabled'}


    if($machineProfileDomainStatus -ne $ProfileDomainEnabled){
        
                    $reasons += @{
                        Code   = '{0}:{1}' -f $reasonCodePrefix, 'ProfileDomainStatusNotExpected'
                        Phrase = ("The machine Firewall Domain Profile is currently set to '{0}' which does not match the specified status '{1}'." -f $currentDomainStatus, $expectedDomainStatus)
                    }
                }
    if($machineProfilePrivateStatus -ne $ProfilePrivateEnabled){

        $reasons += @{
            Code   = '{0}:{1}' -f $reasonCodePrefix, 'ProfilePrivateStatusNotExpected'
            Phrase = ("The machine Firewall Private Profile is currently set to '{0}' which does not match the specified status '{1}'." -f $currentPrivateStatus, $expectedPrivateStatus)
        }
    }

    if($machineProfilePublicStatus -ne $ProfilePublicEnabled){
        
        $reasons += @{
            Code   = '{0}:{1}' -f $reasonCodePrefix, 'ProfilePublicStatusNotExpected'
            Phrase = ("The machine Firewall Public Profile is currently set to '{0}' which does not match the specified status '{1}'." -f $currentPublicStatus, $expectedPublicStatus)
        }
    }
    return $reasons
}
function Get-FirewallProfileStatus
{
    [CmdletBinding()]
    [OutputType([string])]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $ProfileName
    )

    # Test-NetConnection not supported on ps6 version used by the engine 
    $status  = powershell -NonInteractive -Command {param ($name) $env:PSModulePath = ([Environment]::GetEnvironmentVariables("Machine")).PSModulePath;  Get-NetFirewallProfile -Name $name} -args @($ProfileName)
    if (($status.Enabled -eq 1) -or ($status.Enabled -eq 'True') )
    {
        return 'True'
    }
    else {
        return 'False'
    }
}
