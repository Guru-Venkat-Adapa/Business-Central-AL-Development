report 50102 "Sale tax Invoice"
{
    Caption = 'Sale tax Invoice';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    PreviewMode = PrintLayout;
    DefaultRenderingLayout = LayoutName;
    EnableHyperlinks = true;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Sell-to Customer No.";
            RequestFilterHeading = 'Posted Sales Invoices';

            column(Picture; CompanyInfo.Picture)
            {
            }
            column(Bank_Name; CompanyInfo."Bank Name")
            {
            }
            column(Bank_Account_No_; CompanyInfo."Bank Account No.")
            {
            }
            column(IBAN; CompanyInfo.IBAN)
            {
            }
            column(Phone_No_; CompanyInfo."Phone No.")
            {
            }
            column(E_Mail; CompanyInfo."E-Mail")
            {
            }
            column(Home_Page; CompanyInfo."Home Page")
            {
            }
            //company information label
            column(TaxInvoiceLbl; TaxInvoiceLbl)
            {
            }
            column(CommonWealthBankLbl; CommonWealthBankLbl)
            {
            }
            column(BSBlbl; BSBlbl)
            {
            }
            column(AccountNumberlbl; AccountNumberlbl)
            {
            }
            column(DynamoFitnessEquipmentLbl; DynamoFitnessEquipmentLbl)
            {
            }
            column(ExpertinFitnessLbl; ExpertinFitnessLbl)
            {
            }
            column(ABNLbl; ABNLbl)
            {
            }
            column(Plbl; Plbl)
            {
            }
            column(Elbl; Elbl)
            {
            }
            column(Wlbl; Wlbl)
            {
            }
            column(GoodRemainProperty; GoodRemainProperty)
            {
            }
            column(BulkyGoodsLbl; BulkyGoodsLbl)
            {
            }
            column(TermsConditionLbl; TermsConditionLbl)
            {
            }
            column(TermsConditionUrl; TermsConditionUrl)
            {
            }
            //invoice values label
            column(InvoiceDatelbl; InvoiceDatelbl)
            {
            }
            column(InvoiceNolbl; InvoiceNolbl)
            {
            }
            column(CustomerPoNolbl; CustomerPoNolbl)
            {
            }
            column(ETDlbl; ETDlbl)
            {
            }
            column(Customerlbl; Customerlbl)
            {
            }
            column(ShipTolbl; ShipTolbl)
            {
            }
            column(Phonelbl; Phonelbl)
            {
            }
            column(Mobilelbl; Mobilelbl)
            {
            }
            //invoice line label
            column(Imagelbl; Imagelbl)
            {
            }
            column(Codelbl; Codelbl)
            {
            }
            column(Itemlbl; Itemlbl)
            {
            }
            column(OptionsLbl; OptionsLbl)
            {
            }
            column(Qtylbl; Qtylbl)
            {
            }
            column(QtyDiscpatchedlbl; QtyDiscpatchedlbl)
            {
            }
            column(UnitPricelbl; UnitPricelbl)
            {
            }
            column(TotalDiscountlbl; TotalDiscountlbl)
            {
            }
            column(Subtotalbl; Subtotalbl)
            {
            }
            //payments Entry lables
            column(Paymnetslbl; Paymnetslbl)
            {
            }
            column(Methodlbl; Methodlbl)
            {
            }
            column(Reflbl; Reflbl)
            {
            }
            column(Amountlbl; Amountlbl)
            {
            }
            //TOtal Calulations labels
            column(ProductCostlbl; ProductCostlbl)
            {
            }
            column(DeliveryDetailslbl; DeliveryDetailslbl)
            {
            }
            column(Discountlbl; Discountlbl)
            {
            }
            column(OverallDiscountlbl; OverallDiscountlbl)
            {
            }
            column(SubTtllbl; SubTtllbl)
            {
            }
            column(TaxLbl; TaxLbl)
            {
            }
            column(TaxInvoiceTotallbl; TaxInvoiceTotallbl)
            {
            }
            column(TotalPaidlbl; TotalPaidlbl)
            {
            }
            column(Outstandinglbl; Outstandinglbl)
            {
            }
            column(dollarlbl; dollarlbl)
            {
            }
            column(No_; "No.")
            {
            }
            column(Posting_Date; "Posting Date")
            {
            }
            column(Sell_to_Customer_Name; "Sell-to Customer Name")
            {
            }
            column(PhoneNo; Contact."Phone No.")
            {
            }
            column(MobileNo; Contact."Mobile Phone No.")
            {
            }
            column(Ship_to_Name; "Ship-to Name")
            {
            }
            column(Ship_to_Address; "Ship-to Address")
            {
            }
            column(Ship_to_Address_2; "Ship-to Address 2")
            {
            }
            column(Ship_to_City; "Ship-to City")
            {
            }
            column(Ship_to_Post_Code; "Ship-to Post Code")
            {
            }
            column(Ship_to_Country_Region_Code; "Ship-to Country/Region Code")
            {
            }
            column(Invoice_Discount_Amount; "Invoice Discount Amount")
            {
            }
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "Document No."=field("No.");
                DataItemLinkReference = "Sales Invoice Header";
                DataItemTableView = sorting("Document No.", "Line No.");

                column(ItemPicture; ItemTenantMedia.Content)
                {
                }
                column(ItemCode; "No.")
                {
                }
                column(ItemName; Description)
                {
                }
                column(Quantity; Quantity)
                {
                }
                column(QuantityDispatched; Quantity)
                {
                }
                column(Line_Amount; "Unit Price")
                {
                }
                column(TotalAmount; Amount)
                {
                }
                column(LineDiscount; "Line Discount %")
                {
                }
                column(Line_Discount_Amount; "Line Discount Amount")
                {
                }
                column(TotalInclVAT; TotalInclVAT)
                {
                }
                column(TotalLineAmount; TotalLineAmount)
                {
                }
                trigger OnAfterGetRecord()
                begin
                    if "Sales Invoice Line".Type = Type::Item then begin
                        InvoiceLineItem.Get("Sales Invoice Line"."No.");
                        if InvoiceLineItem.Picture.Count > 0 then begin
                            ItemTenantMedia.Get(InvoiceLineItem.Picture.Item(1));
                            ItemTenantMedia.CalcFields(Content)end;
                        if "Sales Invoice Line".FindSet()then repeat TotalInclVAT+="Sales Invoice Line"."Amount Including VAT";
                                TotalLineAmount+="Sales Invoice Line"."Line Amount";
                            until "Sales Invoice Line".Next() = 0;
                    end;
                end;
            }
            dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
            {
                DataItemLinkReference = "Sales Invoice Header";
                DataItemLink = "Document No."=field("No.");
                DataItemTableView = sorting("Entry No.");

                column(Remaining_Amount; "Remaining Amount")
                {
                }
                dataitem("Detailed Cust. Ledg. Entry"; "Detailed Cust. Ledg. Entry")
                {
                    DataItemLinkReference = "Cust. Ledger Entry";
                    DataItemLink = "Cust. Ledger Entry No."=field("Entry No.");
                    DataItemTableView = sorting("Entry No.");

                    column(CustPosting_Date; "Posting Date")
                    {
                    }
                    column(Credit_Amount; "Credit Amount")
                    {
                    }
                    column(PaymentCode; PaymentCode)
                    {
                    }
                    trigger OnAfterGetRecord()
                    begin
                        if CustLedgerEntry.Get("Detailed Cust. Ledg. Entry"."Cust. Ledger Entry No.")then begin
                            PaymentCode:="Cust. Ledger Entry"."Payment Method Code";
                        end;
                    end;
                    trigger OnPreDataItem()
                    begin
                        "Detailed Cust. Ledg. Entry".SetRange("Document Type", "Document Type"::Payment);
                    end;
                }
                trigger OnAfterGetRecord()
                begin
                    "Cust. Ledger Entry".CalcFields("Remaining Amount");
                end;
                trigger OnPreDataItem()
                begin
                    "Cust. Ledger Entry".SetRange("Document Type", "Document Type"::Invoice);
                end;
            }
            trigger OnAfterGetRecord()
            begin
                Contact.Get("Sell-to Contact No.");
            end;
        }
    }
    requestpage
    {
    }
    rendering
    {
        layout(LayoutName)
        {
            Type = RDLC;
            LayoutFile = 'PostedSalesTaxReport.rdlc';
        }
    }
    trigger OnInitReport()
    var
        p: Page "Customer Ledger Entries";
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
    end;
    var CompanyInfo: Record "Company Information";
    Contact: Record Contact;
    PaymentCode: Code[30];
    CustLedgerEntry: Record 21;
    InvoiceLineItem: Record Item;
    ItemTenantMedia: Record "Tenant Media";
    TaxInvoiceLbl: Label 'Tax Invoice';
    DynamoFitnessEquipmentLbl: Label 'Dynamo Fitness Equipment';
    ExpertinFitnessLbl: Label 'The Experts in Fitness Equipment';
    TermsConditionLbl: Label 'By accepting this order you agree to our terms and conditions for more on those please visit';
    BulkyGoodsLbl: Label 'All Bulky Goods (Orders shipped on a pallet 25kg and Over in weight) are Kerbside Delivery Only. It is the customers responsibility to bring the goods inside the home/property.';
    GoodRemainProperty: Label 'All goods remain the property of Dynamo Fitness Equipment until payment in full is received.';
    TermsConditionUrl: Label 'https://dynamofitness.com.au/terms-n-conditions';
    ABNLbl: Label 'ABN :';
    Plbl: Label 'P';
    Elbl: Label 'E';
    Wlbl: Label 'W';
    BSBlbl: Label 'BSB';
    AccountNumberlbl: Label 'Account Number :';
    CommonWealthBankLbl: Label ' Commonwealth bank Account name :';
    InvoiceDatelbl: Label 'Invoice Date';
    InvoiceNolbl: Label 'Invoice No';
    CustomerPoNolbl: Label 'Cusotmer PO No';
    ETDlbl: Label 'ETD';
    Customerlbl: Label 'Customer:';
    ShipTolbl: Label 'Ship To:';
    Phonelbl: Label 'Phone:';
    Mobilelbl: Label 'Mobile:';
    Imagelbl: Label 'Image';
    Codelbl: Label 'Code';
    Itemlbl: Label 'Item';
    OptionsLbl: Label 'Options';
    Qtylbl: Label 'Qty';
    QtyDiscpatchedlbl: Label 'Qty Dispatched';
    UnitPricelbl: Label 'Unit Price';
    TotalDiscountlbl: Label ' Total Discount';
    Subtotalbl: Label 'Subtotal';
    ProductCostlbl: Label 'Product Cost:';
    DeliveryDetailslbl: Label 'Delivery Details:';
    Discountlbl: Label 'Discount:';
    OverallDiscountlbl: Label 'Overall Discount:';
    SubTtllbl: Label 'Sub Total:';
    TaxLbl: Label 'GST (10 %):';
    TaxInvoiceTotallbl: Label 'Tax Invoice Total (AUD):';
    TotalPaidlbl: Label 'Total Paid (AUD):';
    Outstandinglbl: Label 'Outstanding (AUD):';
    Paymnetslbl: Label 'Payments';
    Methodlbl: Label 'Method';
    Reflbl: Label 'Ref';
    Amountlbl: Label 'Amount';
    dollarlbl: Label '$';
    TotalInclVAT: Decimal;
    TotalLineAmount: Decimal;
}
