$Features = @()

$Features +=
Feature 'Gifts' {
    Scenario 10 'Assign quantity on sales line to trigger active promotion message' {
        Given   'Packt setup with "Gift Tolerance Qty"'
        Given   'Customer with non-blocked customer category with "Free Gifts Available"'
        Given   'Item'
        Given   'Gift campaign for item and customer category with "Minimum Order Quantity"'
        Given   'Sales invoice for customer with line for item'
        When    'Set quantity on invoice line smaller than "Minimum Order Quantity" and within "Gift Tolerance Qty"'
        # (SalesLine.Quantity < GiftCampaign.MinimumOrderQuantity) and
        #      (GiftCampaign.MinimumOrderQuantity - SalesLine.Quantity <= PacktSetup."Gift Tolerance Qty")
        #  ====>
        # (5 < 10) and (10-5 <= 6)
        Then    'Active promotion message is displayed'
    }
}

$Features | `
    ConvertTo-ALTestCodeunit `
        -CodeunitID 60101 `
        -CodeunitName 'Gifts PKT' `
        -GivenFunctionName "Create {0}" `
        -ThenFunctionName "Verify {0}" `
        #   | Out-File '.\Src\testcodeunit\COD60101.Gifts.al'