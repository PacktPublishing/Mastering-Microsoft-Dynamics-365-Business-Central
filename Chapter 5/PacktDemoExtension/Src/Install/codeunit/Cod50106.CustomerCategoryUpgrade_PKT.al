codeunit 50106 "CustomerCategoryUpgrade_PKT"
{
    //IMPORTANT: Remember to increase the version number of the extension in the app.json file
    //Upgrade-NAVApp cmdlet

    Subtype = Upgrade;

    // "OnUpgradePerCompany" trigger is used to perform the actual upgrade.
    trigger OnUpgradePerCompany();
    var
        CustomerCategory: Record "Customer Category_PKT";

        // "ModuleInfo" is the current executing module. 
        Module: ModuleInfo;
    begin
        // Get information about the current module.
        NavApp.GetCurrentModuleInfo(Module);

        // In the new version, the BAD class is upgraded to WARNING
        if Module.DataVersion.Major = 1 then begin
            IF CustomerCategory.Get('BAD') THEN BEGIN
                CustomerCategory.Rename('WARNING');
                CustomerCategory.Description := 'Warning Customer [UPG]';
                CustomerCategory.Modify();
            END;
        end;
    end;
}