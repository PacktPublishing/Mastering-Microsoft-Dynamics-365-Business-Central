pageextension 50100 CustomerCardExt extends "Customer Card"
{
    layout
    {
        addlast(General)
        {
            field(SalesAmount; SalesAmount)
            {
                ApplicationArea = All;
                Caption = 'Sales Amount';
                Editable = false;
            }
        }
    }

    var
        // Global variable used for the TaskID
        TaskSalesId: Integer;

        // Variables for the sales amount field (calculated from the background task) 
        SalesAmount: Decimal;

    trigger OnAfterGetRecord()
    var
        TaskParameters: Dictionary of [Text, Text];
    begin
        TaskParameters.Add('CustomerNo', Rec."No.");
        CurrPage.EnqueueBackgroundTask(TaskSalesId, 50100, TaskParameters, 10000, PageBackgroundTaskErrorLevel::Warning);
    end;

    trigger OnPageBackgroundTaskCompleted(TaskId: Integer; Results: Dictionary of [Text, Text])
    var
        PBTNotification: Notification;
    begin
        if (TaskId = TaskSalesId) then begin
            Evaluate(SalesAmount, Results.Get('TotalSales'));
            PBTNotification.Message('Total Sales updated.');
            PBTNotification.Send();
        end;
    end;

    trigger OnPageBackgroundTaskError(TaskId: Integer; ErrorCode: Text; ErrorText: Text; ErrorCallStack: Text; var IsHandled: Boolean)
    var
        PBTErrorNotification: Notification;
    begin
        if (ErrorText = 'Invalid parameter CustomerNo') then begin
            IsHandled := true;
            PBTErrorNotification.Message('Something went wrong. Invalid parameter CustomerNo.');
            PBTErrorNotification.Send();
        end
        else
            if (ErrorText = 'Child Session task was terminated because of a timeout.') then begin
                IsHandled := true;
                PBTErrorNotification.Message('It took to long to get results. Try again.');
                PBTErrorNotification.Send();
            end
    end;
}