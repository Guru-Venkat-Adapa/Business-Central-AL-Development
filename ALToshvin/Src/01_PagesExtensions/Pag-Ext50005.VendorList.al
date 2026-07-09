pageextension 50005 VendorList extends "Vendor List"
{
    layout
    {
        addafter("No.")
        {
            field("Focus Vendor No."; Rec."Focus Vendor No.")
            {
                ApplicationArea = All;
                Caption = 'Focus Vendor No.';
            }
            field("Old No Series"; Rec."CRM Vendor No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the CRM Vendor No. field.';
            }
        }
    }

    actions
    {
        addafter("&Purchases")
        {
            action(DND)
            {
                ApplicationArea = All;
                Caption = 'DND';
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;
                trigger OnAction()
                var
                    VendRec: Record Vendor;
                begin
                    if not Confirm('Are you sure you want to delete ALL Vendor?', false) then
                        exit;
                    VendRec.DeleteAll(true);
                    Message('All Vendor deleted successfully.');
                end;
            }
        }
    }
}
