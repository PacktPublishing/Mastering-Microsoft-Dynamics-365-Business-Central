codeunit 50100 "Customer Category Mgt_PKT"
{
    procedure CreateDefaultCategory()
    var
        CustomerCategory: Record "Customer Category_PKT";
        DefaultCode: Label 'DEFAULT';
        DefaultDescription: Label 'Default Customer Category';
    begin
        CustomerCategory.Code := DefaultCode;
        CustomerCategory.Description := DefaultDescription;
        CustomerCategory.Default := true;
        if CustomerCategory.Insert then;
    end;


    procedure AssignDefaultCategory(CustomerCode: Code[20])

    var
        Customer: Record Customer;
        CustomerCategory: Record "Customer Category_PKT";
    begin
        //Set default category for a Customer        
        Customer.Get(CustomerCode);
        CustomerCategory.SetRange(Default, true);
        if CustomerCategory.FindFirst() then begin
            Customer.Validate("Customer Category Code_PKT", CustomerCategory.Code);
            Customer.Modify();
        end;
    end;

    procedure AssignDefaultCategory()
    var
        Customer: Record Customer;
        CustomerCategory: Record "Customer Category_PKT";
    begin
        //Set default category for ALL Customer       
        CustomerCategory.SetRange(Default, true);
        if CustomerCategory.FindFirst() then begin
            Customer.SetFilter("Customer Category Code_PKT", '%1', '');
            Customer.ModifyAll("Customer Category Code_PKT", CustomerCategory.Code, true);
        end;
    end;

    //Returns the number of Customers without an assigned Customer Category
    procedure GetTotalCustomersWithoutCategory(): Integer
    var
        Customer: record Customer;
    begin
        Customer.SetRange("Customer Category Code_PKT", '');
        exit(customer.Count());
    end;

    procedure GetSalesAmount(CustomerCategoryCode: Code[20]): Decimal
    var
        SalesLine: Record "Sales Line";
        Customer: record Customer;
        TotalAmount: Decimal;
    begin
        Customer.SetCurrentKey("Customer Category Code_PKT");
        Customer.SetRange("Customer Category Code_PKT", CustomerCategoryCode);
        if Customer.FindSet() then
            repeat
                SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                SalesLine.SetRange("Sell-to Customer No.", Customer."No.");
                if SalesLine.FindSet() then
                    repeat
                        TotalAmount += SalesLine."Line Amount";
                    until SalesLine.Next() = 0;
            until Customer.Next() = 0;

        exit(TotalAmount);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::ReportManagement, 'OnAfterSubstituteReport', '', false, false)]
    local procedure OnAfterSubstituteReport(ReportId: Integer; var NewReportId: Integer)
    begin
        if ReportId = Report::"Standard Sales - Order Conf." then
            NewReportId := Report::"Packt Sales - Order Conf.";
    end;
}