report 50101 "Bonus Overview RDLC"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Bonus Overview RDLC';
    DefaultLayout = RDLC;
    RDLCLayout = 'BonusOverRDLC.Report.RDL';
    dataset
    {
        dataitem("bonus Header"; "bonus Header")
        {
            RequestFilterFields = "No.", "Customer No.";
            column(No_; "No.")
            {

            }
            column(Customer_No_; "Customer No.")
            {

            }
            column(Sarting_Date; "Sarting Date")
            {

            }
            column(Ending_Date; "Ending Date")
            {

            }
            column(BonusNoCaptionLbl; BonusNoCaptionLbl)
            {

            }
            column(CustomerNoCaptionLbl; CustomerNoCaptionLbl)
            {

            }
            column(PostingDateCaptionLbl; PostingDateCaptionLbl)
            {

            }
            column(DocumentNoCaptionLbl; DocumentNoCaptionLbl)
            {

            }
            column(BonusAmountCaptionLbl; BonusAmountCaptionLbl)
            {

            }
            column(ItemNoCaptionLbl; ItemNoCaptionLbl)
            {

            }
            column(StartingDateCaptionLbl; StartingDateCaptionLbl)
            {

            }
            column(EndingDateCaptionLbl; EndingDateCaptionLbl)
            {

            }
            dataitem("Bonus Entry"; "Bonus Entry")
            {
                RequestFilterFields = "Posting Date";
                DataItemLink = "Bonus No." = field("No.");
                column(Documnet_No_; "Documnet No.")
                {

                }
                column(Item_No_; "Item No.")
                {

                }
                column(Posting_Date; "Posting Date")
                {

                }
                column(Bonus_Amount; "Bonus Amount")
                {

                }
            }
            column(AmountSum; AmountSum)
            {

            }
            trigger OnAfterGetRecord()
            var
                BonusEntry: Record "Bonus Entry";
            begin
                BonusEntry.CopyFilters("Bonus Entry");
                BonusEntry.SetRange("Bonus No.", "No.");
                BonusEntry.CalcSums("Bonus Amount");
                AmountSum := BonusEntry."Bonus Amount";
            end;
        }
    }
    var
        BonusNoCaptionLbl: Label 'Bonus No.';
        CustomerNoCaptionLbl: Label 'Customer No.';
        PostingDateCaptionLbl: Label 'Posting Date';
        DocumentNoCaptionLbl: Label 'Document No.';
        BonusAmountCaptionLbl: Label 'Amount';
        ItemNoCaptionLbl: Label 'Item No.';
        StartingDateCaptionLbl: Label 'Starting Date';
        EndingDateCaptionLbl: Label 'Ending Date';
        AmountSum: decimal;
}