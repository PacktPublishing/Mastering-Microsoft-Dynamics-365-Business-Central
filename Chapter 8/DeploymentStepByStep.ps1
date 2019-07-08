# Main extension 
Publish-BCContainerApp -containerName 'BC14MTW1' `
    -appFile 'C:\TEMP\UPGRADE\MainExtension\DTacconi Inc._MainExtension_1.0.0.0.app' `
    -skipVerification

Sync-BCContainerApp -containerName 'BC14MTW1' `
    -tenant 'default' `
    -appName 'MainExtension' `
    -Mode Add 

Start-BCContainerAppDataUpgrade -containerName 'BC14MTW1' `
    -tenant 'default' `
    -appName 'MainExtension' `
    -appVersion '1.0.0.0'

Install-NavContainerApp -containerName 'BC14MTW1' `
-tenant 'default' `
-appName 'MainExtension' `
-appVersion '1.0.0.0' 

#Second extension
Publish-BCContainerApp -containerName 'BC14MTW1' `
    -appFile 'C:\TEMP\UPGRADE\DependentExtension\DTacconi Inc._SecondExtension_1.0.0.0.app' `
    -skipVerification

Sync-BCContainerApp -containerName 'BC14MTW1' `
    -tenant 'default' `
    -appName 'SecondExtension' `
    -Mode Add 

Start-BCContainerAppDataUpgrade -containerName 'BC14MTW1' `
    -tenant 'default' `
    -appName 'SecondExtension' `
    -appVersion '1.0.0.0'

Install-NavContainerApp -containerName 'BC14MTW1' `
    -tenant 'default' `
    -appName 'SecondExtension' `
    -appVersion '1.0.0.0' 

# Main extension V2
Publish-BCContainerApp -containerName 'BC14MTW1' `
-appFile 'C:\TEMP\UPGRADE\MainExtensionV2\DTacconi Inc._MainExtension_2.0.0.0.app' `
-skipVerification

Sync-BCContainerApp -containerName 'BC14MTW1' `
-tenant 'default' `
-appName 'MainExtension' `
-appVersion '2.0.0.0' `
-Mode Add 

Start-BCContainerAppDataUpgrade -containerName 'BC14MTW1' `
-tenant 'default' `
-appName 'MainExtension' `
-appVersion '2.0.0.0'

Install-NavContainerApp -containerName 'BC14MTW1' `
-tenant 'default' `
-appName 'MainExtension' `
-appVersion '2.0.0.0' 

#Second extension V2
Publish-BCContainerApp -containerName 'BC14MTW1' `
    -appFile 'C:\TEMP\UPGRADE\DependentExtensionV2\DTacconi Inc._SecondExtension_2.0.0.0.app' `
    -skipVerification

Sync-BCContainerApp -containerName 'BC14MTW1' `
    -tenant 'default' `
    -appName 'SecondExtension' `
    -appVersion '2.0.0.0' `
    -Mode Add 

Start-BCContainerAppDataUpgrade -containerName 'BC14MTW1' `
    -tenant 'default' `
    -appName 'SecondExtension' `
    -appVersion '2.0.0.0'

Install-NavContainerApp -containerName 'BC14MTW1' `
    -tenant 'default' `
    -appName 'SecondExtension' `
    -appVersion '2.0.0.0' 
