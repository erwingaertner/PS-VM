
Clear-Host
#set labname
$labName = 'ADLab'
$labSourcesTools = 'C:\LabSources\Tools'

#create an empty lab template and define where the lab XML files and the VMs will be stored
New-LabDefinition -Name $labName -DefaultVirtualizationEngine HyperV -VmPath C:\LabSources\Labs

#make the network definition
Add-LabVirtualNetworkDefinition -Name $labName -AddressSpace 192.168.10.0/24

#and the domain definition with the domain admin account
Set-LabInstallationCredential -Username Install -Password Somepass1

#the first machine is the root domain controller. Everything in $labSources\Tools get copied to the machine's Windows folder
Add-LabMachineDefinition -Name DC01 -Network $labName -Memory 4GB -OperatingSystem 'Windows Server 2019 Datacenter Evaluation (Desktop Experience)' -Roles RootDC -DomainName gaertners.local -ToolsPath $labSourcesTools
Add-LabMachineDefinition -Name DC02 -Network $labName -Memory 4GB -OperatingSystem 'Windows Server 2019 Datacenter Evaluation (Desktop Experience)' -Roles DC -DomainName gaertners.local -ToolsPath $labSourcesTools

#the second just a member client. Everything in $labSources\Tools get copied to the machine's Windows folder
Add-LabMachineDefinition -Name Client01 -Network $labName -Memory 4GB -OperatingSystem 'Windows 11 Pro' -DomainName gaertners.local -ToolsPath $labSourcesTools
Add-LabMachineDefinition -Name Client02 -Network $labName -Memory 2GB -OperatingSystem 'Windows 11 Pro' -DomainName gaertners.local -ToolsPath $labSourcesTools

$role = Get-LabMachineRoleDefinition -Role DscPullServer -Properties @{
    DatabaseEngine = 'mdb'
    DatabaseName   = 'DSC'
    #DatabaseServer = 'SQL01'
}
Add-LabMachineDefinition -Name Pulli -Network $labName -Memory 4GB -OperatingSystem 'Windows Server 2019 Datacenter Evaluation (Desktop Experience)' -Roles $role -DomainName gaertners.local -ToolsPath $labSourcesTools


Install-Lab
Show-LabDeploymentSummary -Detailed

# Ab hier deinstallieren
# Get-Lab $labName
# Remove-Lab -name $labName