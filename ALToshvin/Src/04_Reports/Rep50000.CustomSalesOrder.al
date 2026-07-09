report 50000 CustomSalesOrder
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Custom Sales Order';
    DefaultLayout = RDLC;
    RDLCLayout = 'Src\04_Reports\Layouts\CustomSalesOrder.rdl';

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = sorting("Document Type", "No.") where("Document Type" = const(Order));
            RequestFilterFields = "No.";
            RequestFilterHeading = 'Sales Order';
            column(CompanyName; CompanyInfo.Name) { }
            column(CompanyInfoPicture; CompanyInfo.Picture) { }
            column(CompanyAddress; CompanyInfo.Address) { }
            column(CompanyAddress2; CompanyInfo."Address 2") { }
            column(CompanyGSTNo; CompanyInfo."GST Registration No.") { }
            column(CompanyCity; companyinfo.City) { }
            column(CompanyPostCode; companyinfo."Post Code") { }
            column(Despatchlbl; DespatchLbl) { }
            column(DespatchLocationLbl; DespatchLocationLbl) { }
            column(BTCNo; "Bill-to Customer No.") { }
            column(BTCName; "Bill-to Name") { }
            column(BTCName2; "Bill-to Name 2") { }
            column(BTCAddress; "Bill-to Address") { }
            column(BTCAddress2; "Bill-to Address 2") { }
            column(BTCCity; "Bill-to City") { }
            column(BTCPostCode; "Bill-to Post Code") { }
            column(STCCode; "Ship-to Code") { }
            column(STCName; "Ship-to Name") { }
            column(STCName2; "Ship-to Name 2") { }
            column(STCAddress; "Ship-to Address") { }
            column(STCAddress2; "Ship-to Address 2") { }
            column(STCCity; "Ship-to City") { }
            column(STCPostCode; "Ship-to Post Code") { }
            column(BTCStateName; BTCStateName) { }
            column(BTCStateCode; BTCStateCode) { }
            column(STCStateName; STCStateName) { }
            column(STCStateCode; STCStateCode) { }
            column(AmountInWords; AmountInWords) { }
            /*<------               Lables Fileds                  ------>*/
            column(BTALbl; BTALbl) { }
            column(STALbl; STALbl) { }
            column(OurDetailLbl; OurDetailLbl) { }
            column(StateLbl; StateLbl) { }
            column(StateCodeLbl; StateCodeLbl) { }
            column(GSTNoLbl; GSTNoLbl) { }
            column(PANNoLbl; PANNoLbl) { }
            column(PORefNoLbl; PORefNoLbl) { }
            column(PORefDtLbl; PORefDtLbl) { }
            column(KindAttLbl; KindAttLbl) { }
            column(ContNoLbl; ContNoLbl) { }
            column(EmailLbl; EmailLbl) { }
            column(PayTermLbl; PayTermLbl) { }
            column(NarrationLbl; NarrationLbl) { }
            column(BranchLbl; BranchLbl) { }
            column(DIFNoLbl; DIFNoLbl) { }
            column(DIFDtLbl; DIFDtLbl) { }
            column(RDCNoLbl; RDCNoLbl) { }
            column(RDCDtLbl; RDCDtLbl) { }
            column(SrNoLbl; SrNoLbl) { }
            column(ProductDescLbl; ProductDescLbl) { }
            column(CodeLbl; CodeLbl) { }
            column(HSNSACLbl; HSNSACLbl) { }
            column(QtyLbl; QtyLbl) { }
            column(UnitRateLbl; UnitRateLbl) { }
            column(AmountLbl; AmountLbl) { }
            column(DiscAmtLbl; DiscAmtLbl) { }
            column(TaxableAmtLbl; TaxableAmtLbl) { }
            column(CGSTLbl; CGSTLbl) { }
            column(SGSTLbl; SGSTLbl) { }
            column(IGSTLbl; IGSTLbl) { }
            column(TotalAmtLbl; TotalAmtLbl) { }
            column(FreightAmtLbl; FreightAmtLbl) { }
            column(PackFwdLbl; PackFwdLbl) { }
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                DataItemLinkReference = "Sales Header";
                DataItemTableView = sorting("Document Type", "Document No.", "Line No.");
                column(ItemNo; "No.") { }
                column(ItemDescription; Description) { }
                column(ItemQuantity; Quantity) { }
                column(ItemUnit_Price; "Unit Price") { }
                column(ItemDiscount_Amount; "Line Discount Amount") { }
                column(ItemLine_Amount; "Line Amount") { }
                column(Outstanding_Amount; "Outstanding Amount") { }
                column(HSN_SAC_Code; "HSN/SAC Code") { }
            }

            trigger OnAfterGetRecord()
            var
                State: Record State;
                Salesline: Record "Sales Line";
            begin
                Clear(BTCStateCode);
                Clear(BTCStateName);
                Clear(STCStateName);
                Clear(STCStateCode);
                if State.Get("Sales Header"."GST Bill-to State Code") then begin
                    BTCStateName := State.Description;
                    BTCStateCode := State."State Code (GST Reg. No.)";
                end;
                if State.Get("Sales Header"."GST Ship-to State Code") then begin
                    STCStateName := State.Description;
                    STCStateCode := State."State Code (GST Reg. No.)";
                end;
                Clear(TotalAmt);
                Clear(AmountTotal);
                Clear(AmountInWords);
                Salesline.SetRange("Document Type", "Sales Header"."Document Type"::Order);
                Salesline.SetRange("Document No.", "Sales Header"."No.");
                if Salesline.FindSet() then
                    repeat
                        TotalAmt += Salesline."Outstanding Amount";
                    until Salesline.Next() = 0;
                AmountTotal := ROUND(TotalAmt, 0.01);
                Check.InitTextVariable();
                Check.FormatNoText(NoText, AmountTotal, "Sales Header"."Currency Code");
                AmountInWords := COPYSTR(NoText[1], 6);
            end;

        }
    }

    trigger OnPreReport()

    begin
        CompanyInfo.get();
        CompanyInfo.CalcFields(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
        Check: Report Check;
        TotalAmt: Decimal;
        NoText: array[2] of Text;
        AmountTotal: Decimal;
        AmountInWords: Text;
        BTCStateName: Text[50];
        BTCStateCode: Code[10];
        STCStateName: Text[50];
        STCStateCode: Code[10];
        DespatchLbl: Label 'DESPATCH INSTRUCTION FORM';
        DespatchLocationLbl: Label 'Despatch Location :';
        BTALbl: Label 'Bill to Address';
        STALbl: Label 'Ship to Address';
        OurDetailLbl: Label 'Our Details';
        StateLbl: Label 'State :';
        StateCodeLbl: Label 'State Code :';
        GSTNoLbl: Label 'GST No. :';
        PANNoLbl: Label 'PAN No. :';
        PORefNoLbl: Label 'PO Ref. No. :';
        PORefDtLbl: Label 'PO Ref. Date :';
        KindAttLbl: Label 'Kind Attn :';
        ContNoLbl: Label 'Contact No. :';
        EmailLbl: label 'Email :';
        PayTermLbl: Label 'Pay. Term :';
        NarrationLbl: Label 'Narration:';
        BranchLbl: Label 'Branch :';
        DIFNoLbl: Label 'DIF No.:';
        DIFDtLbl: Label 'DIF Dt.:';
        RDCNoLbl: Label 'RDC No.:';
        RDCDtLbl: Label 'RDC Dt.:';
        SrNoLbl: Label 'Sr. No.';
        ProductDescLbl: Label 'Product Description';
        CodeLbl: Label 'Code';
        HSNSACLbl: Label 'HSN/SAC';
        QtyLbl: Label 'Qty';
        UnitRateLbl: Label 'Unit Rate';
        AmountLbl: Label 'Amount';
        DiscAmtLbl: Label 'Disc Amt';
        TaxableAmtLbl: Label 'Taxable Amt';
        CGSTLbl: Label 'CGST';
        SGSTLbl: Label 'SGST';
        IGSTLbl: Label 'IGST';
        TotalAmtLbl: Label 'Total Amount';
        FreightAmtLbl: Label 'Freight Amt :';
        PackFwdLbl: Label 'Pack & Fwd :';
}