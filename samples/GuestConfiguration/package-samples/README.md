# Azure Policy Guest Configuration samples

These samples are shared to help authors
to create their own configurations
and resource modules
for us in
[custom Guest Configuration](https://docs.microsoft.com/en-us/azure/governance/policy/how-to/guest-configuration-create) projects.

The community is welcome to contribute changes to these samples,
or create new samples.
However, this is not intended to be an Open Source project
to manage the content used in Azure Policy as built-in content.

## Configurations

[AdministratorsGroupMembers](./configurations/AdministratorsGroupMembers/AdministratorsGroupMembers.mof)<br>
[AdministratorsGroupMembersToExclude](./configurations/AdministratorsGroupMembersToExclude/AdministratorsGroupMembersToExclude.mof)<br>
[AdministratorsGroupMembersToInclude](./configurations/AdministratorsGroupMembersToInclude/AdministratorsGroupMembersToInclude.mof)<br>
[CertificateExpiration](./configurations/CertificateExpiration/CertificateExpiration.mof)<br>
[InstalledApplicationForLinux](./configurations/InstalledApplicationForLinux/InstalledApplicationForLinux.mof)<br>
[installed_application_linux_inspec_controls](./configurations/installed_application_linux_inspec_controls/installed_application_linux_inspec_controls.mof)<br>
[InstalledApplicationForWindows](./configurations/InstalledApplicationForWindows/InstalledApplicationForWindows.mof)<br>
[MachineLastBootUpTime](./configurations/MachineLastBootUpTime/MachineLastBootUpTime.mof)<br>
[NotInstalledApplicationForLinux](./configurations/NotInstalledApplicationForLinux/NotInstalledApplicationForLinux.mof)<br>
[not_installed_application_linux_inspec_controls](./configurations/not_installed_application_linux_inspec_controls/not_installed_application_linux_inspec_controls.mof)<br>
[NotInstalledApplicationForWindows](./configurations/NotInstalledApplicationForWindows/NotInstalledApplicationForWindows.mof)<br>
[SecureWebProtocol](./configurations/SecureWebProtocol/SecureWebProtocol.mof)<br>
[WindowsCertificateInTrustedRoot](./configurations/WindowsCertificateInTrustedRoot/WindowsCertificateInTrustedRoot.mof)<br>
[WindowsDefenderExploitGuard](./configurations/WindowsDefenderExploitGuard/WindowsDefenderExploitGuard.mof)<br>
[WindowsDomainMembership](./configurations/WindowsDomainMembership/WindowsDomainMembership.mof)<br>
[WindowsDscConfiguration](./configurations/WindowsDscConfiguration/WindowsDscConfiguration.mof)<br>
[WindowsLogAnalyticsAgentConnection](./configurations/WindowsLogAnalyticsAgentConnection/WindowsLogAnalyticsAgentConnection.mof)<br>
[WindowsPendingReboot](./configurations/WindowsPendingReboot/WindowsPendingReboot.mof)<br>
[WindowsPowerShellExecutionPolicy](./configurations/WindowsPowerShellExecutionPolicy/WindowsPowerShellExecutionPolicy.mof)<br>
[WindowsPowerShellModules](./configurations/WindowsPowerShellModules/WindowsPowerShellModules.mof)<br>
[WindowsRemoteConnection](./configurations/WindowsRemoteConnection/WindowsRemoteConnection.mof)<br>
[WindowsSerialConsole](./configurations/WindowsSerialConsole/WindowsSerialConsole.mof)<br>
[WindowsServiceStatus](./configurations/WindowsServiceStatus/WindowsServiceStatus.mof)<br>
[WindowsTimeZone](./configurations/WindowsTimeZone/WindowsTimeZone.mof)

## Resource Modules

[CertificateManagement](./resource-modules/CertificateManagement/)<br>
[CertificateStore](./resource-modules/CertificateStore/)<br>
[DomainMembership](./resource-modules/DomainMembership/)<br>
[LocalGroup](./resource-modules/LocalGroup/)<br>
[LogAnalyticsAgent](./resource-modules/LogAnalyticsAgent/)<br>
[MachineUpTime](./resource-modules/MachineUpTime/)<br>
[PowerShellExecutionPolicy](./resource-modules/PowerShellExecutionPolicy/)<br>
[PowerShellModules](./resource-modules/PowerShellModules/)<br>
[SecureProtocolWebServer](./resource-modules/SecureProtocolWebServer/)<br>
[SecureWebServer](./resource-modules/SecureWebServer/)<br>
[UserApplication](./resource-modules/UserApplication/)<br>
[InstalledApplication](./resource-modules/InstalledApplication/)<br>
[WindowsDefender](./resource-modules/WindowsDefender/)
