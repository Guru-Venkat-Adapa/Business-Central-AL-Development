pageextension 50017 SalesOrderArchive extends "Sales Order Archive"
{
    layout
    {
        addafter("No.")
        {
            field("Sales Order Type"; Rec."Sales Order Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Sales Order Type field.';
            }
        }
        modify("External Document No.")
        {
            Caption = 'Customer PO No.';
        }
        addafter(General)
        {
            group("Spares")
            {
                Caption = 'Spares';
                ///Visible = Rec."Sales Order Type" = 'Spares/Tools Order';
                Visible = Rec."Spare Order";
                group("SpareGeneral")
                {
                    Caption = '';

                    field("CRM Quote No."; Rec."CRM Quote No.")
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Caption = 'CRM Quote No.';
                        ToolTip = 'Specifies the value of the CRM Quote No. field.';
                    }
                    field("Quotation Date"; Rec."Quotation Date")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Quotation Date field.';
                    }
                    field("Reference Number"; Rec."Reference Number")
                    {
                        ApplicationArea = All;
                        Caption = 'Reference Number';
                        ToolTip = 'Specifies the value of the Reference Number field.';
                    }
                    field("Delivery Term"; Rec."Delivery Term")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Delivery Term';
                        ToolTip = 'Specifies the value of the Delivery Term field.';
                    }
                    field("Freight Terms"; Rec."Freight Terms")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Freight Term';
                        ToolTip = 'Specifies the value of the Freight Terms field.';
                    }
                }
                group(SpareGeneral1)
                {
                    Caption = '';
                    field("CRM Employee ID 1"; Rec."CRM Employee ID 1")
                    {
                        ApplicationArea = All;
                        Caption = 'Service Person ID';
                        ToolTip = 'Specifies the value of the CRM Employee ID 1 field.';
                    }
                    field("CRM Employee ID 2"; Rec."CRM Employee ID 2")
                    {
                        ApplicationArea = All;
                        Caption = 'Authorized Person ID';
                        ToolTip = 'Specifies the value of the CRM Employee ID 2 field.';
                    }

                    field("RDC No"; Rec."RDC No")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'RDC No.';
                        ToolTip = 'Specifies the value of the RDC No. field.';
                    }
                    field("RDC Date"; Rec."RDC Date")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'RDC Date';
                        ToolTip = 'Specifies the value of the RDC Date field.';
                    }

                    field("Customer PO No."; Rec."Customer PO No.")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Customer PO No. field.';
                    }
                    field("Customer PO Date"; Rec."Customer PO Date")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Customer PO Date field.';
                    }
                }
                group(SpareGenrral2)
                {
                    Caption = '';
                    field("Key/Non-Key"; Rec."Key/Non-Key")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Key/Non-Key field.';
                    }
                    field("KEY/NON KEY(Principal Wise)"; Rec."KEY/NON KEY(Principal Wise)")
                    {
                        ApplicationArea = All;
                        Caption = 'KEY/NON KEY(Principal Wise)';
                        ToolTip = 'Specifies the value of the KEY/NON KEY(Principal Wise) field.';
                    }

                    field("Advance Rec. Amt."; Rec."Advance Rec. Amt.")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Advance Rec. Amt. field.';
                        DecimalPlaces = 2;
                        Editable = false;
                    }
                    field("Approval Ref"; Rec."Approval Ref")
                    {
                        ApplicationArea = All;
                        Caption = 'Approval Reference';
                        ToolTip = 'Specifies the value of the Approval Reference field.';
                    }
                    field("Special Instruction"; Rec."Special Instruction")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Special Instruction';
                        ToolTip = 'Specifies the value of the Special Instruction field.';
                        MultiLine = true;
                    }
                    field("Special Remark-Sez"; Rec."Special Remark-Sez")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Special Remark-Sez';
                        ToolTip = 'Specifies the value of the Special Remark-Sez field.';
                        MultiLine = true;
                    }
                    field("Discount Type"; Rec."Discount Type")
                    {
                        ApplicationArea = All;
                        Caption = 'Discount Type';
                        ToolTip = 'Specifies the value of the Discount Type field.';
                    }
                }
            }
            group(Instrument)
            {
                Caption = 'General-2';
                Visible = Rec."Instrument Order";
                group("Instrument1")
                {
                    Caption = '';

                    field("CRM No."; Rec."CRM Quote No.")
                    {
                        Caption = 'CRM No.';
                        ApplicationArea = All;

                    }
                    field("PO No."; Rec."Customer PO No.")
                    {
                        Caption = 'PO No.';
                        ApplicationArea = All;
                    }
                    field("PO Date"; Rec."Customer PO Date")
                    {
                        Caption = 'PO Date';
                        ApplicationArea = All;
                    }
                    field("Business Sector"; Rec."Business Sector")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Business Sector';
                        ToolTip = 'Specifies the value of the Business Sector field.';
                    }
                    field("Inr. Special Instruction"; Rec."Special Instruction")
                    {
                        ApplicationArea = ALL;
                        ToolTip = 'Specifies the value of the Packing & Forwarding field.';
                        Caption = 'Any Specific Instructions';
                        MultiLine = true;
                    }
                    field("Service Remark"; Rec."Service Remark")
                    {
                        ApplicationArea = ALL;
                        ToolTip = 'Specifies the value of the Service Remark field.';
                        MultiLine = true;
                    }
                }
                group(ExecutiveMaster)
                {
                    Caption = 'Executive Master';
                    field("Executive Master"; Rec."Executive Master")
                    {
                        ApplicationArea = All;
                        Caption = 'Executive Master 1';
                        ToolTip = 'Specifies the value of the executive masater field.';

                    }
                    field("Share Of Exe Master"; Rec."Share Of Exe Master")
                    {
                        ApplicationArea = All;
                        Caption = 'Executive Master 1%';
                        ToolTip = 'Specifies the value of the share of Executive Master 1 field.';

                    }
                    field("Executive Master2"; Rec."Executive Master2")
                    {
                        ApplicationArea = All;
                        Caption = 'Executive Master 2';
                        ToolTip = 'Specifies the value of the Executive Master 2 field.';

                    }
                    field("Share Of Exe Master2"; Rec."Share Of Exe Master2")
                    {
                        ApplicationArea = All;
                        Caption = 'Executive Master 2%';
                        ToolTip = 'Specifies the value of the share of Executive Master 2% field.';

                    }
                    field("Executive Master3"; Rec."Executive Master3")
                    {
                        ApplicationArea = All;
                        Caption = 'Executive Master 3';
                        ToolTip = 'Specifies the value of the Executive Master 3 field.';

                    }
                    field("Share Of Exe Master3"; Rec."Share Of Exe Master3")
                    {
                        ApplicationArea = All;
                        Caption = 'Executive Master 3%';
                        ToolTip = 'Specifies the value of the share of Executive Master 3% field.';

                    }
                    field("Executive Master4"; Rec."Executive Master4")
                    {
                        ApplicationArea = All;
                        Caption = 'Executive Mater 4';
                        ToolTip = 'Specifies the value of the Executive Master 4 field.';

                    }
                    field("Share Of Exe Master4"; Rec."Share Of Exe Master4")
                    {
                        ApplicationArea = All;
                        Caption = 'Executive Master 4%';
                        ToolTip = 'Specifies the value of the share of Executive Master 4% field.';

                    }
                }
            }
        }
    }
}
