tableextension 50100 "CustomerTableExtensions_PKT" extends Customer //18 
{
    fields
    {
        field(50100; "Customer Category Code_PKT"; Code[20])
        {
            TableRelation = "Customer Category_PKT".Code;
            Caption = 'Customer Category Code';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                CustomerCategory: Record "Customer Category_PKT";
                ErrBlocked: Label 'This category is blocked.';
            begin
                if CustomerCategory.Get("Customer Category Code_PKT") then begin
                    if CustomerCategory.Blocked then
                        Error(ErrBlocked);
                end;
            end;
        }

    }

    keys
    {
        key(CustomerCategory; "Customer Category Code_PKT")
        {
        }
    }



    //!Override of a standard function in Customer table
    local procedure CreateAndShowNewInvoice(Category: Code[20])
    var
        CustomerCategory: Record "Customer Category_PKT";
    begin
        //Call standard NAV function
        rec.CreateAndShowNewInvoice();
        //Do other actions
        if CustomerCategory.Get(Category) and (CustomerCategory.Default) then begin
            //...
        end;
    end;
}