#####################################################################
#          Load VMware Plugins and vCenter Connect                  #
#####################################################################
 
#Add-PSSnapin vmware.vimautomation.core
 
Connect-VIServer 172.20.10.3 -User 'vclass.local\administrator' -Password 'D00rb@ck' -ErrorAction Stop | Out-Null

#####################################################################
#      Add .VMX (Virtual Machines) to Inventory from Datastore      #
#####################################################################
 
# Variables: Update these to the match the environment
$Cluster = 'Lab'
$Datastore = 'New-Shared'
$VMFolder = '_test_Script'
$ESXHost = 'esxi02.vclass.local'
 
foreach($Datastore in $Datastore) {
# Searches for .VMX Files in datastore variable
$ds = Get-Datastore -Name $Datastore | %{Get-View $_.Id}
$SearchSpec = New-Object VMware.Vim.HostDatastoreBrowserSearchSpec
$SearchSpec.matchpattern = '*.vmx'
$dsBrowser = Get-View $ds.browser
$DatastorePath = '[' + $ds.Summary.Name + ']'
 
# Find all .VMX file paths in Datastore variable and filters out .snapshot
$SearchResult = $dsBrowser.SearchDatastoreSubFolders($DatastorePath, $SearchSpec) | where {$_.FolderPath -notmatch '.snapshot'} | %{$_.FolderPath + ($_.File | select Path).Path}
 
# Register all .VMX files with vCenter
foreach($VMXFile in $SearchResult) {
New-VM -VMFilePath $VMXFile -VMHost $ESXHost -Location $VMFolder -RunAsync
 }
}