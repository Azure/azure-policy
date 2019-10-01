<#
    .SYNOPSIS
        Retrieves information on the current machine's uptime.

    .PARAMETER NumberOfDays
        The number of days within which the current machine is expected to have restarted.
#>
function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $NumberOfDays
    )

    $machineUptimeInfo = @{
        NumberOfDays = Get-NumberOfDaysSinceLastStart
    }

    $reasons = @(Get-ReasonsUptimeDoesNotMatchExpected -NumberOfDays $NumberOfDays)
    
    if ($null -ne $reasons -and $reasons.Count -gt 0)
    {
        $machineUptimeInfo['Reasons'] = $reasons
    }
    
    return $machineUptimeInfo
}
<#
    .SYNOPSIS
        Tests whether or not the current machine has been restarted within the specified number of days.

    .PARAMETER NumberOfDays
        The number of days within which the current machine is expected to have restarted.
#>
function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $NumberOfDays
    )

    $reasons = @(Get-ReasonsUptimeDoesNotMatchExpected -NumberOfDays $NumberOfDays)

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
        [ValidateNotNullOrEmpty()]
        [String]
        $NumberOfDays
    )

    throw 'Set functionality is not supported in this version of the DSC resource.'
}

<#
    .SYNOPSIS
        Returns Guest Configuration Reasons if the current machine has not restarted within the specified number of days.

    .PARAMETER NumberOfDays
        The number of days within which the current machine is expected to have restarted.
#>
function Get-ReasonsUptimeDoesNotMatchExpected
{
    [CmdletBinding()]
    [OutputType([Hashtable[]])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $NumberOfDays
    )

    $reasons = @()
    $reasonCodePrefix = 'MachineUptime:MachineUptime'
    
    $numberOfDaysSinceLastStart = Get-NumberOfDaysSinceLastStart

    if ($numberOfDaysSinceLastStart -gt $NumberOfDays)
    {
        $reasons += @{
            Code   = '{0}:{1}' -f $reasonCodePrefix, 'MachineUptimeGreaterThanExpected'
            Phrase = ("This machine has not restarted within '{0}' days. Last start time was '{1}' days ago." -f $NumberOfDays, $numberOfDaysSinceLastStart)
        }
    }

    return $reasons
}

<#
    .SYNOPSIS
        Retrieves the number of days since the current machine has started.
#>
function Get-NumberOfDaysSinceLastStart
{
    [CmdletBinding()]
    [OutputType([int])]
    param ()

    $lastStartTime = (Get-CimInstance -ClassName Win32_Operatingsystem).LastBootUpTime
    Write-Verbose -Message "Last start time: $lastBootUpTime"

    $currentDate =  Get-Date
    $daysSinceLastStart = [int](($currentDate - $lastStartTime).TotalDays)

    return $daysSinceLastStart
}
