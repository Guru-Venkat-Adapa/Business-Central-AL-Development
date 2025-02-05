table 50103 GetAutomateData
{
    Caption = 'GetAutomateData';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Sl No."; Integer)
        {
            Caption = 'Sl No.';

            AutoIncrement = true;
        }
        field(2; "Registration No."; Code[50])
        {
            Caption = 'Registration No.';
        }
        field(3; Name; Text[50])
        {
            Caption = 'Name';
        }
        field(4; Address; Text[250])
        {
            Caption = 'Address';
        }
        field(5; "Phone Number"; Text[10])
        {
            Caption = 'Phone Number';
        }
        field(6; Email; Text[50])
        {
            Caption = 'Email';
        }
    }
    keys
    {
        key(PK; "Registration No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    var
        SalesSetup: Record "Sales & Receivables Setup";
        NoSeries: Record "No. Series";
        NoSeriesMag: Codeunit "No. Series";
    begin
        if Rec."Registration No." = '' then begin
            if SalesSetup.get() then
                SalesSetup.TestField("Direct Debit Mandate Nos.");
            if NoSeries.Get(SalesSetup."Direct Debit Mandate Nos.") then
                Rec."Registration No." := NoSeriesMag.GetNextNo(NoSeries.Code);
        end;
    end;
}