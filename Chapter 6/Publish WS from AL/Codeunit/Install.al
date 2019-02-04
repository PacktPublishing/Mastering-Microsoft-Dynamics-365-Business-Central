codeunit 50104 Test1InstallCodeunit
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    var
        TenantWebService: Record "Tenant Web Service";
    begin
        TenantWebService.Init();
        TenantWebService."Object Type" := TenantWebService."Object Type"::Page;
        TenantWebService."Object ID" := 26;  //Vendor Card
        TenantWebService."Service Name" := 'VendorCardWS';
        TenantWebService.Published := true;
        TenantWebService.Insert(true);
    end;
}