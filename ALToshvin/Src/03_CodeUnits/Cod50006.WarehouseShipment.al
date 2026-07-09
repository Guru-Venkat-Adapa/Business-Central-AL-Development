codeunit 50006 WarehouseShipment
{
    SingleInstance = true;
    Permissions =
    tabledata "Posted Whse. Shipment Header" = RIMD,
    tabledata "Posted Whse. Receipt Header" = RIMD;

    var
        CurrentShipmentNo: Code[20];

    procedure SetShipmentNo(No: Code[20])
    begin
        CurrentShipmentNo := No;
    end;

    procedure GetShipmentNo(): Code[20]
    begin
        exit(CurrentShipmentNo);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Warehouse Shipment", 'OnOpenPageEvent', '', false, false)]
    local procedure OnOpenPage(var Rec: Record "Warehouse Shipment Header")

    begin
        SetShipmentNo(Rec."No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Posting Selection Management", 'OnBeforeGetShipInvoiceSelectionForWhseActivity', '', false, false)]
    local procedure OnBeforeGetShipInvoiceSelectionForWhseActivity(
        var DefaultOption: Integer;
        var Selection: Integer;
        var IsHandled: Boolean;
        var Result: Boolean)
    var
        WhseLine: Record "Warehouse Shipment Line";
        SalesHeader: Record "Sales Header";
        // ShipmentContext: Codeunit "Whse Shipment Context";
        ShipmentNo: Code[20];
    begin
        ShipmentNo := GetShipmentNo();
        if ShipmentNo = '' then
            exit;

        WhseLine.SetRange("No.", ShipmentNo);
        if WhseLine.FindFirst() then begin
            if WhseLine."Source Type" = 37 then begin
                if SalesHeader.Get(SalesHeader."Document Type"::Order, WhseLine."Source No.") then begin
                    if (SalesHeader."Sales Order Type" = 'INSTRUMENT ORC') or (SalesHeader."Sales Order Type" = 'SPARES ORC') then begin
                        Selection := 1; // Ship only
                        IsHandled := true;
                        Result := true;
                    end;
                end;
            end;
        end;
    end;

    //Creating only selected items to create in warehouse shipment
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Warehouse Mgt.", 'OnCreateShptLineFromSalesLineOnBeforeGetSalesHeader', '', false, false)]
    local procedure OnCreateShptLineFromSalesLineOnBeforeGetSalesHeader(SalesLine: Record "Sales Line";
    WarehouseShipmentHeader: Record "Warehouse Shipment Header"; var IsHandled: Boolean; var Result: Boolean)
    begin
        if SalesLine."Item by Toshvin" then begin
            IsHandled := true;
            Result := true;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterInitRecord', '', false, false)]
    local procedure OnAfterValidateEventSalesHeaderNo(var SalesHeader: Record "Sales Header")
    var
        NoSeries: Record "No. Series";
        SalesNoSeries: Record "No Series for Sales";
        OrderType: Record "Sales Order Type";
    begin
        IF NoSeries.Get(SalesHeader."No. Series") then
            SalesHeader."Sales Order Type" := NoSeries.Description;

        if SalesHeader."Sales Order Type" = 'CLAIMS' then
            SalesHeader."Claim Order" := true;

        if SalesHeader."Sales Order Type" = 'CMC' then
            SalesHeader."CMC Order" := true;

        if SalesHeader."Sales Order Type" = 'AMC' then
            SalesHeader."AMC Order" := true;
        if SalesHeader."Sales Order Type" = 'SERVICES' then
            SalesHeader."Service Order" := true;
        if (SalesHeader."Sales Order Type" = 'INSTRUMENT ORC') then
            SalesHeader.ORCInstrument := true;


    end;
    //Update Contract No  from header to sales line
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnAfterInsertEvent, '', false, false)]
    local procedure OnAfterInsertEvent(var Rec: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetRange("No.", Rec."Document No.");
        if SalesHeader.FindFirst() then begin
            Rec."CMC/AMC Start Date" := SalesHeader."Contract Start Date";
            Rec."CMC/AMC End Date" := SalesHeader."Contract End Date";
        end;
    end;
    // Update Custom fields from transfer order to Warehouse shipment
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Get Source Doc. Outbound", OnAfterCreateWhseShipmentHeaderFromWhseRequest, '', false, false)]
    local procedure OnAfterCreateWhseShipmentHeaderFromWhseRequest(var WhseShptHeader: Record "Warehouse Shipment Header")
    var
        WarehouseShipmentLine: Record "Warehouse Shipment Line";
        TransferOrder: Record "Transfer Header";
    begin
        WarehouseShipmentLine.SetRange("No.", WhseShptHeader."No.");
        if WarehouseShipmentLine.FindFirst() then begin
            TransferOrder.SetRange("No.", WarehouseShipmentLine."Source No.");
            If TransferOrder.FindFirst() then begin
                WhseShptHeader.Validate("Sales Type", TransferOrder."Sales Type");
                WhseShptHeader.Validate("Requisition Purpose", TransferOrder."Requisition Purpose");
                WhseShptHeader.Validate("Part Requisition Form", TransferOrder."Part Requisition Form");
                WhseShptHeader.Validate("Expected RDC Return Date", TransferOrder."Expected RDC Return Date");
                WhseShptHeader.Customer_Name := TransferOrder.Customer_Name;
                WhseShptHeader."Service Persion ID" := TransferOrder."Service Persion ID";
                WhseShptHeader.Validate(Note, TransferOrder.Note);
                WhseShptHeader.Validate("Value Declaration", TransferOrder."Value Declaration");
                WhseShptHeader.Modify();
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Get Source Doc. Inbound", OnAfterCreateWhseReceiptHeaderFromWhseRequest, '', false, false)]
    local procedure OnAfterCreateWhseReceiptHeaderFromWhseRequest(var WhseReceiptHeader: Record "Warehouse Receipt Header")
    var
        WarehouseReceiptLine: Record "Warehouse Receipt Line";
        TransferOrder: Record "Transfer Header";
    begin
        WarehouseReceiptLine.SetRange("No.", WhseReceiptHeader."No.");
        if WarehouseReceiptLine.FindFirst() then begin
            TransferOrder.SetRange("No.", WarehouseReceiptLine."Source No.");
            If TransferOrder.FindFirst() then begin
                WhseReceiptHeader.Validate("Sales Type", TransferOrder."Sales Type");
                WhseReceiptHeader.Validate("Requisition Purpose", TransferOrder."Requisition Purpose");
                WhseReceiptHeader.Validate("Part Requisition Form", TransferOrder."Part Requisition Form");
                WhseReceiptHeader.Validate("Expected RDC Return Date", TransferOrder."Expected RDC Return Date");
                WhseReceiptHeader.Modify();
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", 'OnAfterCreatePostedShptHeader', '', false, false)]
    local procedure OnAfterCreatePostedShptHeader(
        var PostedWhseShptHeader: Record "Posted Whse. Shipment Header";
        WarehouseShipmentHeader: Record "Warehouse Shipment Header")
    begin
        PostedWhseShptHeader."Sales Type" := WarehouseShipmentHeader."Sales Type";
        PostedWhseShptHeader."Requisition Purpose" := WarehouseShipmentHeader."Requisition Purpose";
        PostedWhseShptHeader."Part Requisition Form" := WarehouseShipmentHeader."Part Requisition Form";
        PostedWhseShptHeader."Expected RDC Return Date" := WarehouseShipmentHeader."Expected RDC Return Date";
        PostedWhseShptHeader.Note := WarehouseShipmentHeader.Note;
        PostedWhseShptHeader."Party PO Received Date" := WarehouseShipmentHeader."Party PO Received Date"; //TBC-973
        PostedWhseShptHeader.Modify();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Receipt", OnAfterPostedWhseRcptHeaderInsert, '', false, false)]
    local procedure OnAfterPostedWhseRcptHeaderInsert(
        var PostedWhseReceiptHeader: Record "Posted Whse. Receipt Header";
        WarehouseReceiptHeader: Record "Warehouse Receipt Header")
    begin
        PostedWhseReceiptHeader."Sales Type" := WarehouseReceiptHeader."Sales Type";
        PostedWhseReceiptHeader."Requisition Purpose" := WarehouseReceiptHeader."Requisition Purpose";
        PostedWhseReceiptHeader."Part Requisition Form" := WarehouseReceiptHeader."Part Requisition Form";
        PostedWhseReceiptHeader."Expected RDC Return Date" := WarehouseReceiptHeader."Expected RDC Return Date";
        PostedWhseReceiptHeader."Port Code" := WarehouseReceiptHeader."Port Code";
        PostedWhseReceiptHeader.Modify();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnAfterInsertTransShptHeader', '', false, false)]
    local procedure OnAfterInsertTransShptHeader(
        var TransferShipmentHeader: Record "Transfer Shipment Header";
        TransferHeader: Record "Transfer Header")
    begin
        TransferShipmentHeader."Sales Type" := TransferHeader."Sales Type";
        TransferShipmentHeader."Requisition Purpose" := TransferHeader."Requisition Purpose";
        TransferShipmentHeader."Part Requisition Form" := TransferHeader."Part Requisition Form";
        TransferShipmentHeader."Expected RDC Return Date" := TransferHeader."Expected RDC Return Date";
        TransferShipmentHeader.Customer_Name := TransferHeader.Customer_Name;
        TransferShipmentHeader."Service Persion ID" := TransferHeader."Service Persion ID";
        TransferShipmentHeader.Note := TransferHeader.Note;
        TransferShipmentHeader."Value Declaration" := TransferHeader."Value Declaration";
        //TBC-1016 --->
        TransferShipmentHeader."Customer No." := TransferHeader."Customer No.";
        TransferShipmentHeader."Contact Name" := TransferHeader."Contact Name";
        //TBC-1016 <----
        TransferShipmentHeader.Modify();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", 'OnAfterInsertTransRcptHeader', '', false, false)]
    local procedure CopyCustomFieldsToTransferReceiptHeader(var TransHeader: Record "Transfer Header";
    var TransRcptHeader: Record "Transfer Receipt Header")
    begin
        TransRcptHeader."Sales Type" := TransHeader."Sales Type";
        TransRcptHeader."Requisition Purpose" := TransHeader."Requisition Purpose";
        TransRcptHeader."Part Requisition Form" := TransHeader."Part Requisition Form";
        TransRcptHeader."Expected RDC Return Date" := TransHeader."Expected RDC Return Date";
        //TBC-1016 --->
        TransRcptHeader."Customer No." := TransHeader."Customer No.";
        TransRcptHeader."Contact Name" := TransHeader."Contact Name";
        //TBC-1016 <---
        TransRcptHeader.Modify();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterInsertShipmentHeader', '', false, false)]
    local procedure OnAfterInsertShipmentHeader(var SalesHeader: Record "Sales Header"; var SalesShipmentHeader: Record "Sales Shipment Header")
    begin
        SalesShipmentHeader."AMC Order" := SalesHeader."AMC Order";
        SalesShipmentHeader."CMC Order" := SalesHeader."CMC Order";
        SalesShipmentHeader."Service Order" := SalesHeader."Service Order";
        SalesShipmentHeader."Claim Order" := SalesHeader."Claim Order";
        SalesShipmentHeader.ORCInstrument := SalesHeader.ORCInstrument;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterInsertInvoiceHeader', '', false, false)]
    local procedure OnAfterInsertInvoiceHeader(var SalesInvHeader: Record "Sales Invoice Header"; var SalesHeader: Record "Sales Header")
    begin
        SalesInvHeader."AMC Order" := SalesHeader."AMC Order";
        SalesInvHeader."CMC Order" := SalesHeader."CMC Order";
        SalesInvHeader."Service Order" := SalesHeader."Service Order";
        SalesInvHeader."Claim Order" := SalesHeader."Claim Order";
        SalesInvHeader.ORCInstrument := SalesHeader.ORCInstrument;
    end;

    // updating Custom ship-to as per ship-to and vise versa
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Customer Mgt.", OnAfterCalculateShipBillToOptions, '', false, false)]
    local procedure OnAfterCalculateShipBillToOptions(var ShipToOptions: Enum "Sales Ship-to Options"; SalesHeader: Record "Sales Header")
    begin
        ShipToOptions := SalesHeader."Custom Ship-to";
    end;

    [EventSubscriber(ObjectType::Page, Page::"Warehouse Receipt", OnBeforeActionEvent, 'Post Receipt', true, true)]
    local procedure OnBeforeActionEventWarehouseReceipt(var Rec: Record "Warehouse Receipt Header")
    begin
        if Rec."No." = '' then
            exit;

        // Apply validation ONLY for Import
        if Rec."Purchase Type" = Rec."Purchase Type"::Import then
            Rec.TestField("Port Code");
    end;
}