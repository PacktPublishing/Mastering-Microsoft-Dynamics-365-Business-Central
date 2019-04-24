page 50102 "Vendor Quality Card_PKT"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Vendor Quality_PKT";
    Caption = 'Vendor Quality Card';
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("Vendor No."; "Vendor No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Vendor Name"; "Vendor Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Vendor Activity Description"; "Vendor Activity Description")
                {
                    ApplicationArea = All;
                }
                field(Rate; Rate)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Style = Strong;
                }
                field(UpdateDate; UpdateDate)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            group(Scoring)
            {
                Caption = 'Score';
                field(ScoreItemQuality; ScoreItemQuality)
                {
                    ApplicationArea = All;
                }
                field(ScoreDelivery; ScoreDelivery)
                {
                    ApplicationArea = All;
                }
                field(ScorePackaging; ScorePackaging)
                {
                    ApplicationArea = All;
                }
                field(ScorePricing; ScorePricing)
                {
                    ApplicationArea = All;
                }
            }
            group(Financials)
            {
                Caption = 'Financials';
                field(InvoicedYearN; InvoicedYearN)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(InvoicedYearN1; InvoicedYearN1)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(InvoicedYearN2; InvoicedYearN2)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(DueAmount; DueAmount)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Style = Attention;
                }
                field(AmountNotDue; AmountNotDue)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Insert() then;
    end;

    trigger OnAfterGetRecord()
    var
        VendorQualityMgt: Codeunit VendorQualityMgt_PKT;
    begin
        VendorQualityMgt.UpdateVendorQualityStatistics(Rec);
    end;


}