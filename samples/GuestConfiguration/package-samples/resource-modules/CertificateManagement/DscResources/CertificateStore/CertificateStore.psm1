function Get-ReasonsCertificateStoreDoesNotMatchExpected
{
    [CmdletBinding()]
    [OutputType([Hashtable[]])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $CertificateStorePath,

        [Parameter()]
        [Int]
        $ExpirationLimitInDays,

        [Parameter()]
        [String[]]
        $CertificateThumbprintsToInclude,

        [Parameter()]
        [String[]]
        $CertificateThumbprintsToExclude,

        [Parameter()]
        [Boolean]
        $IncludeExpiredCertificates = $false
    )

    $reasons = @()

    $nonCompliantCertificates = @()
    $allCertificatesUnderPath = Get-ChildItem -Path $CertificateStorePath -Recurse | Sort-Object -Unique

    if ($PSBoundParameters.ContainsKey('CertificateThumbprintsToInclude') -and $null -ne $CertificateThumbprintsToInclude -and $CertificateThumbprintsToInclude.Count -gt 0)
    {
        foreach ($certificateThumbprintExpected in $CertificateThumbprintsToInclude)
        {
            if ($allCertificatesUnderPath.Thumbprint -notcontains $certificateThumbprintExpected)
            {
                if ($CertificateThumbprintsToExclude -notcontains $certificateThumbprintExpected)
                {
                    Write-Verbose -Message 'Could not find expected thumbprint.'
                    $reason = @{
                        Code = 'CertificateManagement:CertificateStore:ExpectedCertificateNotFound'
                        Phrase = "The certificate with thumbprint '$certificateThumbprintExpected' was not found in the certificate store at the path '$CertificateStorePath'."
                    }
                    $reasons += $reason
                }
            }
        }
    }

    if ($PSBoundParameters.ContainsKey('ExpirationLimitInDays') -and $null -ne $ExpirationLimitInDays)
    {
        $currentDate = Get-Date
        $expirationDate = (Get-Date).AddDays($ExpirationLimitInDays)
        
        foreach ($certificate in $allCertificatesUnderPath)
        {
            if ($null -ne $certificate.Thumbprint)
            {
                if ($certificate.NotAfter -lt $expirationDate)
                {
                    if ($IncludeExpiredCertificates)
                    {
                        $nonCompliantCertificates += $certificate
                    }
                    elseif ($certificate.NotAfter -gt $currentDate)
                    {
                        $nonCompliantCertificates += $certificate
                    }
                }
            }
        }
        
        if ($null -eq $nonCompliantCertificates -or $nonCompliantCertificates.Count -eq 0)
        {
            Write-Verbose -Message "No certificates found under the path '$CertificateStorePath' that are expiring within '$ExpirationLimitInDays' days."
        }
        else
        {
            Write-Verbose -Message "Found $($nonCompliantCertificates.Count) certificates under the path '$CertificateStorePath' that are expiring within '$ExpirationLimitInDays' days."
        }
        
        foreach ($nonCompliantCertificate in $nonCompliantCertificates)
        {
            $certificateReasonValid = $true
            if ($null -ne $CertificateThumbprintsToInclude -and $CertificateThumbprintsToInclude.Count -gt 0)
            {
                if ($CertificateThumbprintsToInclude -notcontains $nonCompliantCertificate.Thumbprint)
                {
                    Write-Verbose -Message "Certificate not included."
                    $certificateReasonValid = $false
                }
            }

            if ($null -ne $CertificateThumbprintsToExclude -and $CertificateThumbprintsToExclude.Count -gt 0)
            {
                if ($CertificateThumbprintsToExclude -contains $nonCompliantCertificate.Thumbprint)
                {
                    Write-Verbose -Message "Certificate excluded."
                    $certificateReasonValid = $false
                }
            }

            if ($certificateReasonValid)
            {
                Write-Verbose -Message 'Found expiring certificate.'
                $reason = @{
                    Code = 'CertificateManagement:CertificateStore:CertificateExpiringWithinMaximumDays'
                    Phrase = "The certificate with thumbprint '$($nonCompliantCertificate.Thumbprint)' and friendly name '$($nonCompliantCertificate.FriendlyName)' is expiring after '$($nonCompliantCertificate.NotAfter)' which is within the specified '$ExpirationLimitInDays' days."
                }
                $reasons += $reason
            }
        }
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
        [ValidateNotNullOrEmpty()]
        [String]
        $CertificateStorePath,

        [Parameter()]
        [String]
        $ExpirationLimitInDays,

        [Parameter()]
        [String]
        $CertificateThumbprintsToInclude = '',

        [Parameter()]
        [String]
        $CertificateThumbprintsToExclude = '',

        [Parameter()]
        [String]
        $IncludeExpiredCertificates = 'false'
    )

    $getReasonsParameters = @{
        CertificateStorePath = $CertificateStorePath
        IncludeExpiredCertificates = [System.Convert]::ToBoolean($IncludeExpiredCertificates)
    }

    if ($null -ne $ExpirationLimitInDays -and -not [String]::IsNullOrWhiteSpace($ExpirationLimitInDays))
    {
        $getReasonsParameters['ExpirationLimitInDays'] = [System.Convert]::ToInt32($ExpirationLimitInDays)
    }

    if ($null -ne $CertificateThumbprintsToInclude -and -not [String]::IsNullOrWhiteSpace($CertificateThumbprintsToInclude))
    {
        $getReasonsParameters['CertificateThumbprintsToInclude'] = $CertificateThumbprintsToInclude.Split(';').Trim()
    }

    if ($null -ne $CertificateThumbprintsToExclude -and -not [String]::IsNullOrWhiteSpace($CertificateThumbprintsToExclude))
    {
        $getReasonsParameters['CertificateThumbprintsToExclude'] = $CertificateThumbprintsToExclude.Split(';').Trim()
    }

    $reasons = @(Get-ReasonsCertificateStoreDoesNotMatchExpected @getReasonsParameters)

    $certificateStoreInfo = @{
        CertificateStorePath = $CertificateStorePath
    }

    if ($null -ne $reasons -and $reasons.Count -gt 0)
    {
        $certificateStoreInfo['Reasons'] = $reasons
    }

    return $certificateStoreInfo
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $CertificateStorePath,

        [Parameter()]
        [String]
        $ExpirationLimitInDays,

        [Parameter()]
        [String]
        $CertificateThumbprintsToInclude = '',

        [Parameter()]
        [String]
        $CertificateThumbprintsToExclude = '',

        [Parameter()]
        [String]
        $IncludeExpiredCertificates = 'false'
    )

    $getReasonsParameters = @{
        CertificateStorePath = $CertificateStorePath
        IncludeExpiredCertificates = [System.Convert]::ToBoolean($IncludeExpiredCertificates)
    }

    if ($null -ne $ExpirationLimitInDays -and -not [String]::IsNullOrWhiteSpace($ExpirationLimitInDays))
    {
        $getReasonsParameters['ExpirationLimitInDays'] = [System.Convert]::ToInt32($ExpirationLimitInDays)
    }

    if ($null -ne $CertificateThumbprintsToInclude -and -not [String]::IsNullOrWhiteSpace($CertificateThumbprintsToInclude))
    {
        $getReasonsParameters['CertificateThumbprintsToInclude'] = $CertificateThumbprintsToInclude.Split(';').Trim()
    }

    if ($null -ne $CertificateThumbprintsToExclude -and -not [String]::IsNullOrWhiteSpace($CertificateThumbprintsToExclude))
    {
        $getReasonsParameters['CertificateThumbprintsToExclude'] = $CertificateThumbprintsToExclude.Split(';').Trim()
    }

    $reasons = @(Get-ReasonsCertificateStoreDoesNotMatchExpected @getReasonsParameters)

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
        [ValidateNotNullOrEmpty()]
        [String]
        $CertificateStorePath,

        [Parameter()]
        [String]
        $ExpirationLimitInDays,

        [Parameter()]
        [String]
        $CertificateThumbprintsToInclude = '',

        [Parameter()]
        [String]
        $CertificateThumbprintsToExclude = '',

        [Parameter()]
        [String]
        $IncludeExpiredCertificates = 'false'
    )

    throw 'Set functionality is not supported in this version of the DSC resource.'
}
