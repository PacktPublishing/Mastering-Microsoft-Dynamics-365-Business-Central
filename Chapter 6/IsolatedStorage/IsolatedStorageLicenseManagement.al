codeunit 50100 LicenseManagement
{
    local procedure StoreLicense()
    var
        StorageKey: Text;
        LicenseText: Text;
        EncryptManagement: Codeunit "Cryptography Management";
        License: Record License temporary;
    begin
        StorageKey := GetStorageKey();
        LicenseText := License.WriteLicenseToJson();
        if EncryptManagement.IsEncryptionEnabled() and EncryptManagement.IsEncryptionPossible() then
            LicenseText := EncryptManagement.Encrypt(LicenseText);

        if IsolatedStorage.Contains(StorageKey, DataScope::Module) then
            IsolatedStorage.Delete(StorageKey);

        IsolatedStorage.Set(StorageKey, LicenseText, DataScope::Module);
    end;

    local procedure GetStorageKey(): Text
    var
        StorageKeyTxt: Label 'dd03d28e-4acb-48d9-9520-c854495362b6', Locked = true;
    begin
        exit(StorageKeyTxt);
    end;

    local procedure ReadLicense()
    var
        StorageKey: Text;
        LicenseText: Text;
        EncryptManagement: Codeunit "Cryptography Management";
        License: Record License temporary;
    begin
        StorageKey := GetStorageKey();
        if IsolatedStorage.Contains(StorageKey, DataScope::Module) then
            IsolatedStorage.Get(StorageKey, DataScope::Module, LicenseText);

        if EncryptManagement.IsEncryptionEnabled() and EncryptManagement.IsEncryptionPossible() then
            LicenseText := EncryptManagement.Decrypt(LicenseText);

        License.ReadLicenseFromJson(LicenseText);
    end;


    local procedure IsolatedStorageTest()
    var
        keyValue: Text;
    begin
        IsolatedStorage.Set('mykey','myvalue',DataScope::Company);
        if IsolatedStorage.Contains('mykey',DataScope::Company) then
        begin
            IsolatedStorage.Get('mykey',DataScope::Company,keyValue);
            Message('Key value retrieved is %1', keyValue);
        end;

        IsolatedStorage.Delete('mykey',DataScope::Company);
    end;

    

}