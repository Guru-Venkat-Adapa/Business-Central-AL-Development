page 50117 "Api Car Model"
{
    PageType = API;
    Caption = 'Api Car Model';
    APIPublisher = 'ShaligramInfotech';
    APIGroup = 'Guru';
    APIVersion = 'v1.0';

    EntityName = 'carModel';
    EntityCaption = 'CarModel';
    EntitySetName = 'carModels';
    EntitySetCaption = 'CarModels';

    SourceTable = "Car Model";
    DelayedInsert = true;
    Extensible = false;
    ODataKeyFields = SystemId;

    layout
    {
        area(Content)
        {
            repeater(Control)
            {
                field(SystemId; Rec.SystemId)
                {
                    Caption = 'Id';
                    Editable = false;
                    ApplicationArea = All;
                }
                field(name; Rec.name)
                {
                    Caption = 'Name';
                    ApplicationArea = All;
                }
                field(description; Rec.description)
                {
                    Caption = 'Description';
                    ApplicationArea = All;
                }
                field(brandid; Rec.brandid)
                {
                    Caption = 'Brand Id';
                    ApplicationArea = All;
                }
                field(power; Rec.power)
                {
                    Caption = 'Power';
                    ApplicationArea = All;
                }
                field(fueltype; Rec.fueltype)
                {
                    Caption = 'Fuel Type';
                    ApplicationArea = All;
                }
            }
        }
    }
}