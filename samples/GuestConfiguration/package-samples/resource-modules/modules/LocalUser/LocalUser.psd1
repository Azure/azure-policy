@{

    # Script module or binary module file associated with this manifest.
    RootModule = 'LocalUser.psm1'
    
    # Version number of this module.
    ModuleVersion = '1.0.0.0'
    
    # ID used to uniquely identify this module
    GUID = '92735b37-d642-46ac-8a84-f3d8104b4f52'
    
    # Author of this module
    Author = 'Michael Greene'
    
    # Company or vendor of this module
    CompanyName = 'Microsoft Corporation'
    
    # Copyright statement for this module
    Copyright = ''
    
    # Description of the functionality provided by this module
    Description = 'Audit local users accounts'
    
    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '5.1'
    
    # Functions to export from this module
    FunctionsToExport = @('Get-LocalUserDSC','Test-LocalUserDSC')
    
    # DSC resources to export from this module
    DscResourcesToExport = @('LocalUser')
    
    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData = @{
    
        PSData = @{
    
            # Tags applied to this module. These help with module discovery in online galleries.
            # Tags = @(Power Plan, Energy, Battery)
    
            # A URL to the license for this module.
            # LicenseUri = ''
    
            # A URL to the main website for this project.
            # ProjectUri = ''
    
            # A URL to an icon representing this module.
            # IconUri = ''
    
            # ReleaseNotes of this module
            # ReleaseNotes = ''
    
        } # End of PSData hashtable
    
    } 
}