codeunit 50105 "Upgrade Catalogue No."
{
    
    Subtype = Upgrade;

    trigger OnUpgradePerCompany();
    var
        ItemRec : Record Item;
        Module : ModuleInfo;
    begin

        NavApp.GetCurrentModuleInfo(Module);

        if (Module.DataVersion.Major = 1) then begin
            ItemRec.Reset();
            IF ItemRec.FindSet(true,false) then repeat
              if (ItemRec."Catalogue No." > 0) THEN begin
                ItemRec.NewCatalogueNo := 'C' + 
                  FORMAT(ItemRec."Catalogue No.");
                ItemRec.Modify(true);
              end;
            until ItemRec.Next() = 0;            
        end;
    end;
}