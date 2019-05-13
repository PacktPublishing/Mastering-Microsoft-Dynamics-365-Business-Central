page 50101 CustomerCategoryCard_PKT
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Documents;
    SourceTable = "Customer Category_PKT";
    Caption = 'Customer Category Card';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field(Code; Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field(Default; Default)
                {
                    ApplicationArea = All;
                }
                field(EnableNewsletter; EnableNewsletter)
                {
                    ApplicationArea = All;
                }
                field(FreeGiftsAvailable; FreeGiftsAvailable)
                {
                    ApplicationArea = All;
                }
            }

            group(Administration)
            {
                Caption = 'Administration';
                field(Blocked; Blocked)
                {
                    ApplicationArea = All;
                }
            }

            group(Statistics)
            {
                Caption = 'Statistics';
                field(TotalCustomersForCategory; TotalCustomersForCategory)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(TotalSalesAmount; TotalSalesAmount)
                {
                    ApplicationArea = All;
                    Caption = 'Total Sales Order Amount';
                    Editable = false;
                    Style = Strong;
                }
            }
        }
    }

    var
        TotalSalesAmount: Decimal;

    trigger OnAfterGetRecord()
    begin
        TotalSalesAmount := Rec.GetSalesAmount();
    end;
}