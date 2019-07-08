#Set local variables for license path and Docker image name to be used and container name 
#########################################################################################
$imageName = "mcr.microsoft.com/businesscentral/sandbox"  
$containerName = "BC14MTW1"  
$createDirectory = $true #move shortcuts into a directory
$checkHelper = $false #install navcontainerhelper

#Install internet libraries (needs PowerShell 3.0 or higher and admin privilege) 
################################################################################
Clear-Host
if ($checkHelper)
{
    Write-Host 'Installing navcontainerhelper module, please wait...'
    install-module navcontainerhelper -force
    Write-Host 'Checking navcontainerhelper module updates, please wait...'
    update-module navcontainerhelper -force
    Get-InstalledModule navcontainerhelper | Format-List -Property name, version    
} 

#Create a new container   
#######################
New-NavContainer -accept_eula `
                 -containerName $containerName `
                 -useBestContainerOS `
                 -imageName $imageName `
                 -auth NavUserPassword `
                 -alwaysPull `
                 -updateHosts `
                 -assignPremiumPlan `
                 -doNotExportObjectsToText `
                 -multitenant `
                 -includeCSide 

if ($createDirectory)
{
    $desktop = [System.Environment]::GetFolderPath('Desktop')
    New-Item -Path $desktop -Name $containerName -ItemType 'directory' -Force
    Get-ChildItem $desktop -Filter "$containerName*" -File | Move-Item -Destination "$desktop\$containerName"

    $code = @'
[System.Runtime.InteropServices.DllImport("Shell32.dll")] 
private static extern int SHChangeNotify(int eventId, int flags, IntPtr item1, IntPtr item2);

public static void Refresh()  {
    SHChangeNotify(0x8000000, 0x1000, IntPtr.Zero, IntPtr.Zero);    
}
'@

    Add-Type -MemberDefinition $code -Namespace WinAPI -Name Explorer 
    [WinAPI.Explorer]::Refresh()
}

