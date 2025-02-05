pageextension 50100 PaymentJournal extends "Payment Journal"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addlast(processing)
        {
            action(MultiDownload)
            {
                ApplicationArea = All;
                Caption = 'Multiple Downloads';
                ToolTip = 'to download multiples';
                Promoted = true;
                PromotedCategory = Category8;
                trigger OnAction()
                var
                    GenJouLine: Record "Gen. Journal Line";
                    Instr: InStream;
                    Outstr: OutStream;
                    TempBlob: Codeunit "Temp Blob";
                    FileName: Text;
                    Value: Text;
                    I: Integer;
                begin
                    I := 0;
                    GenJouLine.SetRange("Journal Template Name");
                    GenJouLine.SetRange("Journal Batch Name");
                    GenJouLine.SetRange("Line No.");
                    if GenJouLine.FindSet() then
                        repeat
                            if GenJouLine."Document Type" <> GenJouLine."Document Type"::" " then begin
                                FileName := 'payment_Journal-' + Format(I) + '.txt';
                                TempBlob.CreateOutStream(Outstr, TextEncoding::Windows);
                                Value := 'Posting Date: ' + Format(GenJouLine."Posting Date") + '; ' +
                                         'Document Type: ' + Format(GenJouLine."Document Type") + '; ' +
                                         'Document No.: ' + Format(GenJouLine."Document No.") + '; ' +
                                         'Account Type: ' + Format(GenJouLine."Account Type") + '; ' +
                                         'Account No: ' + Format(GenJouLine."Account No.") + '; ' +
                                         'Description: ' + Format(GenJouLine.Description) + '; ' +
                                         'Payment Method Code: ' + Format(GenJouLine."Payment Method Code") + '; ' +
                                         'Amount: ' + Format(GenJouLine.Amount) + '; ' +
                                         'Amount (LCY): ' + Format(GenJouLine."Amount (LCY)") + '; ' +
                                         'Bal. Account Type: ' + Format(GenJouLine."Bal. Account Type") + '; ' +
                                         'Bal. Account No.: ' + Format(GenJouLine."Bal. Account No.");
                                Outstr.WriteText(Value);
                                TempBlob.CreateInStream(Instr, TextEncoding::Windows);
                                DownloadFromStream(Instr, '', '', '', FileName);
                                I += 1;
                            end;
                        until GenJouLine.Next() = 0;
                end;

            }
        }
    }
    var
        test: Page "sales order";
        Sales: Page "Sales Order Subform";
}
// trigger OnAction()
// var
//     GenJouLine: Record "Gen. Journal Line";
//     Instr: InStream;
//     Outstr: OutStream;
//     TempBlob: Codeunit "Temp Blob";
//     FileName: Text;
//     value: Text;
//     I: Integer;
// begin
//     I := 0;
//     FileName := 'payment Journal';
//     // TempBlob.CreateOutStream(Outstr, TextEncoding::Windows);
//     GenJouLine.SetRange("Journal Template Name");
//     GenJouLine.SetRange("Journal Batch Name");
//     GenJouLine.SetRange("Line No.");
//     if GenJouLine.FindSet() then begin
//         repeat
//             if GenJouLine."Document Type" <> GenJouLine."Document Type"::" " then begin
//                 FileName := 'payment Journal' + Format(I);
//                  TempBlob.CreateOutStream(Outstr, TextEncoding::Windows);
//                 value := ('Posting Date: ' + '  ' + Format(GenJouLine."Posting Date") + '; ' + 'Document Type: ' + '  ' + Format(GenJouLine."Document Type") + '; '
//                  + 'Documnet No.: ' + '  ' + Format(GenJouLine."Document No.") + '; ' + 'Account Type: ' + '  ' + Format(GenJouLine."Account Type") + '; ' +
//                 'Account No: ' + '  ' + Format(GenJouLine."Account No.") + '; ' + 'Description: ' + '  ' + Format(GenJouLine.Description) + '; ' +
//                 'Payment Method Code: ' + '  ' + Format(GenJouLine."Payment Method Code") + '; ' + 'Amount: ' + '  ' + Format(GenJouLine.Amount) + '; ' +
//                  'Amount (LCY): ' + '  ' + Format(GenJouLine."Amount (LCY)") + '; ' + 'bal. Account Type: ' + '  ' + Format(GenJouLine."Bal. Account Type") + '; '
//                  + 'Bal. Account No.: ' + '  ' + Format(GenJouLine."Bal. Account No."));
//                 Outstr.WriteText(value);
//                 TempBlob.CreateInStream(Instr, TextEncoding::Windows);
//                 DownloadFromStream(Instr, '', '', '', FileName);
//                 i += 1;
//             end;
//         until GenJouLine.Next() = 0;
//     end;
// end;