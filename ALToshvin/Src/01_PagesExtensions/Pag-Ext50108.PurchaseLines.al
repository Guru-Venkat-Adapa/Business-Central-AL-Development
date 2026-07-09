pageextension 50108 "Purchase Lines" extends "Purchase Lines"
{
    layout
    {
        // TBC-1046 ---->
        addafter("Document No.")
        {
            field("Order Date"; Rec."Order Date")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }

        addafter("Buy-from Vendor Name")
        {
            field(AssignedUserID; AssignedUserID)
            {
                ApplicationArea = All;
                Caption = 'Assigned User ID';
                Editable = false;
            }
            field(FolioNo; FolioNo)
            {
                ApplicationArea = All;
                Caption = 'Folio No.';
                Editable = false;
            }
        }
        modify("Purchasing Code")
        {
            Visible = true;
        }

        moveafter("Unit of Measure Code"; "Purchasing Code")

        addafter("Purchasing Code")
        {
            field("Special Order Sales No."; Rec."Special Order Sales No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field(TrackingQtyBase; TrackingQtyBase)
            {
                ApplicationArea = All;
                Caption = 'Item Tracking Qty';
                Editable = false;
            }
        }
        // TBC-1046 <----

        //TBC-1057 -->
        addafter("Shortcut Dimension 1 Code")
        {
            field(DepartmentName; DepartmentName)
            {
                ApplicationArea = All;
                Caption = 'Department Name';
                Editable = false;
            }
        }
        addafter("Shortcut Dimension 2 Code")
        {
            field(RegionName; RegionName)
            {
                ApplicationArea = All;
                Caption = 'Region Name';
                Editable = false;
            }
        }
        //TBC-1057 <--
    }

    trigger OnAfterGetRecord()
    begin
        Clear(AssignedUserID);
        Clear(FolioNo);
        Clear(TrackingQtyBase);

        //TBC-1057 --->
        Clear(RegionName);
        Clear(DepartmentName);
        Clear(TeamsName);
        //TBC-1057 <---

        if PurchaseHeader.Get(Rec."Document Type", Rec."Document No.") then begin
            AssignedUserID := PurchaseHeader."Custom Assigned User ID";
            FolioNo := PurchaseHeader."Folio No.";

            //TBC-1057 --->
            Dimension.Reset();
            Dimension.SetRange(Code, PurchaseHeader."Shortcut Dimension 1 Code");
            if Dimension.FindFirst() then
                DepartmentName := Dimension.Name;

            Dimension.Reset();
            Dimension.SetRange(Code, PurchaseHeader."Shortcut Dimension 2 Code");
            if Dimension.FindFirst() then
                RegionName := Dimension.Name;
            //TBC-1057 <---

        end;

        if Rec."No." <> '' then begin
            ReservationEntry.Reset();
            ReservationEntry.SetRange("Source Type", Database::"Purchase Line");
            ReservationEntry.SetRange("Source Subtype", Rec."Document Type".AsInteger());
            ReservationEntry.SetRange("Source ID", Rec."Document No.");
            ReservationEntry.SetRange("Source Ref. No.", Rec."Line No.");
            ReservationEntry.SetRange("Item No.", Rec."No.");
            ReservationEntry.SetFilter("Quantity (Base)", '>%1', 0);
            if ReservationEntry.FindSet() then
                repeat
                    TrackingQtyBase += ReservationEntry."Quantity (Base)";
                until ReservationEntry.Next() = 0;
        end;

    end;

    var
        PurchaseHeader: Record "Purchase Header";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        ReservationEntry: Record "Reservation Entry";
        AssignedUserID: Text;
        FolioNo: Code[100];
        TrackingQtyBase: Decimal;
        Dimension: Record "Dimension Value";
        RegionName: Text;
        DepartmentName: Text;
        TeamsName: Text;

}
