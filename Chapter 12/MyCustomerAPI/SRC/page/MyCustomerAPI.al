page 50115 MyCustomerAPI
{
    PageType = API;
    Caption = 'customer';
    APIPublisher = 'SD';
    APIVersion = 'v1.0';
    APIGroup = 'customapi';
    EntityName = 'customer';
    EntitySetName = 'customers';
    SourceTable = Customer;
    DelayedInsert = true;
    ODataKeyFields = SystemId;

    //URL: https://api.businesscentral.dynamics.com/v2.0/TENANTID/sandbox/api/SD/customapi/v1.0/customers

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(no; "No.")
                {
                    Caption = 'no';
                }
                field(name; Name)
                {
                    Caption = 'name';
                }
                field(Id; SystemId)
                {
                    Caption = 'Id';
                }
                field(balanceDue; "Balance Due")
                {
                    Caption = 'balanceDue';
                }
                field(creditLimit; "Credit Limit (LCY)")
                {
                    Caption = 'creditLimit';
                }
                field(currencyCode; "Currency Code")
                {
                    Caption = 'currencyCode';
                }
                field(email; "E-Mail")
                {
                    Caption = 'email';
                }
                field(fiscalCode; "Fiscal Code")
                {
                    Caption = 'fiscalCode';
                }
                field(balance; "Balance (LCY)")
                {
                    Caption = 'balance';
                }
                field(countryRegionCode; "Country/Region Code")
                {
                    Caption = 'countryRegionCode';
                }

                field(netChange; "Net Change")
                {
                    Caption = 'netChange';
                }
                field(noOfOrders; "No. of Orders")
                {
                    Caption = 'noOfOrders';
                }
                field(noOfReturnOrders; "No. of Return Orders")
                {
                    Caption = 'noOfReturnOrders';
                }
                field(phoneNo; "Phone No.")
                {
                    Caption = 'phoneNo';
                }
                field(salesLCY; "Sales (LCY)")
                {
                    Caption = 'salesLCY';
                }
                field(shippedNotInvoiced; "Shipped Not Invoiced")
                {
                    Caption = 'shippedNotInvoiced';
                }
            }
        }
    }

}