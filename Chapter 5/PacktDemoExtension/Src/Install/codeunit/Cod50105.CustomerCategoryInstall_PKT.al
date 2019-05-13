codeunit 50105 CustomerCategoryInstall_PKT
{
    Subtype = Install;

    trigger OnInstallAppPerCompany();
    var
        archivedVersion: Text;
        CustomerCategory: Record "Customer Category_PKT";
        PacktSetup: Record "Packt Extension Setup";
    begin
        archivedVersion := NavApp.GetArchiveVersion;
        if archivedVersion = '1.0.0.0' then begin
            NavApp.RestoreArchiveData(Database::"Customer Category_PKT");
            NavApp.RestoreArchiveData(Database::Customer);
            NavApp.RestoreArchiveData(Database::"Packt Extension Setup");
            NavApp.RestoreArchiveData(Database::GiftCampaign_PKT);
            NavApp.RestoreArchiveData(Database::"Vendor Quality_PKT");

            NavApp.DeleteArchiveData(Database::"Customer Category_PKT");
            NavApp.DeleteArchiveData(Database::Customer);
            NavApp.DeleteArchiveData(Database::"Packt Extension Setup");
            NavApp.DeleteArchiveData(Database::GiftCampaign_PKT);
            NavApp.DeleteArchiveData(Database::"Vendor Quality_PKT");
        end;

        if CustomerCategory.IsEmpty() then
            InsertDefaultCustomerCategory();
        if PacktSetup.IsEmpty() then
            InsertDefaultSetup();

    end;

    // Insert the GOLD, SILVER, BRONZE reward levels
    local procedure InsertDefaultCustomerCategory();
    begin
        InsertCustomerCategory('TOP', 'Top Customer', false);
        InsertCustomerCategory('MEDIUM', 'Standard Customer', true);
        InsertCustomerCategory('BAD', 'Bad Customer', false);
    end;

    // Create and insert a Customer Category record
    local procedure InsertCustomerCategory(ID: Code[30]; Description: Text[250]; Default: Boolean);
    var
        CustomerCategory: Record "Customer Category_PKT";
    begin
        CustomerCategory.Init();
        CustomerCategory.Code := ID;
        CustomerCategory.Description := Description;
        CustomerCategory.Default := Default;
        CustomerCategory.Insert();
    end;

    local procedure InsertDefaultSetup()
    var
        PacktSetup: Record "Packt Extension Setup";
    begin
        PacktSetup.Init();
        PacktSetup."Minimum Accepted Vendor Rate" := 6;
        PacktSetup."Gift Tolerance Qty" := 2;
        PacktSetup.Insert();
    end;

}