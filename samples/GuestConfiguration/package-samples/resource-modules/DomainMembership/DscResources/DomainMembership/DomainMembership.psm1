<#
    .SYNOPSIS
        Retrieves the Complaince Status of the Node based on the Domain Name the Machine has joined .

    .PARAMETER DomainName
        The Fully qualified DNS name of the domain.
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

    $reasons = @(Get-ReasonsDomainNameDoNotMatchExpected $DomainName )
    
    $DomainNameInfo = @{
        DomainName = $DomainName
    }
    
    if ($null -ne $reasons -and $reasons.Count -gt 0)
    {
        $DomainNameInfo['Reasons'] = $reasons
    }
    
    return $DomainNameInfo
}
<#
    .SYNOPSIS
        Test whether or not the Node is complaint based on whether the Domain Name the VM currently joined to matching the Name specified by the user.

    .DESCRIPTION
        Returns false if the Domain Name the VM currently joined to is not matching the Name specified by the user.
        Returns true otherwise.

    .PARAMETER DomainName
        The Fully qualified DNS name of the domain.
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

    $reasons = @(Get-ReasonsDomainNameDoNotMatchExpected $DomainName)

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
        Compares the Domain Name the VM currently joined to the Name specified by the user.

    .DESCRIPTION
        Compares the Domain Name the VM currently joined to the Name specified by the user.
    
    .PARAMETER DomainName
        The Fully qualified DNS name of the domain.
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
    $reasonCodePrefix = 'DomainName:DomainName'
    
    Write-Verbose -Message  "Check if the Machine joined DomainName and the user specified DomainName Match..."
    $DNSDomainName = (Get-CimInstance -ClassName win32_computersystem).Domain
    Write-Verbose "Machine is currently joined to $DNSDomainName" -Verbose
        
    if($DomainName.ToLower() -ne $DNSDomainName.ToLower())
    {
        $reasons += @{
            Code   = '{0}:{1}' -f $reasonCodePrefix, 'DNSDomainName'
            Phrase = ("The Domain Name the VM is currently joined to '{0}' does not match the one specified by the User '{1}' .." -f $DNSDomainName ,$DomainName)
        }
    }
    return $reasons
}

