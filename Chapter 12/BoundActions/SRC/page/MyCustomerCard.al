page 50102 "My Customer Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Customer;
    ODataKeyFields = "No.";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(Id; Id)
                {
                    ApplicationArea = All;
                }
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field(Name; Name)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    [ServiceEnabled]
    procedure CloneCustomer(var actionContext: WebServiceActionContext)
    var
        CustomerWSMgt: Codeunit CustomerWSManagement;
    begin
        CustomerWSMgt.CloneCustomer(Rec."No.");
        actionContext.SetObjectType(ObjectType::Page);
        actionContext.SetObjectId(Page::"My Customer Card");
        actionContext.AddEntityKey(Rec.FIELDNO("No."), Rec."No.");
        // Set the result code to inform the caller that the record is created
        actionContext.SetResultCode(WebServiceActionResultCode::Created);
    end;

    [ServiceEnabled]
    procedure GetSalesAmount(CustomerNo: Code[20]): Decimal
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