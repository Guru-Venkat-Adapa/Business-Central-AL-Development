pageextension 50128 "Sales Cr. Memo Statistics Ext" extends "Sales Credit Memo Statistics"
{
    layout
    {
        // Add changes to page layout here
        modify(VATAmount)
        {
            Caption = 'GST Amount';
        }
        modify(AmountInclVAT)
        {
            Caption = 'Total Incl. GST';
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}