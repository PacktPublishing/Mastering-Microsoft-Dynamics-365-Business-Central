tableextension 50120 VendorQualityExt_PKN extends "Vendor Quality_PKT"
{
    fields
    {
        field(50120; "Certification No."; Text[50])
        {
            Caption = 'Classification No.';
            DataClassification = CustomerContent;
        }
    }

}