pageextension 50102 CustomerListExt extends "Customer List"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
    }

    [ServiceEnabled]
    procedure GetSalesForCustomer(var actionContext: WebServiceActionContext)//: Decimal
    var
        CustomerWSMgt: Codeunit CustomerWSManagement;
        total: Decimal;
    begin
        total := CustomerWSMgt.GetSalesAmount(Rec."No.");
        actionContext.SetObjectType(ObjectType::Page);
        actionContext.SetObjectId(Page::"Customer List");
        actionContext.AddEntityKey(Rec.FIELDNO(Id), rec.Id);

        // Set the result code to inform the caller that the result is retrieved
        actionContext.SetResultCode(WebServiceActionResultCode::Get);

        //exit(total)
    end;
}