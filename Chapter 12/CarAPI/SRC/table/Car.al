table 50111 Car
{
    DataClassification = CustomerContent;
    Caption = 'Car';
    LookupPageId = "Car List";
    DrillDownPageId = "Car List";

    fields
    {
        field(1; ModelNo; Code[20])
        {
            Caption = 'Model No.';
            DataClassification = CustomerContent;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(3; Brand; Code[20])
        {
            Caption = 'Brand';
            DataClassification = CustomerContent;
        }
        field(4; Power; Integer)
        {
            Caption = 'Power (CV)';
            DataClassification = CustomerContent;
        }
        field(5; "Engine Type"; Enum EngineType)
        {
            Caption = 'Power (CV)';
            DataClassification = CustomerContent;
        }
        field(10; ID; Guid)
        {
            Caption = 'ID';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; ModelNo)
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        ID := CreateGuid();
    end;
}