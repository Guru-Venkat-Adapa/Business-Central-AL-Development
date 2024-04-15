query 50100 "SCB Subscription"
{
    QueryType = Normal;

    elements
    {
        dataitem(Cust__Ledger_Entry; "Cust. Ledger Entry")
        {
            column(Document_Type; "Document Type")
            {
                Caption = 'Document Type';
            }
            column(External_Document_No_; "External Document No.")
            {
                Caption = 'External Document No.';
            }
            column(Amount__LCY_; "Amount (LCY)")
            {
                Caption = 'Amount (LCY)';
                Method = Sum;
            }
            column(Sales__LCY_; "Sales (LCY)")
            {
                Caption = 'Sales (LCY)';
                Method = Sum;
            }
            column(Profit__LCY_; "Profit (LCY)")
            {
                Caption = 'Profit (LCY)';
                Method = Sum;
            }
            column(Remaining_Amt___LCY_; "Remaining Amt. (LCY)")
            {
                Caption = 'Remaining Amount (LCY)';
                Method = Sum;
            }
        }
    }
    var
        myInt: Integer;

    trigger OnBeforeOpen()
    begin

    end;
}