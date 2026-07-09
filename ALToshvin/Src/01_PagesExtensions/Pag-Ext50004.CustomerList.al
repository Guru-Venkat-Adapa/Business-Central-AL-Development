pageextension 50004 "ExtCustomerList" extends "Customer List"
{
    layout
    {
        addafter("No.")
        {
            field("Focus Customer No."; Rec."Focus Customer No.")
            {
                ApplicationArea = All;
                Caption = 'Focus Customer No.';
                ToolTip = 'Specifies the value of the Focus Customer No. field.';
            }
        }
        //TBC - 885 -->
        addafter(Name)
        {
            field(Address; Rec.Address)
            {
                ApplicationArea = All;
            }
            field("Address 2"; Rec."Address 2")
            {
                ApplicationArea = All;
            }
        }
        modify("Post Code")
        {
            Visible = true;
        }
        moveafter("Address 2"; "Post Code")

        addafter("Post Code")
        {
            field(City; Rec.City)
            {
                ApplicationArea = All;
            }
            field("GST Registration No."; Rec."GST Registration No.")
            {
                ApplicationArea = All;
            }
            field("Customer Type"; Rec."Customer Type")
            {
                ApplicationArea = All;
            }
            field("Virtual Account"; Rec."Virtual Account")
            {
                ApplicationArea = All;
            }
            field("Group Master"; Rec."Group Master")
            {
                ApplicationArea = All;
            }
            field(ContactName; Rec.Contact)
            {
                ApplicationArea = All;
                Caption = 'Contact Name';
            }
            field("GST Customer Type"; Rec."GST Customer Type")
            {
                ApplicationArea = All;
            }
            field("State Code"; Rec."State Code")
            {
                ApplicationArea = All;
            }
            field("KEY/NON KEY(Principal Wise)"; Rec."KEY/NON KEY(Principal Wise)")
            {
                ApplicationArea = All;
            }
        }
        //TBC - 885 <--
    }
}
