pageextension 50100 CustomerCardExt extends "Customer Card"
{
    layout
    {
        modify(Name)
        {
            trigger OnAfterValidate()
            var
                TranslationManagement: Codeunit TranslationManagement;
            begin
                if Name.EndsWith('.com') then begin
                    if Confirm('Inserire informazioni cliente?', false) then
                        TranslationManagement.LookupAddressInfo(Name, Rec);
                end;
            end;
        }
    }

}