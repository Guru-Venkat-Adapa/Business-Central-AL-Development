page 50100 "MRS List Page"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = MRSHeader;
    Caption = 'MRS List Page';
    CardPageId = "MRS Card Page";

    layout
    {
        area(Content)
        {
            repeater(Comtrol)
            {
                field("MRS No."; Rec."SIT_MRS No.")
                {
                    Caption = 'MRS No.';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the MRS No. field';
                }
                field("Date of MRS"; Rec."SIT_Date of MRS")
                {
                    Caption = 'Date of MRS';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date of MRS field';
                }
                field("Manual MRS No."; Rec."SIT_Manual MRS No.")
                {
                    Caption = 'Manual MRS No.';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Manual MRS No. field';
                }
                field("Location Code"; Rec."SIT_Location Code")
                {
                    Caption = 'Location Code';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Location Code field';
                }
                field("Issued Date"; Rec."SIT_Issued Date")
                {
                    Caption = 'Issued Date';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Issued Date field';
                }
                field("Expected Delivery Date"; Rec."SIT_Expected Delivery Date")
                {
                    Caption = 'Expected Delivery Date';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Expected Delivery Date field';
                }
                field("Shortcut Dimension 1 Code"; Rec."SIT_Requistion Division")
                {
                    Caption = 'Shortcut Dimension 1 Code';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Requisition Division field';
                }
                field("Shortcut Dimension 2 Code"; Rec."SIT_Requistion Department")
                {
                    Caption = 'Shortcut Dimension 2 Code';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Requisition Department field';
                }
                field(Status; Rec.SIT_Status)
                {
                    Caption = 'Status';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field';
                }
                field(Comment; Rec.SIT_Comment)
                {
                    Caption = 'Comment';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Comment field';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(deleteOrphan)
            {
                ApplicationArea = All;
                Caption = 'Delete Orphan';
                Image = DeleteOrphan;

                trigger OnAction()
                var
                    line: Record "MRSLine";
                begin

                    line.SetFilter("SIT_Document No.", '');
                    line.SetRange("SIT_Line No.", 20000);
                    if line.FindSet() then begin
                        Message('%1 %2 ', line."SIT_No.", line.SIT_Description);
                        line.DeleteAll();
                    end;
                end;
            }
        }
    }

    var
        myInt: Integer;
}