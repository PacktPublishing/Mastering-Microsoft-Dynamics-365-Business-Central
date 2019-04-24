table 50102 "Vendor Quality_PKT"
{
    Caption = 'Vendor Quality';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            DataClassification = CustomerContent;
            TableRelation = Vendor;
        }
        field(2; "Vendor Name"; Text[50])
        {
            Caption = 'Vendor Name';
            FieldClass = FlowField;
            CalcFormula = lookup (Vendor.Name where ("No." = field ("Vendor No.")));
        }
        field(3; "Vendor Activity Description"; Text[250])
        {
            Caption = 'Vendor Activity Description';
            DataClassification = CustomerContent;
        }
        field(4; ScoreItemQuality; Integer)
        {
            Caption = 'Item Quality Score';
            DataClassification = CustomerContent;
            MinValue = 1;
            MaxValue = 10;

            trigger OnValidate()
            begin
                UpdateVendorRate();
            end;
        }
        field(5; ScoreDelivery; Integer)
        {
            Caption = 'Delivery On Time Score';
            DataClassification = CustomerContent;
            MinValue = 1;
            MaxValue = 10;

            trigger OnValidate()
            begin
                UpdateVendorRate();
            end;
        }
        field(6; ScorePackaging; Integer)
        {
            Caption = 'Packaging Score';
            DataClassification = CustomerContent;
            MinValue = 1;
            MaxValue = 10;

            trigger OnValidate()
            begin
                UpdateVendorRate();
            end;
        }
        field(7; ScorePricing; Integer)
        {
            Caption = 'Pricing Score';
            DataClassification = CustomerContent;
            MinValue = 1;
            MaxValue = 10;

            trigger OnValidate()
            begin
                UpdateVendorRate();
            end;
        }
        field(8; Rate; Decimal)
        {
            Caption = 'Vendor Rate';
            DataClassification = CustomerContent;
        }
        field(10; UpdateDate; DateTime)
        {
            Caption = 'Update Date';
            DataClassification = CustomerContent;
        }

        field(11; InvoicedYearN; Decimal)
        {
            Caption = 'Invoiced for current year (N)';
            DataClassification = CustomerContent;
        }
        field(12; InvoicedYearN1; Decimal)
        {
            Caption = 'Invoiced for year N-1';
            DataClassification = CustomerContent;
        }
        field(13; InvoicedYearN2; Decimal)
        {
            Caption = 'Invoiced for year N-2';
            DataClassification = CustomerContent;
        }
        field(14; DueAmount; Decimal)
        {
            Caption = 'Due Amount';
            DataClassification = CustomerContent;
        }
        field(15; AmountNotDue; Decimal)
        {
            Caption = 'Amount to pay (not due)';
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(PK; "Vendor No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        UpdateDate := CurrentDateTime();
    end;

    trigger OnModify()
    begin
        UpdateDate := CurrentDateTime();
    end;

    local procedure UpdateVendorRate()
    var
        VendorQualityMgt: Codeunit VendorQualityMgt_PKT;
    begin
        VendorQualityMgt.CalculateVendorRate(Rec);
    end;

}