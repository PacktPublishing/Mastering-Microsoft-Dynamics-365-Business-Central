codeunit 60101 "Gifts PKT"
{
    // [FEATURE] Gifts
    SubType = Test;

    var
        Assert: Codeunit Assert;
        LibraryInventory: Codeunit "Library - Inventory";
        LibrarySales: Codeunit "Library - Sales";
        LibraryVariableStorage: Codeunit "Library - Variable Storage";
        LibraryUtility: Codeunit "Library - Utility";

    [Test]
    [HandlerFunctions('MessageHandler')]
    procedure AssignQuantityOnSalesLineToTriggerActivePromotionMessage()
    // [FEATURE] Gifts
    var
        Customer: Record Customer;
        Item: Record Item;
        SalesInvoiceNo: Code[20];
    begin
        // [SCENARIO #0010] Assign quantity on sales line

        // [GIVEN] Packt setup with "Gift Tolerance Qty" set
        CreatePacktSetupWithGiftToleranceQty(6);
        // [GIVEN] Customer with non-blocked customer category with "Free Gifts Available"
        CreateCustomerWithNonBlockedCustomerCategoryWithFreeGiftsAvailable(Customer);
        // [GIVEN] Item
        CreateItem(Item);
        // [GIVEN] Gift campaign for item and customer category with "Minimum Order Quantity" set
        CreateGiftCampaignForItemAndCustomerCategoryWithMinimumOrderQuantity(Item."No.", Customer."Customer Category Code_PKT", 10, 3);
        // [GIVEN] Sales invoice for customer with line for item
        SalesInvoiceNo := CreateSalesInvoiceForCustomerWithLineForItem(Customer."No.", Item."No.");

        // [WHEN] Set quantity on invoice line smaller than "Minimum Order Quantity" and within "Gift Tolerance Qty"
        SetQuantityOnInvoiceLineSmallerThanMinimumOrderQuantityAndWithinGiftToleranceQty(SalesInvoiceNo, 5);

        // [THEN] Active promotion message is displayed
        VerifyActivePromotionMessageIsDisplayed(Item."No.", Customer."Customer Category Code_PKT");
    end;

    local procedure CreateCustomerWithNonBlockedCustomerCategoryWithFreeGiftsAvailable(var Customer: record Customer)
    begin
        LibrarySales.CreateCustomer(Customer);
        with Customer do begin
            Validate("Customer Category Code_PKT", CreateNonBlockedCustomerCategoryWithFreeGiftsAvailable());
            Modify();
        end;
    end;

    local procedure CreateNonBlockedCustomerCategoryWithFreeGiftsAvailable(): Code[20]
    var
        CustomerCategory: Record "Customer Category_PKT";
    begin
        with CustomerCategory do begin
            Init();
            Validate(
                Code,
                LibraryUtility.GenerateRandomCode(FIELDNO(Code),
                Database::"Customer Category_PKT"));
            Validate(Description, Code);
            Validate(FreeGiftsAvailable, true);
            Insert();
            exit(Code);
        end;
    end;

    local procedure CreateGiftCampaignForItemAndCustomerCategoryWithMinimumOrderQuantity(NewItemNo: Code[20]; NewCustomerCategoryCode: code[20]; NewMinimumOrderQuantity: Decimal; NewGiftQuantity: Decimal)
    var
        GiftCampaign: Record GiftCampaign_PKT;
    begin
        with GiftCampaign do begin
            Init();
            Validate(CustomerCategoryCode, NewCustomerCategoryCode);
            Validate(ItemNo, NewItemNo);
            Validate(MinimumOrderQuantity, NewMinimumOrderQuantity);
            Validate(EndingDate, DMY2Date(31, 12, 9999));
            Validate(GiftQuantity, NewGiftQuantity);
            Insert();
        end;
    end;

    local procedure CreateItem(var Item: Record Item)
    begin
        LibraryInventory.CreateItem(Item);
    end;

    local procedure CreatePacktSetupWithGiftToleranceQty(GiftToleranceQtySet: Decimal)
    var
        PacktExtensionSetup: Record "Packt Extension Setup";
    begin
        with PacktExtensionSetup do begin
            if not Get() then
                Insert();
            Validate("Gift Tolerance Qty", GiftToleranceQtySet);
            Modify();
        end;
    end;

    local procedure CreateSalesInvoiceForCustomerWithLineForItem(CustomerNo: Code[20]; ItemNo: Code[20]): Code[20]
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        with SalesHeader do begin
            LibrarySales.CreateSalesDocumentWithItem(SalesHeader, SalesLine, "Document Type"::Invoice, CustomerNo, ItemNo, 0, '', 0D);
            exit("No.");
        end;
    end;

    local procedure SetQuantityOnInvoiceLineSmallerThanMinimumOrderQuantityAndWithinGiftToleranceQty(SalesInvoiceNo: Code[20]; NewQuantity: Decimal)
    var
        SalesLine: Record "Sales Line";
    begin
        with SalesLine do begin
            SetRange("Document Type", "Document Type"::Invoice);
            SetRange("Document No.", SalesInvoiceNo);
            if FindFirst() then begin
                Validate(Quantity, NewQuantity);
                Modify();
            end;
        end;
    end;

    local procedure VerifyActivePromotionMessageIsDisplayed(NewItemNo: Code[20]; NewCustomerCategoryCode: Code[20])
    var
        GiftCampaign: Record GiftCampaign_PKT;
        Value: Variant;
        GiftAlertText: Label 'Attention: there is an active promotion for item %1. if you buy %2 you can have a gift of %3';
    begin
        // Want to learn about Enqueue and Dequeue? Have a look at pag 125-126 in https://www.packtpub.com/business/automated-testing-microsoft-dynamics-365-business-central
        LibraryVariableStorage.Dequeue(Value);

        with GiftCampaign do begin
            SetRange(CustomerCategoryCode, NewCustomerCategoryCode);
            SetRange(ItemNo, NewItemNo);
            FindFirst();
            Assert.AreEqual(
                StrSubstNo(
                    GiftAlertText,
                    ItemNo,
                    Format(MinimumOrderQuantity),
                    Format(GiftQuantity)
                ),
                Value,
                'Gift alert');
        end;
    end;

    [MessageHandler]
    procedure MessageHandler(Msg: Text[1024])
    begin
        // Want to learn about Enqueue and Dequeue? Have a look at pag 125-126 in https://www.packtpub.com/business/automated-testing-microsoft-dynamics-365-business-central
        LibraryVariableStorage.Enqueue(Msg);
    end;
}