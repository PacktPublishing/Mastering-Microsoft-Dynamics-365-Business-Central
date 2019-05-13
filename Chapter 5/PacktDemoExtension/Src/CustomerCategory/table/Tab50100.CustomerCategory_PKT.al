
table 50100 "Customer Category_PKT"
{
    DrillDownPageId = "Customer Category List_PKT";
    LookupPageId = "Customer Category List_PKT";
    Caption = 'Customer Category';

    fields
    {
        field(1; Code; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No.';
        }
        field(2; Description; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(3; Default; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Default';
        }

        /* field(5; EnableNewsletter; Option)
        {
            OptionMembers = " ","Full","Limited";
            OptionCaption = ' ,Full,Limited';
            Caption = 'Enable Newsletter';
            DataClassification = CustomerContent;
        } */

        field(4; EnableNewsletter; Enum NewsletterType)
        {
            Caption = 'Enable Newsletter';
            DataClassification = CustomerContent;
        }

        field(5; FreeGiftsAvailable; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Free Gifts Available';
        }

        field(6; Blocked; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Blocked';
        }

        field(10; TotalCustomersForCategory; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count (Customer where ("Customer Category Code_PKT" = field (Code)));
            Caption = 'No. of associated customers';
        }

    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
        key(K2; Description)
        {
            Unique = true;
        }
    }

    procedure GetSalesAmount(): Decimal
    var
        CustomerCategoryMgt: Codeunit "Customer Category Mgt_PKT";
    begin
        exit(CustomerCategoryMgt.GetSalesAmount(Rec.Code));
    end;

}

enum 50100 NewsletterType
{
    Extensible = true;
    value(0; None)
    {
        Caption = 'None';
    }
    value(1; Full)
    {
        Caption = 'Full';
    }
    value(2; Limited)
    {
        Caption = 'Limited';
    }
}