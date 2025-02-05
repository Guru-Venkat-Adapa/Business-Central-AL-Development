pageextension 50104 "Sales Order Subform Ext" extends "Sales Order Subform"
{
    layout
    {
        addafter("Shipment Date")
        {
            field(Name; Rec.Name)
            {
                ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                ApplicationArea = All;
            }
            field(Address; Rec.Address)
            {
                ToolTip = 'Specifies the value of the Address field.', Comment = '%';
                ApplicationArea = All;
            }
            field("Phone Number"; Rec."Phone Number")
            {
                ToolTip = 'Specifies the value of the Phone Number field.', Comment = '%';
                ApplicationArea = All;
            }
            field(Email; Rec.Email)
            {
                ToolTip = 'Specifies the value of the Email field.', Comment = '%';
                ApplicationArea = All;
            }
        }

    }
}
