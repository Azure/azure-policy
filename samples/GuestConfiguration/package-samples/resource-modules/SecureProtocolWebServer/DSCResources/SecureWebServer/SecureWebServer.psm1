# Localized messages
data LocalizedData
{
    # culture="en-US"
    ConvertFrom-StringData -StringData @'
        SetTargetResourceNotSupported  = Set functionality is not supported in this version of the DSC resource.
        ProtocolNotCompliant           = Protocol {0} not compliant.
        ProtocolCompliant              = Protocol {0} compliant.
        SecureProtocolNotEnabled       = The secure security protocol {0} is not enabled on this web server.
        InsecureProtocolEnabled        = The insecure security protocol {0} is enabled on this web server.
'@
}

<#
    .SYNOPSIS
        Retrieves a list of known insecure security protocols.
#>
function Get-InsecureProtocols
{
    [OutputType([String[]])]
    param ()

    $insecureProtocols = @('SSL 2.0', 'SSL 3.0', 'TLS 1.0', 'PCT 1.0', 'Multi-Protocol Unified Hello')
    return $insecureProtocols
}

<#
    .SYNOPSIS
        Retrieves a list of known secure security protocols.
#>
function Get-SecureProtocols
{
    [OutputType([String[]])]
    param ()

    $secureProtocols = @('TLS 1.1', 'TLS 1.2')
    return $secureProtocols
}

<#
    .SYNOPSIS
        Retrieves the list of supported TLS protocol versions.
#>
function Get-AllSupportedTLSVersions
{
    [OutputType([String[]])]
    param ()

    $tlsVersions = @('1.0', '1.1', '1.2')
    return $tlsVersions
}

<#
    .SYNOPSIS
        Retrieves a list of all known security protocols.
#>
function Get-AllProtocols
{
    [OutputType([String[]])]
    param ()

    $insecureProtocols = @(Get-InsecureProtocols)
    $secureProtocols = @(Get-SecureProtocols)
    $allProtocols = $insecureProtocols + $secureProtocols

    return $allProtocols
}

<#
    .SYNOPSIS
        Retrieves the security channel registry root path.
#>
function Get-SecurityChannelProtocolRoot
{
    [OutputType([String])]
    param ()

    $securityChannelProtocolRoot = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols'
    return $securityChannelProtocolRoot
}

<#
    .SYNOPSIS
        Retrieves information on whether or not the specified security protocol is present or absent.

    .PARAMETER Protocol
        The security protocol of which to retrieve the information.
#>
function Get-SecurityChannelProtocolInfo
{
    [OutputType([Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $Protocol
    )

    $enabledValues = @(1, 4294967295)
    $securityChannelProtocolRoot = Get-SecurityChannelProtocolRoot

    $securityChannelProtocolInfo = @{
        Protocol = $Protocol
        Ensure = 'Absent'
    }

    $securityChannelProtocolKey = Join-Path -Path $securityChannelProtocolRoot -ChildPath $Protocol
    $securityChannelProtocolServerKey = Join-Path -Path $securityChannelProtocolKey -ChildPath 'Server'

    if (Test-Path -Path $securityChannelProtocolServerKey)
    {
        Write-Verbose -Verbose -Message "Protocol key exists."
        $securityChannelProtocolServerItem = Get-Item -Path $securityChannelProtocolServerKey
        if ($null -ne $securityChannelProtocolServerItem)
        {
            Write-Verbose -Verbose -Message "Protocol key value not null."
            $securityChannelProtocolServerEnabledValue = $securityChannelProtocolServerItem.GetValue("Enabled")
            if ($securityChannelProtocolServerEnabledValue -in $enabledValues)
            {
                Write-Verbose -Verbose -Message "Protocol key value is enabled."
                $securityChannelProtocolServerDisabledByDefaultValue = $securityChannelProtocolServerItem.GetValue("DisabledByDefault")
                if ($null -eq $securityChannelProtocolServerDisabledByDefaultValue -or $securityChannelProtocolServerDisabledByDefaultValue -eq 0)
                {
                    Write-Verbose -Verbose -Message "Protocol key value is not disabled by default."
                    $securityChannelProtocolInfo['Ensure'] = 'Present'
                }
            }
        }
    }

    return $securityChannelProtocolInfo
}

<#
    .SYNOPSIS
        Retrieves information on whether or not the specified security protocols are present or absent.

    .PARAMETER Protocols
        The security protocols of which to retrieve the information.
#>
function Get-SecurityChannelProtocolsInfo
{
    [OutputType([Hashtable[]])]
    param
    (
        [Parameter(Mandatory = $true)]
        [String[]]
        $Protocols
    )

    $securityChannelProtocolsInfo = @()
    foreach ($protocol in $Protocols)
    {
        $securityChannelProtocolInfo = Get-SecurityChannelProtocolInfo -Protocol $protocol
        $securityChannelProtocolsInfo += $securityChannelProtocolInfo
    }

    return $securityChannelProtocolsInfo
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
        $IsSingleInstance,

        [Parameter()]
        [ValidateSet('1.1', '1.2')]
        [String]
        $MinimumTLSVersion = '1.1'
    )

    throw $LocalizedData.SetTargetResourceNotSupported
}

<#
    .SYNOPSIS
        Returns the current state of the web server security channel protocols.

    .PARAMETER IsSingleInstance
        Specifies the resource is a single instance, the value must be 'Yes'.

    .EXAMPLE
        Get-TargetResource -IsSingleInstance 'Yes'
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

        [Parameter()]
        [ValidateSet('1.1', '1.2')]
        [String]
        $MinimumTLSVersion = '1.1'
    )

    $protocols = Get-AllProtocols
    $securityChannelProtocolsInfo = Get-SecurityChannelProtocolsInfo -Protocols $protocols
    $failureReasons = @(Get-WebServerProtocolsReasonsForInsecure -MinimumTLSVersion $MinimumTLSVersion)

    $secureWebServerInfo = @{
        IsSingleInstance = $IsSingleInstance
        Protocols = $securityChannelProtocolsInfo
        IsWebServer = Test-IsWebServer
        MinimumTLSVersion = Get-LowestTLSVersionEnabledOnCurrentMachine
    }

    if ($failureReasons.Count -gt 0)
    {
        $displayReason = Get-ProtocolDisplayReason -ProtocolsInfo $securityChannelProtocolsInfo
        $secureWebServerInfo['Reasons'] = $failureReasons + $displayReason
    }

    return $secureWebServerInfo
}

<#
    .SYNOPSIS
        Retrieves the state of the Windows Feature with the specified name via full PowerShell.

    .PARAMETER FeatureName
        The name of the Windows Feature of which to retrieve the state.
#>
function Get-WindowsFeatureInternal
{
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $FeatureName
    )

    $result = @{
        Installed = $false
    }

    $tmpfileName = [System.IO.Path]::GetRandomFileName()
    # This command needs to be run through full PowerShell rather than through PowerShell Core which is what the Policy engine runs
    $null = Invoke-Command -ScriptBlock {
        param ($fileName)
        $fullPowerShellExePath = "$env:SystemRoot\System32\WindowsPowershell\v1.0\powershell.exe"
        $oldPSModulePath = $env:PSModulePath
        try
        {
            # Set env variable to full powershell module path so that powershell can discover Get-WindowsFeature cmdlet.
            $env:PSModulePath = "$env:SystemRoot\System32\WindowsPowershell\v1.0\Modules"
            &$fullPowerShellExePath -command "if (Get-Command 'Get-WindowsFeature' -errorAction SilentlyContinue){Get-WindowsFeature -Name Web-Server | ConvertTo-Json | Out-File $fileName} else { Add-Content -Path $fileName -Value 'NotServer'}"
        }
        finally
        {
            $env:PSModulePath = $oldPSModulePath
        }
    } -args $tmpfileName
    
    if (Test-Path -Path $tmpfileName)
    {
        $fileContent = Get-Content -Path $tmpfileName
        if ($fileContent -ne 'NotServer') 
        {
            $result = Get-Content -Path $tmpfileName -Raw | ConvertFrom-Json
        }
        $null = Remove-Item -Path $tmpfileName
    }

    return $result
}

function Get-ProtocolDisplayReason
{
    [CmdletBinding()]
    [OutputType([Hashtable[]])]
    param
    (
        [Parameter()]
        [Hashtable[]]
        $ProtocolsInfo
    )

    $reasonCodePrefix = "SecureProtocolWebServer:SecureWebServer"
    $protocolDisplayReasonCode = "{0}:{1}" -f $reasonCodePrefix, "DisplayProtocolInfo"
    $protocolDisplayReason = @{
        Code = $protocolDisplayReasonCode
        Phrase = "Displaying current status of protocols: `n"
    }

    foreach ($protocolInfo in $ProtocolsInfo)
    {
        $protocolDisplayReason['Phrase'] += "$($protocolInfo.Protocol) - $($protocolInfo.Ensure) `n"
    }

    return $protocolDisplayReason
}

<#
    .SYNOPSIS
        Tests whether or not the current machine is a web server with secure security channel protocols.

    .PARAMETER IsSingleInstance
        Specifies the resource is a single instance, the value must be 'Yes'.

    .EXAMPLE
        Test-TargetResource -IsSingleInstance 'Yes'
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

        [Parameter()]
        [ValidateSet('1.1', '1.2')]
        [String]
        $MinimumTLSVersion = '1.1'
    )

    $failureReasons = @(Get-WebServerProtocolsReasonsForInsecure -MinimumTLSVersion $MinimumTLSVersion)

    if ($failureReasons.Count -eq 0)
    {
        return $true
    }
    else
    {
        return $false
    }
}

<#
    .SYNOPSIS
        Tests whether or not the current machine is a web sever.
#>
function Test-IsWebServer
{
    [OutputType([Boolean])]
    param()

    # Check whether Web-Server is installed or not.
    $webFeature = Get-WindowsFeatureInternal -FeatureName 'Web-Server'
    return $webFeature.Installed
}

function Get-LowestTLSVersionEnabledOnCurrentMachine
{
    [CmdletBinding()]
    [OutputType([String])]
    param ()

    $lowestTLSVersion = ""
    $tlsProtocols = Get-AllSupportedTLSVersions

    foreach ($tlsProtocol in $tlsProtocols)
    {
        if ([String]::IsNullOrEmpty($lowestTLSVersion) -or $tlsProtocol -lt $lowestTLSVersion)
        {
            $tlsProtocolInfo = Get-SecurityChannelProtocolInfo -Protocol "TLS $tlsProtocol"
            if ($tlsProtocolInfo.Ensure -eq 'Present')
            {
                $lowestTLSVersion = $tlsProtocol
            }
        }
    }

    return $lowestTLSVersion
}

<#
    .SYNOPSIS
        Retrieves a list of reasons about why the current machine is a web server that is insecure.
        If the current machine is not a web server or is found to be a secure web server, an empty
        list is returned.
#>
function Get-WebServerProtocolsReasonsForInsecure
{
    [OutputType([Hashtable[]])]
    param
    (
        [Parameter()]
        [ValidateSet('1.1', '1.2')]
        [String]
        $MinimumTLSVersion = '1.1'
    )

    $reasons = @()
    $reasonCodePrefix = "SecureProtocolWebServer:SecureWebServer"

    if (-not (Test-IsWebServer))
    {
        # Since web server is not installed no protocol checking is needed.
        return $reasons
    }

    $insecureProtocols = @(Get-InsecureProtocols)
    $insecureProtocolsInfo = Get-SecurityChannelProtocolsInfo -Protocols $insecureProtocols

    Write-Verbose -Message ($LocalizedData.TestClientProtocol -f $Protocol, $Ensure)

    foreach ($insecureProtocol in $insecureProtocolsInfo)
    {
        $expectedEnsureValue = 'Absent'

        if ($insecureProtocol.Ensure -eq $expectedEnsureValue)
        {
            Write-Verbose -Message ($LocalizedData.ProtocolCompliant -f $($insecureProtocol.Protocol))
        }
        else
        {
            Write-Verbose -Message ($LocalizedData.ProtocolNotCompliant -f $($insecureProtocol.Protocol))
            $reason = @{
                Code = "{0}:{1}" -f $reasonCodePrefix, "InsecureProtocolEnabled"
                Phrase = "The insecure security protocol $($insecureProtocol.Protocol) is enabled on this web server. `n"
            }
            $reasons += $reason
        }
    }

    $lowestTLSProtocolOnMachine = Get-LowestTLSVersionEnabledOnCurrentMachine

    if ([String]::IsNullOrEmpty($lowestTLSProtocolOnMachine))
    {
        Write-Verbose -Message ($LocalizedData.ProtocolNotCompliant -f $($lowestTLSProtocolOnMachine))
        $reason = @{
            Code = "{0}:{1}" -f $reasonCodePrefix, "SecureTLSProtocolNotEnabled"
            Phrase = "Could not find any secure TLS protocol version enabled on this web server. `n"
        }
        $reasons += $reason
    }
    elseif ($lowestTLSProtocolOnMachine -lt $MinimumTLSVersion)
    {
        Write-Verbose -Message ($LocalizedData.ProtocolNotCompliant -f $($lowestTLSProtocolOnMachine))
        $reason = @{
            Code = "{0}:{1}" -f $reasonCodePrefix, "MinimumTLSProtocolNotEnabled"
            Phrase = "There is a lower TLS protocol enabled than the minimum TLS protocol version expected on this web server. The current lowest TLS version enabled on this machine is '$lowestTLSProtocolOnMachine'. The expected minimum TLS protocol version is '$MinimumTLSVersion'. `n"
        }
        $reasons += $reason
    }
    else
    {
        Write-Verbose -Message "Minimum TLS version is is compliant with expected minimum TLS protocol version on this web server. The current lowest TLS version enabled on this machine is '$lowestTLSProtocolOnMachine'. The expected minimum TLS protocol version is '$MinimumTLSVersion'. `n"
    }
    
    return $reasons
}
