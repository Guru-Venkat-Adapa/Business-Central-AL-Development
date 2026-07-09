codeunit 50001 SalesQuoteWebToBC
{

    procedure GSTCalculations(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; DiscountType: Enum "Discount Type"; Discount: Decimal)
    var
        SH: Record "Sales Header";
        SL: Record "Sales Line";
    begin
        if SH.Get(SalesHeader."Document Type", SalesHeader."No.") then begin
            SL.Reset();
            SL.SetRange("Document Type", SalesLine."Document Type");
            SL.SetRange("Document No.", SalesLine."Document No.");
            SL.SetRange(FOC, false);
            if SL.FindSet() then
                repeat
                    SL.Validate("SGST Percentage", SGSTPercentage(SH, SL));
                    SL.Validate("CGST Percentage", CGSTPercentage(SH, SL));
                    SL.Validate("IGST Percentage", IGSTPercentage(SH, SL));
                    if DiscountType = DiscountType::Percentage then
                        SL.Validate("Invoice Discount %", Discount)
                    else
                        if DiscountType = DiscountType::Fixed then
                            SL.Validate("Discount Amount", Discount);

                    SL.Modify(false);
                until SL.Next() = 0;
        end;
    end;


    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnAfterValidateEvent, Quantity, true, true)]
    local procedure OnAfterValidateEventTQuantity(var Rec: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
    begin
        if not Rec.FOC then begin
            if SalesHeader.Get(Rec."Document Type", Rec."Document No.") then begin
                if (SalesHeader."GST Customer Type" <> SalesHeader."GST Customer Type"::"SEZ Unit") or
                   (not SalesHeader."GST Without Payment of Duty") then begin
                    Rec.Validate("SGST Percentage", SGSTPercentage(SalesHeader, Rec));
                    Rec.Validate("CGST Percentage", CGSTPercentage(SalesHeader, Rec));
                    Rec.Validate("IGST Percentage", IGSTPercentage(SalesHeader, Rec));
                end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnAfterValidateEvent, "Unit Price", true, true)]
    local procedure OnAfterValidateEventTUnitPrice(var Rec: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
    begin
        if not Rec.FOC then begin
            if SalesHeader.Get(Rec."Document Type", Rec."Document No.") then begin
                if (SalesHeader."GST Customer Type" <> SalesHeader."GST Customer Type"::"SEZ Unit") or
      (not SalesHeader."GST Without Payment of Duty") then begin
                    Rec.Validate("SGST Percentage", SGSTPercentage(SalesHeader, Rec));
                    Rec.Validate("CGST Percentage", CGSTPercentage(SalesHeader, Rec));
                    Rec.Validate("IGST Percentage", IGSTPercentage(SalesHeader, Rec));
                end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnAfterValidateEvent, "GST Group Code", true, true)]
    local procedure OnAfterValidateEventGSTGroupCode(var Rec: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
    begin
        if not Rec.FOC then begin
            if SalesHeader.Get(Rec."Document Type", Rec."Document No.") then begin
                if (SalesHeader."GST Customer Type" <> SalesHeader."GST Customer Type"::"SEZ Unit") or
   (not SalesHeader."GST Without Payment of Duty") then begin
                    Rec.Validate("SGST Percentage", SGSTPercentage(SalesHeader, Rec));
                    Rec.Validate("CGST Percentage", CGSTPercentage(SalesHeader, Rec));
                    Rec.Validate("IGST Percentage", IGSTPercentage(SalesHeader, Rec));
                end;
            end;
        end;
    end;


    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnAfterValidateEvent, "HSN/SAC Code", true, true)]
    local procedure OnAfterValidateEventHSNCode(var Rec: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
    begin
        if not Rec.FOC then begin
            if SalesHeader.Get(Rec."Document Type", Rec."Document No.") then begin
                if (SalesHeader."GST Customer Type" <> SalesHeader."GST Customer Type"::"SEZ Unit") or
    (not SalesHeader."GST Without Payment of Duty") then begin
                    Rec.Validate("SGST Percentage", SGSTPercentage(SalesHeader, Rec));
                    Rec.Validate("CGST Percentage", CGSTPercentage(SalesHeader, Rec));
                    Rec.Validate("IGST Percentage", IGSTPercentage(SalesHeader, Rec));
                end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnAfterValidateEvent, 'Line Amount', true, true)]
    local procedure OnAfterValidateEventLineAmt(var Rec: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
    begin
        if not Rec.FOC then begin
            if SalesHeader.Get(Rec."Document Type", Rec."Document No.") then begin
                if (SalesHeader."GST Customer Type" <> SalesHeader."GST Customer Type"::"SEZ Unit") or
  (not SalesHeader."GST Without Payment of Duty") then begin
                    Rec.Validate("SGST Percentage", SGSTPercentage(SalesHeader, Rec));
                    Rec.Validate("CGST Percentage", CGSTPercentage(SalesHeader, Rec));
                    Rec.Validate("IGST Percentage", IGSTPercentage(SalesHeader, Rec));
                end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnAfterValidateEvent, 'Line Discount %', true, true)]
    local procedure OnAfterValidateEventLineDiscountPerc(var Rec: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
    begin
        if not Rec.FOC then begin
            if SalesHeader.Get(Rec."Document Type", Rec."Document No.") then begin
                if (SalesHeader."GST Customer Type" <> SalesHeader."GST Customer Type"::"SEZ Unit") or
  (not SalesHeader."GST Without Payment of Duty") then begin
                    Rec.Validate("SGST Percentage", SGSTPercentage(SalesHeader, Rec));
                    Rec.Validate("CGST Percentage", CGSTPercentage(SalesHeader, Rec));
                    Rec.Validate("IGST Percentage", IGSTPercentage(SalesHeader, Rec));
                end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnAfterValidateEvent, FOC, true, true)]
    local procedure OnAfterValidateEventFOC(var Rec: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
    begin
        if not Rec.FOC then begin
            if SalesHeader.Get(Rec."Document Type", Rec."Document No.") then begin
                if (SalesHeader."GST Customer Type" <> SalesHeader."GST Customer Type"::"SEZ Unit") or
   (not SalesHeader."GST Without Payment of Duty") then begin
                    Rec.Validate("SGST Percentage", SGSTPercentage(SalesHeader, Rec));
                    Rec.Validate("CGST Percentage", CGSTPercentage(SalesHeader, Rec));
                    Rec.Validate("IGST Percentage", IGSTPercentage(SalesHeader, Rec));
                end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnAfterUpdateAmountsDone, '', true, true)]
    local procedure OnAfterInsertSalesLine(var SalesLine: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
    begin
        if not SalesLine.FOC then begin
            if SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.") then begin
                if (SalesHeader."GST Customer Type" <> SalesHeader."GST Customer Type"::"SEZ Unit") or
 (not SalesHeader."GST Without Payment of Duty") then begin
                    SalesLine.Validate("SGST Percentage", SGSTPercentage(SalesHeader, SalesLine));
                    SalesLine.Validate("CGST Percentage", CGSTPercentage(SalesHeader, SalesLine));
                    SalesLine.Validate("IGST Percentage", IGSTPercentage(SalesHeader, SalesLine));
                end;
            end;
        end;
    end;



    procedure SGSTPercentage(Var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"): Decimal
    var
        GSTRate: Record "Gst Rate Percentage";
    begin
        GSTRate.Reset();
        GSTRate.SetRange("From State", SalesHeader."GST Bill-to State Code");
        GSTRate.SetRange("Location State Code", SalesHeader."Location State Code");
        GSTRate.SetRange("GST Group Code", SalesLine."GST Group Code");
        //GSTRate.SetRange("HSN/SAC", SalesLine."HSN/SAC Code");
        GSTRate.SetFilter("SGST Percentage", '<>%1', 0);
        if GSTRate.FindFirst() then
            exit(GSTRate."SGST Percentage");
    end;

    procedure CGSTPercentage(Var SalesHeader: Record "Sales Header"; Var SalesLine: Record "Sales Line"): Decimal
    var
        GSTRate: Record "Gst Rate Percentage";
    begin
        GSTRate.Reset();
        GSTRate.SetRange("From State", SalesHeader."GST Bill-to State Code");
        GSTRate.SetRange("Location State Code", SalesHeader."Location State Code");
        GSTRate.SetRange("GST Group Code", SalesLine."GST Group Code");
        //GSTRate.SetRange("HSN/SAC", SalesLine."HSN/SAC Code");
        GSTRate.SetFilter("CGST Percentage", '<>%1', 0);
        if GSTRate.FindFirst() then
            exit(GSTRate."CGST Percentage");
    end;

    procedure IGSTPercentage(Var SalesHeader: Record "Sales Header"; Var SalesLine: Record "Sales Line"): Decimal
    var
        GSTRate: Record "Gst Rate Percentage";
    begin
        GSTRate.Reset();
        GSTRate.SetRange("From State", SalesHeader."GST Bill-to State Code");
        GSTRate.SetRange("Location State Code", SalesHeader."Location State Code");
        GSTRate.SetRange("GST Group Code", SalesLine."GST Group Code");
        //GSTRate.SetRange("HSN/SAC", SalesLine."HSN/SAC Code");
        GSTRate.SetFilter("IGST Percentage", '<>%1', 0);
        if GSTRate.FindFirst() then
            exit(GSTRate."IGST Percentage");
    end;



    //TBC-1044 --->
    [EventSubscriber(ObjectType::Page, Page::"Sales Order", OnAfterValidateEvent, "GST Without Payment of Duty", false, false)]
    local procedure OnAfterValidateGSTWithoutPaymentonSalesOrder(var Rec: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.SetRange("Document Type", Rec."Document Type");
        SalesLine.SetRange("Document No.", Rec."No.");
        if SalesLine.FindSet(true) then
            repeat
                if not Rec."GST Without Payment of Duty" then begin
                    if Rec."GST Customer Type" = Rec."GST Customer Type"::"SEZ Unit" then begin
                        SalesLine.Validate("SGST Percentage", 0);
                        SalesLine.Validate("CGST Percentage", 0);
                        SalesLine.Validate("IGST Percentage", SEZCustomerIGSTPercentage(Rec, SalesLine));
                    end else begin
                        SalesLine.Validate("SGST Percentage", SGSTPercentage(Rec, SalesLine));
                        SalesLine.Validate("CGST Percentage", CGSTPercentage(Rec, SalesLine));
                        SalesLine.Validate("IGST Percentage", IGSTPercentage(Rec, SalesLine));
                    end;
                end else begin
                    SalesLine.Validate("SGST Percentage", 0);
                    SalesLine.Validate("CGST Percentage", 0);
                    SalesLine.Validate("IGST Percentage", 0);
                end;
                SalesLine.Modify(true);
            until SalesLine.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Invoice", OnAfterValidateEvent, 'GST Without Payment of Duty', false, false)]
    local procedure OnAfterValidateGSTWithoutPaymentOnSalesInvoice(var Rec: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.SetRange("Document Type", Rec."Document Type");
        SalesLine.SetRange("Document No.", Rec."No.");
        if SalesLine.FindSet(true) then
            repeat
                if not Rec."GST Without Payment of Duty" then begin
                    if Rec."GST Customer Type" = Rec."GST Customer Type"::"SEZ Unit" then begin
                        SalesLine.Validate("SGST Percentage", 0);
                        SalesLine.Validate("CGST Percentage", 0);
                        SalesLine.Validate("IGST Percentage", SEZCustomerIGSTPercentage(Rec, SalesLine));
                    end else begin
                        SalesLine.Validate("SGST Percentage", SGSTPercentage(Rec, SalesLine));
                        SalesLine.Validate("CGST Percentage", CGSTPercentage(Rec, SalesLine));
                        SalesLine.Validate("IGST Percentage", IGSTPercentage(Rec, SalesLine));
                    end;
                end else begin
                    SalesLine.Validate("SGST Percentage", 0);
                    SalesLine.Validate("CGST Percentage", 0);
                    SalesLine.Validate("IGST Percentage", 0);
                end;
                SalesLine.Modify(true);
            until SalesLine.Next() = 0;
    end;


    procedure SEZCustomerIGSTPercentage(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"): Decimal
    var
        GSTRate: Record "Gst Rate Percentage";
    begin
        GSTRate.Reset();
        GSTRate.SetRange("From State", SalesHeader."GST Bill-to State Code");
        GSTRate.SetRange("Location State Code", SalesHeader."Location State Code");
        GSTRate.SetRange("GST Group Code", SalesLine."GST Group Code");
        if GSTRate.FindFirst() then
            exit(GSTRate."CGST Percentage" + GSTRate."SGST Percentage" + GSTRate."IGST Percentage");

    end;
    //TBC-1044 <---

}

