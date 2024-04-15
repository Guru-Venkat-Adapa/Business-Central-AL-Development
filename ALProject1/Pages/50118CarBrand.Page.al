page 50118 "Car Brand"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Car Brand";
    Caption = 'Car Brand';
    Editable = false;
    layout
    {
        area(Content)
        {
            repeater(Control)
            {
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Caption = 'Name';
                    // Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    // Editable = false;
                }
                field(country; Rec.country)
                {
                    Caption = 'Country';
                    ApplicationArea = All;
                    //Editable = false;
                }
                // field(SystemId; Rec.SystemId)
                // {
                //     Caption = 'StystemId';
                //     ApplicationArea = All;
                //     Editable = false;
                // }
            }
        }
    }
}