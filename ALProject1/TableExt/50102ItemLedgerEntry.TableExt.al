tableextension 50102 "Item Ledger Entry Table Ext" extends "Item Ledger Entry"
{
    fields
    {
        // Add changes to table fields here
        field(50100;"Customer Category";Code[20])
        {
            Caption='Customer Category';
            DataClassification=CustomerContent;
            TableRelation="Customer Category".No;
        }
    }
    
    var
        myInt: Integer;
}