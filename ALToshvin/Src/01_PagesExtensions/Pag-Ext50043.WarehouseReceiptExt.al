pageextension 50043 "Warehouse Receipt Ext" extends "Warehouse Receipt"
{
    layout
    {
        modify("Location Code")
        {
            Caption = 'Warehouse Code';
        }
        addbefore("Location Code")
        {
            field("Sales Type"; Rec."Sales Type")
            {
                Caption = 'Sales Type';
                ApplicationArea = All;
                ShowMandatory = true;
            }
        }
        addlast(General)
        {
            field("Requisition Purpose"; Rec."Requisition Purpose")
            {
                ApplicationArea = All;
                Caption = 'Requisition Purpose';
            }
            field("Part Requisition Form"; Rec."Part Requisition Form")
            {
                ApplicationArea = All;
                Caption = 'Part Requisition Form';
            }
            field("Expected RDC Return Date"; Rec."Expected RDC Return Date")
            {
                ApplicationArea = All;
                Caption = 'Expected RDC Return Date';
            }
            field("Carriage Name"; Rec."Carriage Name")
            {
                ApplicationArea = All;
                Caption = 'Carriage Name';
            }
            field("Mode Of Shipment"; Rec."Mode Of Shipment")
            {
                ApplicationArea = All;
                Caption = 'Mode Of Shipment';
            }
            field("Pre carriage By"; Rec."Pre carriage By")
            {
                ApplicationArea = All;
                Caption = 'Pre Carriage By';
            }
            field("Follo Number Master"; Rec."Follo Number Master")
            {
                ApplicationArea = All;
                Caption = 'Follo Number Master';
            }
            field("AWB No."; Rec."AWB No.")
            {
                ApplicationArea = All;
                Caption = 'AWB No.';
            }
            field("AWB Date"; Rec."AWB Date")
            {
                ApplicationArea = All;
                Caption = 'AWB Date';
            }
            field("Bill of Entry No."; Rec."Bill of Entry No.")
            {
                ApplicationArea = All;
                Caption = 'Bill of Entry No.';
            }
            field("Bill of Entry Date"; Rec."Bill of Entry Date")
            {
                ApplicationArea = All;
                Caption = 'Bill of Entry Date';
            }
            field("Vendor Bill No."; Rec."Vendor Bill No.")
            {
                ApplicationArea = All;
                Caption = 'Vendor Bill No.';
            }
            field("Vendor Bill Date"; Rec."Vendor Bill Date")
            {
                ApplicationArea = All;
                Caption = 'Vendor Bill Date';
            }
            field("BL No."; Rec."BL No.")
            {
                ApplicationArea = All;
                Caption = 'BL No.';
            }
            field("BL Date"; Rec."BL Date")
            {
                ApplicationArea = All;
                Caption = 'BL Date';
            }
            field("Gross Weight"; Rec."Gross Weight")
            {
                ApplicationArea = All;
                Caption = 'Gross Weight';
            }
            field("Net Weight"; Rec."Net Weight")
            {
                ApplicationArea = All;
                Caption = 'Net Weight';
            }


            field("Purchase Type"; Rec."Purchase Type")
            {
                ApplicationArea = All;

                trigger OnValidate()
                begin
                    CurrPage.Update(false);   // Refresh page
                end;
            }
            group("GRN")
            {
                Caption = '';
                Visible = Rec."Purchase Type" = Rec."Purchase Type"::Import;

                field("Port Code"; Rec."Port Code")
                {
                    ApplicationArea = All;
                    Caption = 'Port Code';
                    ShowMandatory = true;
                }
                field("Exchange Rate"; Rec."Exchange Rate")
                {
                    ApplicationArea = All;
                }
                field(Insurance; Rec.Insurance)
                {
                    ApplicationArea = All;
                }
                field(Freight; Rec.Freight)
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                        WhseReceiptLine: Record "Warehouse Receipt Line";
                        TotalAmountINR: Decimal;
                    begin
                        TotalAmountINR := 0;

                        WhseReceiptLine.Reset();
                        WhseReceiptLine.SetRange("No.", Rec."No.");
                        // If Freight = 0 → Clear all line freight
                        if Rec.Freight = 0 then begin
                            if WhseReceiptLine.FindSet() then
                                repeat
                                    WhseReceiptLine.Validate("Freight Charges", 0);
                                    WhseReceiptLine.Modify(false);
                                until WhseReceiptLine.Next() = 0;
                            exit;
                        end;

                        // Calculate total Amount INR
                        WhseReceiptLine.Reset();
                        WhseReceiptLine.SetRange("No.", Rec."No.");
                        if WhseReceiptLine.FindSet() then
                            repeat
                                TotalAmountINR += WhseReceiptLine."Amount INR";
                            until WhseReceiptLine.Next() = 0;

                        if TotalAmountINR = 0 then
                            exit;

                        // Distribute proportionally (no rounding)
                        WhseReceiptLine.Reset();
                        WhseReceiptLine.SetRange("No.", Rec."No.");
                        WhseReceiptLine.FindSet();
                        repeat
                            WhseReceiptLine.Validate("Freight Charges",
                                (Rec.Freight * WhseReceiptLine."Amount INR") / TotalAmountINR);
                            WhseReceiptLine.Modify(false);
                        until WhseReceiptLine.Next() = 0;
                    end;
                }
                field("Misc Charges"; Rec."Misc Charges")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                        WhseReceiptLine: Record "Warehouse Receipt Line";
                        TotalAmountINR: Decimal;
                    begin
                        TotalAmountINR := 0;

                        WhseReceiptLine.Reset();
                        WhseReceiptLine.SetRange("No.", Rec."No.");
                        // If Freight = 0 → Clear all line freight
                        if Rec.Freight = 0 then begin
                            if WhseReceiptLine.FindSet() then
                                repeat
                                    WhseReceiptLine.Validate("Misc Charges", 0);
                                    WhseReceiptLine.Modify(false);
                                until WhseReceiptLine.Next() = 0;
                            exit;
                        end;

                        // Calculate total Amount INR
                        WhseReceiptLine.Reset();
                        WhseReceiptLine.SetRange("No.", Rec."No.");
                        if WhseReceiptLine.FindSet() then
                            repeat
                                TotalAmountINR += WhseReceiptLine."Amount INR";
                            until WhseReceiptLine.Next() = 0;

                        if TotalAmountINR = 0 then
                            exit;

                        // Distribute proportionally (no rounding)
                        WhseReceiptLine.Reset();
                        WhseReceiptLine.SetRange("No.", Rec."No.");
                        WhseReceiptLine.FindSet();
                        repeat
                            WhseReceiptLine.Validate("Misc Charges",
                                (Rec."Misc Charges" * WhseReceiptLine."Amount INR") / TotalAmountINR);
                            WhseReceiptLine.Modify(false);
                        until WhseReceiptLine.Next() = 0;
                    end;
                }
            }
        }
    }
}

