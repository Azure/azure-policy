@{
    # Version number of this module.
    ModuleVersion = '1.0.0.0'

    # ID used to uniquely identify this module
    GUID = '7c0dd848-e1c6-40c5-aed4-5fea81a9136e'

    # Author of this module
    Author = 'Microsoft Corporation'

    # Company or vendor of this module
    CompanyName = 'Microsoft Corporation'

    # Copyright statement for this module
    Copyright = '(c) 2019 Microsoft Corporation. All rights reserved.'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '4.0'

    # Minimum version of the common language runtime (CLR) required by this module
    CLRVersion = '4.0'

    # Functions to export from this module
    FunctionsToExport = @()

    # Cmdlets to export from this module
    CmdletsToExport = @()

    # DSC resources to export from this module
    DscResourcesToExport = @('WindowsDefenderExploitGuard')

    # Module dependencies
    RequiredModules = @(
        @{ModuleName = 'Defender'; ModuleVersion = '1.0'}
    )

    # Root module
    RootModule = ''
}
