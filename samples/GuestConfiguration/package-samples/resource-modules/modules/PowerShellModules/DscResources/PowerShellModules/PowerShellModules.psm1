function Get-ReasonsModulesNotInstalled
{
    [CmdletBinding()]
    [OutputType([Hashtable[]])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Modules
    )

    $reasons = @()
    $reasonCodePrefix = 'PowerShellModules:PowerShellModules'

    $moduleVersionStrings = @($Modules.Split(';'))

    foreach ($moduleVersionString in $moduleVersionStrings)
    {
        $moduleInfo = @($moduleVersionString.Split(',').Trim())
        $moduleName = $moduleInfo[0]
        $module = powershell -OutputFormat 'Xml' -NonInteractive -Command {param ($moduleName) $env:PSModulePath = ([Environment]::GetEnvironmentVariables("Machine")).PSModulePath; Get-Module -Name $moduleName -ListAvailable} -args $moduleName

        if ($null -eq $module)
        {
            Write-Verbose -Message "Could not find an installed module with the name '$moduleName'."
            $reason = @{
                Code = $reasonCodePrefix + ':ModuleNotInstalled'
                Phrase = "Could not find an installed module with the name '$moduleName'."
            }
            $reasons += $reason
        }
        elseif ($moduleInfo.Count -gt 1)
        {
            $moduleVersion = $moduleInfo[1]
            $moduleVersionFound = $false
            
            foreach ($moduleOption in $module)
            {
                if ($moduleOption.Version -eq $moduleVersion)
                {
                    $moduleVersionFound = $true
                }
            }

            if (-not $moduleVersionFound)
            {
                Write-Verbose -Message "Could not find an installed module with the name '$moduleName' and the version '$moduleVersion'."
                $reason = @{
                    Code = $reasonCodePrefix + ':ModuleVersionNotInstalled'
                    Phrase = "Could not find an installed module with the name '$moduleName' and the version '$moduleVersion'."
                }
                $reasons += $reason
            }
        }
    }

    return $reasons
}

function Get-AllInstalledModules
{
    [CmdletBinding()]
    [OutputType([String])]
    param ()

    $modulesStringList = @()
    $modules = powershell -OutputFormat 'Xml' -NonInteractive -Command {$env:PSModulePath = ([Environment]::GetEnvironmentVariables("Machine")).PSModulePath; Get-Module -ListAvailable}

    foreach ($module in $modules)
    {
        $moduleString = "$($module.Name), $($module.Version)"
        $modulesStringList += $moduleString
    }

    return $modulesStringList -join ';'
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
        $Modules
    )

    $powerShellModulesInfo = @{
        Modules = Get-AllInstalledModules
    }

    $reasons = @(Get-ReasonsModulesNotInstalled -Modules $Modules)

    if ($null -ne $reasons -and $reasons.Count -gt 0)
    {
        $powerShellModulesInfo['Reasons'] = $reasons
    }

    return $powerShellModulesInfo
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
        $Modules
    )

    $reasons = @(Get-ReasonsModulesNotInstalled -Modules $Modules)

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
        $Modules
    )

    throw 'Set functionality is not supported in this version of the DSC resource.'
}
