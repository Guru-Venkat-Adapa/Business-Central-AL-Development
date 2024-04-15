codeunit 50106 "MRS Actions"
{
    procedure CreatePRSbyMRS(Rec: Record MRSHeader)
    var
        MRSLine: Record MRSLine;
        PurchaseDoc: Page "PRS Card";
        PurcahseOrderNo: Code[20];
        PRSHeader: Record "PRS Header";
        PRSLIne: Record "PRS Line";
        Check: Boolean;
    begin
        if Rec.SIT_Status = Rec.SIT_Status::Released then begin
            PRSHeader.Reset();
            MRSLine.SetRange("SIT_Document No.", Rec."SIT_MRS No.");
            if MRSLine.FindSet() then begin
                repeat
                    if MRSLine."SIT_Available Stock" < MRSLine.SIT_Quantity then begin
                        Check := true;
                    end;
                until MRSLine.Next() = 0;
            end;
            if not Check then exit;
            if Rec."SIT_Purch. Req. Ref. No." = '' then begin

                PRSHeader.Init();
                PRSHeader."Shortcut Dim 1 Code" := Rec."SIT_Requistion Division";
                PRSHeader."Shortcut Dim 2 Code" := Rec."SIT_Requistion Department";
                PRSHeader.Comment := Rec.SIT_Comment;
                PRSHeader."Project Stage Code" := Rec."SIT_Project Stage Code";
                PRSHeader."Document Date" := System.Today();
                PRSHeader."Posting Date" := System.Today();
                PRSHeader.Status := Rec."SIT_Status";
                PurcahseOrderNo := PRSHeader."No.";
                PRSHeader."Project Ref. No." := rec."SIT_MRS No.";
                PRSHeader."Dimension Set ID" := Rec."SIT_Dimension Setup ID";
                PRSHeader.Insert(true);
                Rec.Modify(true);

                MRSLine.SetRange("SIT_Document No.", Rec."SIT_MRS No.");
                if MRSLine.FindSet() then begin
                    repeat
                        if MRSLine."SIT_Available Stock" < MRSLine.SIT_Quantity then begin
                            PRSLIne.Init();
                            PRSLIne."Documnet No." := PRSHeader."No.";
                            PRSLIne."Line No." := MRSLine."SIT_Line No.";
                            PRSLIne.Type := MRSLine.SIT_Type;
                            PRSLIne."No." := MRSLine."SIT_No.";
                            PRSLIne.Description := MRSLine.SIT_Description;
                            PRSLIne."Unit of Measure Code" := MRSLine."SIT_Unit of Measure Code";
                            PRSLIne."Unit Price" := MRSLine."SIT_Unit Cost";
                            PRSLIne."Requested Quantity" := MRSLine.SIT_Quantity;
                            PRSLIne."Qty to Order" := MRSLine.SIT_Quantity - MRSLine."SIT_Available Stock";
                            PRSLIne."Expected Delivery Date" := Rec."SIT_Expected Delivery Date";
                            PRSLIne."Avaliable Stock" := MRSLine."SIT_Available Stock";
                            PRSLIne.Comment := MRSLine.SIT_Comment;
                            PRSLIne."MRS No." := Rec."SIT_MRS No.";
                            PRSLIne."Shortcut Dimension 1 Code" := MRSLine."SIT_Shortcut Dimension 1 Code";
                            PRSLIne."Shortcut Dimension 2 Code" := MRSLine."SIT_Shortcut Dimension 2 Code";
                            PRSLIne.Insert(true);
                            MRSLine."SIT_PRS Created" := true;
                            MRSLine.Modify(true);
                        end;
                    until MRSLine.Next() = 0;
                end;
                Clear(PurchaseDoc);
                PurchaseDoc.SetTableView(PRSHeader);
                PurchaseDoc.SetRecord(PRSHeader);
                PurchaseDoc.Run();
            end else
                Message('Already an existdocument is present for this Mrs No. %1', Rec."SIT_MRS No.");
        end else
            Error('Status is not in relaese form');
    end;

    procedure CreatePObyPRS(var Rec: Record "PRS Header")
    var
        PRSLine: Record "PRS Line";
        TempPRSLine: Record "PRS Line";
        PurchaseHeaderCode: Code[20];
    begin
        if Confirm('Do you want to create the Purchase Order?') then begin
            if Rec.Status = Rec.Status::Released then begin
                PRSLine.Reset();
                PRSLine.SetRange(PRSLine."Documnet No.", Rec."No.");
                if PRSLine.FindSet() then begin
                    repeat begin
                        if not (PRSLine.POCheck) then begin
                            TempPRSLine.Reset();
                            TempPRSLine.SetRange("Documnet No.", Rec."No.");
                            TempPRSLine.SetRange("Vendor No.", PRSLine."Vendor No.");
                            if TempPRSLine.FindSet() then begin
                                Clear(PurchaseHeaderCode);
                                PurchaseHeaderCode := CreatePurchaseHeader(PRSLine."Vendor No.", Rec."No.");
                                GetDimension(Rec);
                                repeat begin
                                    CreatePurchaseOrderLines(PurchaseHeaderCode, TempPRSLine);
                                    TempPRSLine.POCheck := true;
                                    TempPRSLine.Modify(true);
                                end until TempPRSLine.Next() = 0;
                            end;
                            Rec.Modify(true);
                        end;
                    end until PRSLine.Next() = 0;
                end;
            end else begin
                Error('Status is not in released state');
            end;
        end;

    end;

    local procedure CreatePurchaseHeader(var VendorNo: Code[20]; PRSNo: Code[20]): Code[20]
    var
        PurchaseHeader: Record "Purchase Header";
        Rec: Record "PRS Header";
    begin
        PurchaseHeader.Init();
        PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Order;
        PurchaseHeader.Validate("Buy-from Vendor No.", VendorNo);
        PurchaseHeader."Vendor Invoice No." := PRSNo;
        PurchaseHeader."Shortcut Dimension 1 Code" := Rec."Shortcut Dim 1 Code";
        PurchaseHeader."Shortcut Dimension 2 Code" := Rec."Shortcut Dim 2 Code";
        PurchaseHeader.Insert(true);
        exit(PurchaseHeader."No.");
    end;


    local procedure CreatePurchaseOrderLines(var PurcahseOrderNo: Code[20]; var POLines: Record "PRS Line")
    var
        PurchaseLines: Record "Purchase Line";
    begin
        PurchaseLines.Init();
        PurchaseLines."Document No." := PurcahseOrderNo;
        PurchaseLines.Validate("Line No.", POLines."Line No.");
        PurchaseLines."Document Type" := PurchaseLines."Document Type"::Order;
        PurchaseLines.Validate(Type, POLines."Type");
        PurchaseLines.Validate("No.", POLines."No.");
        PurchaseLines.Validate("Buy-from Vendor No.", POLines."Vendor No.");
        PurchaseLines.Validate(Description, POLines."Description");
        PurchaseLines.Validate("Unit of Measure", POLines."Unit of Measure Code");
        PurchaseLines.Validate(Quantity, POLines."Qty to Order");
        PurchaseLines.Validate("Unit Cost (LCY)", POLines."Unit Price");
        PurchaseLines.Validate("Shortcut Dimension 1 Code", POLines."Shortcut Dimension 1 Code");
        PurchaseLines.Validate("Shortcut Dimension 2 Code", POLines."Shortcut Dimension 2 Code");
        PurchaseLines.Insert(true);
    end;

    procedure GetDimension(Rec: Record "PRS Header")
    var
        PRSHeader: Record "PRS Header";
        PO: Record "Purchase Header";
    begin
        Po.SetRange("Vendor Invoice No.", Rec."No.");
        if PO.FindSet() then begin
            PO."Shortcut Dimension 1 Code" := Rec."Shortcut Dim 1 Code";
            PO."Shortcut Dimension 2 Code" := Rec."Shortcut Dim 2 Code";
            PO.Modify(true);
        end;

    end;
}
