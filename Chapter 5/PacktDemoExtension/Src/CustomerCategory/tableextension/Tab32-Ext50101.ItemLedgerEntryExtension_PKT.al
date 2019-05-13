tableextension 50101 "ItemLedgerEntryExtension_PKT" extends "Item Ledger Entry"
{
    fields
    {

        //Field added during Sales Post
        field(50100; "Customer Category_PKT"; Code[20])
        {
            TableRelation = "Customer Category_PKT".Code;
            Caption = 'Customer Category';
            DataClassification = CustomerContent;
        }


    }

    keys
    {
        key(FK; "Customer Category_PKT")
        {

        }
    }

}