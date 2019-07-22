codeunit 50102 CustomerWSManagement
{
    procedure CloneCustomer(CustomerNo: Code[20])
    var
        Customer: Record Customer;
        NewCustomer: Record Customer;
    begin
        Customer.Get(CustomerNo);
        NewCustomer.Init();
        NewCustomer.TransferFields(Customer, false);
        NewCustomer.Name := 'CUSTOMER BOUND ACTION';
        NewCustomer.Insert(true);
    end;

    procedure GetSalesAmount(CustomerNo: Code[20]): Decimal
    var
        SalesLine: Record "Sales Line";
        total: Decimal;
    begin
        //Data to retrieve
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetRange("Sell-to Customer No.", CustomerNo);
        SalesLine.SetFilter(Type, '<>%1', SalesLine.Type::" ");
        if SalesLine.FindSet() then
            repeat
                total += SalesLine."Line Amount";
            until SalesLine.Next() = 0;
        exit(total);
    end;
}