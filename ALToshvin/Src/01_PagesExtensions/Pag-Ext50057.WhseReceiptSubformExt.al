pageextension 50057 "Whse. Receipt Subform Ext" extends "Whse. Receipt Subform"
{
    layout
    {
        //TBC - 835 -->
        addbefore("Item No.")
        {
            field("Source Line No."; Rec."Source Line No.")
            {
                ApplicationArea = All;
                Visible = true;
                Editable = false;
                Caption = 'Source Line No.';
            }
        }
        //TBC - 835 <--
        modify("Location Code")
        {
            Visible = true;
            Caption = 'Warehouse Code';
        }
        modify("Bin Code")
        {
            Visible = true;
        }
        movebefore(Quantity; "Bin Code")
        movebefore("Bin Code"; "Location Code")

        addafter(Description)
        {
            field(Principle; Rec.Principle)
            {
                ApplicationArea = All;
                Visible = VisibleImportFileds;
                Editable = false;
            }
            field("HSN/SAC Code"; Rec."HSN/SAC Code")
            {
                ApplicationArea = All;
                Visible = VisibleImportFileds;
                Editable = false;
            }
        }
        addafter("Qty. to Receive")
        {
            field("Direct Unit Cost"; Rec."Direct Unit Cost")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = VisibleImportFileds;
            }
            field("Line Amount"; Rec."Line Amount")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = VisibleImportFileds;
            }
            field("Exchange Rate"; Rec."Exchange Rate")
            {
                ApplicationArea = All;
                Visible = VisibleImportFileds;
                Editable = false;
            }
            field("Per Unit Rate INR"; Rec."Per Unit Rate INR")
            {
                ApplicationArea = All;
                Visible = VisibleImportFileds;
                Editable = false;
            }
            field("Amount INR"; Rec."Amount INR")
            {
                ApplicationArea = All;
                Visible = VisibleImportFileds;
                Editable = false;
            }
            field("Insurance Charges"; Rec."Insurance Charges")
            {
                ApplicationArea = All;
                Visible = VisibleImportFileds;
                Editable = false;
            }
            field("Freight Charges"; Rec."Freight Charges")
            {
                ApplicationArea = All;
                Visible = VisibleImportFileds;
                Editable = false;
            }
            field("Misc Charges"; Rec."Misc Charges")
            {
                ApplicationArea = All;
                Visible = VisibleImportFileds;
                Editable = false;
            }
            field("Gross Amount"; Rec."Gross Amount")
            {
                ApplicationArea = All;
                Visible = VisibleImportFileds;
                Editable = false;
            }
            field("GST Group Code"; Rec."GST Group Code")
            {
                ApplicationArea = All;
                Visible = VisibleImportFileds;
            }
            field("Custom Duty Percentage"; Rec."Custom Duty Percentage")
            {
                ApplicationArea = All;
                Visible = VisibleImportFileds;
                Editable = false;
            }
            field("Custom Duty Amount"; Rec."Custom Duty Amount")
            {
                ApplicationArea = All;
                Visible = VisibleImportFileds;
                Editable = false;
            }
            field("Total Assesable value"; Rec."Total Assesable value")
            {
                ApplicationArea = All;
                Visible = VisibleImportFileds;
                Editable = false;
            }
            field("IGST Percentage"; Rec."IGST Percentage")
            {
                ApplicationArea = All;
                Visible = VisibleImportFileds;
                Editable = false;
            }
            field("IGST Amount"; Rec."IGST Amount")
            {
                ApplicationArea = All;
                Visible = VisibleImportFileds;
                Editable = false;
            }
            field("Gross Total"; Rec."Gross Total")
            {
                ApplicationArea = All;
                Visible = VisibleImportFileds;
                Editable = false;
            }
        }
        addlast(Control1)
        {
            field(MExpiryDate; Rec.MExpiryDate)
            {
                ApplicationArea = All;
                Caption = 'M Expiry Date';
            }
        }
        //TBC-956 --->
        addafter("Source Document")
        {
            field("Line No."; Rec."Line No.")
            {
                ApplicationArea = All;
                Caption = 'Line No.';
                Editable = false;
            }
        }
        //TBC-956 <---

        //TBC-979 --->
        addafter("Location Code")
        {
            field("Lot No."; Rec."Lot No.")
            {
                ApplicationArea = All;
                Visible = true;
                Editable = false;
                Caption = 'Lot No.';
            }
        }
        //TBC-979  <-----
    }
    trigger OnAfterGetRecord()
    var
        WhseRcptHeader: Record "Warehouse Receipt Header";
    begin
        VisibleImportFileds := false;
        if WhseRcptHeader.Get(Rec."No.") then
            VisibleImportFileds :=
                WhseRcptHeader."Purchase Type" =
                WhseRcptHeader."Purchase Type"::Import;
    end;

    var
        VisibleImportFileds: Boolean;
}
