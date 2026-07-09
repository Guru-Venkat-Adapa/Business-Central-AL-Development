pageextension 50006 ItemList extends "Item List"
{
    layout
    {
        addafter("No.")
        {
            field("CRM Item No."; Rec."CRM Item No.")
            {
                ApplicationArea = All;
                Caption = 'CRM Item No.';
            }
        }
    }
    actions
    {
        addafter(CopyItem)
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
                    ItemRec: Record Item;
                    SalesLine: Record "Sales Line";
                begin
                    if not Confirm('Are you sure you want to delete Sales Lines for 016-31428 AND delete ALL Items?', false) then
                        exit;

                    // Delete Sales Lines for the specific item
                    SalesLine.Reset();
                    SalesLine.SetRange("No.", '016-31428');
                    SalesLine.DeleteAll(false);

                    // Delete ALL Items
                    ItemRec.DeleteAll(true);

                    Message('Sales Lines deleted for 016-31428 and ALL items deleted successfully.');
                end;

            }
        }
    }
}
