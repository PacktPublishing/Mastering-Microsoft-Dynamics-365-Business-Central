pageextension 50100 ItemCardExt extends "Item Card"
{
    layout
    {
        addlast(Item)
        {
            group(userControlTimer)
            {
                usercontrol(D365BCPingPong; D365BCPingPong)
                {
                    ApplicationArea = All;

                    trigger TimerElapsed()
                    begin
                        //Stops the timer when the timer has elapsed
                        CurrPage.D365BCPingPong.StopTimer();
                        //Here you can have your code that must be executed every tick
                        Message('Run your code here');
                        CurrPage.D365BCPingPong.StartTimer();
                    end;
                }
            }
        }
    }


    trigger OnAfterGetCurrRecord()
    begin
        //Sets a timer interval every 10 seconds
        CurrPage.D365BCPingPong.SetTimerInterval(10000);
        CurrPage.D365BCPingPong.StartTimer();
    end;

}