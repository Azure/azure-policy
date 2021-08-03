<#
    .SYNOPSIS
        Retrieves the current time zone of the machine.
#>
function Get-CurrentTimeZoneDisplayName
{
    [CmdletBinding()]
    [OutputType([String])]
    param ()

    $currentTimeZone = Get-CimInstance -ClassName 'Win32_TimeZone' -Namespace 'root\cimv2'
    $timeZoneInfo = [System.TimeZoneInfo]::GetSystemTimeZones() | Where-Object -Property StandardName -EQ $currentTimeZone.StandardName
    return $timeZoneInfo.DisplayName
}

function Get-ReasonsTimeZoneDoesNotMatch
{
    [CmdletBinding()]
    [OutputType([Hashtable[]])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $TimeZone
    )

    $reasons = @()
    $reasonCodePrefix = 'WindowsTimeZone:WindowsTimeZone'

    $currentTimeZone = Get-CurrentTimeZoneDisplayName

    if ($currentTimeZone -ine $TimeZone)
    {
        $reason = @{
            Code = $reasonCodePrefix + ':UnexpectedTimeZone'
            Phrase = "Expected the current time zone to be '$TimeZone' but the actual time zone is '$currentTimeZone'."
        }
        $reasons += $reason
    }

    return $reasons
}

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
        [ValidateNotNullOrEmpty()]
        [String]
        $TimeZone
    )

    $timeZoneInfo = @{
        IsSingleInstance = 'Yes'
        TimeZone = Get-CurrentTimeZoneDisplayName
    }

    $reasons = @(Get-ReasonsTimeZoneDoesNotMatch -TimeZone $TimeZone)

    if ($null -ne $reasons -and $reasons.Count -gt 0)
    {
        $timeZoneInfo['Reasons'] = $reasons
    }

    return $timeZoneInfo
}

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
        [ValidateNotNullOrEmpty()]
        [String]
        $TimeZone
    )

    $reasons = @(Get-ReasonsTimeZoneDoesNotMatch -TimeZone $TimeZone)

    if ($null -ne $reasons -and $reasons.Count -gt 0)
    {
        return $false
    }

    return $true
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [String]
        $IsSingleInstance,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $TimeZone
    )

    throw 'Set functionality is not supported in this version of the DSC resource.'
}
