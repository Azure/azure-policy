function Get-ReasonsServiceStatusNotCompliant
{
    [CmdletBinding()]
    [OutputType([Hashtable[]])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ServiceName
    )

    $reasons = @()

    $reasonCodePrefix = 'WindowsServiceStatus:WindowsServiceStatus'

    $serviceInfo = Get-ServiceInfo -ServiceName $ServiceName

    foreach ($service in $serviceInfo)
    {
        if ($service.Status -ne 'Running' )
        {

           if ($service.Status -eq 'Absent')
           {
                $reasons += @{
                    Code   = '{0}:{1}' -f $reasonCodePrefix, 'ServicesNotInstalled'
                    Phrase = ("The service with the name '{0}' was not found." -f $service.Name)
                }
            }
            else
            {
                $reasons += @{
                    Code   = '{0}:{1}' -f $reasonCodePrefix, 'ServiceStatusUnexpected'
                    Phrase = ("The service with the name '{0}' has the unexpected status '{1}'. The 'Running' status was expected." -f $service.Name, $service.Status)
                }
            }
        }
    }

    return $reasons
}
<#
    .SYNOPSIS
        Formats the specified running, stopped and not installed service into the service info
        objects expected as an output property of this DSC resource.

    .PARAMETER ServiceName
        The name(s) of the service(s) of which to check their status.
        Multiple entries should be seperated by a semicolon.
        Example: 'WinRM; Wlan*'
#>
function Get-ServiceInfo
{
    [OutputType([System.Collections.Hashtable[]])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ServiceName
    )

    $serviceInfo = @()

    if ($ServiceName.Contains(';'))
    {
        $serviceNames = $ServiceName.Split(';')
    }
    else
    {
        $serviceNames = @($ServiceName)
    }
   
    foreach ($name in $serviceNames)
    {   
        if (-not [String]::IsNullOrEmpty($name))
        {
            $serviceObjects = @(Get-Service -Name $name -ErrorAction 'SilentlyContinue')

            if ($null -ne $serviceObjects)
            {
                foreach ($service in $serviceObjects)
                {
                    $serviceInfo += @{
                        Name   = $service.Name
                        Status = $service.Status
                    }
                }
            }
            else
            {
                $serviceInfo += @{
                    Name   = $name
                    Status = 'Absent'
                }
            }
        }
    }

    return $serviceInfo
}

<#
    .SYNOPSIS
        Retrieves the status of the service(s) with the specified names.

    .PARAMETER ServiceName
        The name(s) of the service(s) of which to check their status.
        Multiple entries should be seperated by a semicolon.
        Example: 'WinRM; Wlan*'
#>
function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $ServiceName
    )

    $serviceStatusInfo = @{
        ServiceName = $ServiceName
    }

    $reasons = @(Get-ReasonsServiceStatusNotCompliant -ServiceName $ServiceName)

    if ($null -ne $reasons -and $reasons.Count -gt 0)
    {
        $serviceStatusInfo['Reasons'] = $reasons
    }

    return $serviceStatusInfo
}

<#
    .SYNOPSIS
        Tests whether or not the services with the specified names are installed and running in the current environment.

    .DESCRIPTION
        Returns false if at least one specified services is not installed nor running.
        Returns true otherwise.

    .PARAMETER ServiceName
        The name(s) of the service(s) of which to check their status.
        Multiple entries should be seperated by a semicolon.
        Example: 'WinRM; Wlan*'
#>
function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $ServiceName
    )

    $reasons = @(Get-ReasonsServiceStatusNotCompliant -ServiceName $ServiceName)

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
        $ServiceName
    )

    throw 'Set functionality is not supported in this version of the DSC resource.'
}
