<#
    .SYNOPSIS
        Retrieves the compliance status of the node based on the status of the specified DSC configuration
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
        [Boolean]
        $CompliantWhenNotManaged = $true
    )

    $reasons = @(Get-ReasonsDscConfigurationNotComplaint -CompliantWhenNotManaged $CompliantWhenNotManaged)

    $dscConfigurationInfo = @{
        IsSingleInstance = 'Yes'
    }
    
    if ($null -ne $reasons -and $reasons.Count -gt 0)
    {
        $dscConfigurationInfo['Reasons'] = $reasons
        $dscConfigurationInfo['DSCLogs'] = Get-DSCLogs

    }
    
    return $dscConfigurationInfo
}
<#
    .SYNOPSIS
        Test whether or not the Node is complaint based on the status of the specified DSC configuration

    .DESCRIPTION
        Returns false if the VM is not running the specified the DSC configuration or if the Test-DscConfiguration returned False.
        Returns true otherwise.
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
        [Boolean]
        $CompliantWhenNotManaged = $true
    )

    $reasons = @(Get-ReasonsDscConfigurationNotComplaint -CompliantWhenNotManaged $CompliantWhenNotManaged)

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
        [ValidateSet('Yes')]
        [String]
        $IsSingleInstance,

        [Parameter()]
        [Boolean]
        $CompliantWhenNotManaged = $true
    )

    throw 'Set functionality is not supported in this version of the DSC resource.'
}
<#
    .SYNOPSIS
        Run Test-DscConfiguration and check if there is any resource not in the desired status.
        if Test-DscConfiguration return 'False', it will return reason with the name of failing resource as well as compress the JSON and MOF file as send it as a compressed string in the reasons list.

    .DESCRIPTION
        Run Test-DscConfiguration and check if there is any resource not in the desired status.
        if Test-DscConfiguration return 'False', it will return reason with the name of failing resource as well as compress the JSON and MOF file as send it as a compressed string in the reasons list.
#>
function Get-ReasonsDscConfigurationNotComplaint
{
    [CmdletBinding()]
    [OutputType([Hashtable[]])]
    param
    (
        [Parameter()]
        [Boolean]
        $CompliantWhenNotManaged = $true
    )

    $reasons = @()
    $reasonCodePrefix = 'WindowsDscConfiguration:WindowsDscConfiguration'
    
    $fullpspath = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
    
    $psVersion  = & $fullpspath -noprofile -NonInteractive -command {$env:PSModulePath = [System.Environment]::GetEnvironmentVariable("PSModulePath", "Machine"); $PSVersionTable.PSVersion}
    
    # Only run verification code if WMF insatlled version is 4 or higher; DSC is not supported on WMF 3 or lower.
    if ($psVersion.Major -gt 3 )
    {
        Write-Verbose -Message  "Checking the status of the DSC configuration running on the machine if any exists..."

        $currentConfigurationName  =  Get-ConfigurationName

        if ($null -ne $currentConfigurationName)
        {
            Write-Verbose "DSC configuration running locally is $currentConfigurationName" 

            $currentStatus = & $fullpspath -noprofile -NonInteractive -command {$env:PSModulePath = [System.Environment]::GetEnvironmentVariable("PSModulePath", "Machine");Get-DscConfigurationStatus -ErrorAction SilentlyContinue }
            
            if ($null -ne $currentStatus)
            {
                $resourcesNotInDesiredState = $currentStatus.ResourcesNotInDesiredState.ResourceId
            
                if ($null -ne $resourcesNotInDesiredState)
                {
                    $resourcesNotInDesiredState = $resourcesNotInDesiredState -join ', '
                    
                    $reasons += @{
                        Code   = '{0}:{1}' -f $reasonCodePrefix, 'GetDscConfigurationStatusFailed'
                        Phrase = ("The current DSC configuration with the name '{0}' returned a non-compliant status. The resources with the following IDs are not in the desired state: {1}." -f $currentConfigurationName, $resourcesNotInDesiredState)
                        }
                }
                else
                {
                    Write-Verbose -Message "All resources are in desired state."           
                }
            }
            else
            {
                $reasons += @{
                    Code   = '{0}:{1}' -f $reasonCodePrefix, 'GetDscConfigurationStatusFailed'
                    Phrase = ("Could not retrieve the status of the current DSC configuration with the name '{0}'. The Get-DscConfigurationStatus operation returned null." -f $currentConfigurationName)
                }
            }
        }
        else
        {
            Write-Verbose -Message "This node is not currently managed by any DSC configuration."

            if ($false -eq $CompliantWhenNotManaged)
            {
                $reasons += @{
                    Code   = '{0}:{1}' -f $reasonCodePrefix, 'NotManaged'
                    Phrase = ("This node is not currently managed by any DSC configuration.")
                }
            }
        }
    }
    else
    {
        Write-Verbose -Message "DSC is only supported on WMF 4 and higher" 
    }

    return $reasons
}

function Get-DSCLogs
{
    [CmdletBinding()]
    [OutputType([Hashtable[]])]
    param
    ()
    
    $dsclogs = @()
    
    $fullpspath = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
        
    #if we run on WMF 5 or lower return as DSC logs required to be uploaded does not exists on these SKUs
    $psVersion  = & $fullpspath -noprofile -NonInteractive -command {$env:PSModulePath = [System.Environment]::GetEnvironmentVariable("PSModulePath", "Machine"); $PSVersionTable.PSVersion}
    
    if (($psVersion.Major -eq 5 -and $psVersion.Minor -eq 1) -or $psVersion.Major -gt 5 )
    {
        
        #upload JSON and MOF files
        $currentStatus = & $fullpspath -noprofile -NonInteractive -command {$env:PSModulePath = [System.Environment]::GetEnvironmentVariable("PSModulePath", "Machine");Get-DscConfigurationStatus -ErrorAction SilentlyContinue }
                                    
        $jobId = $currentStatus.JobID
        
        $searchPath = "$env:windir\system32\configuration\ConfigurationStatus"
        
        $jsonFileFilter = $jobId + "-*.details.json"
        
        $mofFileFilter = $jobId + "-*.mof"

        #Compress Json Content
        Get-ChildItem $searchPath -Filter $jsonFileFilter | 
        Foreach-Object {
            if (Test-Path $_.FullName)
            {
                $jsoncontent = Get-Content -Path $_.FullName | Out-String
                $jsoncontentCompressed = Compress-String $jsoncontent
                if ($jsoncontentCompressed.Length -lt 300kb)
                {
                    $dsclogs += @{
                        Name   = 'JSONContent:UTF8'
                        Content = ("{0}" -f $jsoncontentCompressed)
                    }
                }
                else 
                {
                    Write-Warning "JSON file will not be compressed and returned by the agent. The file size is bigger than the current compress limit." 
                }
            }
        }
        
        # Compress MOF
        Get-ChildItem $searchPath -Filter $mofFileFilter | 
        Foreach-Object { 
            if (Test-Path $_.FullName)
            {
                $mofcontent = Get-Content -Path $_.FullName | Out-String
                $mofcontentCompressed = Compress-String $mofcontent
                if ($mofcontentCompressed.Length -lt 300kb)
                {
                    $dsclogs += @{
                        Name   = 'MOFContent:UTF8'
                        Content = ("{0}" -f $mofcontentCompressed)                                        
                    }
                }
                else 
                {
                    Write-Warning "MOF file will not be compressed and returned by the agent. The file size is bigger than the current compress limit." 
                }
            }
        }
    }

    return $dsclogs
}

function Compress-String
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $stringValue,

        [Parameter()]
        [System.Text.Encoding]
        $encoding = [System.Text.Encoding]::UTF8
    )

    try
    {
        $bytesValue = $encoding.GetBytes($stringValue)

        $outputStream = New-Object System.IO.MemoryStream

        try
        {
                $gzipStream = New-Object System.IO.Compression.GzipStream $outputStream, ([IO.Compression.CompressionMode]::Compress)
    
                $gzipStream.Write( $bytesValue, 0, $bytesValue.Length )

                $compressedString = [Convert]::ToBase64String($outputStream.ToArray()) 
        }
        finally
        {
            if ($null -ne $gzipStream)
            {
                $gzipStream.Close()    
            }
        }
        
    }
    catch
    {
        Write-Warning "Error occurred during the compression of DSC logs." 
    }
    finally
    {
              
        try
        {
            if ($null -ne $outputStream)
            {
                $outputStream.close()    
            }
        }
        catch
        {
            Write-Warning "Error occurred while closing output stream." 
        }
    }  

    return $compressedString
 }

function Get-ConfigurationName
{
    [CmdletBinding()]
    [OutputType([String])]
    param()
    
    $fullpspath = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
    $configName = @(& $fullpspath -noprofile -NonInteractive -command {$env:PSModulePath = [System.Environment]::GetEnvironmentVariable("PSModulePath", "Machine");Get-DscConfiguration -ErrorAction SilentlyContinue} | Select-Object ConfigurationName)
    if ($null -ne $configName)
    {
        $currentConfigurationName  = ($configName)[0].ConfigurationName
        return $currentConfigurationName
    }
    else
    {
        return $null
    }
 }
