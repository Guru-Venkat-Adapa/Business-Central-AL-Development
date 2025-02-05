table 50103 CopyTable
{
    Caption = 'CopyTable';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(2; Name; Text[100])
        {
            Caption = 'Name';
        }
        field(3; Address; Text[100])
        {
            Caption = 'Address';
        }
    }
    keys
    {
        key(PK; "Document No.")
        {
            Clustered = true;
        }
    }
    // trigger OnInsert()
    // begin
    //     if "Document No." = '' then begin
    //         SalesSetup.Get();
    //         "Document No." := NoSeriesMgt.GetNextNo(SalesSetup.OriginalCopy, WorkDate(), true);
    //     end;
    // end;

    // var
    //     SalesSetup: Record "Sales & Receivables Setup";
    //     NoSeriesMgt: Codeunit NoSeriesManagement;
}
