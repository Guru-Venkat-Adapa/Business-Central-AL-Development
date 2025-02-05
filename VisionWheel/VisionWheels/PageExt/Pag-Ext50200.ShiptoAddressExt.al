namespace VisionWheels.VisionWheels;

using Microsoft.Sales.Customer;
using Microsoft.Foundation.Comment;

pageextension 50200 "Ship-to Address List Ext" extends "Ship-to Address List"
{
    actions
    {
        addafter("&Address")
        {
            action("Co&mments")
            {
                ApplicationArea = Comments;
                Caption = 'Co&mments';
                Image = ViewComments;
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;
                // RunObject = Page "Comment Sheet";
                // RunPageLink = "Table Name" = const(Customer),
                //                   "No." = field("No.");
                // ToolTip = 'View or add comments for the record.';
                RunObject = page "Comment Sheet";
                RunPageLink = "Table Name" = const("Ship-to Address"), "No." = field("Customer No."), Code = field(Code);
            }
        }
    }
}
