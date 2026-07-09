page 50046 "TripGain Integration Log"
{
    ApplicationArea = All;
    Caption = 'TripGain Integration Log';
    PageType = List;
    SourceTable = "TripGain Voucher Header";
    CardPageID = "Integration Logs";
    UsageCategory = Lists;
    RefreshOnActivate = true;
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = true;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }
                field("Payment Method"; Rec."Payment Method")
                {
                    ApplicationArea = All;
                }
                field("Status"; Rec.Status)
                {
                    ApplicationArea = All;

                }
                field("Input JSON"; JsonText)
                {
                    ApplicationArea = All;
                }
                field("BC Journal Completed"; Rec."BC Journal Completed")
                {
                    ApplicationArea = All;
                }
                field("Error Message"; Rec."Error Message")
                {
                    ApplicationArea = All;
                }
                field("G/L Posted"; Rec."G/L Posted")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(GenerateBCJournal)
            {
                ApplicationArea = All;
                Caption = 'Delete Log';
                Image = Delete;

                trigger OnAction()
                var
                    VoucherLine: Record "TripGain Voucher Line";
                begin
                    if Confirm('Do you want to delete the selected record?', false) then begin
                        VoucherLine.SetRange("Entry No.", Rec."Entry No."); // Adjust key field
                        VoucherLine.DeleteAll();

                        Rec.Delete(true);
                    end;
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        InStr: InStream;
    begin
        Clear(JsonText);
        Rec.CalcFields("Input JSON");

        if Rec."Input JSON".HasValue then begin
            Rec."Input JSON".CreateInStream(InStr);
            InStr.ReadText(JsonText);
        end;
    end;


    var
        JsonText: Text;
}
