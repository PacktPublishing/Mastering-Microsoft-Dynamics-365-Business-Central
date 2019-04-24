pageextension 50104 MyNewBCHeadline_PKT extends "Headline RC Business Manager" //1440
{
    layout
    {
        // Add changes to page layout here
        addafter(Control4)
        {
            field(newHeadlineText; newHeadlineText)
            {
                ApplicationArea = all;
                trigger OnDrillDown()
                var
                    Customer: Record Customer;
                    CustomerList: Page "Customer List";
                begin
                    //Here we can handle a custom drilldown for details regarding the Headline
                    Customer.SetRange("Customer Category_PKT", '');
                    CustomerList.SetTableView(Customer);
                    CustomerList.Run();
                end;
            }
        }
    }



    //Global variables
    var
        newHeadlineText: Text;

    trigger OnOpenPage()
    var
        HeadlineMgt: Codeunit "Headline Management";
        CustomerCategoryMgt: Codeunit "Customer Category Mgt_PKT";
    begin
        //Set Headline text            
        newHeadlineText := 'Number of Customers without assigned Category: ' + HeadlineMgt.Emphasize(Format(CustomerCategoryMgt.GetTotalCustomersWithoutCategory()));
    end;

}