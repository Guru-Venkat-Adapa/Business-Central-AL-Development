tableextension 50102 "Sales Header Ext" extends "Sales Header"
{
    fields
    {
        field(50100; "Custom Amount (LCY)"; Decimal)
        {
            Caption = 'Custom Amount (LCY)';
            DataClassification = CustomerContent;
        }
        modify("Prices Including VAT")
        {
            Caption = 'Prices Including GST';
        }
        modify("VAT Bus. Posting Group")
        {
            Caption = 'GST Bus. Posting Group';
        }
        field(50101; "SGN Signature"; Blob)
        {
            Caption = 'Customer Signature';
            DataClassification = CustomerContent;
            SubType = Bitmap;
        }
    }


    procedure SignDocument(var Base64Text: Text)
    var
        Base64Cu: Codeunit "Base64 Convert";
        RecordRef: RecordRef;
        OutStream: OutStream;
        TempBlob: Codeunit "Temp Blob";
        ImageBase64String: Text;
    begin
        Base64Text := Base64Text.Replace('data:image/png;base64,', '');
        TempBlob.CreateOutStream(OutStream);
        Base64Cu.FromBase64(Base64Text, OutStream);
        RecordRef.GetTable(Rec);
        TempBlob.ToRecordRef(RecordRef, Rec.FieldNo("SGN Signature"));
        RecordRef.Modify();
    end;
}
