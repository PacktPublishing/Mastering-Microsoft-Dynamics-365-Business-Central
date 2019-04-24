page 50103 "Gift Campaign List_PKT"
{
    PageType = List;
    SourceTable = GiftCampaign_PKT;
    UsageCategory = Lists;
    Caption = 'Gift Campaigns';
    ApplicationArea = All;
    AdditionalSearchTerms = 'promotions, marketing';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(CustomerCategoryCode; CustomerCategoryCode)
                {
                    ApplicationArea = All;
                }
                field(ItemNo; ItemNo)
                {
                    ApplicationArea = All;
                }
                field(StartingDate; StartingDate)
                {
                    ApplicationArea = All;
                }
                field(EndingDate; EndingDate)
                {
                    ApplicationArea = All;
                }

                field(MinimumOrderQuantity; MinimumOrderQuantity)
                {
                    ApplicationArea = All;
                    Style = Strong;
                }
                field(GiftQuantity; GiftQuantity)
                {
                    ApplicationArea = All;
                    Style = Strong;
                }
                field(Inactive; Inactive)
                {
                    ApplicationArea = All;
                }
            }
        }

    }

    views
    {
        view(ActiveCampaigns)
        {
            Caption = 'Active Gift Campaigns';
            Filters = where (Inactive = const (false));
        }
        view(InactiveCampaigns)
        {
            Caption = 'Inactive Gift Campaigns';
            Filters = where (Inactive = const (true));
        }
    }
}