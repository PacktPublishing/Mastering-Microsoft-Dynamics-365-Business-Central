table 50105 "NewTable"
{
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1;"Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2;"Description"; Text [30] )
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;   
        }
        field(4; "Open"; Boolean)
        {
            DataClassification = ToBeClassified;   
        }
    }
    
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
        
}