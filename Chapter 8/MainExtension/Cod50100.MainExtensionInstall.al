codeunit 50100 "MainExtensionInstall"
{
    Subtype = Install;
    
    trigger OnInstallAppPerCompany();
    var
        NewTable : Record NewTable;
    begin        
        if NewTable.IsEmpty() then 
          InsertDefaultValues();
    end;

    local procedure InsertDefaultValues();
    begin
        InsertValue(1,'Activity Start',TODAY,false);
        InsertValue(2,'First Activity',TODAY,false);
        InsertValue(3,'Second Activity',TODAY,false);
    end;

    local procedure InsertValue(EntryNo : Integer; Desc : Text[30]; PostingDate : Date; isOpen : Boolean);
    var
        NewTable : Record NewTable;
    begin
        NewTable.Init();
        NewTable."Entry No." := EntryNo;
        NewTable.Description := Desc;
        NewTable."Posting Date" := PostingDate;
        NewTable.Open := isOpen;
        NewTable.Insert();
    end;
}