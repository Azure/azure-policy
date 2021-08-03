function Get-CurrentPowerShellExecutionPolicy
{
    [CmdletBinding()]
    [OutputType([String])]
    param ()

    $executionPolicy = powershell -OutputFormat 'Xml' -NonInteractive -Command {Get-ExecutionPolicy}
    Write-Verbose -Message "The current PowerShell execution policy is '$($executionPolicy.Value)'."
    return $executionPolicy.Value
}

function Get-ReasonsExecutionPolicyDoesNotMatch
{
    [CmdletBinding()]
    [OutputType([Hashtable[]])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('AllSigned', 'Bypass', 'Default', 'RemoteSigned', 'Restricted', 'Undefined', 'Unrestricted')]
        [String]
        $ExecutionPolicy
    )

    $reasons = @()
    $reasonCodePrefix = 'PowerShellExecutionPolicy:PowerShellExecutionPolicy'

    $currentExecutionPolicy = Get-CurrentPowerShellExecutionPolicy

    if ($currentExecutionPolicy -ine $ExecutionPolicy)
    {
        $reason = @{
            Code = $reasonCodePrefix + ':ExecutionPolicyDoesNotMatchExpected'
            Phrase = "The current PowerShell execution policy is '$currentExecutionPolicy' which does not match the expected execution policy '$ExecutionPolicy'."
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
        [ValidateSet('AllSigned', 'Bypass', 'Default', 'RemoteSigned', 'Restricted', 'Undefined', 'Unrestricted')]
        [String]
        $ExecutionPolicy
    )

    $powershellExecutionPolicyInfo = @{
        IsSingleInstance = 'Yes'
        ExecutionPolicy = Get-CurrentPowerShellExecutionPolicy
    }

    $reasons = @(Get-ReasonsExecutionPolicyDoesNotMatch -ExecutionPolicy $ExecutionPolicy)

    if ($null -ne $reasons -and $reasons.Count -gt 0)
    {
        $powershellExecutionPolicyInfo['Reasons'] = $reasons
    }

    return $powershellExecutionPolicyInfo
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
        [ValidateSet('AllSigned', 'Bypass', 'Default', 'RemoteSigned', 'Restricted', 'Undefined', 'Unrestricted')]
        [String]
        $ExecutionPolicy
    )

    $reasons = @(Get-ReasonsExecutionPolicyDoesNotMatch -ExecutionPolicy $ExecutionPolicy)

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
        [ValidateSet('AllSigned', 'Bypass', 'Default', 'RemoteSigned', 'Restricted', 'Undefined', 'Unrestricted')]
        [String]
        $ExecutionPolicy
    )

    throw 'Set functionality is not supported in this version of the DSC resource.'
}
