namespace Toshvin.Toshvin;

using Microsoft.Sales.Archive;

pageextension 50024 "Sales Order Archive Subform" extends "Sales Order Archive Subform"
{
    layout
    {
        addafter("Unit Price")
        {
            field("L-Spares Quotation"; Rec."L-Spares Quotation")
            {
                ApplicationArea = All;
            }
            field("Item Instrument No."; Rec."Item Instrument No.")
            {
                ApplicationArea = All;
            }
            field("Lead Time Calculation"; Rec."Lead Time Calculation")
            {
                ApplicationArea = All;
            }
        }
        addafter("Line Amount")
        {
            field("SGST Percentage"; Rec."SGST Percentage")
            {
                ApplicationArea = All;
            }
            field("SGST Amount"; Rec."SGST Amount")
            {
                ApplicationArea = All;
            }
            field("CGST Percentage"; Rec."CGST Percentage")
            {
                ApplicationArea = All;
            }
            field("CGST Amount"; Rec."CGST Amount")
            {
                ApplicationArea = All;
            }
            field("IGST Percentage"; Rec."IGST Percentage")
            {
                ApplicationArea = All;
            }
            field("IGST Amount"; Rec."IGST Amount")
            {
                ApplicationArea = All;
            }
        }
    }
}
