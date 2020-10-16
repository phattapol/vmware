#####################################################################
#          Load VMware Plugins and vCenter Connect                  #
#####################################################################
 
#Add-PSSnapin vmware.vimautomation.core
 
$vCenter="10.71.32.25"
$dc="Labs"
Connect-VIServer $vCenter -User 'administrator@vclass.local' -Password 'Password@123' -ErrorAction Stop | Out-Null

# Variables: Update these to the match the environment
$Cluster = 'Labs'
Get-datacenter -Name $dc

Disconnect-VIServer $vCenter -Confirm:$False