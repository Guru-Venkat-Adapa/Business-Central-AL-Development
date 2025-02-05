report 50201 SalesQuoteCustom
{
    ApplicationArea = All;
    Caption = 'Sales Quote Custom';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'SalesQuoteCustom.rdlc';
    // WordLayout = 'SalesQuoteCustom.docx';
    dataset
    {
        dataitem(SalesHeader; "Sales Header")
        {
            DataItemTableView = sorting("Document Type", "No.") where("Document Type" = const(Quote));
            RequestFilterFields = "No.", "Sell-to Customer No.";
            column(SalesQuoteNo_; "No.") { }
            column(CompanyName; CompanyInfo.Name) { }
            column(CompanyPicture; CompanyInfo.Picture) { }
            column(CompanyAddress; CompanyInfo.Address) { }
            column(CompanyAddress2; CompanyInfo."Address 2") { }
            column(CompanyCity; CompanyInfo.City) { }
            // column(CompanyContactName; CompanyInfo."Contact Name") { }
            column(CompanyPhoneNo; CompanyInfo."Phone No.") { }
            column(CurrentDateTime; CurrentDateTime) { }
            column(CustomerNo_; "Sell-to Customer No.") { }
            column(CustomerName; "Sell-to Customer Name") { }
            column(CustomerNameLbl; CustomerNameLbl) { }
            column(Order_Date; "Order Date") { }
            column(Document_Date; CreatedDate) { }
            column(Salesperson_Code; "Salesperson Code") { }
            column(Due_Date; "Due Date") { }
            column(Ship_to_Name; "Ship-to Name") { }
            column(ShipToLbl; ShipToLbl) { }
            column(Sell_to_Phone_No_; "Sell-to Phone No.") { }
            column(PhNumberLbl; PhNumberLbl) { }
            column(MbNumberLbl; MbNumberLbl) { }
            column(Your_Reference; "Your Reference") { }
            column(ProdCostLbl; ProdCostLbl) { }
            column(DelDetailsLbl; DelDetailsLbl) { }
            column(TotalDiscountLbl; TotalDiscountLbl) { }
            column(OverallDiscountLbl; OverallDiscountLbl) { }
            column(lastSubtotalLbl; lastSubtotalLbl) { }
            column(TaxLbl; TaxLbl) { }
            column(TotalLbl; TotalLbl) { }
            column(TotalLineAmount; TotalDiscountAmount) { }
            // column(Currency_Code; "Currency Code") { }
            dataitem(salesLine; "Sales Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = SalesHeader;
                DataItemTableView = sorting("Document No.", "Line No.");
                column(Document_No_; "Document No.") { }
                column(Line_No_; "Line No.") { }
                column(SalesLineNo_; "No.") { }
                column(SalesLineNo_Lbl; CodeLbl) { }
                column(SalesLineDescription; Description) { }
                column(SalesLineDescriptionLbl; DescriptionLbl) { }
                column(Quantity; Quantity) { }
                column(SalesLineQtyLbl; qtylbl) { }
                column(Unit_Price; "Unit Price") { }
                column(SalesLineUnitPriceLbl; UnitPricelbl) { }
                column(Amount; Amount) { }
                column(SalesLineAmountLbl; subtotallbl) { }
                column(ItemImage; ItemImage.Content) { }
                column(ItemImageLbl; itemimagelbl) { }
                column(Line_Discount__; "Line Discount %") { }
                column(Line_Discount_Lbl; DiscountLbl) { }
                column(Line_Discount_Amount; "Line Discount Amount") { }
                column(Line_Discount_AmountLbl; TotDisAmtLbl) { }
                column(OptionsLbl; OptionsLbl) { }
                column(GSTAmount; GSTAmount) { }
                column(Line_Amount; LineAmount) { }
                column(AmountExclGST; AmountExclGST) { }
                column(AmountInclGST; AmountInclGST) { }

                trigger OnAfterGetRecord()
                var
                    Item: Record Item;
                    DocumentTotals: Codeunit "Document Totals";
                    InvoiceDiscountAmount, InvoiceDiscountPct : decimal;
                begin
                    Clear(ItemImage.Content);
                    LineAmount := "Line Amount";
                    AmountExclGST := Amount;
                    AmountInclGST := "Amount Including VAT";
                    if type = Type::Item then
                        if Item.Get("No.") then
                            if Item.Picture.Count > 0 then begin
                                ItemImage.Get(Item.Picture.Item(1));
                                ItemImage.CalcFields(Content);
                            end;
                    DocumentTotals.CalculateSalesSubPageTotals(SalesHeader, salesLine, GSTAmount, InvoiceDiscountAmount, InvoiceDiscountPct);
                end;
            }
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
    var
        CompanyInfo: Record "Company Information";
        CurrentDateTime: Date;
        CreatedDate: Text;
        ItemImage: Record "Tenant Media";
        SalesQuoteLbl: Label 'Quote';
        CreatedDateLbl: Label 'Created Date';
        CreatedByLbl: Label 'Created By';
        ETDLbl: Label 'ETD';
        RefLbl: Label 'Ref';
        CusPONoLbl: Label 'Customer PO No';
        CustomerNameLbl: Label 'Customer:';
        ShipToLbl: Label 'Ship To:';
        PhNumberLbl: Label 'Phone Number:';
        MbNumberLbl: Label 'Mobile Number:';
        ItemImageLbl: Label 'Image';
        CodeLbl: Label 'Code';
        DescriptionLbl: Label 'Description';
        OptionsLbl: Label 'Options';
        QtyLbl: Label 'Qty';
        UnitPriceLbl: Label 'Unit Price';
        DiscountLbl: Label 'Discount';
        TotDisAmtLbl: Label 'Total Discount Amount';
        SubTotalLbl: Label 'Sub Total';
        ProdCostLbl: Label 'Product Cost:';
        DelDetailsLbl: Label 'Delivery Details:';
        TotalDiscountLbl: Label 'Discount:';
        OverallDiscountLbl: Label 'Overall Discount:';
        lastSubtotalLbl: Label 'SubTotal:';
        TaxLbl: Label 'GST (10%):';
        TotalLbl: Label 'Total (AUD):';
        GSTAmount: Decimal;
        LineAmount: Decimal;
        AmountExclGST: Decimal;
        AmountInclGST: Decimal;
        StandardQuote: Report 1304;
        page1: Page 133;

    trigger OnPreReport()
    begin
        CompanyInfo.get();
        CompanyInfo.CalcFields(Picture);
        CurrentDateTime := Today();
    end;
}
