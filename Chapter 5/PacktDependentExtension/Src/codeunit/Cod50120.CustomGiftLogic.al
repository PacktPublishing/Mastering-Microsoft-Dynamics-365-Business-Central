codeunit 50120 CustomGiftLogic_PKN
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::GiftManagement_PKT, 'OnBeforeFreeGiftSalesLineAdded', '', false, false)]
    local procedure HideDefaultBehaviour(var Rec: Record "Sales Line"; var Handled: Boolean)
    begin
        Handled := true;
        //Here we create a custom gift line with a fixed quantity (override of standard behaviour)
        CreateCustomGiftLine(Rec);
    end;

    local procedure CreateCustomGiftLine(var SalesLine: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
        SalesLineGift: Record "Sales Line";
        LineNo: Integer;
        FixedQty: Decimal;
    begin
        FixedQty := 2;
        SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.");
        LineNo := GetLastSalesDocumentLineNo(SalesHeader);
        SalesLineGift.init;
        SalesLineGift.TransferFields(SalesLine);
        SalesLineGift."Line No." := LineNo + 10000;
        SalesLineGift.Validate(Quantity, FixedQty);
        SalesLineGift.Validate("Line Discount %", 100);
        if SalesLineGift.Insert() then;
    end;

    local procedure GetLastSalesDocumentLineNo(SalesHeader: Record "Sales Header"): Integer
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        if SalesLine.FindLast() then
            exit(SalesLine."Line No.")
        else
            exit(0);
    end;

}