pageextension 50115 "New Table Page Extension" extends "Item Card"
{
    layout
    {
        addafter(Description)
        {
            field("Catalogue No.";"Catalogue No.")
            {
                ApplicationArea = All;
            }
        }
    }
    
}