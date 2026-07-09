report 50044 "RCM Tax Invoice"
{
    //TBC-1025 ---->
    ApplicationArea = All;
    Caption = 'RCM Tax Invoice';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'Src\Reports\Layouts\RCMTaxInvoice.rdl';

    dataset
    {
        dataitem(PurchInvHeader; "Purch. Inv. Header")
        {
            RequestFilterFields = "No.";
            DataItemTableView = sorting("No.");

            column(No_; "No.") { }
            column(Posting_Date; "Posting Date") { }
            column(Buy_from_Vendor_Name; "Buy-from Vendor Name") { }
            column(Buy_from_Address; "Buy-from Address") { }
            column(Buy_from_Address_2; "Buy-from Address 2") { }
            column(Buy_from_City; "Buy-from City") { }
            column(Buy_from_County; "Buy-from County") { }
            column(Buy_from_Country_Region_Code; "Buy-from Country/Region Code") { }
            column(Buy_from_Post_Code; "Buy-from Post Code") { }
            column(Vendor_Invoice_No_; "Vendor Invoice No.") { }
            column(Vendor_GST_Reg__No_; "Vendor GST Reg. No.") { }
            column(Comment; HeaderComment) { }

            dataitem(Location; Location)
            {
                DataItemLink = Code = field("Location Code");
                DataItemTableView = sorting(Code);

                column(Loc_Name; Name) { }
                column(Loc_Address; Address) { }
                column(Loc_Address_2; "Address 2") { }
                column(Loc_City; City) { }
                column(Loc_County; County) { }
                column(Loc_Post_Code; "Post Code") { }
                column(Loc_Country_Region_Code; "Country/Region Code") { }
                column(Loc_GST_Registration_No_; "GST Registration No.") { }
            }

            dataitem("Purch. Inv. Line"; "Purch. Inv. Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = PurchInvHeader;
                DataItemTableView = sorting("Document No.", "Line No.") where("GST Reverse Charge" = const(true));

                column(Description; Description) { }
                column(HSN_SAC_Code; "HSN/SAC Code") { }
                column(Line_Amount; "Line Amount") { }
                column(SrNo; SrNo) { }
                column(CGSTPer; CGSTPer) { }
                column(CGSTAmt; CGSTAmt) { }
                column(SGSTPer; SGSTPer) { }
                column(SGSTAmt; SGSTAmt) { }

                trigger OnAfterGetRecord()
                begin
                    SrNo += 1;

                    Clear(IGSTAmt);
                    Clear(CGSTAmt);
                    Clear(SGSTAmt);
                    Clear(IGSTPer);
                    Clear(CGSTPer);
                    Clear(SGSTPer);
                    DetGSTLedgerEntry.Reset();
                    DetGSTLedgerEntry.SetRange("Document No.", "Purch. Inv. Line"."Document No.");
                    DetGSTLedgerEntry.SetRange("Document Line No.", "Purch. Inv. Line"."Line No.");
                    DetGSTLedgerEntry.SetRange("Document Type", DetGSTLedgerEntry."Document Type"::Invoice);
                    if DetGSTLedgerEntry.FindSet() then
                        repeat
                            case DetGSTLedgerEntry."GST Component Code" of
                                'IGST':
                                    begin
                                        IGSTAmt += Abs(DetGSTLedgerEntry."GST Amount");
                                        IGSTPer := DetGSTLedgerEntry."GST %";
                                    end;
                                'CGST':
                                    begin
                                        CGSTAmt += Abs(DetGSTLedgerEntry."GST Amount");
                                        CGSTPer := DetGSTLedgerEntry."GST %";
                                    end;
                                'SGST':
                                    begin
                                        SGSTAmt += Abs(DetGSTLedgerEntry."GST Amount");
                                        SGSTPer := DetGSTLedgerEntry."GST %";
                                    end;
                            end;
                        until DetGSTLedgerEntry.Next() = 0;
                end;
            }

            trigger OnAfterGetRecord()
            var
            begin
                Clear(HeaderComment);
                PurchCommentLine.Reset();
                PurchCommentLine.SetRange("Document Type", PurchCommentLine."Document Type"::"Posted Invoice");
                PurchCommentLine.SetRange("No.", PurchInvHeader."No.");
                PurchCommentLine.SetRange("Document Line No.", 0);
                if PurchCommentLine.FindSet() then
                    repeat
                        if HeaderComment = '' then
                            HeaderComment := PurchCommentLine.Comment
                        else
                            HeaderComment := HeaderComment + ' ' + PurchCommentLine.Comment;
                    until PurchCommentLine.Next() = 0;
            end;
        }
    }
    var
        PurchCommentLine: Record "Purch. Comment Line";
        HeaderComment: Text;
        SrNo: Integer;
        DetGSTLedgerEntry: Record "Detailed GST Ledger Entry";
        IGSTAmt: Decimal;
        CGSTAmt: Decimal;
        SGSTAmt: Decimal;
        IGSTPer: Decimal;
        CGSTPer: Decimal;
        SGSTPer: Decimal;

    //TBC-1025 <----
}
