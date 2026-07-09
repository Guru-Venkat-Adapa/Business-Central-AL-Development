codeunit 50002 OrderProcessing
{
    Permissions = tabledata "Purch. Rcpt. Line" = RIMD,
    tabledata "Sales Shipment Line" = RIMD,
    tabledata "Transfer Shipment Header" = RIMD, //TBC-506
    tabledata "Transfer Receipt Header" = RIMD,
    tabledata "Detailed Cust. Ledg. Entry" = RIMD,//TBC-947
      tabledata "G/L Entry" = RIMD, //TBC-1010
    tabledata "Cust. Ledger Entry" = RIMD, //TBC-1010
        tabledata "Sales Cr.Memo Header" = RIMD;//TBC-1072

    //NavSoft_HG 24/04/2025 Sales Order Description(Sales Order Type) flow on Sales Order -------->
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterInitRecord', '', false, false)]
    local procedure OnAfterValidateEventSalesHeaderNo(var SalesHeader: Record "Sales Header")
    var
        NoSeries: Record "No. Series";
        SalesNoSeries: Record "No Series for Sales";
        OrderType: Record "Sales Order Type";
    begin
        if SalesHeader."Sales Order Type" = '' then begin
            IF NoSeries.Get(SalesHeader."No. Series") then
                SalesHeader."Sales Order Type" := NoSeries.Description;

            if SalesHeader."Sales Order Type" = 'INSTRUMENT' then
                SalesHeader."Instrument Order" := true
            else
                if SalesHeader."Sales Order Type" = 'SPARES' then
                    SalesHeader."Spare Order" := true;

            // Update Posting No. Series and SHipping No Series. base on Sales Order Type
            if SalesNoSeries.Get(SalesHeader."Sales Order Type") then begin
                SalesHeader.Validate("Posting No. Series", SalesNoSeries."Posting No. Series");
                SalesHeader.Validate("Shipping No. Series", SalesNoSeries."Shipping No. Series");
            end;
        end;
    end;
    //NavSoft_HG 24/04/2025 Sales Order Description(Sales Order Type) flow on Sales Order <--------



    [EventSubscriber(ObjectType::Page, Page::"Customer Card", OnQueryClosePageEvent, '', true, true)]
    local procedure OnQueryClosePageEventCustomerCard(var Rec: Record Customer)
    var
        MissingFields: Text;
    begin
        if Rec."Is MSME" then begin
            MissingFields := '';
            if Rec."MSME No" = '' then
                MissingFields += 'MSME No., ';
            if Rec."MSME Validity Date" = 0D then
                MissingFields += 'MSME Validity Date, ';
            if Rec."Type of Enterprises" = Rec."Type of Enterprises"::" " then
                MissingFields += 'Type of Enterprises, ';
            if MissingFields <> '' then begin
                MissingFields := DelStr(MissingFields, StrLen(MissingFields) - 1, 2);
                Error('%1 cannot be empty as IS MSME is true.', MissingFields);
            end;
        end;
    end;


    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnAfterCopySellToCustomerAddressFieldsFromCustomer, '', true, true)]
    local procedure OnAfterCopySellToCustomerAddressFieldsFromCustomer(SellToCustomer: Record Customer; var SalesHeader: Record "Sales Header")
    var

    begin
        if SalesHeader."Sales Order Type" = 'SPARES' then begin
            If SellToCustomer."KEY/NON KEY(Restek)" <> SellToCustomer."KEY/NON KEY(Restek)"::" " then
                SalesHeader."Key/Non-Key" := SellToCustomer."KEY/NON KEY(Restek)"
            else
                if SellToCustomer."KEY/NON KEY(Schimatzu)" <> SellToCustomer."KEY/NON KEY(Schimatzu)"::" " then
                    SalesHeader."Key/Non-Key" := SellToCustomer."KEY/NON KEY(Schimatzu)";

            SalesHeader."KEY/NON KEY(Principal Wise)" := SellToCustomer."KEY/NON KEY(Principal Wise)";
        end;
        SalesHeader."Ship-to GST Reg. No." := SellToCustomer."State Code";
        SalesHeader."GST Bill-to State Code" := SellToCustomer."State Code";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnAfterValidateEvent, 'Sell-to Customer No.', true, true)]
    local procedure OnAfterValidateEventCustomerNo(var Rec: Record "Sales Header")
    var
        SalesNoSeries: Record "No Series for Sales";
        SellToCustomer: Record Customer;
    begin
        // Update Posting No. Series and SHipping No Series. base on Sales Order Type
        if Rec."Sales Order Type" = '' then
            if SalesNoSeries.Get(Rec."Sales Order Type") then begin
                Rec.Validate("Posting No. Series", SalesNoSeries."Posting No. Series");
                Rec.Validate("Shipping No. Series", SalesNoSeries."Shipping No. Series");
            end;

        //TBC-1044 --->
        if SellToCustomer.Get(Rec."Sell-to Customer No.") then
            if SellToCustomer."GST Customer Type" = SellToCustomer."GST Customer Type"::"SEZ Unit" then
                Rec."GST Without Payment of Duty" := true
            else
                Rec."GST Without Payment of Duty" := false;
        //TBC-1044 <---
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnAfterCopyFromItem, '', true, true)]
    local procedure OnAfterCopyFromItem(Item: Record Item; var SalesLine: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
        GSTRate: Record "Gst Rate Percentage";
    begin
        SalesLine.Principal := Item.Principal;
        SalesLine."Item Category Code" := Item."Item Category Code";
        SalesLine."Reordering Policy" := Item."Reordering Policy";
        SalesLine."Lead Time Calculation" := Item."Lead Time Calculation";
        SalesLine."MOQ Quantity" := Item."Reorder Quantity";
    end;

    // //HG 17 June 2025 Remove status validation on Purchasig Code in Sales Line +++++
    // [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnBeforeTestStatusOpen, '', true, true)]
    // local procedure OnBeforeTestStatusOpen(var IsHandled: Boolean; var SalesLine: Record "Sales Line"; var SalesHeader: Record "Sales Header")
    // begin
    //     if SalesHeader.Status <> SalesHeader.Status::Open then
    //         IsHandled := true;
    // end;
    // //HG 17 June 2025 Remove status validation on Purchasig Code in Sales Line +++++

    [EventSubscriber(ObjectType::Table, Database::Employee, OnAfterValidateEvent, "Company E-Mail", true, true)]
    local procedure OnAfterValidateEventCompanyEmail(var Rec: Record Employee)
    begin
        Rec."User ID" := Rec."Company E-Mail";
    end;

    [EventSubscriber(ObjectType::Page, Page::"No. Series", OnAfterValidateEvent, 'Description', true, true)]
    local procedure OnAfterValidateEventCode(var Rec: Record "No. Series")
    var
        SalesOrderType: Record "Sales Order Type";
    begin
        if SalesOrderType.Get(Rec.Code) then begin
            SalesOrderType."Sales Order Type" := Rec.Description;
            SalesOrderType.Modify(false);
        end;
    end;

    procedure POSGSTPercentage(Var PurchaseHeader: Record "Purchase Header"; var PurchaseLine: Record "Purchase Line"): Decimal
    var
        GSTRate: Record "Gst Rate Percentage";
    begin
        GSTRate.Reset();
        GSTRate.SetRange("From State", PurchaseHeader.State);
        GSTRate.SetRange("Location State Code", PurchaseHeader."Location State Code");
        GSTRate.SetRange("GST Group Code", PurchaseLine."GST Group Code");
        //GSTRate.SetRange("HSN/SAC", PurchaseLine."HSN/SAC Code");
        GSTRate.SetFilter("SGST Percentage", '<>%1', 0);
        if GSTRate.FindFirst() then
            exit(GSTRate."SGST Percentage");
    end;

    procedure POCGSTPercentage(Var PurchaseHeader: Record "Purchase Header"; var PurchaseLine: Record "Purchase Line"): Decimal
    var
        GSTRate: Record "Gst Rate Percentage";
    begin
        GSTRate.Reset();
        GSTRate.SetRange("From State", PurchaseHeader.State);
        GSTRate.SetRange("Location State Code", PurchaseHeader."Location State Code");
        GSTRate.SetRange("GST Group Code", PurchaseLine."GST Group Code");
        //GSTRate.SetRange("HSN/SAC", PurchaseLine."HSN/SAC Code");
        GSTRate.SetFilter("CGST Percentage", '<>%1', 0);
        if GSTRate.FindFirst() then
            exit(GSTRate."CGST Percentage");
    end;

    procedure POIGSTPercentage(Var PurchaseHeader: Record "Purchase Header"; var PurchaseLine: Record "Purchase Line"): Decimal
    var
        GSTRate: Record "Gst Rate Percentage";
    begin
        GSTRate.Reset();
        GSTRate.SetRange("From State", PurchaseHeader.State);
        GSTRate.SetRange("Location State Code", PurchaseHeader."Location State Code");
        GSTRate.SetRange("GST Group Code", PurchaseLine."GST Group Code");
        //GSTRate.SetRange("HSN/SAC", PurchaseLine."HSN/SAC Code");
        GSTRate.SetFilter("IGST Percentage", '<>%1', 0);
        if GSTRate.FindFirst() then
            exit(GSTRate."IGST Percentage");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", OnAfterValidateEvent, Quantity, true, true)]
    local procedure OnAfterValidateEventTQuantity(var Rec: Record "Purchase Line")
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        if PurchaseHeader.Get(Rec."Document Type", Rec."Document No.") then begin
            Rec.Validate("SGST Percentage", POSGSTPercentage(PurchaseHeader, Rec));
            Rec.Validate("CGST Percentage", POCGSTPercentage(PurchaseHeader, Rec));
            Rec.Validate("IGST Percentage", POIGSTPercentage(PurchaseHeader, Rec));
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", OnAfterValidateEvent, "Direct Unit Cost", true, true)]
    local procedure OnAfterValidateEventTUnitPrice(var Rec: Record "Purchase Line")
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        if PurchaseHeader.Get(Rec."Document Type", Rec."Document No.") then begin
            Rec.Validate("SGST Percentage", POSGSTPercentage(PurchaseHeader, Rec));
            Rec.Validate("CGST Percentage", POCGSTPercentage(PurchaseHeader, Rec));
            Rec.Validate("IGST Percentage", POIGSTPercentage(PurchaseHeader, Rec));
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", OnAfterValidateEvent, "GST Group Code", true, true)]
    local procedure OnAfterValidateEventGSTGroupCode(var Rec: Record "Purchase Line")
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        if PurchaseHeader.Get(Rec."Document Type", Rec."Document No.") then begin
            Rec.Validate("SGST Percentage", POSGSTPercentage(PurchaseHeader, Rec));
            Rec.Validate("CGST Percentage", POCGSTPercentage(PurchaseHeader, Rec));
            Rec.Validate("IGST Percentage", POIGSTPercentage(PurchaseHeader, Rec));
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", OnAfterValidateEvent, "HSN/SAC Code", true, true)]
    local procedure OnAfterValidateEventHSNCode(var Rec: Record "Purchase Line")
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        if PurchaseHeader.Get(Rec."Document Type", Rec."Document No.") then begin
            Rec.Validate("SGST Percentage", POSGSTPercentage(PurchaseHeader, Rec));
            Rec.Validate("CGST Percentage", POCGSTPercentage(PurchaseHeader, Rec));
            Rec.Validate("IGST Percentage", POIGSTPercentage(PurchaseHeader, Rec));
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", OnAfterValidateEvent, 'Line Amount', true, true)]
    local procedure OnAfterValidateEventLineAmt(var Rec: Record "Purchase Line")
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        if PurchaseHeader.Get(Rec."Document Type", Rec."Document No.") then begin
            Rec.Validate("SGST Percentage", POSGSTPercentage(PurchaseHeader, Rec));
            Rec.Validate("CGST Percentage", POCGSTPercentage(PurchaseHeader, Rec));
            Rec.Validate("IGST Percentage", POIGSTPercentage(PurchaseHeader, Rec));
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", OnAfterValidateEvent, 'Line Discount %', true, true)]
    local procedure OnAfterValidateEventLineDiscountPerc(var Rec: Record "Purchase Line")
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        if PurchaseHeader.Get(Rec."Document Type", Rec."Document No.") then begin
            Rec.Validate("SGST Percentage", POSGSTPercentage(PurchaseHeader, Rec));
            Rec.Validate("CGST Percentage", POCGSTPercentage(PurchaseHeader, Rec));
            Rec.Validate("IGST Percentage", POIGSTPercentage(PurchaseHeader, Rec));
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", OnAfterValidateEvent, "Location Code", true, true)]
    local procedure OnAfterValidateEventLineLocation(var Rec: Record "Purchase Line")
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        if PurchaseHeader.Get(Rec."Document Type", Rec."Document No.") then begin
            Rec.Validate("SGST Percentage", POSGSTPercentage(PurchaseHeader, Rec));
            Rec.Validate("CGST Percentage", POCGSTPercentage(PurchaseHeader, Rec));
            Rec.Validate("IGST Percentage", POIGSTPercentage(PurchaseHeader, Rec));
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPostPurchLine', '', false, false)]
    local procedure OnAfterPostPurchLine(var PurchaseHeader: Record "Purchase Header"; var PurchaseLine: Record "Purchase Line")
    var
        PostedWhseReceiptLine: Record "Posted Whse. Receipt Line";
        PurchRcptLine: Record "Purch. Rcpt. Line";
    begin
        // Update Purchase Line
        PostedWhseReceiptLine.SetRange("Source No.", PurchaseLine."Document No.");
        PostedWhseReceiptLine.SetRange("Source Line No.", PurchaseLine."Line No.");
        if PostedWhseReceiptLine.FindFirst() then begin
            PurchaseLine."Posted Warehouse Rec No" := PostedWhseReceiptLine."No.";
            PurchaseLine.Modify(false);
        end;
        // <-----------------                          Update Purch. Rcpt Line             ---------------------------------->
        if PostedWhseReceiptLine.FindFirst() then begin
            PurchRcptLine.SetRange("Order No.", PurchaseLine."Document No.");
            if PurchRcptLine.FindSet() then
                repeat
                    PurchRcptLine.Validate("Posted Warehouse Rec No", PostedWhseReceiptLine."No.");
                    PurchRcptLine.Modify(false);
                until PurchRcptLine.Next() = 0;
        end;
    end;
    // <-----------------                          Assigning Number Series for Purchase while coming through Requsition Worksheet             ---------------------------------->
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Req. Wksh.-Make Order", 'OnBeforePurchOrderHeaderInsert', '', false, false)]
    // local procedure OnBeforePurchOrderHeaderInsertPO(
    //  RequisitionLine: Record "Requisition Line";
    //  var PurchaseHeader: Record "Purchase Header";
    //  var OrderDateReq: Date;
    //  var PostingDateReq: Date;
    //  var ReceiveDateReq: Date;
    //  var ReferenceReq: Text[35])
    // var
    //     Vendor: Record Vendor;
    //     Item: Record Item;
    //     PurchSetup: Record "Purchases & Payables Setup";
    //     // NoSeriesMgt: Codeunit NoSeriesManagement;
    //     NoSeriesMgt: Codeunit "No. Series";
    //     NoSeriesCode: Code[20];
    //     NoSeries: Record "No. Series";
    // begin
    //     NoSeriesCode := '';
    //     if not Item.Get(RequisitionLine."No.") then
    //         exit;
    //     if not Vendor.Get(RequisitionLine."Vendor No.") then
    //         exit;
    //     // Determine number series based on Item Category and Vendor GBPG
    //     if (Item."Item Category Code" = 'SPARE') and (Vendor."Gen. Bus. Posting Group" = 'DOMESTIC') then
    //         NoSeriesCode := 'DOM PURC ORD SPA'
    //     else
    //         if (Item."Item Category Code" = 'SPARE') and (Vendor."Gen. Bus. Posting Group" = 'IMPORT') then
    //             NoSeriesCode := 'IMPORT PURCHASE ORDE'
    //         else
    //             if (Item."Item Category Code" = 'INSTRUMENT') and (Vendor."Gen. Bus. Posting Group" = 'DOMESTIC') then
    //                 NoSeriesCode := 'DOMESTIC PURCHASE OR'
    //             else
    //                 if (Item."Item Category Code" = 'INSTRUMENT') and (Vendor."Gen. Bus. Posting Group" = 'IMPORT') then
    //                     NoSeriesCode := 'IMPORT PURCHASE SALE';

    //     // Use default PO No. Series if none matched
    //     if NoSeriesCode = '' then
    //         if PurchSetup.Get() then
    //             NoSeriesCode := PurchSetup."Order Nos.";

    //     // Assign next number using NoSeriesManagement
    //     if NoSeriesCode <> '' then
    //         PurchaseHeader."No." := NoSeriesMgt.GetNextNo(NoSeriesCode, Today(), true);
    //     IF NoSeries.Get(NoSeriesCode) then
    //         PurchaseHeader."Purchase Order Type" := NoSeries.Description;
    // end;
    // <-----------------                          Updating Posting Number Series and Shipping Number Series             ---------------------------------->


    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterInitRecord', '', false, false)]
    local procedure OnAfterValidateEventPurchaseHeaderNo(var PurchHeader: Record "Purchase Header")
    var
        NoSeries: Record "No. Series";
        SalesNoSeries: Record "No Series for Sales";
        OrderType: Record "Sales Order Type";
    begin
        IF NoSeries.Get(PurchHeader."No. Series") then
            PurchHeader."Purchase Order Type" := NoSeries.Description;
    end;

    // If Instrumnet Sales Order Type Workflow rejetc then update workflow status in Sales Header and Instrumnet Sales Header Staging Table  >>>>
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnAfterRejectSelectedApprovalRequest', '', true, true)]
    // local procedure OnAfterRejectSelectedApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    // var
    //     SalesHeader: Record "Sales Header";
    // begin
    //     if ApprovalEntry.Status = ApprovalEntry.Status::Rejected then begin
    //         SalesHeader.Reset();
    //         SalesHeader.SetRange("No.", ApprovalEntry."Document No.");
    //         SalesHeader.SetRange("Instrument Order", true);
    //         SalesHeader.SetFilter("Workflow Status", '=%1', '');
    //         if SalesHeader.FindFirst() then begin
    //             SalesHeader.Validate("Workflow Status", 'Rejected');
    //             SalesHeader.Modify(false);
    //         end;
    //     end;
    // end;
    // If Instrumnet Sales Order Type Workflow rejetc then update workflow status in Sales Header and Instrumnet Sales Header Staging Table  <<<<<

    // If Instrumnet Sales Order Type Workflow Approved then update workflow status in Sales Header and Instrumnet Sales Header Staging Table  >>>>
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnApproveApprovalRequest', '', true, true)]
    // local procedure OnApproveApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    // var
    //     SalesHeader: Record "Sales Header";
    //     Co: Page Companies;
    // begin
    //     if ApprovalEntry.Status = ApprovalEntry.Status::Approved then begin
    //         SalesHeader.Reset();
    //         SalesHeader.SetRange("No.", ApprovalEntry."Document No.");
    //         SalesHeader.SetRange("Instrument Order", true);
    //         SalesHeader.SetFilter("Workflow Status", '=%1', '');
    //         if SalesHeader.FindFirst() then begin
    //             SalesHeader.Validate("Workflow Status", 'Approved');
    //             SalesHeader.Modify(false);
    //         end;
    //     end;
    // end;
    // If Instrumnet Sales Order Type Workflow Approved then update workflow status in Sales Header and Instrumnet Sales Header Staging Table  >>>>>


    // Once Gen. Journal Approved from Approver then update status in Expense Voucher Table ------>
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnApproveApprovalRequest', '', false, false)]
    // local procedure OnApproveApprovalRequestVoucher(var ApprovalEntry: Record "Approval Entry")
    // var
    //     GenJournalLine: Record "Gen. Journal Line";
    //     VoucherHeader: Record "Expense Voucher Header"; // your custom
    //     TemplateName: Code[10];
    //     BatchName: Code[10];
    //     FullText: Text;
    //     AfterColon: Text;
    //     CommaPos: Integer;
    //     VoucherLine: Record "Expense Voucher Line";
    // begin
    //     ClearAll();
    //     if ApprovalEntry.Status = ApprovalEntry.Status::Approved then begin
    //         FullText := Format(ApprovalEntry."Record ID to Approve");
    //         if FullText = 'OnApproveApprovalRequest' then begin
    //             if StrPos(FullText, ':') > 0 then begin
    //                 AfterColon := DelStr(FullText, 1, StrPos(FullText, ':'));
    //                 AfterColon := DelChr(AfterColon, '<>', ' '); // ✅ Trims edges, not inner spaces

    //                 CommaPos := StrPos(AfterColon, ',');

    //                 if CommaPos > 0 then begin
    //                     TemplateName := DelChr(CopyStr(AfterColon, 1, CommaPos - 1), '<>', ' ');
    //                     BatchName := DelChr(CopyStr(AfterColon, CommaPos + 1), '<>', ' ');

    //                     // Truncate to field length if needed
    //                     if StrLen(TemplateName) > 10 then
    //                         TemplateName := CopyStr(TemplateName, 1, 10);
    //                     if StrLen(BatchName) > 10 then
    //                         BatchName := CopyStr(BatchName, 1, 10);
    //                 end else begin
    //                     TemplateName := CopyStr(AfterColon, 1, 10);
    //                     BatchName := '';
    //                 end;
    //             end else begin
    //                 TemplateName := '';
    //                 BatchName := '';
    //             end;

    //             GenJournalLine.SetRange("Journal Template Name", TemplateName);
    //             GenJournalLine.SetRange("Journal Batch Name", BatchName);
    //             GenJournalLine.SetRange(SystemCreatedBy, ApprovalEntry.SystemCreatedBy);
    //             if GenJournalLine.FindSet() then
    //                 repeat
    //                     VoucherHeader.Reset();
    //                     VoucherHeader.SetRange(Status, VoucherHeader.Status::"Pending Finance Approval");
    //                     VoucherHeader.SetRange("BC General Voucher No.", GenJournalLine."Document No.");
    //                     if VoucherHeader.FindFirst() then begin
    //                         VoucherHeader.Status := VoucherHeader.Status::"Finance Approved";
    //                         if VoucherHeader.Modify(false) then begin
    //                             VoucherLine.Reset();
    //                             VoucherLine.SetRange("Entry No.", VoucherHeader."Entry No.");
    //                             if VoucherLine.FindSet(true) then
    //                                 repeat
    //                                     VoucherLine.Status := 'Finance Approved';
    //                                     VoucherLine.Modify(false);
    //                                 until VoucherLine.Next() = 0;
    //                         end;
    //                     end;
    //                 until GenJournalLine.Next() = 0;
    //         end;
    //     end;
    // end;
    // Once Gen. Journal Approved from Approver then update status in Expense Voucher Table <------


    // Once Gen. Journal Rejected from Reject then update status in Expense Voucher Table ------>
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnRejectApprovalRequest', '', false, false)]
    // local procedure OnRejectApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    // var
    //     GenJournalLine: Record "Gen. Journal Line";
    //     VoucherHeader: Record "Expense Voucher Header"; // your custom
    //     TemplateName: Code[10];
    //     BatchName: Code[10];
    //     FullText: Text;
    //     AfterColon: Text;
    //     VoucherLine: Record "Expense Voucher Line";
    //     CommaPos: Integer;
    // begin
    //     ClearAll();
    //     if ApprovalEntry.Status = ApprovalEntry.Status::Open then begin
    //         FullText := Format(ApprovalEntry."Record ID to Approve");
    //         if FullText = 'Gen. Journal Batch: EMP TOUR,DEFAULT' then begin
    //             if StrPos(FullText, ':') > 0 then begin
    //                 AfterColon := DelStr(FullText, 1, StrPos(FullText, ':'));
    //                 AfterColon := DelChr(AfterColon, '<>', ' '); // ✅ Trims edges, not inner spaces

    //                 CommaPos := StrPos(AfterColon, ',');

    //                 if CommaPos > 0 then begin
    //                     TemplateName := DelChr(CopyStr(AfterColon, 1, CommaPos - 1), '<>', ' ');
    //                     BatchName := DelChr(CopyStr(AfterColon, CommaPos + 1), '<>', ' ');

    //                     // Truncate to field length if needed
    //                     if StrLen(TemplateName) > 10 then
    //                         TemplateName := CopyStr(TemplateName, 1, 10);
    //                     if StrLen(BatchName) > 10 then
    //                         BatchName := CopyStr(BatchName, 1, 10);
    //                 end else begin
    //                     TemplateName := CopyStr(AfterColon, 1, 10);
    //                     BatchName := '';
    //                 end;
    //             end else begin
    //                 TemplateName := '';
    //                 BatchName := '';
    //             end;

    //             GenJournalLine.SetRange("Journal Template Name", TemplateName);
    //             GenJournalLine.SetRange("Journal Batch Name", BatchName);
    //             GenJournalLine.SetRange(SystemCreatedBy, ApprovalEntry.SystemCreatedBy);
    //             if GenJournalLine.FindSet() then
    //                 repeat
    //                     VoucherHeader.Reset();
    //                     VoucherHeader.SetRange(Status, VoucherHeader.Status::"Pending Finance Approval");
    //                     VoucherHeader.SetRange("BC General Voucher No.", GenJournalLine."Document No.");
    //                     if VoucherHeader.FindFirst() then begin
    //                         VoucherHeader.Status := VoucherHeader.Status::"Finance Rejected";
    //                         if VoucherHeader.Modify(false) then begin
    //                             VoucherLine.Reset();
    //                             VoucherLine.SetRange("Entry No.", VoucherHeader."Entry No.");
    //                             if VoucherLine.FindSet(true) then
    //                                 repeat
    //                                     VoucherLine.Status := 'Finance Rejected';
    //                                     VoucherLine.Modify(false);
    //                                 until VoucherLine.Next() = 0;
    //                         end
    //                     end;
    //                 until GenJournalLine.Next() = 0;
    //         end;
    //     end;
    // end;
    // Once Gen. Journal Rejected from Reject then update status in Expense Voucher Table <------



    //Custome Instrumnet/Spare/Service Report print from Poasted Sales Invoice Page --------------------->

    [EventSubscriber(ObjectType::Page, Page::"Posted Sales Invoice", 'OnBeforeSalesInvHeaderPrintRecords', '', true, true)]
    local procedure OnBeforeSalesInvHeaderPrintRecords(var SalesInvHeader: Record "Sales Invoice Header"; var IsHandled: Boolean)
    var
        InvSalesHeader: Record "Sales Invoice Header";
    begin
        if (SalesInvHeader."Instrument Order") OR (SalesInvHeader."Spare Order") then begin
            InvSalesHeader.Reset();
            InvSalesHeader.SetRange("No.", SalesInvHeader."No.");
            if InvSalesHeader.FindFirst() then begin
                Report.Run(Report::"Custom Posted Sales Invoice", true, true, InvSalesHeader);
                IsHandled := true; // stop the standard report
            end;
        end else //TBC-945  -->
            if SalesInvHeader."Sales Order Type" = 'SALES OF POWER' then begin
                InvSalesHeader.Reset();
                InvSalesHeader.SetRange("No.", SalesInvHeader."No.");
                if InvSalesHeader.FindFirst() then begin
                    Report.Run(Report::"Sales Invoice Sales Of Power", true, true, InvSalesHeader);
                    IsHandled := true;
                end;
                //TBC-945  <---
            end
            else
                if SalesInvHeader."Sales Order Type" = 'OTHERS' then begin
                    //Start of TBC-887
                    InvSalesHeader.Reset();
                    InvSalesHeader.SetRange("No.", SalesInvHeader."No.");
                    if InvSalesHeader.FindFirst() then begin
                        Report.Run(Report::"Posted Sales Invoice - Others", true, true, InvSalesHeader);
                        IsHandled := true;
                    end;
                    //End Of TCB-887
                end else
                    if not (SalesInvHeader."Instrument Order") OR (SalesInvHeader."Spare Order") then begin
                        InvSalesHeader.Reset();
                        InvSalesHeader.SetRange("No.", SalesInvHeader."No.");
                        if InvSalesHeader.FindFirst() then begin
                            Report.Run(Report::"Service Tax Invoice", true, true, InvSalesHeader);
                            IsHandled := true; // stop the standard report
                        end;
                    end;
    end;
    //Custome Instrumnet/Spare/Service Report print from Poasted Sales Invoice Page ---------------------<


    //Custome Instrumnet/Spare/Service Report print from Poasted Sales Shipment Page --------------------->
    [EventSubscriber(ObjectType::Table, DataBase::"Sales Shipment Header", OnBeforePrintRecords, '', true, true)]
    local procedure OnBeforeSalesShipmentHeaderPrintRecords(var SalesShipmentHeader: Record "Sales Shipment Header"; var IsHandled: Boolean)
    var
        SalesShipHeader: Record "Sales Shipment Header";
    begin
        if SalesShipmentHeader."Instrument Order" then begin
            SalesShipHeader.Reset();
            SalesShipHeader.SetRange("No.", SalesShipmentHeader."No.");
            if SalesShipHeader.FindFirst() then begin
                Report.Run(Report::"Instrument Deliver Challan", true, true, SalesShipHeader);
                IsHandled := true; // stop the standard report
            end;
        end else
            if SalesShipmentHeader."Spare Order" then begin
                SalesShipHeader.Reset();
                SalesShipHeader.SetRange("No.", SalesShipmentHeader."No.");
                if SalesShipHeader.FindFirst() then begin
                    Report.Run(Report::"Spare Delivery Challan", true, true, SalesShipHeader);
                    IsHandled := true; // stop the standard report
                end;
            end
            else if
            not (SalesShipmentHeader."Instrument Order") OR not (SalesShipmentHeader."Spare Order") then begin
                SalesShipHeader.Reset();
                SalesShipHeader.SetRange("No.", SalesShipmentHeader."No.");
                if SalesShipHeader.FindFirst() then begin
                    Report.Run(Report::"Service Deliver Challan", true, true, SalesShipHeader);
                    IsHandled := true; // stop the standard report
                end;
            end;
    end;
    //Custome Instrumnet/Spare/Service Report print from Poasted Sales Shipment Page ---------------------<


    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnAfterValidateEvent, 'Quantity', true, true)]
    local procedure OnAfterValidateEventQuantity(var Rec: Record "Sales Line")
    begin
        if (Rec.Quantity <> 0) and (Rec."Unit Price" <> 0) then
            Rec."Gross Value" := Rec.Quantity * Rec."Unit Price";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnAfterValidateEvent, 'Unit Price', true, true)]
    local procedure OnAfterValidateEventUnitPrice(var Rec: Record "Sales Line")
    begin
        if (Rec.Quantity <> 0) and (Rec."Unit Price" <> 0) then
            Rec."Gross Value" := Rec.Quantity * Rec."Unit Price";
    end;

    //Warehouse shipemnt page - Get Source Document (Action) - While creating warehouse shipment (DC), if type of Sales order is selected as Spares then in source data, list of only ending "Spares orders " must appear instead of all
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Get Source Doc. Outbound", 'OnBeforeGetSourceDocForHeader', '', true, true)]
    local procedure OnBeforeGetSourceDocForHeader(
    var WarehouseShipmentHeader: Record "Warehouse Shipment Header";
    var WarehouseRequest: Record "Warehouse Request";
    var IsHandled: Boolean)
    var
        SourceDocSelection: Page "Source Documents";
        DynamicSalesType: Text[50];
        GetSourceDocuments: Report "Get Source Documents";
    begin
        // // --- Mark as handled to skip standard logic ---
        // IsHandled := true;

        // // --- Apply standard filters ---
        // WarehouseRequest.SetRange(Type, WarehouseRequest.Type::Outbound);
        // WarehouseRequest.SetRange("Location Code", WarehouseShipmentHeader."Location Code");
        // WarehouseRequest.SetFilter("Source Document", '<>%1', WarehouseRequest."Source Document"::"Prod. Consumption");
        // WarehouseRequest.SetRange("Completely Handled", false);
        // WarehouseRequest.SetRange("Document Status", WarehouseRequest."Document Status"::Released);

        // --- Dynamic Sales Type filter ---
        // Convert Enum to Text for SETFILTER
        DynamicSalesType := FORMAT(WarehouseShipmentHeader."Sales Type");
        // if DynamicSalesType <> '' then
        WarehouseRequest.SETFILTER("Sales Type", '%1', DynamicSalesType);

        // --- Open Source Documents page in Lookup Mode ---
        // SourceDocSelection.LookupMode(true);
        // SourceDocSelection.SetTableView(WarehouseRequest);

        // if SourceDocSelection.RunModal() <> ACTION::LookupOK then
        //     exit;

        // // --- Get the selected result back ---
        // SourceDocSelection.GetResult(WarehouseRequest);

        // GetSourceDocuments.SetOneCreatedShptHeader(WarehouseShipmentHeader);
        // GetSourceDocuments.SetSkipBlocked(true);
        // GetSourceDocuments.UseRequestPage(false);
        // WarehouseRequest.SetRange("Location Code", WarehouseShipmentHeader."Location Code");
        // GetSourceDocuments.SetTableView(WarehouseRequest);
        // GetSourceDocuments.RunModal();
    end;
    //Warehouse shipemnt page - Get Source Document (Action) - While creating warehouse shipment (DC), if type of Sales order is selected as Spares then in source data, list of only ending "Spares orders " must appear instead of all

    [EventSubscriber(ObjectType::Page, Page::"Sales Order", OnQueryClosePageEvent, '', true, true)]
    local procedure OnQueryClosePageEvent(var Rec: Record "Sales Header")
    var
        MissingFields: Text;
    begin
        if Rec."Instrument Order" then begin
            MissingFields := '';
            if Rec."CRM Quote No." = '' then
                MissingFields += 'CRM No., ';
            if Rec."Business Sector" = '' then
                MissingFields += 'Business Sector, ';
            if Rec.Industry = '' then
                MissingFields += 'Industry, ';
            if Rec."Industry Sub-Segment" = '' then
                MissingFields += 'Industry Sub-Segment, ';
            if Rec.Application = '' then
                MissingFields += 'Application, ';
            if Rec."Appliaction Sub-Segment" = '' then
                MissingFields += 'Application Sub-Segment, ';
            if Rec."Dealer Customer" then
                if Rec."Dealer Customer Name" = '' then
                    MissingFields += 'Dealer Customer Name, ';

            if MissingFields <> '' then begin
                MissingFields := DelStr(MissingFields, StrLen(MissingFields) - 1, 2);
                Error('%1 cannot be empty ', MissingFields);
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Order", OnBeforeActionEvent, 'Post', true, true)]
    local procedure OnBeforeActionEventSalesOrder(var Rec: Record "Sales Header")
    var
        MissingFields: Text;
    begin
        IF Rec."No." <> '' THEN BEGIN
            if Rec."Shortcut Dimension 1 Code" = '' then
                Rec.TestField(Rec."Shortcut Dimension 1 Code");

            if Rec."Shortcut Dimension 2 Code" = '' then
                Rec.TestField(Rec."Shortcut Dimension 2 Code");

            if not Rec."Instrument Order" then
                Rec.TestField(Rec."Shortcut Dimension 3 Code");
        end;

        if Rec."Instrument Order" then begin
            MissingFields := '';
            if Rec."CRM Quote No." = '' then
                MissingFields += 'CRM No., ';
            if Rec."Business Sector" = '' then
                MissingFields += 'Business Sector, ';
            if Rec.Industry = '' then
                MissingFields += 'Industry, ';
            if Rec."Industry Sub-Segment" = '' then
                MissingFields += 'Industry Sub-Segment, ';
            if Rec.Application = '' then
                MissingFields += 'Application, ';
            if Rec."Appliaction Sub-Segment" = '' then
                MissingFields += 'Application Sub-Segment, ';
            if Rec."Dealer Customer" then
                if Rec."Dealer Customer Name" = '' then
                    MissingFields += 'Dealer Customer Name, ';

            if MissingFields <> '' then begin
                MissingFields := DelStr(MissingFields, StrLen(MissingFields) - 1, 2);
                Error('%1 cannot be empty ', MissingFields);
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"ORC Sales Order", OnQueryClosePageEvent, '', true, true)]
    local procedure OnQueryClosePageEventORCSalesOrder(var Rec: Record "Sales Header")
    var
        MissingFields: Text;
    begin
        if Rec."No." <> '' then begin
            MissingFields := '';
            if Rec."CRM Quote No." = '' then
                MissingFields += 'CRM No., ';
            if Rec."Business Sector" = '' then
                MissingFields += 'Business Sector, ';
            if Rec.Industry = '' then
                MissingFields += 'Industry, ';
            if Rec."Industry Sub-Segment" = '' then
                MissingFields += 'Industry Sub-Segment, ';
            if Rec.Application = '' then
                MissingFields += 'Application, ';
            if Rec."Appliaction Sub-Segment" = '' then
                MissingFields += 'Application Sub-Segment, ';
            if Rec."Dealer Customer" then
                if Rec."Dealer Customer Name" = '' then
                    MissingFields += 'Dealer Customer Name, ';

            if MissingFields <> '' then begin
                MissingFields := DelStr(MissingFields, StrLen(MissingFields) - 1, 2);
                Error('%1 cannot be empty ', MissingFields);
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"ORC Sales Order", OnBeforeActionEvent, 'Post', true, true)]
    local procedure OnBeforeActionEventPostORCSalesOrder(var Rec: Record "Sales Header")
    var
        MissingFields: Text;
    begin
        if Rec."No." <> '' then begin
            MissingFields := '';
            if Rec."CRM Quote No." = '' then
                MissingFields += 'CRM No., ';
            if Rec."Business Sector" = '' then
                MissingFields += 'Business Sector, ';
            if Rec.Industry = '' then
                MissingFields += 'Industry, ';
            if Rec."Industry Sub-Segment" = '' then
                MissingFields += 'Industry Sub-Segment, ';
            if Rec.Application = '' then
                MissingFields += 'Application, ';
            if Rec."Appliaction Sub-Segment" = '' then
                MissingFields += 'Application Sub-Segment, ';
            if Rec."Dealer Customer" then
                if Rec."Dealer Customer Name" = '' then
                    MissingFields += 'Dealer Customer Name, ';

            if MissingFields <> '' then begin
                MissingFields := DelStr(MissingFields, StrLen(MissingFields) - 1, 2);
                Error('%1 cannot be empty ', MissingFields);
            end;
        end;
    end;


    [EventSubscriber(ObjectType::Page, Page::"ORC Sales Order Subform", OnAfterValidateEvent, "No.", true, true)]
    local procedure OnAfterValidateEventORCSalesOrder(var Rec: Record "Sales Line")
    var
    begin
        if Rec.Type = Rec.Type::Item then
            if Rec."No." <> '' then begin
                Rec."Item by Toshvin" := true;
                Rec.Modify(False);
            end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"ORC Sales Order Subform", OnAfterValidateEvent, "Qty. to Ship", true, true)]
    local procedure OnAfterValidateEventQtytoShip(var Rec: Record "Sales Line")
    var
    begin
        if Rec."Item by Toshvin" then begin
            Rec."Qty. to Invoice" := 0;
            Rec.Modify(False);
        end else begin
            Rec."Qty. to Invoice" := Rec."Qty. to Ship";
            Rec.Modify(False);
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"ORC Sales Order Subform", OnAfterValidateEvent, Quantity, true, true)]
    local procedure OnAfterValidateEventORCSOQuantity(var Rec: Record "Sales Line")
    var
    begin
        if Rec."Item by Toshvin" then begin
            Rec."Qty. to Invoice" := 0;
            Rec.Modify(False);
        end else begin
            Rec."Qty. to Invoice" := Rec."Qty. to Ship";
            Rec.Modify(False);
        end;
    end;


    //Break Special Order Relation - Code for when Warehouse Receipt post partilly Suppose Two Item One Item Recevied fully and second item zero after posting Line Amount & Invoice Discount Amt blank update on Purchase Line ---->
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnBeforeDivideAmount, '', true, true)]
    local procedure OnBeforeDivideAmount(var PurchHeader: Record "Purchase Header"; var PurchLine: Record "Purchase Line"; var PurchLineQty: Decimal)
    var
        UpdatePurLine: Record "Purchase Line";
    begin
        if PurchHeader.Receive then
            PurchLineQty := PurchLine."Qty. to Receive";
    end;
    //Break Special Order Relation - Code for when Warehouse Receipt post partilly Suppose Two Item One Item Recevied fully and second item zero after posting Line Amount & Invoice Discount Amt blank update on Purchase Line <----


    [EventSubscriber(ObjectType::Page, Page::"Sales Order", OnModifyRecordEvent, '', true, true)]
    local procedure OnModifyRecordEventHeader(var AllowModify: Boolean; var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    begin
        if xRec.Status = xRec.Status::Released then
            if Rec.Status = Rec.Status::Released then
                Rec.TestStatusOpen();
    end;
    //ORC sales order page validating based on order status
    [EventSubscriber(ObjectType::Page, Page::"ORC Sales Order", OnModifyRecordEvent, '', true, true)]
    local procedure OnModifyRecordEventORCHeader(var AllowModify: Boolean; var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    begin
        if xRec.Status = xRec.Status::Released then
            if Rec.Status = Rec.Status::Released then
                Rec.TestStatusOpen();
    end;

    [EventSubscriber(ObjectType::Page, Page::"Purchase Order", OnModifyRecordEvent, '', true, true)]
    local procedure OnModifyRecordEventHeaderPO(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header")
    begin
        if xRec.Status = xRec.Status::Released then
            if Rec.Status = Rec.Status::Released then
                Rec.TestStatusOpen();
    end;



    [EventSubscriber(ObjectType::Table, Database::"Sales Shipment Line", OnAfterInitFromSalesLine, '', false, false)]
    local procedure OnAfterInitFromSalesLine(SalesLine: Record "Sales Line"; var SalesShptLine: Record "Sales Shipment Line")
    begin
        SalesShptLine."Special Order Purchase No." := SalesLine."Special Order Purchase No.";
        SalesShptLine."Special Order Purch. Line No." := SalesLine."Special Order Purch. Line No.";
        SalesShptLine.Remark := SalesLine.Remark; //TBC-823
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Invoice Line", OnAfterInitFromSalesLine, '', false, false)]
    local procedure OnAfterInitFromSalesLineSIL(SalesLine: Record "Sales Line"; var SalesInvLine: Record "Sales Invoice Line")
    begin
        SalesInvLine."Special Order Purchase No." := SalesLine."Special Order Purchase No.";
        SalesInvLine."Special Order Purch. Line No." := SalesLine."Special Order Purch. Line No.";
        SalesInvLine.Remark := SalesLine.Remark; //TBC-823
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterValidateEvent', 'Quantity', true, true)]
    local procedure QtyChanged(var Rec: Record "Purchase Line"; xRec: Record "Purchase Line")
    var
        TotalAmt: Decimal;
        PurchaseHeader: Record "Purchase Header";
    begin
        TotalAmt := GetTotalPOAmount(Rec, xRec);
        if TotalAmt = 0 then
            exit;
        if PurchaseHeader.Get(Rec."Document Type", Rec."Document No.") then
            if PurchaseHeader."Custom Freight Amount" <> 0 then
                Rec."Freight Amount" := (PurchaseHeader."Custom Freight Amount" / TotalAmt) * Rec."Line Amount";
        if PurchaseHeader."Custom Insurance Amount" <> 0 then
            Rec."Insurance Amount" := (PurchaseHeader."Custom Insurance Amount" / TotalAmt) * Rec."Line Amount";
        // Now TotalAmt contains: ALL previous lines + CURRENT updated line
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterValidateEvent', 'Direct Unit Cost', true, true)]
    local procedure CostChanged(var Rec: Record "Purchase Line"; xRec: Record "Purchase Line")
    var
        TotalAmt: Decimal;
        PurchaseHeader: Record "Purchase Header";

    begin
        TotalAmt := GetTotalPOAmount(Rec, xRec);
        if TotalAmt = 0 then
            exit;
        if PurchaseHeader.Get(Rec."Document Type", Rec."Document No.") then
            if PurchaseHeader."Custom Freight Amount" <> 0 then
                Rec."Freight Amount" := (PurchaseHeader."Custom Freight Amount" / TotalAmt) * Rec."Line Amount";
        if PurchaseHeader."Custom Insurance Amount" <> 0 then
            Rec."Insurance Amount" := (PurchaseHeader."Custom Insurance Amount" / TotalAmt) * Rec."Line Amount";

    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterValidateEvent', 'Line Amount', true, true)]
    local procedure LineAmountChanged(var Rec: Record "Purchase Line"; xRec: Record "Purchase Line")
    var
        TotalAmt: Decimal;
        PurchaseHeader: Record "Purchase Header";
    begin
        TotalAmt := GetTotalPOAmount(Rec, xRec);
        if TotalAmt = 0 then
            exit;
        if PurchaseHeader.Get(Rec."Document Type", Rec."Document No.") then
            if PurchaseHeader."Custom Freight Amount" <> 0 then
                Rec."Freight Amount" := (PurchaseHeader."Custom Freight Amount" / TotalAmt) * Rec."Line Amount";
        if PurchaseHeader."Custom Insurance Amount" <> 0 then
            Rec."Insurance Amount" := (PurchaseHeader."Custom Insurance Amount" / TotalAmt) * Rec."Line Amount";

    end;



    local procedure GetTotalPOAmount(var CurrLine: Record "Purchase Line"; xCurrLine: Record "Purchase Line"): Decimal
    var
        PL: Record "Purchase Line";
        TotalDB: Decimal;
    begin
        // 1. Sum all saved lines (previous lines)
        TotalDB := 0;
        PL.SetRange("Document Type", CurrLine."Document Type");
        PL.SetRange("Document No.", CurrLine."Document No.");
        if PL.FindSet() then
            repeat
                TotalDB += PL."Line Amount";
            until PL.Next() = 0;

        // 2. Replace old current line with new current line
        //    Old line amount = xCurrLine."Line Amount"
        //    New line amount = CurrLine."Line Amount"
        exit(TotalDB - xCurrLine."Line Amount" + CurrLine."Line Amount");
    end;


    // [EventSubscriber(ObjectType::Table, Database::"Purch. Rcpt. Line", 'OnInsertInvLineFromRcptLineOnBeforeSetDirectUnitCost', '', false, false)]
    // local procedure OnInsertInvLineFromRcptLineOnBeforeSetDirectUnitCost(PurchaseOrderLine: Record "Purchase Line"; var DirectUnitCost: Decimal; var PurchaseLine: Record "Purchase Line")
    // begin
    //     DirectUnitCost := PurchaseOrderLine."Direct Unit Cost";
    // end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnAfterRoundAmount, '', false, false)]
    local procedure OnAfterRoundAmount(var PurchaseLine: Record "Purchase Line"; PurchLineQty: Decimal; PurchaseHeader: Record "Purchase Header")
    var
        CurrExchRate: Record "Currency Exchange Rate";
        GSTRate: Record "Gst Rate Percentage";
        KlFloogPer: Decimal;
        CUstomDuty: Decimal;
    begin
        Clear(KlFloogPer);
        Clear(CUstomDuty);
        GSTRate.Reset();
        GSTRate.SetRange("From State", PurchaseHeader.State);
        GSTRate.SetRange("Location State Code", PurchaseHeader."Location State Code");
        GSTRate.SetRange("GST Group Code", PurchaseLine."GST Group Code");
        if GSTRate.FindFirst() then
            KlFloogPer := GSTRate."KFloodCess Percentage";

        CUstomDuty := PurchaseLine."Line Amount" * KlFloogPer / 100;

        PurchaseLine."IGST Amount" := (PurchaseLine."Line Amount" + CUstomDuty) * (PurchaseLine."IGST Percentage" / 100);
        PurchaseLine."Total GST Amount" := PurchaseLine."SGST Amount" + PurchaseLine."CGST Amount" + PurchaseLine."IGST Amount";
    end;

    [EventSubscriber(ObjectType::Table, DataBase::"Purch. Rcpt. Header", 'OnBeforePrintRecords', '', true, true)]
    local procedure OnBeforePrintRecords(var IsHandled: Boolean; var PurchRcptHeader: Record "Purch. Rcpt. Header")
    var
        PurchRcptHeaderRec: Record "Purch. Rcpt. Header";
    begin
        if PurchRcptHeader."Purchase Type" = PurchRcptHeader."Purchase Type"::Domestic then begin
            PurchRcptHeaderRec.Reset();
            PurchRcptHeaderRec.SetRange("No.", PurchRcptHeader."No.");
            if PurchRcptHeaderRec.FindFirst() then begin
                Report.RunModal(Report::"Domestic GRN", true, false, PurchRcptHeaderRec);
                IsHandled := true;
            end;
        end;
        if PurchRcptHeader."Purchase Type" = PurchRcptHeader."Purchase Type"::Import then begin
            PurchRcptHeaderRec.Reset();
            PurchRcptHeaderRec.SetRange("No.", PurchRcptHeader."No.");
            if PurchRcptHeaderRec.FindFirst() then begin
                Report.RunModal(Report::"Import Purchase Receipt", true, false, PurchRcptHeaderRec);
                IsHandled := true;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Invoice", OnBeforeActionEvent, 'Post', true, true)]
    local procedure SalesInvoiceOnBeforeActionEvent(var Rec: Record "Sales Header")
    var
        MissingFields: Text;
        Res: Record "Reservation Entry";
    begin
        IF Rec."No." <> '' THEN BEGIN
            if Rec."Shortcut Dimension 1 Code" = '' then
                Rec.TestField(Rec."Shortcut Dimension 1 Code");

            if Rec."Shortcut Dimension 2 Code" = '' then
                Rec.TestField(Rec."Shortcut Dimension 2 Code");

            if not Rec."Instrument Order" then
                Rec.TestField(Rec."Shortcut Dimension 3 Code");
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Get Shipment", OnAfterCreateInvLines, '', true, true)]
    local procedure OnAfterCreateInvLines(SalesShipmentHeader: Record "Sales Shipment Header"; var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; var SalesShipmentLine2: Record "Sales Shipment Line")
    var
        SalesCommentLine: Record "Sales Comment Line";
        ShipmentComment: Record "Sales Comment Line";
        Cust: Record Customer;
    begin
        SalesHeader."External Document No." := SalesShipmentHeader."External Document No.";
        SalesHeader.Validate("Location Code", SalesShipmentHeader."Location Code");
        SalesHeader."Customer PO Date" := SalesShipmentHeader."Customer PO Date";
        SalesHeader."Executive Master" := SalesShipmentHeader."Executive Master";
        SalesHeader."Executive Master2" := SalesShipmentHeader."Executive Master2";
        SalesHeader."Executive Master3" := SalesShipmentHeader."Executive Master3";
        SalesHeader."Executive Master4" := SalesShipmentHeader."Executive Master4";
        SalesHeader."Share Of Exe Master" := SalesShipmentHeader."Share Of Exe Master";
        SalesHeader."Share Of Exe Master2" := SalesShipmentHeader."Share Of Exe Master2";
        SalesHeader."Share Of Exe Master3" := SalesShipmentHeader."Share Of Exe Master3";
        SalesHeader."Share Of Exe Master4" := SalesShipmentHeader."Share Of Exe Master4";
        SalesHeader."CRM Quote No." := SalesShipmentHeader."CRM Quote No.";
        SalesHeader."Dimension Set ID" := SalesShipmentHeader."Dimension Set ID";
        SalesHeader."Shortcut Dimension 1 Code" := SalesShipmentHeader."Shortcut Dimension 1 Code";
        SalesHeader."Shortcut Dimension 2 Code" := SalesShipmentHeader."Shortcut Dimension 2 Code";
        SalesHeader."Shortcut Dimension 3 Code" := SalesShipmentHeader."Shortcut Dimension 3 Code";
        SalesHeader."Custom Assigned User ID" := SalesShipmentHeader."Custom Assigned User ID";
        SalesHeader."Discount Type" := SalesShipmentHeader."Discount Type";
        SalesHeader."Quotation Date" := SalesShipmentHeader."Quotation Date";
        SalesHeader."Reference Number" := SalesShipmentHeader."Reference Number";
        SalesHeader."Delivery Term" := SalesShipmentHeader."Delivery Term";
        SalesHeader.Service_Type_ := SalesShipmentHeader.Service_Type_;
        SalesHeader."Service Description" := SalesShipmentHeader."Service Description";
        SalesHeader."No. of Visit" := SalesShipmentHeader."No. of Visit";
        SalesHeader."Visit Date" := SalesShipmentHeader."Visit Date";
        SalesHeader."Invoice Term" := SalesShipmentHeader."Invoice Term";
        SalesHeader."Contract Start Date" := SalesShipmentHeader."Contract Start Date";
        SalesHeader."Contract End Date" := SalesShipmentHeader."Contract End Date";
        SalesHeader."Discount Type" := SalesShipmentHeader."Discount Type";
        SalesHeader."SHI Claim No" := SalesShipmentHeader."SHI Claim No";
        SalesHeader."Claim Date" := SalesShipmentHeader."Claim Date";
        SalesHeader."Sale Invoice No. Ref." := SalesShipmentHeader."Sale Invoice No. Ref.";
        SalesHeader."Claim Accept Ref. No" := SalesShipmentHeader."Claim Accept Ref. No";
        SalesHeader."Invoice Date" := SalesShipmentHeader."Invoice Date";
        SalesHeader."Description of Trouble" := SalesShipmentHeader."Description of Trouble";
        SalesHeader."Trouble object" := SalesShipmentHeader."Trouble object";
        SalesHeader.Campaign := SalesShipmentHeader.Campaign;
        SalesHeader."Campaign Details" := SalesShipmentHeader."Campaign Details";
        SalesHeader.Insurance := SalesShipmentHeader.Insurance;
        SalesHeader."Packing & Forwarding" := SalesShipmentHeader."Packing & Forwarding";
        SalesHeader."Special Instruction" := SalesShipmentHeader."Special Instruction";
        SalesHeader."Service Remark" := SalesShipmentHeader."Service Remark";
        SalesHeader."New Customer" := SalesShipmentHeader."New Customer";
        SalesHeader.Validate("Dealer Customer", SalesShipmentHeader."Dealer Customer");
        SalesHeader."Dealer Customer" := SalesShipmentHeader."Dealer Customer";
        SalesHeader."Dealer Customer Name" := SalesShipmentHeader."Dealer Customer Name";
        SalesHeader."Dealer Customer Address" := SalesShipmentHeader."Dealer Customer Address";
        SalesHeader."Dealer Customer Address 2" := SalesShipmentHeader."Dealer Customer Address 2";
        SalesHeader."Dealer Customer City" := SalesShipmentHeader."Dealer Customer City";
        SalesHeader."Dealer Customer County" := SalesShipmentHeader."Dealer Customer County";
        SalesHeader."Dealer Customer Post Code" := SalesShipmentHeader."Dealer Customer Post Code";
        SalesHeader."Dealer Country/Region Code" := SalesShipmentHeader."Dealer Country/Region Code";
        SalesHeader."Dealer Customer GST No." := SalesShipmentHeader."Dealer Customer GST No.";
        SalesHeader.Validate("EMD Details", SalesShipmentHeader."EMD Details");
        SalesHeader."EMD No." := SalesShipmentHeader."EMD No.";
        SalesHeader."EMD Date" := SalesShipmentHeader."EMD Date";
        SalesHeader."EMD Due Date" := SalesShipmentHeader."EMD Due Date";
        SalesHeader.Validate("PBG Details", SalesShipmentHeader."PBG Details");
        SalesHeader."PBG No." := SalesShipmentHeader."PBG No.";
        SalesHeader."PBG Date" := SalesShipmentHeader."PBG Date";
        SalesHeader."PBG Due Date" := SalesShipmentHeader."PBG Due Date";
        SalesHeader."Business Sector" := SalesShipmentHeader."Business Sector";
        SalesHeader.Industry := SalesShipmentHeader.Industry;
        SalesHeader."Industry Sub-Segment" := SalesShipmentHeader."Industry Sub-Segment";
        SalesHeader.Application := SalesShipmentHeader.Application;
        SalesHeader."Appliaction Sub-Segment" := SalesShipmentHeader."Appliaction Sub-Segment";
        SalesHeader."CRM Employee ID 1" := SalesShipmentHeader."CRM Employee ID 1";
        SalesHeader."RDC No" := SalesShipmentHeader."RDC No";
        SalesHeader."RDC Date" := SalesShipmentHeader."RDC Date";
        SalesHeader."Key/Non-Key" := SalesShipmentHeader."Key/Non-Key";
        SalesHeader."KEY/NON KEY(Principal Wise)" := SalesShipmentHeader."KEY/NON KEY(Principal Wise)";
        SalesHeader."Approval Ref" := SalesShipmentHeader."Approval Ref";
        SalesHeader."Year" := SalesShipmentHeader."Year";
        SalesHeader."TAPL Booking Month" := SalesShipmentHeader."TAPL Booking Month";
        SalesHeader."Group Master" := SalesShipmentHeader."Group Master";
        SalesHeader."Prepayment Amount" := SalesShipmentHeader."Prepayment Amount";
        SalesHeader."Master Sales Order Number" := SalesShipmentHeader."Master Sales Order Number";
        SalesHeader."Special Instruction" := SalesShipmentHeader."Special Instruction";
        SalesHeader."Special Remark-Sez" := SalesShipmentHeader."Special Remark-Sez";
        SalesHeader.Validate("Ship-to Code", SalesShipmentHeader."Ship-to Code");
        SalesHeader."Ship-to Name" := SalesShipmentHeader."Ship-to Name";
        SalesHeader."Ship-to Name 2" := SalesShipmentHeader."Ship-to Name 2";
        SalesHeader."Ship-to Address" := SalesShipmentHeader."Ship-to Address";
        SalesHeader."Ship-to Address 2" := SalesShipmentHeader."Ship-to Address 2";
        SalesHeader.Validate("Ship-to City", SalesShipmentHeader."Ship-to City");
        SalesHeader."Ship-to County" := SalesShipmentHeader."Ship-to County";
        SalesHeader.Validate("Ship-to Post Code", SalesShipmentHeader."Ship-to Post Code");
        SalesHeader."Ship-to County" := SalesShipmentHeader."Ship-to County";
        SalesHeader.Validate("Ship-to Country/Region Code", SalesShipmentHeader."Ship-to Country/Region Code");
        SalesHeader."Ship to Industry Caregory" := SalesShipmentHeader."Ship to Industry Caregory";
        SalesHeader.Validate("GST Ship-to State Code", SalesShipmentHeader."GST Ship-to State Code");

        SalesHeader."Bill-to Name" := SalesShipmentHeader."Bill-to Name";
        SalesHeader."Bill-to Name 2" := SalesShipmentHeader."Bill-to Name 2";
        SalesHeader."Bill-to Address" := SalesShipmentHeader."Bill-to Address";
        SalesHeader."Bill-to Address 2" := SalesShipmentHeader."Bill-to Address 2";
        SalesHeader."Bill-to City" := SalesShipmentHeader."Bill-to City";
        SalesHeader."Bill-to County" := SalesShipmentHeader."Bill-to County";
        SalesHeader."Bill-to Post Code" := SalesShipmentHeader."Bill-to Post Code";
        SalesHeader."Bill-to Country/Region Code" := SalesShipmentHeader."Bill-to Country/Region Code";
        SalesHeader."Bill-to Contact" := SalesShipmentHeader."Bill-to Contact";
        SalesHeader."Bill-to Contact No." := SalesShipmentHeader."Bill-to Contact No.";
        SalesHeader."Ship-to Contact" := SalesShipmentHeader."Ship-to Contact";
        SalesHeader."Ship-to Phone No." := SalesShipmentHeader."Ship-to Phone No.";
        SalesHeader."CRM Employee ID 1" := SalesShipmentHeader."CRM Employee ID 1";
        SalesHeader."CRM Employee ID 2" := SalesShipmentHeader."CRM Employee ID 2";
        SalesHeader."Sell-to Phone No." := SalesShipmentHeader."Sell-to Phone No.";
        SalesHeader."Salesperson Code" := SalesShipmentHeader."Salesperson Code";

        SalesHeader."Custom Assigned User ID" := SalesShipmentHeader."Custom Assigned User ID";
        SalesHeader."Your Reference" := SalesShipmentHeader."Order No.";
        SalesHeader.Validate("Payment Terms Code", SalesShipmentHeader."Payment Terms Code");
        SalesHeader."Payment Term Details" := SalesShipmentHeader."Payment Term Details";
        SalesHeader.Freight := SalesShipmentHeader.Freight;
        SalesHeader."Freight Terms" := SalesShipmentHeader."Freight Terms";
        SalesHeader."Party PO Received Date" := SalesShipmentHeader."Party PO Received Date"; //TBc-973
        SalesLine."Description 2" := SalesShipmentLine2."Description 2";
        SalesLine."Inst. Model" := SalesShipmentLine2."Inst. Model";
        SalesLine."Inst SR No." := SalesShipmentLine2."Inst SR No.";
        SalesLine."Item Instrument No." := SalesShipmentLine2."Item Instrument No.";
        SalesLine."CMC/AMC Start Date" := SalesShipmentLine2."CMC/AMC Start Date";
        SalesLine."CMC/AMC End Date" := SalesShipmentLine2."CMC/AMC End Date";
        SalesLine."Warranty/Service Period" := SalesShipmentLine2."Warranty/Service Period";
        SalesLine.MOQ := SalesShipmentLine2.MOQ;
        SalesLine.Remark := SalesShipmentLine2.Remark; //TBC-823
        SalesLine.Validate("CGST Percentage", SalesShipmentLine2."CGST Percentage");
        SalesLine.Validate("SGST Percentage", SalesShipmentLine2."SGST Percentage");
        SalesLine.Validate("IGST Percentage", SalesShipmentLine2."IGST Percentage");
        SalesShipmentHeader.CalcFields("Work Description");
        SalesHeader."Work Description" := SalesShipmentHeader."Work Description";
        SalesHeader."SEZ Instruction" := SalesShipmentHeader."SEZ Instruction";
        SalesHeader."Custom Ship-to" := SalesShipmentHeader."Custom Ship-to";
        SalesHeader."Custom GST No" := SalesShipmentHeader."Custom GST No";
        SalesHeader."Custom PAN No." := SalesShipmentHeader."Custom PAN No.";
        SalesHeader."Custom State" := SalesShipmentHeader."Custom State";
        SalesHeader."Sell-to Phone No." := SalesShipmentHeader."Sell-to Phone No.";
        SalesHeader."Sell-to E-Mail" := SalesShipmentHeader."Sell-to E-Mail";
        SalesHeader."Sell-to Contact" := SalesShipmentHeader."Sell-to Contact";
        //start of ticket no.- 918 on 30/03/26
        SalesHeader."Deemed Export" := SalesShipmentHeader."Deemed Export";
        SalesHeader."Deemed Export Instruction" := SalesShipmentHeader."Deemed Export Instruction";
        // end of ticket no.- 918

        //TBC-503 --->
        SalesHeader."Claim Inst Sr. No." := SalesShipmentHeader."Claim Inst Sr. No.";
        SalesHeader."Claim Inst. Model" := SalesShipmentHeader."Claim Inst. Model";
        SalesHeader."Claim Contact Person" := SalesShipmentHeader."Claim Contact Person";
        SalesHeader."Claim Narration" := SalesShipmentHeader."Claim Narration";
        //TBC-503 <---

        // Check if Shipment Header comments exist
        ShipmentComment.Reset();
        ShipmentComment.SetRange("Document Type", ShipmentComment."Document Type"::Shipment);
        ShipmentComment.SetRange("No.", SalesShipmentHeader."No.");
        ShipmentComment.SetRange("Document Line No.", 0); // HEADER
        if ShipmentComment.FindFirst() then
            CopyShipmentHeaderComments(SalesHeader, SalesShipmentHeader);

        //Check Shipment Line Comments
        ShipmentComment.Reset();
        ShipmentComment.SetRange("Document Type", ShipmentComment."Document Type"::Shipment);
        ShipmentComment.SetRange("No.", SalesShipmentHeader."No.");
        ShipmentComment.SetFilter("Document Line No.", '<>%1', 0); // LINE comments only
        if ShipmentComment.FindFirst() then
            CopyShipmentLineComments(SalesHeader, SalesShipmentHeader);

        //CopyShipmentHeaderComments(SalesHeader, SalesShipmentHeader);
        //CopyShipmentLineComments(SalesHeader, SalesShipmentHeader);
        SalesHeader.Modify(false);
    end;

    local procedure CopyShipmentHeaderComments(
        SalesHeader: Record "Sales Header";
        SalesShipmentHeader: Record "Sales Shipment Header")
    var
        FromComment: Record "Sales Comment Line";
        ToComment: Record "Sales Comment Line";
        NextLineNo: Integer;
    begin
        // 1️⃣ Check if Invoice Header Comments already exist
        ToComment.Reset();
        ToComment.SetRange("Document Type", ToComment."Document Type"::Invoice);
        ToComment.SetRange("No.", SalesHeader."No.");
        ToComment.SetRange("Document Line No.", 0); // HEADER
        if ToComment.FindFirst() then
            exit; // Already exists → Do not copy again
        FromComment.Reset();
        FromComment.SetRange("Document Type", FromComment."Document Type"::Shipment);
        FromComment.SetRange("No.", SalesShipmentHeader."No.");
        FromComment.SetRange("Document Line No.", 0); // IMPORTANT
        if FromComment.FindSet() then begin
            ToComment.SetRange("Document Type", ToComment."Document Type"::Invoice);
            ToComment.SetRange("No.", SalesHeader."No.");
            ToComment.SetRange("Document Line No.", 0);
            if ToComment.FindLast() then
                NextLineNo := ToComment."Line No." + 10000
            else
                NextLineNo := 10000;
            repeat
                ToComment.Init();
                ToComment."Document Type" := ToComment."Document Type"::Invoice;
                ToComment."No." := SalesHeader."No.";
                ToComment."Document Line No." := 0; // HEADER
                ToComment."Line No." := NextLineNo;
                ToComment.Date := FromComment.Date;
                ToComment.Comment := FromComment.Comment;
                ToComment.Insert(false);
                NextLineNo += 10000;
            until FromComment.Next() = 0;
        end;
    end;

    local procedure CopyShipmentLineComments(
    SalesHeader: Record "Sales Header";
    SalesShipmentHeader: Record "Sales Shipment Header")
    var
        InvoiceLine: Record "Sales Line";
        ShipmentLine: Record "Sales Shipment Line";
        FromComment: Record "Sales Comment Line";
        ToComment: Record "Sales Comment Line";
        NextLineNo: Integer;
    begin
        // Get last comment line no only once
        ToComment.Reset();
        ToComment.SetRange("Document Type", ToComment."Document Type"::Invoice);
        ToComment.SetRange("No.", SalesHeader."No.");
        if ToComment.FindLast() then
            NextLineNo := ToComment."Line No." + 10000
        else
            NextLineNo := 10000;

        // Loop shipment lines of CURRENT shipment
        ShipmentLine.SetRange("Document No.", SalesShipmentHeader."No.");
        if ShipmentLine.FindSet() then
            repeat
                // Find EXACT invoice line created from this shipment line
                InvoiceLine.Reset();
                InvoiceLine.SetRange("Document Type", InvoiceLine."Document Type"::Invoice);
                InvoiceLine.SetRange("Document No.", SalesHeader."No.");
                InvoiceLine.SetRange("Shipment No.", ShipmentLine."Document No.");
                InvoiceLine.SetRange("Shipment Line No.", ShipmentLine."Line No.");
                InvoiceLine.SetRange(Type, InvoiceLine.Type::Item); // Only Item
                if InvoiceLine.FindFirst() then begin
                    FromComment.Reset();
                    FromComment.SetRange("Document Type", FromComment."Document Type"::Shipment);
                    FromComment.SetRange("No.", ShipmentLine."Document No.");
                    FromComment.SetRange("Document Line No.", ShipmentLine."Line No.");
                    if FromComment.FindSet() then
                        repeat
                            ToComment.Init();
                            ToComment."Document Type" := ToComment."Document Type"::Invoice;
                            ToComment."No." := SalesHeader."No.";
                            ToComment."Document Line No." := InvoiceLine."Line No.";
                            ToComment."Line No." := NextLineNo;
                            ToComment.Date := FromComment.Date;
                            ToComment.Comment := FromComment.Comment;
                            ToComment.Insert(false);
                            NextLineNo += 10000;
                        until FromComment.Next() = 0;
                end;

            until ShipmentLine.Next() = 0;
    end;


    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Prepayment %', true, true)]
    local procedure OnAfterValidateEventPrepayment(var Rec: Record "Sales Header"; xRec: Record "Sales Header")
    var
        TotalAmt: Decimal;
        SalesLine: Record "Sales Line";
    begin
        Clear(TotalAmt);

        if Rec."Prepayment %" = 0 then
            Rec."Prepayment Amount" := 0;

        // Use header total directly
        SalesLine.Reset();
        SalesLine.SetRange("Document Type", Rec."Document Type");
        SalesLine.SetRange("Document No.", Rec."No.");
        if SalesLine.FindSet() then
            repeat
                TotalAmt += SalesLine."Line Amount" + SalesLine."CGST Amount" + SalesLine."SGST Amount" + SalesLine."IGST Amount";
            until SalesLine.Next() = 0;

        if TotalAmt <> 0 then begin
            Rec."Prepayment Amount" :=
                (TotalAmt * Rec."Prepayment %") / 100;
            Rec.Modify(false);
        end;
    end;

    [EventSubscriber(ObjectType::codeunit, codeunit::"TransferOrder-Post Receipt", OnAfterInsertTransRcptHeader, '', true, true)]
    local procedure OnAfterInsertTransRcptHeader(var TransHeader: Record "Transfer Header"; var TransRcptHeader: Record "Transfer Receipt Header")
    begin
        TransRcptHeader.Customer_Name := TransHeader.Customer_Name;
        TransRcptHeader."Custom Assigned User ID" := TransHeader."Custom Assigned User ID";
        TransRcptHeader."Master Sales Order No." := TransHeader."Master Sales Order No.";
    end;


    //GST not calcluat fro ORC Sales Order ++++
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnAfterCopyFromItem, '', true, true)]
    local procedure OnAfterCopyFromItemGSTGroupCOde(Item: Record Item; var SalesLine: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
    begin
        if SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.") then
            if (SalesHeader."Sales Order Type" = 'SPARES ORC') OR (SalesHeader."Sales Order Type" = 'INSTRUMENT ORC') then begin
                SalesLine.Validate("GST Group Code", '');
                SalesLine."HSN/SAC Code" := Item."HSN/SAC Code";
            end;
    end;
    //GST not calcluat fro ORC Sales Order ---

    //If Purchase Order Import then Not update GST Group Code on Line level +++++
    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", OnAfterAssignItemValues, '', true, true)]
    local procedure OnAfterAssignItemValues(PurchHeader: Record "Purchase Header"; var PurchLine: Record "Purchase Line"; Item: Record Item)
    var
    begin
        if PurchHeader."Document Type" = PurchHeader."Document Type"::Order then
            if PurchHeader."Purchase Type" = PurchHeader."Purchase Type"::Import then begin
                PurchLine.Validate("GST Group Code", '');
                PurchLine."HSN/SAC Code" := Item."HSN/SAC Code";
            end;
    end;
    //If Purchase Order Import then Not update GST Group Code on Line level -----

    // GST Group Code blank for Import PO receipt post and get recept line from Sales Invoice Page GST Group COde & HSN/SAC Update  ++++
    [EventSubscriber(ObjectType::Table, Database::"Purch. Rcpt. Line", OnAfterCopyFromPurchRcptLine, '', true, true)]
    local procedure OnAfterCopyFromPurchRcptLine(var PurchaseLine: Record "Purchase Line"; var TempPurchLine: Record "Purchase Line")
    var
        RecItem: Record Item;
    begin
        if PurchaseLine.Type = PurchaseLine.Type::Item then
            if PurchaseLine."GST Group Code" = '' then
                if RecItem.Get(PurchaseLine."No.") then begin
                    PurchaseLine.Validate("GST Group Code", RecItem."GST Group Code");
                    PurchaseLine."HSN/SAC Code" := RecItem."HSN/SAC Code";
                end;
    end;
    // GST Group Code blank for Import PO receipt post and get recept line from Sales Invoice Page GST Group COde & HSN/SAC Update  ++++

    //Flow Direct Unit Cost & Line AMount from Purcha lIne to warehouse Recet Line. ++++++++
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purchases Warehouse Mgt.", OnAfterCreateRcptLineFromPurchLine, '', true, true)]
    local procedure OnAfterCreateRcptLineFromPurchLine(PurchaseLine: Record "Purchase Line"; var WarehouseReceiptLine: Record "Warehouse Receipt Line"; WarehouseReceiptHeader: Record "Warehouse Receipt Header")
    var
        ItemMaster: Record Item;
    begin
        WarehouseReceiptLine."Direct Unit Cost" := PurchaseLine."Direct Unit Cost";
        WarehouseReceiptLine."Line Amount" := WarehouseReceiptLine."Qty. to Receive" * PurchaseLine."Direct Unit Cost";
        if ItemMaster.Get(WarehouseReceiptLine."Item No.") then
            WarehouseReceiptLine.Principle := ItemMaster.Principal;
        WarehouseReceiptLine."HSN/SAC Code" := PurchaseLine."HSN/SAC Code";
        WarehouseReceiptLine.Modify(false);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Whse. Receipt Subform", OnAfterValidateEvent, "Qty. to Receive", true, true)]
    local procedure OnAfterValidateEvent(var Rec: Record "Warehouse Receipt Line"; var xRec: Record "Warehouse Receipt Line")
    begin
        if xRec."Qty. to Receive" <> Rec."Qty. to Receive" then begin
            Rec."Line Amount" := Rec."Qty. to Receive" * Rec."Direct Unit Cost";
            Rec.Modify(false);
        end;
    end;
    //Flow Direct Unit Cost & Line AMount from Purcha lIne to warehouse Recet Line. -------


    //Inwards TBC - 862 ------>

    [EventSubscriber(ObjectType::Page, Page::"Purchase Invoice", OnBeforePostDocument, '', true, true)]
    local procedure OnBeforePostDocument(var PurchaseHeader: Record "Purchase Header")
    begin
        if PurchaseHeader."No." = '' then
            exit;

        if PurchaseHeader."Document Type" <> PurchaseHeader."Document Type"::Invoice then
            exit;

        // Vendor Invoice No. must not be blank
        PurchaseHeader.TestField("Vendor Invoice No.");

        // Only validate Import vendors
        if PurchaseHeader."GST Vendor Type" = PurchaseHeader."GST Vendor Type"::Import then
            if (PurchaseHeader."Bill of Entry No." <> '') and
               (PurchaseHeader."Bill of Entry Date" <> 0D) and
               (PurchaseHeader."Bill of Entry Value" <> 0) then
                PurchaseHeader.TestField("Reference Date (Import)");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Get Receipt", OnAfterCreateInvLines, '', true, true)]
    local procedure OnAfterCreatePurchaseInvLines(var PurchaseHeader: Record "Purchase Header"; var PurchaseLine: Record "Purchase Line")
    var
        PurchRcptHeader: Record "Purch. Rcpt. Header";
    begin
        if PurchaseHeader."Document Type" <> PurchaseHeader."Document Type"::Invoice then
            exit;

        if PurchaseHeader."GST Vendor Type" <> PurchaseHeader."GST Vendor Type"::Import then
            exit;

        if PurchaseLine."Receipt No." = '' then
            exit;

        if PurchRcptHeader.Get(PurchaseLine."Receipt No.") then
            if (PurchRcptHeader."Port Code (Imports)" <> '') and
               (PurchaseHeader."Port Code (Imports)" <> PurchRcptHeader."Port Code (Imports)") then begin
                PurchaseHeader."Port Code (Imports)" := PurchRcptHeader."Port Code (Imports)";
                PurchaseHeader.Modify(false);
            end;
    end;

    //Inwards TBC - 862 <------

    //Flow custom fields from  Warehouse Receipt to posted Purchase rceipt -- TBC-875
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterInsertReceiptHeader', '', false, false)]
    local procedure OnAfterInsertReceiptHeader(
            var PurchRcptHeader: Record "Purch. Rcpt. Header";
            PurchHeader: Record "Purchase Header")
    var
        WhseRcptHeader: Record "Warehouse Receipt Header";
        WhseRcptLine: Record "Warehouse Receipt Line";
    begin
        //Find warehouse receipt linked to the purchase order
        WhseRcptLine.SetRange("Source Type", Database::"Purchase Line");
        WhseRcptLine.SetRange("Source Subtype", PurchHeader."Document Type");
        WhseRcptLine.SetRange("Source No.", PurchHeader."No.");
        if WhseRcptLine.FindFirst() then begin
            if WhseRcptHeader.Get(WhseRcptLine."No.") then begin
                //Flow custom fields
                PurchRcptHeader."Vendor Bill No." := WhseRcptHeader."Vendor Bill No.";
                PurchRcptHeader."Vendor Bill Date" := WhseRcptHeader."Vendor Bill Date";
                PurchRcptHeader."AWB No." := WhseRcptHeader."AWB No.";
                PurchRcptHeader."AWB Date" := WhseRcptHeader."AWB Date";
                PurchRcptHeader."BL No." := WhseRcptHeader."BL No.";
                PurchRcptHeader."BL Date" := WhseRcptHeader."BL Date";
                PurchRcptHeader.Modify(false);
            end;

        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Get Source Doc. Inbound", 'OnAfterCreateWhseReceiptHeaderFromWhseRequest', '', false, false)]
    local procedure UpdateBillOfEntryonWhseReceiptHeader(
       var WhseReceiptHeader: Record "Warehouse Receipt Header";
       WarehouseRequest: Record "Warehouse Request")
    var
        PurchHeader: Record "Purchase Header";
    begin

        // if WarehouseRequest."Source Type" <> Database::"Purchase Header" then
        //     exit;
        PurchHeader.Get(PurchHeader."Document Type"::Order, WarehouseRequest."Source No.");
        // WhseReceiptHeader."Challan No." := PurchHeader."Challan No.";
        // WhseReceiptHeader."Challan Date" := PurchHeader."Challan Date";
        WhseReceiptHeader."Bill of Entry Date" := PurchHeader."Bill of Entry Date";
        WhseReceiptHeader."Bill of Entry No." := PurchHeader."Bill of Entry No.";

        //TBC - 925  -->
        //Updating Posting Warehouse Receipt No. on warehouse receipt
        if PurchHeader."Document Type" = PurchHeader."Document Type"::Order then
            WhseReceiptHeader."Receiving No. Series" := UpdateReceivingNoSeries(PurchHeader);
        //TBC - 925  <--

        WhseReceiptHeader.Modify();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPurchRcptLineInsert', '', false, false)]
    local procedure OnAfterPurchRcptLineInsert(PurchaseLine: Record "Purchase Line"; PurchRcptHeader: Record "Purch. Rcpt. Header"; var PurchRcptLine: Record "Purch. Rcpt. Line")
    var
        WhseRcptLine: Record "Warehouse Receipt Line";
        LocalPurchRcptLine: Record "Purch. Rcpt. Line";
    begin
        WhseRcptLine.SetRange("Source Type", Database::"Purchase Line");
        WhseRcptLine.SetRange("Source Subtype", PurchaseLine."Document Type");
        WhseRcptLine.SetRange("Source No.", PurchaseLine."Document No.");
        WhseRcptLine.SetRange("Source Line No.", PurchaseLine."Line No.");
        if WhseRcptLine.FindSet() then
            repeat
                LocalPurchRcptLine.SetRange("Document No.", PurchRcptHeader."No.");
                LocalPurchRcptLine.SetRange(Type, LocalPurchRcptLine.Type::Item);
                LocalPurchRcptLine.SetRange("No.", WhseRcptLine."Item No.");
                LocalPurchRcptLine.SetRange("Order Line No.", WhseRcptLine."Source Line No.");
                if LocalPurchRcptLine.FindFirst() then begin
                    LocalPurchRcptLine.MExpiryDate := WhseRcptLine.MExpiryDate;
                    LocalPurchRcptLine.Modify(false);
                end;
            until WhseRcptLine.Next() = 0;
    end;
    // Start --> TBC-879 
    [EventSubscriber(ObjectType::Page, Page::"Purchase Order", OnAfterCalculateCurrentShippingAndPayToOption, '', false, false)]
    local procedure OnAfterCalculateCurrentShippingAndPayToOption(var ShipToOptions: Option; PurchaseHeader: Record "Purchase Header")
    begin
        ShipToOptions := PurchaseHeader."Custom Ship-to";
    end;
    // End --> TBC-879 
    //Ticket - TBC - 889 --->
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Receipt", 'OnAfterCode', '', true, true)]
    local procedure OnAfterPostWhseReceipt(var WarehouseReceiptHeader: Record "Warehouse Receipt Header")
    var
        PostedWhseReceiptHeader: Record "Posted Whse. Receipt Header";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        PurchLine: Record "Purchase Line";
        SalesLine: Record "Sales Line";
        ILE: Record "Item Ledger Entry";
    begin
        // Get the Posted Receipt Header related to this Warehouse Receipt
        PostedWhseReceiptHeader.SetRange("Whse. Receipt No.", WarehouseReceiptHeader."No.");
        if not PostedWhseReceiptHeader.FindFirst() then
            exit;

        // 🔹 Step 2: Loop Posted Purchase Receipt Lines
        PurchRcptLine.Reset();
        PurchRcptLine.SetRange("Posted Warehouse Rec No", PostedWhseReceiptHeader."No."); // ⭐ PPR No.
        if PurchRcptLine.FindSet() then begin
            repeat
                // Find the Item Ledger Entry created during this receipt to get the Lot No.
                ILE.SetRange("Document No.", PurchRcptLine."Document No.");
                ILE.SetRange("Document Line No.", PurchRcptLine."Line No.");
                ILE.SetRange("Item No.", PurchRcptLine."No.");
                ILE.SetFilter("Lot No.", '<>%1', '');

                if ILE.FindFirst() then begin
                    // Get the Purchase Order Line
                    if PurchLine.Get(PurchLine."Document Type"::Order, PurchRcptLine."Order No.", PurchRcptLine."Order Line No.") then begin
                        // Verify it is a Special Order and find the linked Sales Line
                        if (PurchLine."Special Order Sales No." <> '') and (PurchLine."Special Order Sales Line No." <> 0) then begin
                            if SalesLine.Get(SalesLine."Document Type"::Order, PurchLine."Special Order Sales No.", PurchLine."Special Order Sales Line No.") then begin
                                AssignLotToSalesLine(SalesLine, ILE);
                            end;
                        end;
                    end;
                end;
            until PurchRcptLine.Next() = 0;
        end;
    end;

    local procedure AssignLotToSalesLine(var SalesLine: Record "Sales Line"; ItemLedgEntry: Record "Item Ledger Entry")
    var
        ReservEntry: Record "Reservation Entry";
        TempReservEntry: Record "Reservation Entry" temporary;
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        // Define the Enum to avoid ambiguity
        ReservationStatus: Enum "Reservation Status";
    begin
        // 1. Clear any existing tracking to avoid "Already Reserved" errors
        ReservEntry.SetRange("Source Type", DATABASE::"Sales Line");
        ReservEntry.SetRange("Source Subtype", SalesLine."Document Type".AsInteger());
        ReservEntry.SetRange("Source ID", SalesLine."Document No.");
        ReservEntry.SetRange("Source Ref. No.", SalesLine."Line No.");
        if not ReservEntry.IsEmpty then
            ReservEntry.DeleteAll();

        // 2. Prepare the tracking info container
        TempReservEntry.Init();
        TempReservEntry."Lot No." := ItemLedgEntry."Lot No.";

        // 3. Register the Sales Line as the source (10 arguments)
        CreateReservEntry.CreateReservEntryFor(
            DATABASE::"Sales Line",
            SalesLine."Document Type".AsInteger(),
            SalesLine."Document No.",
            '',
            0,
            SalesLine."Line No.",
            SalesLine."Qty. per Unit of Measure",
            SalesLine.Quantity,
            SalesLine."Quantity (Base)",
            TempReservEntry
        );

        // 4. Create the entry using all 8 required parameters
        // Parameters: ItemNo, Variant, Location, Desc, ReceiptDate, ShipmentDate, TransFromEntryNo, Status
        CreateReservEntry.CreateEntry(
            SalesLine."No.",                     // ItemNo
            SalesLine."Variant Code",            // VariantCode
            SalesLine."Location Code",           // LocationCode
            SalesLine.Description,               // Description
            0D,                                  // ExpectedReceiptDate
            SalesLine."Shipment Date",           // ShipmentDate
            0,                                   // TransferredFromEntryNo
            ReservationStatus::Prospect          // Status (Prospect means 'Selected Lot')
        );
    end;
    //Ticket  -TBS - 899 <---

    //TBC - 922 -->
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Get Source Doc. Outbound", OnAfterCreateWhseShipmentHeaderFromWhseRequest, '', false, false)]
    local procedure OnAfterCreateWhseShipmentHeaderFromWhseRequest(var WhseShptHeader: Record "Warehouse Shipment Header"; var WarehouseRequest: Record "Warehouse Request")
    var
        SalesHeader: Record "Sales Header";
    begin
        //OLD Code COmmendt By HG 09 July 2026 --->
        // SalesHeader.Get(SalesHeader."Document Type"::Order, WarehouseRequest."Source No.");
        // if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin
        //     WhseShptHeader."Shipping No. Series" := UpdateShippingNoSeries(SalesHeader);
        //     WhseShptHeader.Modify(false);
        // end;
        //OLD Code COmmendt By HG 09 July 2026 <---

        //TBC-1074 ---->
        if WarehouseRequest."Source Type" <> Database::"Sales Line" then
            exit;

        if WarehouseRequest."Source Subtype" <> WarehouseRequest."Source Subtype"::"1" then // 1 = Order
            exit;

        if not SalesHeader.Get(SalesHeader."Document Type"::Order, WarehouseRequest."Source No.") then
            exit;

        WhseShptHeader."Shipping No. Series" := UpdateShippingNoSeries(SalesHeader);
        WhseShptHeader.Modify(false);
        //TBC-1074 <---
    end;

    local procedure UpdateShippingNoSeries(var SalesHeader: Record "Sales Header"): Code[20]
    var
        NoSeries: Record "No. Series";
    begin
        if SalesHeader."No. Series" = '' then
            exit;

        if NoSeries.Get(SalesHeader."No. Series") then
            exit(NoSeries."Posting Warehouse No. Series");
    end;

    //TBC - 922 <--


    //TBC - 925  -->

    local procedure UpdateReceivingNoSeries(var PurchaseHeader: Record "Purchase Header"): Code[20]
    var
        NoSeries: Record "No. Series";
    begin
        if PurchaseHeader."No. Series" = '' then
            exit;

        if NoSeries.Get(PurchaseHeader."No. Series") then
            exit(NoSeries."Posting Warehouse No. Series");
    end;
    //TBC - 925  <--


    //TBC-506  --->
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", OnAfterInsertTransShptHeader, '', false, false)]
    local procedure OnAfterInsertTransShptHeaderTeamsCode(var TransferHeader: Record "Transfer Header"; var TransferShipmentHeader: Record "Transfer Shipment Header")
    begin
        TransferShipmentHeader."Shortcut Dimension 3 Code" := TransferHeader."Shortcut Dimension 3 Code";
        TransferShipmentHeader.Modify(false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", OnAfterInsertTransRcptHeader, '', false, false)]
    local procedure OnAfterInsertTransRcptHeaderTeamsCode(var TransHeader: Record "Transfer Header"; var TransRcptHeader: Record "Transfer Receipt Header")
    begin
        TransRcptHeader."Shortcut Dimension 3 Code" := TransHeader."Shortcut Dimension 3 Code";
        TransRcptHeader.Modify(false);
    end;
    //TNC-506 <---

    //TBC-499 -->
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Get Receipt", OnAfterCreateInvLines, '', false, false)]
    local procedure OnAfterCreatePurchaseInvoiceLines(var PurchaseHeader: Record "Purchase Header"; var PurchaseLine: Record "Purchase Line")
    var
        PurchReceiptHeader: Record "Purch. Rcpt. Header";
    begin
        if PurchaseHeader."Document Type" <> PurchaseHeader."Document Type"::Invoice then
            exit;

        if PurchaseLine."Receipt No." = '' then
            exit;

        if PurchReceiptHeader.Get(PurchaseLine."Receipt No.") then begin
            if PurchReceiptHeader."Inco Terms" = '' then
                exit;

            // First time set
            if PurchaseHeader."Inco Terms" = '' then begin
                PurchaseHeader."Inco Terms" := PurchReceiptHeader."Inco Terms";
                PurchaseHeader.Modify(false);
            end;
        end;
    end;
    //TBC-499 <--

    //TBC-944 -->
    [EventSubscriber(ObjectType::Table, Database::"Warehouse Receipt Header", OnAfterInsertEvent, '', false, false)]
    local procedure OnBeforeInsertWhseReceipt(var Rec: Record "Warehouse Receipt Header")
    begin
        UpdateReceivingNoSeries(Rec);
        Rec.Modify(false);
    end;

    local procedure UpdateReceivingNoSeries(var Rec: Record "Warehouse Receipt Header")
    var
        NoSeries: Record "No. Series";
    begin
        if Rec."No. Series" <> '' then begin
            if NoSeries.Get(Rec."No. Series") then begin
                if NoSeries."Posting Warehouse No. Series" <> '' then
                    Rec."Receiving No. Series" := NoSeries."Posting Warehouse No. Series";
            end;
        end;
    end;
    //TBC-944 <--

    //TBC-950 -->
    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", OnAfterOnClosePage, '', false, false)]
    local procedure UpdateLastLotOnClose(var TrackingSpecification: Record "Tracking Specification")
    var
        ReservEntry: Record "Reservation Entry";
        WhseLine: Record "Warehouse Shipment Line";
        LastLotNo: Code[50];
    begin
        // Only for Warehouse Shipment
        if TrackingSpecification."Source Type" <> DATABASE::"Sales Line" then
            exit;


        // Get warehouse shipment line
        WhseLine.Reset();
        WhseLine.SetRange("Source No.", TrackingSpecification."Source ID");
        WhseLine.SetRange("Source Line No.", TrackingSpecification."Source Ref. No.");
        if not WhseLine.FindFirst() then
            exit;

        // Find last lot no
        ReservEntry.Reset();
        ReservEntry.SetCurrentKey("Entry No.");
        ReservEntry.SetRange("Source Type", DATABASE::"Sales Line");
        ReservEntry.SetRange("Source ID", WhseLine."Source No.");
        ReservEntry.SetRange("Source Ref. No.", WhseLine."Source Line No.");
        ReservEntry.SetFilter("Lot No.", '<>%1', '');
        if ReservEntry.FindLast() then
            LastLotNo := ReservEntry."Lot No."
        else
            LastLotNo := '';

        // Update field
        if WhseLine."Lot No." <> LastLotNo then begin
            WhseLine."Lot No." := LastLotNo;
            WhseLine.Modify(false);
        end;
    end;
    //TBC-950 <--

    //TBC-973 --->
    [EventSubscriber(ObjectType::Report, Report::"Get Source Documents", OnSalesLineOnAfterCreateShptHeader, '', true, true)]
    local procedure OnSalesLineOnAfterCreateShptHeader(SalesHeader: Record "Sales Header"; var WhseShptHeader: Record "Warehouse Shipment Header")
    begin
        if SalesHeader."Party PO Received Date" <> 0D then begin
            WhseShptHeader."Party PO Received Date" := SalesHeader."Party PO Received Date";
            WhseShptHeader.Modify(false);
        end;
    end;
    //TBC-973 <---


    //TBC-975 --->
    [EventSubscriber(ObjectType::Report, Report::"Get Sales Orders", 'OnBeforeInsertReqWkshLine', '', false, false)]
    local procedure ApplyNoSeriesBeforeInsert(var ReqLine: Record "Requisition Line"; SalesLine: Record "Sales Line"; SpecOrder: Integer)
    var
        NoSeriesCode: Code[20];
        Sender: Report "Get Sales Orders";
        NoSer: Record "No. Series";
    begin
        NoSeriesCode := Sender.GetSelectedNoSeries();

        if NoSeriesCode = '' then
            exit;

        // Apply for Special Order OR Drop Shipment
        if (SpecOrder = 1) or (SalesLine."Drop Shipment") then begin
            ReqLine.Validate("No. Series", NoSeriesCode);

        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Req. Wksh.-Make Order", 'OnBeforePurchOrderHeaderInsert', '', true, true)]
    local procedure OnBeforePurchHeaderInsert(var PurchaseHeader: Record "Purchase Header"; RequisitionLine: Record "Requisition Line")
    var
        NoSeriesMgt: Codeunit "No. Series";
        RecNoSeries: Record "No. Series";
    begin
        if (RequisitionLine."Purchasing Code" <> 'SPCL ORD') and
           (RequisitionLine."Purchasing Code" <> 'DROP SHIP') then
            exit;

        if RequisitionLine."No. Series" = '' then
            exit;

        if not RecNoSeries.Get(RequisitionLine."No. Series") then
            exit;

        PurchaseHeader."No. Series" := RecNoSeries.Code;
        PurchaseHeader."No." := NoSeriesMgt.GetNextNo(RecNoSeries.Code, Today, true);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Req. Wksh.-Make Order", OnAfterInsertPurchOrderHeader, '', false, false)]
    local procedure OnAfterInsertPurchOrderHeader(CommitIsSuppressed: Boolean; SpecialOrder: Boolean; var PurchaseOrderHeader: Record "Purchase Header"; var RequisitionLine: Record "Requisition Line")
    var
        SalesHeader: Record "Sales Header";
    begin
        if (SpecialOrder) OR (RequisitionLine."Purchasing Code" = 'DROP SHIP') then begin
            SalesHeader.Reset();
            SalesHeader.SetRange("No.", RequisitionLine."Sales Order No.");
            if SalesHeader.FindFirst() then begin
                PurchaseOrderHeader.Validate("Dimension Set ID", SalesHeader."Dimension Set ID");
                PurchaseOrderHeader.Validate("Shortcut Dimension 1 Code", SalesHeader."Shortcut Dimension 1 Code");
                PurchaseOrderHeader.Validate("Shortcut Dimension 2 Code", SalesHeader."Shortcut Dimension 2 Code");
            end;
            // If Special Order then its update ship to opption for print level
            if PurchaseOrderHeader."Location Code" <> '' then
                PurchaseOrderHeader."Custom Ship-to" := PurchaseOrderHeader."Custom Ship-to"::Location;
        end;
    end;
    //TBC-975 <---

    //TBC-892 --->
    [EventSubscriber(ObjectType::Page, Page::"Sales Invoice", OnBeforeActionEvent, 'Post', true, true)]
    local procedure OnBeforeActionEventSIPost(var Rec: Record "Sales Header")

    begin
        if Rec."No." = '' then
            exit;

        if Rec."Document Type" <> Rec."Document Type"::Invoice then
            exit;

        if Rec."Ship-to Code" <> '' then
            Rec.TestField(Rec."GST Ship-to State Code");
    end;
    //TBC-892 <---

    //TBC-987 ---->
    [EventSubscriber(ObjectType::Page, Page::"Sales Order", OnBeforeActionEvent, 'Post', true, true)]
    local procedure OnBeforeActionEventSO(var Rec: Record "Sales Header")
    var
        User: Record "User Setup";
    begin
        if Rec."Document Type" <> Rec."Document Type"::Order then
            exit;

        if Rec."No." = '' then
            exit;

        if User.Get(UserId) then begin
            if User."Posting Permission" then
                Error('You do not have permission to post the Sales Order.');
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Warehouse Shipment", OnBeforeActionEvent, "P&ost Shipment", true, true)]
    local procedure OnBeforeActionEventWareShip(var Rec: Record "Warehouse Shipment Header")
    var
        User: Record "User Setup";
    begin
        if Rec."No." = '' then
            exit;

        if User.Get(UserId) then begin
            if User."Posting Permission" then
                Error('You do not have permission to post the Warehouse Shipment.');
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Purchase Order", OnBeforeActionEvent, 'Post', true, true)]
    local procedure OnBeforeActionEventPO(var Rec: Record "Purchase Header")
    var
        User: Record "User Setup";
    begin
        if Rec."Document Type" <> Rec."Document Type"::Order then
            exit;

        if Rec."No." = '' then
            exit;

        if User.Get(UserId) then begin
            if User."Posting Permission" then
                Error('You do not have permission to post the Purchase Order.');
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Warehouse Receipt", OnBeforeActionEvent, 'Post Receipt', true, true)]
    local procedure OnBeforeActionEventWareRec(var Rec: Record "Warehouse Receipt Header")
    var
        User: Record "User Setup";
    begin
        if Rec."No." = '' then
            exit;

        if User.Get(UserId) then begin
            if User."Posting Permission" then
                Error('You do not have permission to post the Warehouse Receipt.');
        end;
    end;
    //TBC-987 <----  Posting Validation for Sales Order, Purchase Order, Warehouse Shipment and Warehouse Receipt


    //TBC-979 ---->
    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", OnAfterOnClosePage, '', false, false)]
    local procedure UpdateLastLotOnCloseWarehouseReceipt(var TrackingSpecification: Record "Tracking Specification")
    var
        ReservEntry: Record "Reservation Entry";
        WhseLine: Record "Warehouse Receipt Line";
        LastLotNo: Code[50];
    begin
        // Only for Warehouse Receipt
        if TrackingSpecification."Source Type" <> DATABASE::"Purchase Line" then
            exit;


        // Get warehouse receipt line
        WhseLine.Reset();
        WhseLine.SetRange("Source No.", TrackingSpecification."Source ID");
        WhseLine.SetRange("Source Line No.", TrackingSpecification."Source Ref. No.");
        if not WhseLine.FindFirst() then
            exit;

        // Find last lot no
        ReservEntry.Reset();
        ReservEntry.SetCurrentKey("Entry No.");
        ReservEntry.SetRange("Source Type", DATABASE::"Purchase Line");
        ReservEntry.SetRange("Source ID", WhseLine."Source No.");
        ReservEntry.SetRange("Source Ref. No.", WhseLine."Source Line No.");
        ReservEntry.SetFilter("Lot No.", '<>%1', '');

        if ReservEntry.FindLast() then
            LastLotNo := ReservEntry."Lot No."
        else
            LastLotNo := '';

        // Update field
        if WhseLine."Lot No." <> LastLotNo then begin
            WhseLine."Lot No." := LastLotNo;
            WhseLine.Modify(false);
        end;
    end;
    //TBC-979 <-----


    //TBC - 905 --->
    [EventSubscriber(ObjectType::Table, Database::"Bank Account Ledger Entry", OnAfterCopyFromGenJnlLine, '', false, false)]
    local procedure OnAfterCopyFromGenJnlLine(GenJournalLine: Record "Gen. Journal Line"; var BankAccountLedgerEntry: Record "Bank Account Ledger Entry")
    begin
        BankAccountLedgerEntry."Beneficiary Name" := GenJournalLine."Beneficiary Name";
        BankAccountLedgerEntry."UTR/Cheque No." := GenJournalLine."UTR/Cheque No.";//TBC-947
        BankAccountLedgerEntry."Comment" := GenJournalLine."Comment"; //TBC-1000;
    end;


    [EventSubscriber(ObjectType::Table, Database::"Vendor Ledger Entry", OnAfterCopyVendLedgerEntryFromGenJnlLine, '', true, true)]
    local procedure OnAfterCopyVendLedgerEntryFromGenJnlLine(GenJournalLine: Record "Gen. Journal Line"; var VendorLedgerEntry: Record "Vendor Ledger Entry")
    begin
        VendorLedgerEntry."Beneficiary Name" := GenJournalLine."Beneficiary Name";
    end;

    [EventSubscriber(ObjectType::Page, Page::"Bank Payment Voucher",
    OnAfterValidateEvent, "Account No.", true, true)]
    local procedure OnAfterValidateEventAccountNo(var Rec: Record "Gen. Journal Line")
    var
        VendorBankAccount: Record "Vendor Bank Account";
    begin
        if (Rec."Account Type" = Rec."Account Type"::Vendor) and
           (Rec."Account No." <> '') then begin
            VendorBankAccount.Reset();
            VendorBankAccount.SetRange("Vendor No.", Rec."Account No.");
            if VendorBankAccount.FindFirst() then
                Rec."Beneficiary Name" := VendorBankAccount."Beneficiary Name"
            else
                Rec."Beneficiary Name" := '';
            Rec.Modify(false);
        end;
    end;
    //TBC - 905 <---

    //TBC-947 --->
    [EventSubscriber(ObjectType::Table, Database::"Cust. Ledger Entry", OnAfterCopyCustLedgerEntryFromGenJnlLine, '', true, true)]
    local procedure OnAfterCopyCustLedgerEntryFromGenJnlLine(GenJournalLine: Record "Gen. Journal Line"; var CustLedgerEntry: Record "Cust. Ledger Entry")
    begin
        CustLedgerEntry."UTR/Cheque No." := GenJournalLine."UTR/Cheque No.";
        CustLedgerEntry.Comment := GenJournalLine.Comment; //TBC-1010
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", OnAfterInsertDtldCustLedgEntry, '', false, false)]
    local procedure OnAfterDtldCustLedgEntryInsert(GenJournalLine: Record "Gen. Journal Line"; DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry")
    begin
        DtldCustLedgEntry."UTR/Cheque No." := GenJournalLine."UTR/Cheque No.";
        DtldCustLedgEntry.Comment := GenJournalLine.Comment; //TBc-1010
        DtldCustLedgEntry.Modify(false);
    end;
    //TBC-947 <---

    //TBC-1008 ---->
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnAfterInitRecord, '', false, false)]
    local procedure OnAfterInitRecord(var SalesHeader: Record "Sales Header")
    var
        NoSeries: Record "No. Series";
    begin
        ServiceOrderUpdateShippingNoSeries(SalesHeader);
    end;

    local procedure ServiceOrderUpdateShippingNoSeries(var SalesHeader: Record "Sales Header")
    var
        NoSeries: Record "No. Series";
    begin
        // Only for Sales Orders
        if SalesHeader."Document Type" <> SalesHeader."Document Type"::Order then
            exit;

        // Only for Service Orders
        if (SalesHeader."Sales Order Type" <> 'SERVICES') or
           (not SalesHeader."Service Order")
        then
            exit;

        // Get No. Series setup
        if NoSeries.Get(SalesHeader."No. Series") then begin
            if NoSeries."Posting Warehouse No. Series" <> '' then
                SalesHeader."Shipping No. Series" := NoSeries."Posting Warehouse No. Series";
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Sell-to Customer No.', false, false)]
    local procedure SelltoCustomerNoOnAfterValidate(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    begin
        ServiceOrderUpdateShippingNoSeries(Rec);
    end;


    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Location Code', false, false)]
    local procedure LocationCodeOnAfterValidate(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    begin
        ServiceOrderUpdateShippingNoSeries(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', "Bill-to Customer No.", false, false)]
    local procedure BilltoCustomerNoOnAfterValidate(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    begin
        ServiceOrderUpdateShippingNoSeries(Rec);
    end;


    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', "Shortcut Dimension 1 Code", false, false)]
    local procedure Dimension1OnAfterValidate(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    begin
        ServiceOrderUpdateShippingNoSeries(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', "Shortcut Dimension 2 Code", false, false)]
    local procedure Dimension2OnAfterValidate(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    begin
        ServiceOrderUpdateShippingNoSeries(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', "Shortcut Dimension 3 Code", false, false)]
    local procedure Dimension3OnAfterValidate(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    begin
        ServiceOrderUpdateShippingNoSeries(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', "Sell-to Contact", false, false)]
    local procedure SelltoContactnAfterValidate(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    begin
        ServiceOrderUpdateShippingNoSeries(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', "Bill-to Contact", false, false)]
    local procedure BilltoContactnAfterValidate(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    begin
        ServiceOrderUpdateShippingNoSeries(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', "Ship-to Contact", false, false)]
    local procedure ShiptoContactnAfterValidate(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    begin
        ServiceOrderUpdateShippingNoSeries(Rec);
    end;
    //TBC-1008 <----

    //TBC-1015 ---->
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', "Posting Date", false, false)]
    local procedure PostingDateOnAfterValidate(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    begin
        ServiceOrderUpdateShippingNoSeries(Rec);
    end;
    //TBC-1015 <----


    //TBC-1010 ----->
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Batch", 'OnAfterPostGenJnlLine', '', false, false)]
    local procedure OnAfterPostGenJnlLine(var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; var GenJournalLine: Record "Gen. Journal Line"; var PostingGenJournalLine: Record "Gen. Journal Line")
    var
        GLEntry: Record "G/L Entry";
        GenJnlLine2: Record "Gen. Journal Line";
        UTRNo: Text[100];
        CommentTxt: Text[250];
    begin

        if GenJournalLine.IsTemporary then
            exit;

        // Find line having UTR
        GenJnlLine2.Reset();
        GenJnlLine2.SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
        GenJnlLine2.SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
        GenJnlLine2.SetRange("Document No.", GenJournalLine."Document No.");
        GenJnlLine2.SetFilter("UTR/Cheque No.", '<>%1', '');

        if GenJnlLine2.FindFirst() then begin
            UTRNo := GenJnlLine2."UTR/Cheque No.";
            CommentTxt := GenJnlLine2.Comment;
        end;

        // Update all G/L Entries
        GLEntry.Reset();
        GLEntry.SetRange("Document No.", GenJournalLine."Document No.");

        if GLEntry.FindSet(true) then
            repeat
                GLEntry."UTR/Cheque No." := UTRNo;
                GLEntry.Comment := CommentTxt;
                GLEntry.Modify(false);
            until GLEntry.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterCustLedgEntryInsert', '', false, false)]
    local procedure OnAfterCustLedgEntryInsert(
        var CustLedgerEntry: Record "Cust. Ledger Entry";
        GenJournalLine: Record "Gen. Journal Line";
        DtldLedgEntryInserted: Boolean)
    var
        GenJnlLine2: Record "Gen. Journal Line";
    begin

        if CustLedgerEntry.IsTemporary then
            exit;

        // Find line where UTR is entered
        GenJnlLine2.Reset();
        GenJnlLine2.SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
        GenJnlLine2.SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
        GenJnlLine2.SetRange("Document No.", GenJournalLine."Document No.");
        GenJnlLine2.SetFilter("UTR/Cheque No.", '<>%1', '');

        if GenJnlLine2.FindFirst() then begin
            CustLedgerEntry."UTR/Cheque No." := GenJnlLine2."UTR/Cheque No.";
            CustLedgerEntry.Comment := GenJnlLine2.Comment;
            CustLedgerEntry.Modify(false);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInsertDtldCustLedgEntry', '', false, false)]
    local procedure OnAfterInsertDtldCustLedgEntry(
    GenJournalLine: Record "Gen. Journal Line";
    var DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry")
    var
        GenJnlLine2: Record "Gen. Journal Line";
    begin

        if DtldCustLedgEntry.IsTemporary then
            exit;

        // Find line where UTR is entered
        GenJnlLine2.Reset();
        GenJnlLine2.SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
        GenJnlLine2.SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
        GenJnlLine2.SetRange("Document No.", GenJournalLine."Document No.");
        GenJnlLine2.SetFilter("UTR/Cheque No.", '<>%1', '');

        if GenJnlLine2.FindFirst() then begin
            DtldCustLedgEntry."UTR/Cheque No." := GenJnlLine2."UTR/Cheque No.";
            DtldCustLedgEntry.Comment := GenJnlLine2.Comment;
            DtldCustLedgEntry.Modify(false);
        end;
    end;
    //TBC-1010 <-----


    //TBC-982 ----->
    [EventSubscriber(ObjectType::Codeunit, CodeUnit::"Document-Print", 'OnBeforePrintTransferHeader', '', false, false)]
    local procedure OnBeforePrintTransferHeader(var IsPrinted: Boolean; var TransferHeader: Record "Transfer Header")
    var
        TransferHeader2: Record "Transfer Header";
    begin
        TransferHeader2.Reset();
        TransferHeader2.SetRange("No.", TransferHeader."No.");
        if TransferHeader2.FindFirst() then
            Report.Run(Report::"Transfer Order Print", true, false, TransferHeader2);

        IsPrinted := true; // Skip standard report
    end;
    //TBC-982 <-----

    //TBC-1012 ---->
    [EventSubscriber(ObjectType::Table, Database::"Transfer Receipt Header", OnBeforePrintRecords, '', false, false)]
    local procedure OnBeforePrintRecordsPrint(var IsHandled: Boolean; var TransferReceiptHeader: Record "Transfer Receipt Header")
    begin
        IsHandled := true;
        Report.RunModal(Report::"Posted Transfer Receipts Print", true, false, TransferReceiptHeader);
    end;
    //TBC-1012 <----

    //TBC-1019 --->
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post (Yes/No)", OnBeforeConfirmPost, '', false, false)]
    local procedure OnBeforeConfirmPost(var SalesHeader: Record "Sales Header")
    begin
        case SalesHeader."Document Type" of
            SalesHeader."Document Type"::Order,
            SalesHeader."Document Type"::Invoice,
            SalesHeader."Document Type"::"Credit Memo":
                if SalesHeader."Posting Date" <> WorkDate() then
                    Message('Posting Date does not match the current date. Kindly check and correct it before posting the document.');
        end;
    end;
    //TBC-1019 <---

    //TBC-1020 --->
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", OnApproveApprovalRequest, '', false, false)]
    local procedure OnApproveApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    var
        SalesHeader: Record "Sales Header";
        ApprovalEntry2: Record "Approval Entry";
        MaxSequenceNo: Integer;
    begin
        // Find highest sequence for this document
        ApprovalEntry2.Reset();
        ApprovalEntry2.SetRange("Table ID", ApprovalEntry."Table ID");
        ApprovalEntry2.SetRange("Document Type", ApprovalEntry."Document Type");
        ApprovalEntry2.SetRange("Document No.", ApprovalEntry."Document No.");
        if ApprovalEntry2.FindLast() then
            MaxSequenceNo := ApprovalEntry2."Sequence No.";

        // Update only when highest sequence approves
        if ApprovalEntry."Sequence No." <> MaxSequenceNo then
            exit;

        if SalesHeader.Get(ApprovalEntry."Document Type", ApprovalEntry."Document No.")
        then begin
            SalesHeader."Approved By" := ApprovalEntry."Approver ID";
            SalesHeader."Approval Date and Time" := CurrentDateTime;
            SalesHeader.Modify(false);
        end;
    end;
    //TBC-1020 <---


    //TBC-1032 --->
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post (Yes/No)", 'OnBeforeConfirmPost', '', false, false)]
    local procedure OnBeforeConfirmPostGSTJurisdiction(var SalesHeader: Record "Sales Header")
    var
        Cust: Record Customer;
        Loc: Record Location;
        SalesLine: Record "Sales Line";
        CustStateCode: Code[20];
        LocStateCode: Code[20];
        ExpectedGSTJurisdiction: Enum "GST Jurisdiction Type";
    begin
        // Only validate Invoice and Order
        if SalesHeader."Document Type" <> SalesHeader."Document Type"::Invoice then
            exit;

        if (SalesHeader."GST Customer Type" = SalesHeader."GST Customer Type"::"SEZ Unit") OR
        (SalesHeader."GST Customer Type" = SalesHeader."GST Customer Type"::"Deemed Export") then
            exit;

        Clear(CustStateCode);
        Clear(LocStateCode);
        Clear(ExpectedGSTJurisdiction);

        // Step 1: Get Customer State Code
        if Cust.Get(SalesHeader."Sell-to Customer No.") then
            CustStateCode := Cust."State Code";

        // Step 2: Get Location State Code
        if Loc.Get(SalesHeader."Location Code") then
            LocStateCode := Loc."State Code";

        // Step 3: Determine Expected GST Jurisdiction Type
        // Same State → Intrastate | Different State → Interstate
        if CustStateCode = LocStateCode then
            ExpectedGSTJurisdiction := ExpectedGSTJurisdiction::Intrastate
        else
            ExpectedGSTJurisdiction := ExpectedGSTJurisdiction::Interstate;

        // Step 4: Validate all Item type Sales Lines
        SalesLine.Reset();
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        if SalesLine.FindSet() then
            repeat
                if SalesLine."GST Jurisdiction Type" <> ExpectedGSTJurisdiction then
                    Error(
                        'GST Jurisdiction Type mismatch on Sales Line %1 ' +
                        'Customer State: %2, Location State: %3.\' +
                        'Please check before posting.',
                        SalesLine."Line No.",
                        CustStateCode,
                        LocStateCode
                    );
            until SalesLine.Next() = 0;
    end;
    //TBC-1032 <---

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Get Receipt", OnAfterInsertLines, '', false, false)]
    local procedure OnRunOnAfterCreateInvLines(var PurchHeader: Record "Purchase Header")
    var
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchInvHeader: Record "Purchase Header";
        PurchInvLine: Record "Purchase Line";
    begin
        // Only process Purchase Invoices
        if PurchHeader."Document Type" <> PurchHeader."Document Type"::Invoice then
            exit;

        // Find the first receipt line linked to this invoice
        // to get the Purch. Rcpt. Header
        PurchInvLine.Reset();
        PurchInvLine.SetRange("Document Type", PurchHeader."Document Type");
        PurchInvLine.SetRange("Document No.", PurchHeader."No.");
        PurchInvLine.SetRange(Type, PurchInvLine.Type::Item);
        PurchInvLine.SetFilter("Receipt No.", '<>%1', '');
        if not PurchInvLine.FindFirst() then
            exit;

        // Get the Purch. Rcpt. Header
        if not PurchRcptHeader.Get(PurchInvLine."Receipt No.") then
            exit;

        if PurchRcptHeader."Custom Assigned User ID" = '' then
            exit;

        // Get a fresh copy of the Invoice Header to avoid concurrency issue
        if not PurchInvHeader.Get(PurchHeader."Document Type", PurchHeader."No.") then
            exit;

        // Only update if not already set
        if PurchInvHeader."Custom Assigned User ID" <> '' then
            exit;

        PurchInvHeader."Custom Assigned User ID" := PurchRcptHeader."Custom Assigned User ID";
        PurchInvHeader.Modify(false);
    end;

    //TBC-1069 ---->
    [EventSubscriber(ObjectType::Page, Page::"Sales Credit Memo", OnBeforeActionEvent, 'Post', false, false)]
    local procedure OnBeforeActionEventSalesCreditMemoPost(var Rec: Record "Sales Header")
    begin
        if Rec."Document Type" = Rec."Document Type"::"Credit Memo" then
            if Rec."Credit Note Type" = Rec."Credit Note Type"::" " then
                Error('Credit Note Type must not be Blank in Sales Header: Document Type=%1, No.=%2', Rec."Document Type", Rec."No.");
    end;
    //TBC-1069 <---

    //TBC-7072 --->
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnAfterInsertCrMemoHeader, '', false, false)]
    local procedure OnAfterInsertCrMemoHeader(SalesHeader: Record "Sales Header"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header")
    begin
        SalesCrMemoHeader."Applies-to ID" := SalesHeader."Applies-to ID";
        SalesCrMemoHeader.Modify(false);
    end;
    //TBC-1072 <---

    //TBC-1071 ----->
    [EventSubscriber(ObjectType::Page, Page::"Sales Order", OnBeforeActionEvent, 'Release', false, false)]
    local procedure OnBeforeActionEventRelease(var Rec: Record "Sales Header")
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then
            if UserSetup."Release/Reopen" then
                Error('Sorry, The current permission prevented the action. You do not have permission to Release this Sales Order.');
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Order", OnBeforeActionEvent, 'Reopen', false, false)]
    local procedure OnBeforeActionEventReopen(var Rec: Record "Sales Header")
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then
            if UserSetup."Release/Reopen" then
                Error('Sorry, The current permission prevented the action. You do not have permission to Reopen this Sales Order.');
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Invoice", OnBeforeActionEvent, 'Release', false, false)]
    local procedure OnBeforeActionEventReleaseSalesInvoice(var Rec: Record "Sales Header")
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then
            if UserSetup."Release/Reopen" then
                Error('Sorry, The current permission prevented the action. You do not have permission to Release this Sales Invoice.');
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Invoice", OnBeforeActionEvent, 'Reopen', false, false)]
    local procedure OnBeforeActionEventReopenSalesInvoice(var Rec: Record "Sales Header")
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then
            if UserSetup."Release/Reopen" then
                Error('Sorry, The current permission prevented the action. You do not have permission to Reopen this Sales Invoice.');
    end;

    [EventSubscriber(ObjectType::Page, Page::"Transfer Order", OnBeforeActionEvent, "Re&lease", false, false)]
    local procedure OnBeforeActionEventReleaseTransferOrder(var Rec: Record "Transfer Header")
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then
            if UserSetup."Release/Reopen" then
                Error('Sorry, The current permission prevented the action. You do not have permission to Release this Transfer Order.');
    end;

    [EventSubscriber(ObjectType::Page, Page::"Transfer Order", OnBeforeActionEvent, "Reo&pen", false, false)]
    local procedure OnBeforeActionEventReOpenTransferOrder(var Rec: Record "Transfer Header")
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then
            if UserSetup."Release/Reopen" then
                Error('Sorry, The current permission prevented the action. You do not have permission to Reopen this Transfer Order.');
    end;

    [EventSubscriber(ObjectType::Page, Page::"Purchase Invoice", OnBeforeActionEvent, "Re&lease", false, false)]
    local procedure OnBeforeActionEventReleasePurchaseInvoice(var Rec: Record "Purchase Header")
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then
            if UserSetup."Release/Reopen" then
                Error('Sorry, The current permission prevented the action. You do not have permission to Release this Purchase Invoice.');
    end;

    [EventSubscriber(ObjectType::Page, Page::"Purchase Invoice", OnBeforeActionEvent, 'Reopen', false, false)]
    local procedure OnBeforeActionEventReopenPurchaseInvoice(var Rec: Record "Purchase Header")
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then
            if UserSetup."Release/Reopen" then
                Error('Sorry, The current permission prevented the action. You do not have permission to Reopen this Purchase Invoice.');
    end;


    //List Pages
    [EventSubscriber(ObjectType::Page, Page::"Sales Order List", OnBeforeActionEvent, 'Release', false, false)]
    local procedure OnBeforeActionEventReleaseSOList(var Rec: Record "Sales Header")
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then
            if UserSetup."Release/Reopen" then
                Error('Sorry, The current permission prevented the action. You do not have permission to Release this Sales Order.');
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Order List", OnBeforeActionEvent, 'Reopen', false, false)]
    local procedure OnBeforeActionEventReopenSOList(var Rec: Record "Sales Header")
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then
            if UserSetup."Release/Reopen" then
                Error('Sorry, The current permission prevented the action. You do not have permission to Reopen this Sales Order.');
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Invoice List", OnBeforeActionEvent, "Re&lease", false, false)]
    local procedure OnBeforeActionEventReleaseSalesInvoiceList(var Rec: Record "Sales Header")
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then
            if UserSetup."Release/Reopen" then
                Error('Sorry, The current permission prevented the action. You do not have permission to Release this Sales Invoice.');
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Invoice List", OnBeforeActionEvent, "Re&open", false, false)]
    local procedure OnBeforeActionEventReopenSalesInvoiceList(var Rec: Record "Sales Header")
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then
            if UserSetup."Release/Reopen" then
                Error('Sorry, The current permission prevented the action. You do not have permission to Reopen this Sales Invoice.');
    end;

    [EventSubscriber(ObjectType::Page, Page::"Transfer Orders", OnBeforeActionEvent, "Re&lease", false, false)]
    local procedure OnBeforeActionEventReleaseTransferOrders(var Rec: Record "Transfer Header")
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then
            if UserSetup."Release/Reopen" then
                Error('Sorry, The current permission prevented the action. You do not have permission to Release this Transfer Order.');
    end;

    [EventSubscriber(ObjectType::Page, Page::"Transfer Orders", OnBeforeActionEvent, "Reo&pen", false, false)]
    local procedure OnBeforeActionEventReOpenTransferOrders(var Rec: Record "Transfer Header")
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then
            if UserSetup."Release/Reopen" then
                Error('Sorry, The current permission prevented the action. You do not have permission to Reopen this Transfer Order.');
    end;

    [EventSubscriber(ObjectType::Page, Page::"Purchase Invoices", OnBeforeActionEvent, Release, false, false)]
    local procedure OnBeforeActionEventReleasePurchaseInvoices(var Rec: Record "Purchase Header")
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then
            if UserSetup."Release/Reopen" then
                Error('Sorry, The current permission prevented the action. You do not have permission to Release this Purchase Invoice.');
    end;

    [EventSubscriber(ObjectType::Page, Page::"Purchase Invoices", OnBeforeActionEvent, 'Reopen', false, false)]
    local procedure OnBeforeActionEventReopenPurchaseInvoices(var Rec: Record "Purchase Header")
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then
            if UserSetup."Release/Reopen" then
                Error('Sorry, The current permission prevented the action. You do not have permission to Reopen this Purchase Invoice.');
    end;


    [EventSubscriber(ObjectType::Page, Page::"ORC Sales Order", OnBeforeActionEvent, 'Release', false, false)]
    local procedure OnBeforeActionEventReleaseORCSalesOrder(var Rec: Record "Sales Header")
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then
            if UserSetup."Release/Reopen" then
                Error('Sorry, The current permission prevented the action. You do not have permission to Release this ORC Sales Order.');
    end;

    [EventSubscriber(ObjectType::Page, Page::"ORC Sales Order", OnBeforeActionEvent, 'Reopen', false, false)]
    local procedure OnBeforeActionEventReopenORCSalesOrder(var Rec: Record "Sales Header")
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then
            if UserSetup."Release/Reopen" then
                Error('Sorry, The current permission prevented the action. You do not have permission to Reopen this ORC Sales Order.');
    end;

    //List Page
    [EventSubscriber(ObjectType::Page, Page::"ORC Sales Order List", OnBeforeActionEvent, 'Release', false, false)]
    local procedure OnBeforeActionEventReleaseORCSalesOrderList(var Rec: Record "Sales Header")
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then
            if UserSetup."Release/Reopen" then
                Error('Sorry, The current permission prevented the action. You do not have permission to Release this ORC Sales Order.');
    end;

    [EventSubscriber(ObjectType::Page, Page::"ORC Sales Order List", OnBeforeActionEvent, 'Reopen', false, false)]
    local procedure OnBeforeActionEventReopenORCSalesOrderList(var Rec: Record "Sales Header")
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then
            if UserSetup."Release/Reopen" then
                Error('Sorry, The current permission prevented the action. You do not have permission to Reopen this ORC Sales Order.');
    end;


    [EventSubscriber(ObjectType::Page, Page::"Purchase Order", OnBeforeActionEvent, 'Release', false, false)]
    local procedure OnBeforeActionEventReleasePurchaseOrder(var Rec: Record "Purchase Header")
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then
            if UserSetup."Release/Reopen" then
                Error('Sorry, The current permission prevented the action. You do not have permission to Release this Purchase Order.');
    end;

    [EventSubscriber(ObjectType::Page, Page::"Purchase Order", OnBeforeActionEvent, 'Reopen', false, false)]
    local procedure OnBeforeActionEventReopenPurchaseOrder(var Rec: Record "Purchase Header")
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then
            if UserSetup."Release/Reopen" then
                Error('Sorry, The current permission prevented the action. You do not have permission to Reopen this Purchase Order.');
    end;

    [EventSubscriber(ObjectType::Page, Page::"Purchase Order List", OnBeforeActionEvent, 'Release', false, false)]
    local procedure OnBeforeActionEventReleasePurchaseOrderList(var Rec: Record "Purchase Header")
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then
            if UserSetup."Release/Reopen" then
                Error('Sorry, The current permission prevented the action. You do not have permission to Release this Purchase Order.');
    end;

    [EventSubscriber(ObjectType::Page, Page::"Purchase Order List", OnBeforeActionEvent, 'Reopen', false, false)]
    local procedure OnBeforeActionEventReopenPurchaseOrderList(var Rec: Record "Purchase Header")
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then
            if UserSetup."Release/Reopen" then
                Error('Sorry, The current permission prevented the action. You do not have permission to Reopen this Purchase Order.');
    end;

    //TBC-1071 <---

    //TBC-1074 ---->
    [EventSubscriber(ObjectType::Page, Page::"Transfer Order Subform", OnAfterValidateEvent, "Item No.", false, false)]
    local procedure OnAfterValidateItemNo(var Rec: Record "Transfer Line")
    var
        Item: Record Item;
    begin
        if Rec."Item No." = '' then
            exit;

        Rec.Validate("GST Group Code", '');

        if Item.Get(Rec."Item No.") then
            Rec."HSN/SAC Code" := Item."HSN/SAC Code"
        else
            Rec."HSN/SAC Code" := '';

        if Rec.Modify(true) then;
    end;
    //TBC-1074 <----

}
