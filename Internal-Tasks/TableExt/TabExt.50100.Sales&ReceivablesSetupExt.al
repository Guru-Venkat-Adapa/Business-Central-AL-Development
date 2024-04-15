tableextension 50100 "Sale & Recive Setup Ext" extends "Sales & Receivables Setup"
{
    fields
    {
        // Add changes to table fields here
        field(100; MRS; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'MRS no. Series';
            TableRelation = "No. Series".Code;
        }
        field(101; PRS; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'PRS no. Series';
            TableRelation = "No. Series".Code;
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}