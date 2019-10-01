$errorActionPreference = 'Stop'
Set-StrictMode -Version 'Latest'

$script:resourceModuleName = 'CertificateStore'

Describe "$script:resourceModuleName Tests" {
    BeforeAll {
        $modulePath = Split-Path -Path $PSScriptRoot -Parent
        $moduleResourcesPath = Join-Path -Path $modulePath -ChildPath 'DscResources'
        $resourceFolderPath = Join-Path -Path $moduleResourcesPath -ChildPath $script:resourceModuleName
        $resourceModulePath = Join-Path -Path $resourceFolderPath -ChildPath "$script:resourceModuleName.psm1"
        Import-Module -Name $resourceModulePath -Force
    }

    InModuleScope $script:resourceModuleName {
        function Run-CertificateStoreComplianceTest
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
                $ExpectedReasonCodes
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

                    It 'Test-TargetResource should call Get-ChildItem' {
                        Assert-MockCalled -CommandName 'Get-ChildItem' -Scope 'Context'
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

                    It 'Get-TargetResource should call Get-ChildItem' {
                        Assert-MockCalled -CommandName 'Get-ChildItem' -Scope 'Context'
                    }

                    It 'Get-TargetResource should the specified CertificateStorePath' {
                        $getTargetResourceResult.CertificateStorePath | Should -Be $ResourceParameters.CertificateStorePath
                    }

                    if ($ShouldBeCompliant)
                    {
                        It 'Get-TargetResource should return 1 property' {
                            $getTargetResourceResult.Count | Should -Be 1
                        }

                        It 'Get-TargetResource should not return Reasons' {
                            $getTargetResourceResult.ContainsKey('Reasons') | Should -BeFalse
                        }
                    }
                    else
                    {
                        It 'Get-TargetResource should return 2 properties' {
                            $getTargetResourceResult.Count | Should -Be 2
                        }

                        It 'Get-TargetResource should return Reasons' {
                            $getTargetResourceResult.Reasons | Should -Not -Be $null
                        }

                        It "Get-TargetResource should return $($ExpectedReasonCodes.Count) Reasons" {
                            $getTargetResourceResult.Reasons.Count | Should -Be $ExpectedReasonCodes.Count
                        }

                        It "Get-TargetResource should return only the expected Reason Codes" {
                            $getTargetResourceResult.Reasons.Code | Should -Be $ExpectedReasonCodes
                        }
                    }
                }
            }
        }

        $reasonCodePrefix = "CertificateManagement:CertificateStore:"

        $currentDate = Get-Date
        $testExpirationDays = 7
        $testExpirationDate = $currentDate.AddDays($testExpirationDays)

        $testCertificateObjects = @(
            @{
                Thumbprint = "TestThumbprint1"
                NotAfter = $testExpirationDate.AddDays(1)
            },
            @{
                Thumbprint = "TestThumbprint2"
                NotAfter = $testExpirationDate.AddDays(-1)
            },
            @{
                Thumbprint = "TestThumbprint3"
                NotAfter = $currentDate.AddDays(-1)
            }
        )

        for ($numberActualCertificates = 0; $numberActualCertificates -le $testCertificateObjects.Count; $numberActualCertificates++)
        {
            $actualCertificates = @($testCertificateObjects | Select-Object -First $numberActualCertificates)

            $contextTitle = "CERTIFICATES IN MOCK STORE - "

            if ($actualCertificates -eq $null -or $actualCertificates.Count -eq 0)
            {
                $contextTitle += "None"
            }
            else
            {
                $certificateStrings = @()
                foreach ($actualCertificate in $actualCertificates)
                {
                    $certificateStrings += "(Thumbprint: $($actualCertificate.Thumbprint), Expiration: $($actualCertificate.NotAfter))"
                }
                $contextTitle += ($certificateStrings -join ", ")
            }

            Context $contextTitle {
                Mock -CommandName 'Get-ChildItem' -MockWith { return $actualCertificates }

                # ExpirationLimitInDays only
                $complianceTestParameters = @{
                    ResourceParameters = @{
                        CertificateStorePath = 'TestCertificateStorePath'
                        ExpirationLimitInDays = $testExpirationDays
                    }
                    ShouldBeCompliant = $true
                    ExpectedReasonCodes = @()
                }

                foreach ($actualCertificate in $actualCertificates)
                {
                    if ($actualCertificate.NotAfter -lt $testExpirationDate -and $actualCertificate.NotAfter -gt $currentDate)
                    {
                        $complianceTestParameters['ShouldBeCompliant'] = $false
                        $complianceTestParameters['ExpectedReasonCodes'] += ($reasonCodePrefix + "CertificateExpiringWithinMaximumDays")
                    }
                }

                Run-CertificateStoreComplianceTest @complianceTestParameters

                # ExpirationLimitInDays and IncludeExpiredCertificates
                $complianceTestParameters = @{
                    ResourceParameters = @{
                        CertificateStorePath = 'TestCertificateStorePath'
                        ExpirationLimitInDays = $testExpirationDays
                        IncludeExpiredCertificates = 'true'
                    }
                    ShouldBeCompliant = $true
                    ExpectedReasonCodes = @()
                }

                foreach ($actualCertificate in $actualCertificates)
                {
                    if ($actualCertificate.NotAfter -lt $testExpirationDate)
                    {
                        $complianceTestParameters['ShouldBeCompliant'] = $false
                        $complianceTestParameters['ExpectedReasonCodes'] += ($reasonCodePrefix + "CertificateExpiringWithinMaximumDays")
                    }
                }

                Run-CertificateStoreComplianceTest @complianceTestParameters

                for ($numberExpectedCertificates = 0; $numberExpectedCertificates -le $testCertificateObjects.Count; $numberExpectedCertificates++)
                {
                    $expectedCertificates = @($testCertificateObjects | Select-Object -First $numberExpectedCertificates)
                    $expectedThumbprintsString = $expectedCertificates.Thumbprint -join "; "

                    # CertificateThumbprintsToInclude only
                    $complianceTestParameters = @{
                        ResourceParameters = @{
                            CertificateStorePath = 'TestCertificateStorePath'
                            CertificateThumbprintsToInclude = $expectedThumbprintsString
                        }
                        ShouldBeCompliant = $true
                        ExpectedReasonCodes = @()
                    }
    
                    foreach ($expectedCertificate in $expectedCertificates)
                    {
                        if ($actualCertificates -eq $null -or -not $actualCertificates.Contains($expectedCertificate))
                        {
                            $complianceTestParameters['ShouldBeCompliant'] = $false
                            $complianceTestParameters['ExpectedReasonCodes'] += ($reasonCodePrefix + "ExpectedCertificateNotFound")
                        }
                    }
    
                    Run-CertificateStoreComplianceTest @complianceTestParameters

                    # CertificateThumbprintsToInclude and ExpirationLimitInDays
                    $complianceTestParameters['ResourceParameters']['ExpirationLimitInDays'] = $testExpirationDays

                    foreach ($actualCertificate in $actualCertificates)
                    {
                        if ($expectedCertificates -eq $null -or $expectedCertificates.Count -eq 0 -or $expectedCertificates.Contains($actualCertificate))
                        {
                            if ($actualCertificate.NotAfter -lt $testExpirationDate -and $actualCertificate.NotAfter -gt $currentDate)
                            {
                                $complianceTestParameters['ShouldBeCompliant'] = $false
                                $complianceTestParameters['ExpectedReasonCodes'] += ($reasonCodePrefix + "CertificateExpiringWithinMaximumDays")
                            }
                        }
                    }

                    Run-CertificateStoreComplianceTest @complianceTestParameters

                    # CertificateThumbprintsToInclude, ExpirationLimitInDays, and IncludeExpiredCertificates
                    $complianceTestParameters['ResourceParameters']['IncludeExpiredCertificates'] = 'true'

                    foreach ($actualCertificate in $actualCertificates)
                    {
                        if ($expectedCertificates -eq $null -or $expectedCertificates.Count -eq 0 -or $expectedCertificates.Contains($actualCertificate))
                        {
                            if ($actualCertificate.NotAfter -lt $currentDate)
                            {
                                $complianceTestParameters['ShouldBeCompliant'] = $false
                                $complianceTestParameters['ExpectedReasonCodes'] += ($reasonCodePrefix + "CertificateExpiringWithinMaximumDays")
                            }
                        }
                    }

                    Run-CertificateStoreComplianceTest @complianceTestParameters

                    # CertificateThumbprintsToExclude and ExpirationLimitInDays
                    $complianceTestParameters = @{
                        ResourceParameters = @{
                            CertificateStorePath = 'TestCertificateStorePath'
                            CertificateThumbprintsToExclude = $expectedThumbprintsString
                            ExpirationLimitInDays = $testExpirationDays
                        }
                        ShouldBeCompliant = $true
                        ExpectedReasonCodes = @()
                    }

                    foreach ($actualCertificate in $actualCertificates)
                    {
                        if ($expectedCertificates -eq $null -or $expectedCertificates.Count -eq 0 -or -not $expectedCertificates.Contains($actualCertificate))
                        {
                            if ($actualCertificate.NotAfter -lt $testExpirationDate -and $actualCertificate.NotAfter -gt $currentDate)
                            {
                                $complianceTestParameters['ShouldBeCompliant'] = $false
                                $complianceTestParameters['ExpectedReasonCodes'] += ($reasonCodePrefix + "CertificateExpiringWithinMaximumDays")
                            }
                        }
                    }

                    Run-CertificateStoreComplianceTest @complianceTestParameters

                    # CertificateThumbprintsToExclude, ExpirationLimitInDays, and IncludeExpiredCertificates
                    $complianceTestParameters['ResourceParameters']['IncludeExpiredCertificates'] = 'true'

                    foreach ($actualCertificate in $actualCertificates)
                    {
                        if ($expectedCertificates -eq $null -or $expectedCertificates.Count -eq 0 -or -not $expectedCertificates.Contains($actualCertificate))
                        {
                            if ($actualCertificate.NotAfter -lt $currentDate)
                            {
                                $complianceTestParameters['ShouldBeCompliant'] = $false
                                $complianceTestParameters['ExpectedReasonCodes'] += ($reasonCodePrefix + "CertificateExpiringWithinMaximumDays")
                            }
                        }
                    }

                    Run-CertificateStoreComplianceTest @complianceTestParameters

                    for ($numberExcludedCertificates = 0; $numberExcludedCertificates -le $testCertificateObjects.Count; $numberExcludedCertificates++)
                    {
                        $excludedCertificates = @($testCertificateObjects | Select-Object -First $numberExcludedCertificates)
                        $excludedThumbprintsString = $excludedCertificates.Thumbprint -join "; "

                        # CertificateThumbprintsToInclude and CertificatesThumbprintsToExclude
                        $complianceTestParameters = @{
                            ResourceParameters = @{
                                CertificateStorePath = 'TestCertificateStorePath'
                                CertificateThumbprintsToInclude = $expectedThumbprintsString
                                CertificateThumbprintsToExclude = $excludedThumbprintsString
                            }
                            ShouldBeCompliant = $true
                            ExpectedReasonCodes = @()
                        }
        
                        foreach ($expectedCertificate in $expectedCertificates)
                        {
                            if ($actualCertificates -eq $null -or -not $actualCertificates.Contains($expectedCertificate))
                            {
                                if ($excludedCertificates -eq $null -or -not $excludedCertificates.Contains($expectedCertificate))
                                {
                                    $complianceTestParameters['ShouldBeCompliant'] = $false
                                    $complianceTestParameters['ExpectedReasonCodes'] += ($reasonCodePrefix + "ExpectedCertificateNotFound")
                                }
                            }
                        }
        
                        Run-CertificateStoreComplianceTest @complianceTestParameters

                        # CertificateThumbprintsToInclude, CertificatesThumbprintsToExclude, and ExpirationLimitInDays
                        $complianceTestParameters['ResourceParameters']['ExpirationLimitInDays'] = $testExpirationDays

                        foreach ($actualCertificate in $actualCertificates)
                        {
                            if ($expectedCertificates -eq $null -or $expectedCertificates.Count -eq 0 -or $expectedCertificates.Contains($actualCertificate))
                            {
                                if ($excludedCertificates -eq $null -or -not $excludedCertificates.Contains($actualCertificate))
                                {
                                    if ($actualCertificate.NotAfter -lt $testExpirationDate -and $actualCertificate.NotAfter -gt $currentDate)
                                    {
                                        $complianceTestParameters['ShouldBeCompliant'] = $false
                                        $complianceTestParameters['ExpectedReasonCodes'] += ($reasonCodePrefix + "CertificateExpiringWithinMaximumDays")
                                    }
                                }
                            }
                        }

                        Run-CertificateStoreComplianceTest @complianceTestParameters

                        # CertificateThumbprintsToInclude, CertificatesThumbprintsToExclude, ExpirationLimitInDays, and IncludeExpiredCertificates
                        $complianceTestParameters['ResourceParameters']['IncludeExpiredCertificates'] = 'true'

                        foreach ($actualCertificate in $actualCertificates)
                        {
                            if ($expectedCertificates -eq $null -or $expectedCertificates.Count -eq 0 -or $expectedCertificates.Contains($actualCertificate))
                            {
                                if ($excludedCertificates -eq $null -or -not $excludedCertificates.Contains($actualCertificate))
                                {
                                    if ($actualCertificate.NotAfter -lt $currentDate)
                                    {
                                        $complianceTestParameters['ShouldBeCompliant'] = $false
                                        $complianceTestParameters['ExpectedReasonCodes'] += ($reasonCodePrefix + "CertificateExpiringWithinMaximumDays")
                                    }
                                }
                            }
                        }

                        Run-CertificateStoreComplianceTest @complianceTestParameters
                    }
                }
            }
        }
    }
}