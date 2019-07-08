tableextension 50105 "New Table Extension" extends Item 
{
    fields
    {
        field(50105;"Catalogue No.";Integer)
        {
            DataClassification = ToBeClassified;  
            ObsoleteState = Removed; 
        }
        field(50106;NewCatalogueNo;Text[30])
        {
            CaptionML=ENU='Catalogue No. 2';
            DataClassification = ToBeClassified;  
        }
    }
    
}