<#
    .SYNOPSIS
        Retrieves the compliance status of the node based on whether the local EMS settings match those specified.

    .Parameter IsSingleInstance
        Specifies the resource is a single instance

    .PARAMETER EMSPortNumber
        The expected value of the EMS setting 'emsportnumber' on the machine.

    .PARAMETER EMSBaudRate
        The expected value of the EMS setting 'emsbaudrate' on the machine.
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
        
        [Parameter(Mandatory = $true)]
        [String]
        $EMSPortNumber,

        [Parameter(Mandatory = $true)]
        [String]
        $EMSBaudRate
    )

    $reasons = @(Get-ReasonsSACisNotComplaint -EMSPortNumber $EMSPortNumber -EMSBaudRate $EMSBaudRate)
    $actualEMSPortNumber = Get-CurrentEMSPortNumber
    $actualEMSBaudRate = Get-CurrentEMSBaudRate

    $SACInfo = @{
        IsSingleInstance = 'Yes'
        EMSPortNumber = $actualEMSPortNumber
        EMSBaudRate = $actualEMSBaudRate
    }
    
    if ($null -ne $reasons -and $reasons.Count -gt 0)
    {
        $SACInfo['Reasons'] = $reasons
    }
    
    return $SACInfo
}
<#
   .SYNOPSIS
        Tests the Complaince Status of the Node based on whether the local EMS settings matches those specified.

    .Parameter IsSingleInstance
        Specifies the resource is a single instance

    .PARAMETER EMSPortNumber
        The expected value of the EMS setting 'emsportnumber' on the machine.

    .PARAMETER EMSBaudRate
        The expected value of the EMS setting 'emsbaudrate' on the machine.
#>
function Test-TargetResource
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
        [String]
        $EMSPortNumber,

        [Parameter(Mandatory = $true)]
        [String]
        $EMSBaudRate
    )

    $reasons = @(Get-ReasonsSACisNotComplaint -EMSPortNumber $EMSPortNumber -EMSBaudRate $EMSBaudRate)

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
        [ValidateSet('Yes')]
        [String]
        $IsSingleInstance,

        [Parameter(Mandatory = $true)]
        [String]
        $EMSPortNumber,

        [Parameter(Mandatory = $true)]
        [String]
        $EMSBaudRate
    )

    throw 'Set functionality is not supported in this version of the DSC resource.'
}
<#
    .SYNOPSIS
        Get the reasons why the node is non-compliant.

    .PARAMETER EMSPortNumber
        The expected value of the EMS setting 'emsportnumber' on the machine.

    .PARAMETER EMSBaudRate
        The expected value of the EMS setting 'emsbaudrate' on the machine.
#>
function Get-ReasonsSACisNotComplaint
{
    [CmdletBinding()]
    [OutputType([Hashtable[]])]
    param
    (
       [Parameter()]
       [String]
       $EMSPortNumber,

       [Parameter()]
       [String]
       $EMSBaudRate
    )
    $reasons = @()
    $reasonCodePrefix = 'WindowsSerialConsole:WindowsSerialConsole'
    
    #SAC is supported on server versions of Windows but isn't available on client versions (for example, Windows 10, Windows 8, or Windows 7).
    $OSType = Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName . | Select-Object -Property ProductType | % ProductType

    if($OSType -eq '2' -or $OSType -eq '3'){
        
        # For SAC to be configured correctly, EMS must be true and debug must be false.
        # To determine this we look at the results of BCDEdit.exe.
        # Check if EMS is enabled.
        $checkems = bcdedit /enum | Select-String -Pattern "ems"
        
        if(-not [String]::IsNullOrEmpty($checkems))
        {
            Write-Verbose "EMS enabled is true."
                    
            #check for Port and Baud rate
            $emsportValue = Get-CurrentEMSPortNumber

            if(-not [String]::IsNullOrEmpty($emsportValue)){

                
                if($EMSPortNumber -ne $emsportValue)
                {
                    $reasons += @{
                        Code   = '{0}:{1}' -f $reasonCodePrefix, 'EMSPortNotExpected'
                        Phrase = ("The current EMS port number '{0}' does not match the specified port number '{1}'." -f $emsportValue, $EMSPortNumber)
                    }
                }
            }
            else{

                $reasons += @{
                        Code   = '{0}:{1}' -f $reasonCodePrefix, 'EMSPortNumberMissing'
                        Phrase = ("The EMS port number setting could not be retrieved on this machine. For serial console to work, EMS must be enabled and the EMS baud rate and EMS port number must be set.")
                        }
            }

            $emsbaudrateValue = Get-CurrentEMSBaudRate

            if(-not [String]::IsNullOrEmpty($emsbaudrateValue)){
            
                if($emsbaudrateValue -ne $EMSBaudRate)
                {
                    $reasons += @{
                        Code   = '{0}:{1}' -f $reasonCodePrefix, 'EMSBaudRateNotExpected'
                        Phrase = ("The EMS Baud Rate : '{0}' mismatch the value specified : '{1}' " -f $emsbaudrateValue, $EMSBaudRate)
                    }
                }
            }
            else{

                    $reasons += @{
                        Code   = '{0}:{1}' -f $reasonCodePrefix, 'EMSBaudRateMissing'
                        Phrase = ("The EMS baud rate setting could not be retrieved on this machine. For serial console to work, EMS must be enabled and the EMS baud rate and EMS port number must be set.")
                        }
            }

        }
        else {
            Write-Verbose "EMS is not enabled."
            $reasons += @{
                        Code   = '{0}:{1}' -f $reasonCodePrefix, 'EMSNotEnabled'
                        Phrase = ("EMS is not enabled on this machine. For serial console to work, EMS must be enabled and the EMS baud rate and EMS port number must be set.")
                        }

        }
        
        # See if debug is disabled.
        $Isdebug= bcdedit /enum | Select-String "debug"

        if(-not [String]::IsNullOrEmpty($Isdebug))
        {
            Write-Verbose "Debug enabled is true."
            $reasons += @{
                        Code   = '{0}:{1}' -f $reasonCodePrefix, 'Debug'
                        Phrase = ("BCDEdit Debug setting is Enabled on this machine. For SAC to be configured correctly, EMS must be enabled and debug must not be enabled.")
                        }
        }
    }
    return $reasons
}
function Get-CurrentEMSPortNumber
{
    [CmdletBinding()]
    [OutputType([string])]
    param
    ()

    $emsportValue = ''

    $checkemsport = bcdedit /enum All| Select-String -Pattern "emsport"
    
    if(-not [String]::IsNullOrEmpty($checkemsport)){

        $emsportSetting = $checkemsport.ToString().Split(" ")
       
        if($emsportSetting.Count -gt 1 )
        {
            $emsportValue = $emsportSetting[$emsportSetting.Count-1]
        }
    }
    
    return $emsportValue
}

function Get-CurrentEMSBaudRate
{
    [CmdletBinding()]
    [OutputType([string])]
    param
    ()

    $emsbaudrateValue = ''

    $checkemsbaudrate = bcdedit /enum All| Select-String -Pattern "emsbaudrate"
            
    if(-not [String]::IsNullOrEmpty($checkemsbaudrate)){
    
        $emsbaudrateSetting = $checkemsbaudrate.ToString().Split(" ")
        
        if($emsbaudrateSetting.Count -gt 1 ){
            $emsbaudrateValue = $emsbaudrateSetting[$emsbaudrateSetting.Count-1]
        }
    }

    return $emsbaudrateValue
}
