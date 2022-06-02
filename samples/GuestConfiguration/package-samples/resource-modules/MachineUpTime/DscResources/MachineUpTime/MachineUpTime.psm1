<#
    .SYNOPSIS
        Retrieves the Complaince Status of the Node based on the Last Date the VM was restarted.

    .PARAMETER NumberOfDays
        The number of days afterwhich the node is considered not compliant if it is not restarted.
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

    $reasons = @(Get-ReasonsLastBootUpTimeDoNotMatchExpected $NumberOfDays )
    
    $machineUpTimeInfo = @{
        NumberOfDays = $NumberOfDays
    }
    
    if ($null -ne $reasons -and $reasons.Count -gt 0)
    {
        $machineUpTimeInfo['Reasons'] = $reasons
    }
    
    return $machineUpTimeInfo
}
<#
    .SYNOPSIS
        Test whether or not the Node is complaint based on whether the VM has been restarted within X days.

    .DESCRIPTION
        Returns false if the VM is not restarted within X days, that could indicate that the target node is not part of the normal maintenance cycle, for example that is has not received updates.
        Returns true otherwise.

    .PARAMETER NumberOfDays
        The number of days afterwhich the node is considered not compliant if it is not restarted.
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

    $reasons = @(Get-ReasonsLastBootUpTimeDoNotMatchExpected $NumberOfDays)

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
        Compares LastBootUpTime with the Current Date time of the VM.

    .DESCRIPTION
        Compares LastBootUpTime with the Current Date time of the VM it will return a reasone 
        when the Difference is greater than the Number of Days specified as Input.
    
    .PARAMETER NumberOfDays
        The number of days afterwhich the node is considered not compliant if it is not restarted.
#>
function Get-ReasonsLastBootUpTimeDoNotMatchExpected
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
    $reasonCodePrefix = 'MachineUpTime:MachineUpTime'
    
    Write-Verbose -Message  "Check if the difference between VM's LastBootUpTime and current datatime is less than NumberOfDays"
    $lastbootuptime = (Get-CimInstance -ClassName Win32_Operatingsystem).LastBootUpTime
    Write-Verbose "Last Bootuptime $lastbootuptime" -Verbose
    $CurrentDate =  Get-Date
    
    if(($CurrentDate - $lastbootuptime).TotalDays -gt $NumberOfDays)
    {
        $reasons += @{
            Code   = '{0}:{1}' -f $reasonCodePrefix, 'LastBootUpTime'
            Phrase = ("The VM was not restarted within '{0}' days, LastBootUpTime was on '{1}' that could indicate that the target node is not part of the normal maintenance cycle, and has not received updates. '{0}'." -f $NumberOfDays ,($lastbootuptime))
        }
    }
    return $reasons
}

