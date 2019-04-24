codeunit 50102 VendorQualityMgt_PKT
{
    procedure CalculateVendorRate(var VendorQuality: Record "Vendor Quality_PKT")
    var
        Handled: Boolean;
    begin
        OnBeforeCalculateVendorRate(VendorQuality, Handled);
        //This is the company's criteria to assign the Vendor rate.        
        VendorRateCalculation(VendorQuality, Handled);
        OnAfterCalculateVendorRate(VendorQuality);
    end;

    [IntegrationEvent(true, true)]
    local procedure OnBeforeCalculateVendorRate(var VendorQuality: Record "Vendor Quality_PKT"; var Handled: Boolean)
    begin
    end;

    [IntegrationEvent(true, true)]
    local procedure OnAfterCalculateVendorRate(var VendorQuality: Record "Vendor Quality_PKT")
    begin
    end;

    local procedure VendorRateCalculation(var VendorQuality: Record "Vendor Quality_PKT"; var Handled: Boolean)
    begin
        if Handled then
            exit;
        VendorQuality.Rate := (VendorQuality.ScoreDelivery + VendorQuality.ScoreItemQuality +
          VendorQuality.ScorePackaging + VendorQuality.ScorePricing) / 4;
    end;

    procedure UpdateVendorQualityStatistics(var VendorQuality: Record "Vendor Quality_PKT")
    var
        Year: Integer;
        DW: Dialog;
        DialogMessage: Label 'Calculating Vendor statistics...';
    begin
        DW.OPEN(DialogMessage);
        Year := DATE2DMY(TODAY, 3);
        VendorQuality.InvoicedYearN := GetInvoicedAmount(VendorQuality."Vendor No.", DMY2DATE(1, 1, Year), TODAY);
        VendorQuality.InvoicedYearN1 := GetInvoicedAmount(VendorQuality."Vendor No.", DMY2DATE(1, 1, Year - 1), DMY2DATE(31, 12, Year - 1));
        VendorQuality.InvoicedYearN2 := GetInvoicedAmount(VendorQuality."Vendor No.", DMY2DATE(1, 1, Year - 2), DMY2DATE(31, 12, Year - 2));
        VendorQuality.DueAmount := GetDueAmount(VendorQuality."Vendor No.", TRUE);
        VendorQuality.AmountNotDue := GetDueAmount(VendorQuality."Vendor No.", FALSE);
        DW.CLOSE;
    end;

    local procedure GetInvoicedAmount(VendorNo: Code[20]; StartDate: Date; EndDate: Date): Decimal
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        Total: Decimal;
    begin
        VendorLedgerEntry.SETRANGE("Vendor No.", VendorNo);
        VendorLedgerEntry.SETFILTER("Document Date", '%1..%2', StartDate, EndDate);
        if VendorLedgerEntry.FINDSET then
            repeat
                Total += VendorLedgerEntry."Purchase (LCY)";
            until VendorLedgerEntry.NEXT = 0;

        exit(Total * (-1));
    end;

    local procedure GetDueAmount(VendorNo: Code[20]; Due: Boolean): Decimal
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        Total: Decimal;
    begin
        VendorLedgerEntry.SETRANGE("Vendor No.", VendorNo);
        VendorLedgerEntry.SETRANGE(Open, TRUE);
        if Due then
            VendorLedgerEntry.SETFILTER("Due Date", '< %1', TODAY)
        else
            VendorLedgerEntry.SETFILTER("Due Date", '> %1', TODAY);
        VendorLedgerEntry.SETAUTOCALCFIELDS(VendorLedgerEntry."Remaining Amt. (LCY)");
        if VendorLedgerEntry.FINDSET then
            repeat
                Total += VendorLedgerEntry."Remaining Amt. (LCY)";
            until VendorLedgerEntry.NEXT = 0;

        exit(Total * (-1));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", 'OnBeforeManualReleasePurchaseDoc', '', false, false)]
    local procedure QualityCheckForReleasingPurchaseDoc(var PurchaseHeader: Record "Purchase Header")
    var
        VendorQuality: Record "Vendor Quality_PKT";
        PacktSetup: Record "Packt Extension Setup";
        ErrNoMinimumRate: Label 'Vendor %1 has a rate of %2 and it''s under the required minimum value (%3)';
    begin
        PacktSetup.Get();
        if VendorQuality.Get(PurchaseHeader."Buy-from Vendor No.") then begin
            if VendorQuality.Rate < PacktSetup."Minimum Accepted Vendor Rate" then
                Error(ErrNoMinimumRate, PurchaseHeader."Buy-from Vendor No.",
                Format(VendorQuality.Rate), Format(PacktSetup."Minimum Accepted Vendor Rate"));
        end;
    end;

}