codeunit 50100 TaskCodeunit
{
    trigger OnRun()
    var
        Result: Dictionary of [Text, Text];
        CustomerNo: Code[20];
        CustomerSalesValue: Text;
    begin
        CustomerNo := Page.GetBackgroundParameters().Get('CustomerNo');
        if CustomerNo = '' then
            Error('Invalid parameter CustomerNo');
        if CustomerNo <> '' then begin
            CustomerSalesValue := format(GetCustomerSalesAmount(CustomerNo));
        end;
        Result.Add('TotalSales', CustomerSalesValue);
        Page.SetBackgroundTaskResult(Result);
    end;

    local procedure GetCustomerSalesAmount(CustomerNo: Code[20]): Decimal
    var
        Customer: Record Customer;
        SalesLine: Record "Sales Line";
        amount: Decimal;
    begin
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetRange("Sell-to Customer No.", CustomerNo);
        if SalesLine.FindSet() then
            repeat
                amount += SalesLine."Line Amount";
            until SalesLine.Next() = 0;
        exit(amount);
    end;
}