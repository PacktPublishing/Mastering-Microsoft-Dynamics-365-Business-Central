pageextension 50103 CustomerCardExt extends "Customer Card"
{

    //This is to show that this will not work
    //https://d365bcita0918vm.westeurope.cloudapp.azure.com:7048/NAV/ODataV4/$metadata
    [ServiceEnabled]
    procedure GetSalesAmount(customerno: Code[20]): Decimal
    var
        actionContext: WebServiceActionContext;
        CustomerWSMgt: Codeunit CustomerWSManagement;
        total: Decimal;
    begin
        actionContext.SetObjectType(ObjectType::Page);
        actionContext.SetObjectId(Page::"My Customer Card");
        actionContext.AddEntityKey(Rec.FIELDNO("No."), rec."No.");
        total := CustomerWSMgt.GetSalesAmount(CustomerNo);
        // Set the result code to inform the caller that the result is retrieved
        actionContext.SetResultCode(WebServiceActionResultCode::Get);
        exit(total);
    end;
}