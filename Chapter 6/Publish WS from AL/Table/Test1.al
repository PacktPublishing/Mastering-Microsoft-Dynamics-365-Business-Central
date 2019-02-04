table 50105 Test1
{
    DataClassification = CustomerContent;
    Caption = 'Test 1';

    fields
    {
        field(1; ID; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'ID';
        }
        field(2; Description; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
    }

    keys
    {
        key(PK; ID)
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}