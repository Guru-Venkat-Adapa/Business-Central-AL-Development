tableextension 50152 CustLedEntry extends "Cust. Ledger Entry"
{
    fields
    {
        field(50101; "Sales Order No."; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        // Add changes to table fields here
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