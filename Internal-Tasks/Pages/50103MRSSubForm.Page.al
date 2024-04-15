page 50103 "MRS Subform"
{
    PageType = ListPart;
    // ApplicationArea = basic;
    // UsageCategory = Lists;
    SourceTable = MRSLine;
    Caption = 'MRS Subform Page';
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(MRSLine)
            {
                field("MRS Type"; Rec."SIT_MRS Type")
                {
                    ApplicationArea = basic;
                    Caption = 'MRS Type';
                    ToolTip = 'Specifies the value of the MRS Type field';
                }
                field(Type; Rec.SIT_Type)
                {
                    ApplicationArea = basic;
                    Caption = 'Type';
                    ToolTip = 'specifies the value of the Type field';
                    ShowMandatory = true;
                }
                field("Item Category Code"; Rec."SIT_Item Category Code")
                {
                    Caption = 'Item Category Code';
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Item Category Code field';
                }
                field("No."; Rec."SIT_No.")
                {
                    ApplicationArea = basic;
                    Caption = 'No.';
                    ToolTip = 'Specifies the value of the No. field';
                    ShowMandatory = true;
                }
                field(Description; Rec.SIT_Description)
                {
                    ApplicationArea = basic;
                    Caption = 'Description';
                    ToolTip = 'Specifies the value of the Description field';
                    ShowMandatory = true;
                }
                field("Description 2"; Rec.SIT_Description2)
                {
                    ApplicationArea = basic;
                    Caption = 'Description 2';
                    ToolTip = 'Specifies the value of the Description 2 field';
                }
                field("Location Code"; Rec."SIT_Location Code")
                {
                    ApplicationArea = basic;
                    Caption = 'Location Code';
                    ToolTip = 'Specifies the value of the Location Code field';
                }
                field("Unit of Measure Code"; Rec."SIT_Unit of Measure Code")
                {
                    ApplicationArea = basic;
                    Caption = 'Unit of Measure Code';
                    ToolTip = 'Specifies the value of the Unit of Measure Code field';
                }
                field("Quantity"; Rec."SIT_Quantity")
                {
                    ApplicationArea = basic;
                    Caption = 'Quantity';
                    ToolTip = 'Specifies the value of the Quantity field';
                    BlankZero = true;
                    ShowMandatory = true;
                }
                field("Unit Cost"; Rec."SIT_Unit Cost")
                {
                    ApplicationArea = basic;
                    Caption = 'Unit Cost';
                    ToolTip = 'Specifies the value of the Unit Cost field';
                    BlankZero = true;
                    ShowMandatory = true;
                }

                field("Line Amount(LCY)"; Rec."SIT_Line Amount(LCY)")
                {
                    ApplicationArea = basic;
                    Caption = 'Line Amount (LCY)';
                    ToolTip = 'Specifies the value of the Line Amount (LCY) field';
                    BlankZero = true;
                    ShowMandatory = true;
                }
                field("Available Stock"; Rec."SIT_Available Stock")
                {
                    ApplicationArea = basic;
                    Caption = 'Available Stock';
                    ToolTip = 'Specifies the value of the Available Stock field';
                    BlankZero = true;
                    // ShowMandatory = true;
                }
                field("Expected Delivery Date"; Rec."SIT_Expected Delivery Date")
                {
                    ApplicationArea = basic;
                    Caption = 'Expected Delivery Date';
                    ToolTip = 'Specifies the value of the Expected Delivery Date field';
                }
                field("FA No."; Rec."SIT_FA No.")
                {
                    ApplicationArea = basic;
                    Caption = 'FA No.';
                    ToolTip = 'Specifies the value of the FA No. field';
                }
                field("FA Posting Type"; Rec."SIT_FA Posting Type")
                {
                    ApplicationArea = basic;
                    Caption = 'FA Posting Type';
                    ToolTip = 'Specifies the value of the FA Posting Type field';
                }
                field("Maintenance Code"; Rec."SIT_Maintenance Code")
                {
                    ApplicationArea = basic;
                    Caption = 'Maintenance Code';
                    ToolTip = 'Specifies the value of the Maintenance Code field';
                }
                field("Requisition Division"; Rec."SIT_Shortcut Dimension 1 Code")
                {
                    ApplicationArea = basic;
                    Caption = 'Requisition Division';
                    ToolTip = 'Specifies the value of the Requisition Division field';
                }
                field("Requistion Department"; Rec."SIT_Shortcut Dimension 2 Code")
                {
                    ApplicationArea = basic;
                    Caption = 'Requistion Department';
                    ToolTip = 'Specifies the value of the Requistion Department field';
                }
                field(Comment; Rec.SIT_Comment)
                {
                    ApplicationArea = basic;
                    Caption = 'Comment';
                    ToolTip = 'Specifies the value of the Comment field';
                }
                field(Status; Rec.SIT_Status)
                {
                    ApplicationArea = basic;
                    Caption = 'Status';
                    ToolTip = 'Specifies the value of the Status field';
                }
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if (rec."SIT_Document No." = '') then begin
            rec."SIT_Document No." := xRec."SIT_Document No.";
            rec.Modify(true);
        end;
    end;
}