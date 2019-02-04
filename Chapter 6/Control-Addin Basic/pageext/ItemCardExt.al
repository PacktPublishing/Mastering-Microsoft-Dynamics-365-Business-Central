pageextension 50100 ItemCardExt extends "Item Card"
{
    layout
    {
        addlast(Item)
        {
            group(AddinGroup)
            {
                Caption = 'Control Add-in';

                usercontrol(DemoAddin; DemoD365BCAddin)
                {
                    ApplicationArea = All;

                    trigger ControlReady()
                    begin
                        CurrPage.DemoAddin.HelloWorld();
                    end;
                }
            }
        }
    }
}