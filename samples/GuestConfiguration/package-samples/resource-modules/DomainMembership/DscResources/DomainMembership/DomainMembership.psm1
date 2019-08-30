<#
    .SYNOPSIS
        Retrieves the domain membership information of the current machine.

    .PARAMETER DomainName
        The name of the domain that the machine is expected to be joined to.
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
        $DomainName
    )

    $domainMembershipInfo = @{
        DomainName = Get-MachineDomainName
    }

    $reasons = @(Get-ReasonsDomainNameDoNotMatchExpected -DomainName $DomainName)
    
    if ($null -ne $reasons -and $reasons.Count -gt 0)
    {
        $domainMembershipInfo['Reasons'] = $reasons
    }
    
    return $domainMembershipInfo
}

<#
    .SYNOPSIS
        Tests whether or not the current machine joined to the domain with the specified name.

    .PARAMETER DomainName
        The name of the domain that the machine is expected to be joined to.
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
        $DomainName
    )

    $reasons = @(Get-ReasonsDomainNameDoNotMatchExpected -DomainName $DomainName)

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
        $DomainName
    )

    throw 'Set functionality is not supported in this version of the DSC resource.'
}

<#
    .SYNOPSIS
        Retrieves the reasons that the current machine is not joined to the domain with the specified name.

    .PARAMETER DomainName
        The name of the domain that the machine is expected to be joined to.
#>
function Get-ReasonsDomainNameDoNotMatchExpected
{
    [CmdletBinding()]
    [OutputType([Hashtable[]])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $DomainName
    )

    $reasons = @()
    $reasonCodePrefix = 'DomainMembership:DomainMembership'
    
    $machineDomainName = Get-MachineDomainName
    Write-Verbose -Message "Machine is currently joined to the domain with the name '$machineDomainName'."

    if ($DomainName -ine $machineDomainName)
    {
        $reasons += @{
            Code   = '{0}:{1}' -f $reasonCodePrefix, 'MachineDomainNameDoesNotMatchSpecified'
            Phrase = ("This machine is joined to the domain '{0}', but it was expected to be joined to the domain '{1}'." -f $machineDomainName, $DomainName)
        }
    }

    return $reasons
}

<#
    .SYNOPSIS
        Retrieves the name of the domain that the current machine is joined to.
#>
function Get-MachineDomainName
{
    [CmdletBinding()]
    [OutputType([String])]
    param ()
    
    Write-Verbose -Message  "Retrieving the machine-joined domain name..."
    return (Get-CimInstance -ClassName 'win32_computersystem').Domain
}
