pageextension 50102 "Sales Order Ext" extends "Sales Order"
{
    layout
    {
        addlast(General)
        {
            field("Custom Amount (LCY)"; Rec."Custom Amount (LCY)")
            {
                ApplicationArea = All;
                Caption = 'Custom Amount(LCY)';
                ToolTip = 'Specifies the quantity to ship amount';
                Editable = false;
            }
            group("SGN Signature Group")
            {
                usercontrol("SGN SGNSignaturePad"; "SGN SGNSignaturePad")
                {
                    ApplicationArea = All;
                    Visible = true;
                    trigger Ready()
                    begin
                        CurrPage."SGN SGNSignaturePad".InitializeSignaturePad();
                    end;

                    trigger Sign(Signature: Text)
                    begin
                        Rec.SignDocument(Signature);
                        CurrPage.Update();
                    end;
                }

            }
            field("SGN Signature"; Rec."SGN Signature")
            {
                Caption = 'Customer Signature';
                ApplicationArea = All;
                Editable = false;
            }
        }
    }

    actions
    {
        addlast(processing)
        {
            action(ReminderEmail)
            {
                ApplicationArea = All;
                Caption = 'Reminder email';
                Image = Email;
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    code: Codeunit SendAutoEmailWithHtmlbody;
                begin
                    code.ConformingEmail(rec);
                end;
            }
            action(DeleteSign)
            {
                ApplicationArea = All;
                Caption = 'Delete Signature';
                Image = Signature;
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    SHeader: Record "Sales Header";
                begin
                    // SHeader.SetRange("No.",Rec."No.");
                    // if SHeader.FindFirst() then begin
                    Clear(Rec."SGN Signature");
                    Rec.Modify(true);
                    // end;
                end;
            }
        }
    }
    trigger OnOpenPage()
    var
        SLine: Record "Sales Line";
        data: Text;
        msg: Text;
        text: Text;
    begin
        SLine.SetRange("Document No.", Rec."No.");
        SLine.SetRange("Document Type", Rec."Document Type");
        if SLine.FindSet() then begin
            // data := Format(SLine."Unit Price");
            data := Format(SLine."Unit Price", 0, '<Integer><Decimals>');
            text := Format(Round(SLine."Unit Price", 100, '='));
            msg := PadStr('', 19 - StrLen(text), '0') + data;
            Message(msg);
        end;
    end;
}
