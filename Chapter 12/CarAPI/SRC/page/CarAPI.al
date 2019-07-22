page 50111 CarAPI
{
    PageType = API;
    Caption = 'CarAPI';
    APIPublisher = 'sd';
    APIGroup = 'custom';
    APIVersion = 'v1.0';
    EntityName = 'car';
    EntitySetName = 'cars';
    SourceTable = Car;
    DelayedInsert = true;
    ODataKeyFields = ID;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(id; ID)
                {
                    Caption = 'id';
                }
                field(modelno; ModelNo)
                {
                    Caption = 'modelNo';
                }
                field(description; Description)
                {
                    Caption = 'description';
                }
                field(brand; Brand)
                {
                    Caption = 'brand';
                }
                field(engineType; "Engine Type")
                {
                    Caption = 'engineType';
                }
                field(power; Power)
                {
                    Caption = 'power';
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Insert(true);

        Modify(true);
        exit(false);
    end;

    trigger OnModifyRecord(): Boolean
    var
        Car: Record Car;
    begin
        Car.SetRange(ID, ID);
        Car.FindFirst();

        if ModelNo <> Car.ModelNo then begin
            Car.TransferFields(Rec, false);
            Car.Rename(ModelNo);
            TransferFields(Car);
        end;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        Delete(true);
    end;
}