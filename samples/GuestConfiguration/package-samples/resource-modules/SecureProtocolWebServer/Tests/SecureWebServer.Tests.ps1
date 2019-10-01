$errorActionPreference = 'Stop'
Set-StrictMode -Version 'Latest'

$script:resourceModuleName = 'SecureWebServer'

Describe "$script:resourceModuleName Tests" {
    BeforeAll {        
        $modulePath = Split-Path -Path $PSScriptRoot -Parent
        $moduleResourcesPath = Join-Path -Path $modulePath -ChildPath 'DscResources'
        $resourceFolderPath = Join-Path -Path $moduleResourcesPath -ChildPath $script:resourceModuleName
        $resourceModulePath = Join-Path -Path $resourceFolderPath -ChildPath "$script:resourceModuleName.psm1"
        Import-Module -Name $resourceModulePath -Force
    }

    InModuleScope $script:resourceModuleName {
        function Run-SecureWebServerComplianceTest
        {
            param
            (
                [Parameter(Mandatory = $true)]
                [Hashtable]
                $ResourceParameters,

                [Parameter(Mandatory = $true)]
                [Boolean]
                $ShouldBeCompliant,

                [Parameter()]
                [String[]]
                $ExpectedReasonCodes,

                [Parameter()]
                [Hashtable[]]
                $ActualProtocolInfo,

                [Parameter()]
                [Boolean]
                $ActualIsWebServerValue,

                [Parameter()]
                [String]
                $ActualLowestTLSVersion
            )

            $contextTitle = "PARAMETERS - "
            $resourceParameterStrings = @()

            foreach ($resourceParameterName in $ResourceParameters.Keys)
            {
                $resourceParameterStrings += ($resourceParameterName + ": $($ResourceParameters[$resourceParameterName])")
            }

            $contextTitle += $resourceParameterStrings -join ", "

            Context $contextTitle {
                Context 'Test-TargetResource' {
                    It 'Test-TargetResource should not throw' {
                        { $null = Test-TargetResource @ResourceParameters } | Should -Not -Throw
                    }

                    $testTargetResourceResult = Test-TargetResource @ResourceParameters

                    It 'Test-TargetResource should call Test-IsWebServer' {
                        Assert-MockCalled -CommandName 'Test-IsWebServer' -Scope 'Context'
                    }

                    if ($ActualIsWebServerValue)
                    {
                        It 'Test-TargetResource should call Get-SecurityChannelProtocolInfo' {
                            Assert-MockCalled -CommandName 'Get-SecurityChannelProtocolInfo' -Scope 'Context'
                        }
                    }

                    It "Test-TargetResource should return $ShouldBeCompliant" {
                        $testTargetResourceResult | Should -Be $ShouldBeCompliant
                    }
                }

                Context 'Get-TargetResource' {
                    It 'Get-TargetResource should not throw' {
                        { $null = Get-TargetResource @ResourceParameters } | Should -Not -Throw
                    }

                    $getTargetResourceResult = Get-TargetResource @ResourceParameters

                    It 'Get-TargetResource should call Test-IsWebServer' {
                        Assert-MockCalled -CommandName 'Test-IsWebServer' -Scope 'Context'
                    }

                    It 'Get-TargetResource should call Get-SecurityChannelProtocolInfo' {
                        Assert-MockCalled -CommandName 'Get-SecurityChannelProtocolInfo' -Scope 'Context'
                    }

                    It 'Get-TargetResource should return the IsSingleInstance property with the specified value' {
                        $getTargetResourceResult.IsSingleInstance | Should -Be $ResourceParameters.IsSingleInstance
                    }

                    It 'Get-TargetResource should return information on the same number of protocols that are currently on the machine' {
                        $getTargetResourceResult.Protocols.Count | Should -Be $ActualProtocolInfo.Count
                    }

                    foreach ($retrievedProtocol in $getTargetResourceResult.Protocols)
                    {
                        Write-Verbose -Message "PROTOCOL - $($retrievedProtocol.Protocol) ENSURE - $($retrievedProtocol.Ensure)" -Verbose
                    }

                    foreach ($actualProtocol in $ActualProtocolInfo)
                    {
                        It "Get-TargetResource should return the protocol '$($actualProtocol.Protocol)' as '$($actualProtocol.Ensure)'" {
                            $matchingProtocol = $getTargetResourceResult.Protocols | Where-Object {$_.Protocol -eq $actualProtocol.Protocol}
                            $matchingProtocol | Should -Not -Be $null
                            $matchingProtocol.Ensure | Should -Be $actualProtocol.Ensure
                        }
                    }

                    It 'Get-TargetResource should return whether the machine is a web server or not' {
                        $getTargetResourceResult.IsWebServer | Should -Be $ActualIsWebServerValue
                    }

                    It 'Get-TargetResource should return the lowest TLS version on the machine' {
                        $getTargetResourceResult.MinimumTLSVersion | Should -Be $ActualLowestTLSVersion
                    }

                    if ($ShouldBeCompliant)
                    {
                        It 'Get-TargetResource should return 4 properties' {
                            $getTargetResourceResult.Count | Should -Be 4
                        }

                        It 'Get-TargetResource should not return Reasons' {
                            $getTargetResourceResult.ContainsKey('Reasons') | Should -BeFalse
                        }
                    }
                    else
                    {
                        It 'Get-TargetResource should return 5 properties' {
                            $getTargetResourceResult.Count | Should -Be 5
                        }

                        It 'Get-TargetResource should return Reasons' {
                            $getTargetResourceResult.Reasons | Should -Not -Be $null
                        }

                        It "Get-TargetResource should return $($ExpectedReasonCodes.Count) Reasons" {
                            $getTargetResourceResult.Reasons.Count | Should -Be $ExpectedReasonCodes.Count
                        }

                        It "Get-TargetResource should return only the expected Reason Codes" {
                            Compare-Object -ReferenceObject $getTargetResourceResult.Reasons.Code -DifferenceObject $ExpectedReasonCodes | Should -Be $null
                        }
                    }
                }
            }
        }

        $reasonCodePrefix = "SecureProtocolWebServer:SecureWebServer:"
        $allProtocolNames = @('SSL 2.0', 'SSL 3.0', 'TLS 1.0', 'TLS 1.1', 'TLS 1.2', 'PCT 1.0', 'Multi-Protocol Unified Hello')

        Context 'Machine is not a web server and has no info on security protocols' {
            $actualIsWebServer = $false
            Mock -CommandName 'Test-IsWebServer' -MockWith { return $actualIsWebServer }
            Mock -CommandName 'Get-SecurityChannelProtocolInfo' -MockWith { return @() }

            $complianceTestParameters = @{
                ResourceParameters = @{
                    IsSingleInstance = 'Yes'
                }
                ShouldBeCompliant = $true
                ExpectedReasonCodes = @()
                ActualProtocolInfo = @()
                ActualIsWebServer = $actualIsWebServer
                ActualLowestTLSVersion = ""
            }

            Run-SecureWebServerComplianceTest @complianceTestParameters
        }

        Context 'Machine is a web server' {
            $actualIsWebServer = $true
            Mock -CommandName 'Test-IsWebServer' -MockWith { return $actualIsWebServer }

            Context 'All security protocols are absent' {  
                Mock -CommandName 'Get-SecurityChannelProtocolInfo' -MockWith {
                    return @{ 
                        Protocol = $ProtocoL
                        Ensure = 'Absent'
                    }
                }

                $complianceTestParameters = @{
                    ResourceParameters = @{
                        IsSingleInstance = 'Yes'
                    }
                    ShouldBeCompliant = $false
                    ExpectedReasonCodes = @(($reasonCodePrefix + "SecureTLSProtocolNotEnabled"), ($reasonCodePrefix + "DisplayProtocolInfo"))
                    ActualProtocolInfo = @()
                    ActualIsWebServer = $actualIsWebServer
                    ActualLowestTLSVersion = ""
                }

                foreach ($protocolName in $allProtocolNames)
                {
                    $complianceTestParameters['ActualProtocolInfo'] += @{
                        Protocol = $protocolName
                        Ensure = 'Absent'
                    }
                }

                Run-SecureWebServerComplianceTest @complianceTestParameters
            }

            Context 'All security protocols are present' {  
                Mock -CommandName 'Get-SecurityChannelProtocolInfo' -MockWith {
                    return @{ 
                        Protocol = $ProtocoL
                        Ensure = 'Present'
                    }
                }

                $complianceTestParameters = @{
                    ResourceParameters = @{
                        IsSingleInstance = 'Yes'
                    }
                    ShouldBeCompliant = $false
                    ExpectedReasonCodes = @(($reasonCodePrefix + "MinimumTLSProtocolNotEnabled"), ($reasonCodePrefix + "DisplayProtocolInfo"))
                    ActualProtocolInfo = @()
                    ActualIsWebServer = $actualIsWebServer
                    ActualLowestTLSVersion = "1.0"
                }

                foreach ($protocolName in $allProtocolNames)
                {
                    $complianceTestParameters['ActualProtocolInfo'] += @{
                        Protocol = $protocolName
                        Ensure = 'Present'
                    }

                    if (-not ($protocolName -in @('TLS 1.1', 'TLS 1.2')))
                    {
                        $complianceTestParameters['ExpectedReasonCodes'] += ($reasonCodePrefix + "InsecureProtocolEnabled")
                    }
                }

                Run-SecureWebServerComplianceTest @complianceTestParameters
            }

            Context 'Only TLS 1.1 protocol present' {  
                Mock -CommandName 'Get-SecurityChannelProtocolInfo' -MockWith {
                    if ($Protocol -ieq 'TLS 1.1')
                    {
                        return @{
                            Protocol = $Protocol
                            Ensure = 'Present'
                        }
                    }
                    else
                    {
                        return @{
                            Protocol = $Protocol
                            Ensure = 'Absent'
                        }
                    }
                }

                $complianceTestParameters = @{
                    ResourceParameters = @{
                        IsSingleInstance = 'Yes'
                        MinimumTLSVersion = '1.1'
                    }
                    ShouldBeCompliant = $true
                    ExpectedReasonCodes = @()
                    ActualProtocolInfo = @()
                    ActualIsWebServer = $actualIsWebServer
                    ActualLowestTLSVersion = "1.1"
                }

                foreach ($protocolName in $allProtocolNames)
                {
                    if ($protocolName -ieq 'TLS 1.1')
                    {
                        $complianceTestParameters['ActualProtocolInfo'] += @{
                            Protocol = $protocolName
                            Ensure = 'Present'
                        }
                    }
                    else
                    {
                        $complianceTestParameters['ActualProtocolInfo'] += @{
                            Protocol = $protocolName
                            Ensure = 'Absent'
                        }
                    }
                }

                Run-SecureWebServerComplianceTest @complianceTestParameters

                $complianceTestParameters['ResourceParameters']['MinimumTLSVersion'] = '1.2'
                $complianceTestParameters['ShouldBeCompliant'] = $false
                $complianceTestParameters['ExpectedReasonCodes'] = @(($reasonCodePrefix + "MinimumTLSProtocolNotEnabled"), ($reasonCodePrefix + "DisplayProtocolInfo"))

                Run-SecureWebServerComplianceTest @complianceTestParameters
            }

            Context 'TLS 1.1 and TLS 1.2 protocols present' {  
                Mock -CommandName 'Get-SecurityChannelProtocolInfo' -MockWith {
                    if ($Protocol -in @('TLS 1.1', 'TLS 1.2'))
                    {
                        return @{
                            Protocol = $Protocol
                            Ensure = 'Present'
                        }
                    }
                    else
                    {
                        return @{
                            Protocol = $Protocol
                            Ensure = 'Absent'
                        }
                    }
                }

                $complianceTestParameters = @{
                    ResourceParameters = @{
                        IsSingleInstance = 'Yes'
                        MinimumTLSVersion = '1.1'
                    }
                    ShouldBeCompliant = $true
                    ExpectedReasonCodes = @()
                    ActualProtocolInfo = @()
                    ActualIsWebServer = $actualIsWebServer
                    ActualLowestTLSVersion = "1.1"
                }

                foreach ($protocolName in $allProtocolNames)
                {
                    if ($protocolName -in @('TLS 1.1', 'TLS 1.2'))
                    {
                        $complianceTestParameters['ActualProtocolInfo'] += @{
                            Protocol = $protocolName
                            Ensure = 'Present'
                        }
                    }
                    else
                    {
                        $complianceTestParameters['ActualProtocolInfo'] += @{
                            Protocol = $protocolName
                            Ensure = 'Absent'
                        }
                    }
                }

                Run-SecureWebServerComplianceTest @complianceTestParameters

                $complianceTestParameters['ResourceParameters']['MinimumTLSVersion'] = '1.2'
                $complianceTestParameters['ShouldBeCompliant'] = $false
                $complianceTestParameters['ExpectedReasonCodes'] = @(($reasonCodePrefix + "MinimumTLSProtocolNotEnabled"), ($reasonCodePrefix + "DisplayProtocolInfo"))

                Run-SecureWebServerComplianceTest @complianceTestParameters
            }

            Context 'Only TLS 1.2 protocol present' {  
                Mock -CommandName 'Get-SecurityChannelProtocolInfo' -MockWith {
                    if ($Protocol -eq 'TLS 1.2')
                    {
                        return @{
                            Protocol = $Protocol
                            Ensure = 'Present'
                        }
                    }
                    else
                    {
                        return @{
                            Protocol = $Protocol
                            Ensure = 'Absent'
                        }
                    }
                }

                $complianceTestParameters = @{
                    ResourceParameters = @{
                        IsSingleInstance = 'Yes'
                        MinimumTLSVersion = '1.1'
                    }
                    ShouldBeCompliant = $true
                    ExpectedReasonCodes = @()
                    ActualProtocolInfo = @()
                    ActualIsWebServer = $actualIsWebServer
                    ActualLowestTLSVersion = "1.2"
                }

                foreach ($protocolName in $allProtocolNames)
                {
                    if ($protocolName -eq 'TLS 1.2')
                    {
                        $complianceTestParameters['ActualProtocolInfo'] += @{
                            Protocol = $protocolName
                            Ensure = 'Present'
                        }
                    }
                    else
                    {
                        $complianceTestParameters['ActualProtocolInfo'] += @{
                            Protocol = $protocolName
                            Ensure = 'Absent'
                        }
                    }
                }

                Run-SecureWebServerComplianceTest @complianceTestParameters

                $complianceTestParameters['ResourceParameters']['MinimumTLSVersion'] = '1.2'

                Run-SecureWebServerComplianceTest @complianceTestParameters
            }
        }
    }
}