report 50102 "Customer Multi-Tables Report"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    Caption = 'Customer Multiple Tables Report';
    DefaultLayout = RDLC;
    RDLCLayout = 'CustomerMultipleTableRep.RDL';
    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            PrintOnlyIfDetail = true;
            column(No_; "No.")
            {
                IncludeCaption = true;
            }
            column(Name; Name)
            {
                IncludeCaption = true;
            }
            column(Address; Address)
            {
                IncludeCaption = true;
            }
            column(Phone_No_; "Phone No.")
            {
                IncludeCaption = true;
            }
            column(E_Mail; "E-Mail")
            {
                IncludeCaption = true;
            }
            dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
            {
                DataItemTableView = sorting("Entry No.");
                DataItemLink = "Customer No." = field("No.");
                column(Entry_No_; "Entry No.")
                {
                    IncludeCaption = true;
                }
                column(Customer_No_; "Customer No.")
                {
                    IncludeCaption = true;
                }
                column(Posting_Date; "Posting Date")
                {
                    IncludeCaption = true;
                }
                column(Document_Type; "Document Type")
                {
                    IncludeCaption = true;
                }
                column(Document_No_; "Document No.")
                {
                    IncludeCaption = true;
                }
                column(Description; Description)
                {
                    IncludeCaption = true;
                }
                column(Currency_Code; "Currency Code")
                {
                    IncludeCaption = true;
                }
                column(Amount; Amount)
                {
                    IncludeCaption = true;
                }
                column(Original_Amount; "Original Amt. (LCY)")
                {
                    IncludeCaption = true;
                }
                column(Remaining_Amount; "Remaining Amt. (LCY)")
                {
                    IncludeCaption = true;
                }
                dataitem("Detailed Cust. Ledg. Entry"; "Detailed Cust. Ledg. Entry")
                {
                    DataItemTableView = sorting("Entry No.");
                    DataItemLink = "Cust. Ledger Entry No." = field("Entry No."), "Customer No." = field("Customer No.");

                    column(Detail_Entry_No_; "Entry No.")
                    {

                    }
                    column(Entry_Type; "Entry Type")
                    {

                    }
                    column(Detail_Posting_Date; "Posting Date")
                    {

                    }
                    column(Detail_Document_Type; "Document Type")
                    {

                    }
                    column(Detail_Document_No_; "Document No.")
                    {

                    }
                    column(Amount__LCY_; "Amount (LCY)")
                    {

                    }
                    column(Transaction_No_; "Transaction No.")
                    {

                    }
                    column(Journal_Batch_Name; "Journal Batch Name")
                    {

                    }
                    column(Debit_Amount__LCY_; "Debit Amount (LCY)")
                    {

                    }
                    column(Credit_Amount__LCY_; "Credit Amount (LCY)")
                    {

                    }
                }
            }
            dataitem("Sales Header"; "Sales Header")
            {
                DataItemTableView = sorting("Document Type", "No.");
                DataItemLink = "Sell-to Customer No." = field("No.");
                column(Sales_Document_Type; "Document Type")
                {
                    IncludeCaption = true;
                }
                column(Sales_No_; "No.")
                {
                    IncludeCaption = true;
                }
                column(Sales_Posting_Date; "Posting Date")
                {
                    IncludeCaption = true;
                }
                column(Prices_Including_VAT; "Prices Including VAT")
                {
                    IncludeCaption = true;
                }
                column(Sales_Amount; Amount)
                {
                    IncludeCaption = true;
                }
            }
        }
    }


    Labels
    {
        Sales_Document = 'Sales Document';

        Total_Caption = 'TotalAmount';
    }

}