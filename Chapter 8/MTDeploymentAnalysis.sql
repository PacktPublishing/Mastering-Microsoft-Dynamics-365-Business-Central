-- Application database
USE "CRONUS" 
GO

DECLARE @PackageID uniqueidentifier
SELECT @PackageID = NavApp.[Package ID] 
FROM [CRONUS].[dbo].[NAV App] NavApp 
WHERE (([Name] = 'MainExtension') and ([Version Major] = 1))

SELECT * FROM [NAV App] WHERE [Package ID] = @PackageID
SELECT * FROM [NAV App Dependencies] WHERE [Package ID] = @PackageID
SELECT * FROM [NAV App Object Metadata] WHERE [App Package ID] = @PackageID
SELECT * FROM [NAV App Object Prerequisites] WHERE [Package ID] = @PackageID  
SELECT * FROM [NAV App Publish Reference] WHERE [App Package ID] = @PackageID
SELECT * FROM [NAV App Resource] WHERE [Package ID] = @PackageID 
SELECT * FROM [NAV App Tenant App] WHERE [App Package ID] = @PackageID

-- Tenant database
USE "default"
GO

DECLARE @AppID uniqueidentifier
DECLARE @PackageID uniqueidentifier

SELECT @AppID = NavApp.ID, @PackageID = NavApp.[Package ID] 
FROM [CRONUS].[dbo].[NAV App] NavApp
WHERE (([Name] = 'MainExtension') and ([Version Major] = 1))

SELECT * FROM [$ndo$navappschemasnapshot] WHERE appid = @AppID
SELECT * FROM [$ndo$navappschematracking] WHERE appid = @AppID
SELECT * FROM [$ndo$navappuninstalledapp] WHERE appid = @AppID
SELECT * FROM [NAV App Data Archive] WHERE [App ID] = @AppID
SELECT * FROM [NAV App Installed App] 
  WHERE ([App ID] = @AppID) and ([Package ID] = @PackageID)
SELECT * FROM [NAV App Published App] 
  WHERE ([App ID] = @AppID) and ([Package ID] = @PackageID)
SELECT * FROM [NAV App Setting] WHERE [App ID] = @AppID
SELECT * FROM [NAV App Tenant Add-In] WHERE [App ID] = @AppID





