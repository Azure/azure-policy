<#
    .SYNOPSIS
        Retrieves the connection status to remote host machine

    .Parameter Host
        Specifies the Domain Name System (DNS) name or IP address of the target computer 

    .PARAMETER Port
        Specifies the TCP port number on the remote computer 

    .PARAMETER ShouldConnect
        Must be 'True' or 'False'. True indicates that the node can establish connection with remote host specified, False indicates that the node can not establish connection with remote host specified 
#>
function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $host,
        
        [Parameter(Mandatory = $true)]
        [String]
        $port,

        [Parameter(Mandatory = $true)]
        [ValidateSet('True', 'False')]
        [String]
        $shouldConnect
    )

    $reasons = @(Get-ReasonsRemoteConnectionIsNotCompliant -host $host -port $port -shouldConnect $shouldConnect)
    
    $WindowsRemoteConnectionInfo = @{
        host = $host
        port = $port
        shouldConnect = $shouldConnect
    }
    
    if ($null -ne $reasons -and $reasons.Count -gt 0)
    {
        $WindowsRemoteConnectionInfo['Reasons'] = $reasons
    }
    
    return $WindowsRemoteConnectionInfo
}
<#
   .SYNOPSIS
        Tests the complaince status of the node based on connection status to remote host machine

    .Parameter Host
        Specifies the Domain Name System (DNS) name or IP address of the target computer 

    .PARAMETER Port
        Specifies the TCP port number on the remote computer

    .PARAMETER ShouldConnect
        Must be 'True' or 'False'. True indicates that the node can establish connection with remote host specified, False indicates that the node can not establish connection with remote host specified
#>
function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $host,
        
        [Parameter(Mandatory = $true)]
        [String]
        $port,

        [Parameter(Mandatory = $true)]
        [ValidateSet('True', 'False')]
        [String]
        $shouldConnect
    )

    $reasons = @(Get-ReasonsRemoteConnectionIsNotCompliant -host $host -port $port -shouldConnect $shouldConnect)

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
        [String]
        $host,
        
        [Parameter(Mandatory = $true)]
        [String]
        $port,

        [Parameter(Mandatory = $true)]
        [ValidateSet('True', 'False')]
        [String]
        $shouldConnect
    )

    throw 'Set functionality is not supported in this version of the DSC resource.'
}
<#
    .SYNOPSIS
        Get the reasons why the node is non-compliant.

    .PARAMETER Host
        Specifies the Domain Name System (DNS) name or IP address of the target computer

    .PARAMETER Port
        Specifies the TCP port number on the remote computer 

    .PARAMETER ShouldConnect
        Must be 'True' or 'False'. True indicates that the node can establish connection with remote host specified, False indicates that the node can not establish connection with remote host specified 
#>
function Get-ReasonsRemoteConnectionIsNotCompliant
{
    [CmdletBinding()]
    [OutputType([Hashtable[]])]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $host,
        
        [Parameter(Mandatory = $true)]
        [String]
        $port,

        [Parameter(Mandatory = $true)]
        [ValidateSet('True', 'False')]
        [String]
        $shouldConnect
    )
    $reasons = @()
    $reasonCodePrefix = 'WindowsRemoteConnection:WindowsRemoteConnection'
    
    try {
            $canConnect = Test-Port -Server $host -port $port
    }
    catch {
             Write-Verbose -Message "An error occurred when attempting to establish a connection with the remote host $host on port $port"                
        }
    
    if($shouldConnect -eq 'True' -and (($false -eq $canConnect) -and ($null -ne $canConnect)))
    {
        $reasons += @{
                    Code   = '{0}:{1}' -f $reasonCodePrefix, 'ConnectionStatusFailed'
                    Phrase = ("This machine was not able to establish a connection with the remote host {0} on port {1}. A connection to this remote host should be possible on this machine" -f $host, $port)
                    }
    }

    if($shouldConnect -eq 'False' -and (($true -eq $canConnect)-and ($null -ne $canConnect))){
    $reasons += @{
        Code   = '{0}:{1}' -f $reasonCodePrefix, 'ConnectionStatusSucceeded'
        Phrase = ("This machine was able to establish a connection to the remote host with the name '{0}' on the port '{1}'. A connection to this remote host should not be possible on this machine" -f $host, $port)
        }
    }    
      
    return $reasons
}

function Test-Port
{
    [CmdletBinding()]
    [OutputType([Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $Server,
        
        [Parameter(Mandatory = $true)]
        [String]
        $port

    )
    $client = New-Object Net.Sockets.TcpClient
    try {
        $client.Connect($Server, $port)
        $CanConnect = $true
    } catch {
        $CanConnect = $false
    } finally {
        $client.Dispose()
    }

    return $CanConnect
}