page 50119 "Car Model"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Car Model";
    Caption = 'Car Model';
    Editable = false;
    layout
    {
        area(Content)
        {
            repeater(Control)
            {
                field(name; Rec.name)
                {
                    ApplicationArea = All;
                    Caption = 'Name';
                }
                field(description; Rec.description)
                {
                    Caption = 'Description';
                    ApplicationArea = All;
                }
                field(fueltype; Rec.fueltype)
                {
                    Caption = 'Fule Type';
                    ApplicationArea = All;
                }
                field(power; Rec.power)
                {
                    Caption = 'Power (cc)';
                    ApplicationArea = All;
                }
            }
        }
    }

}