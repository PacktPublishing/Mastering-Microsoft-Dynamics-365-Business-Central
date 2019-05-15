$Features = @()

$Features +=
Feature 'Customer Category' {
    Scenario 1 'Assign non-blocked customer category to customer' {
        Given   'A non-blocked customer category'
        Given   'A customer'
        When    'Set customer category on customer'
        Then    'Customer has customer category code field populated'
    }
    Scenario 2 'Assign blocked customer category to customer' {
        Given   'A blocked customer category'
        Given   'A customer'
        When    'Set customer category on customer'
        Then    'Blocked category error thrown'
    }
    Scenario 3 'Assign non-existing customer category to customer' {
        Given   'A non-existing customer category'
        Given   'A customer record variable'
        When    'Set non-existing customer category on customer'
        Then    'Non existing customer category error thrown'
    }
    Scenario 4 'Assign default category to a customer'{
        Given   'A non-blocked default customer category'
        Given   'a customer with customer category not equal to default customer category'
        When    'Run AssignDefaultCategory function for one customer'
        Then    'Customer has default customer category'
    }
    Scenario 5 'Assign default category to all customers'{
        Given   'A non-blocked default customer category'
        Given   'Customers with customer category empty'
        When    'Run AssignDefaultCategory function'
        Then    'All customers have default customer category'
    }
}

$Features +=
Feature 'Customer Category UI' {
    Scenario 6 'Assign customer category on customer card' {
        Given   'A non-blocked customer category'
        Given   'A customer card'
        When    'Set customer category on customer card'
        Then    'Customer has customer category code field populated'
    }
    Scenario 7 'Assign default category to customer from customer card'{
        Given   'A non-blocked default customer category'
        Given   'A customer with customer category not equal to default customer category'
        When    'Select "Assign Default Category" action on customer card'
        Then    'Customer has default customer category'
    }
    Scenario 8 'Assign default category to all customers from customer list'{
        Given   'A non-blocked default customer category'
        Given   'Customers with customer category empty'
        When    'Select "Assign Default Category to all Customers" action on customer list'
        Then    'All customers have default customer category'
    }
}

$Features | `
    ConvertTo-ALTestCodeunit `
        -CodeunitID 60100 `
        -CodeunitName 'Customer Category PKT' `
        -GivenFunctionName "Create {0}" `
        -ThenFunctionName "Verify {0}" `
        #  | Out-File '.\Src\testcodeunit\COD60100.CustomerCategory.al'