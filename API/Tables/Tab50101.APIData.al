table 50101 "API Table"
{
    DataClassification = CustomerContent;
    Caption = 'Api Table';
    fields
    {
        field(1; ID; code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; Status; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(3; Date; Date)
        {
            DataClassification = CustomerContent;
        }
        field(4; Time; Time)
        {
            DataClassification = CustomerContent;
        }
        field(5; Depot; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(6; Credential; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(7; APILink; Text[500])
        {
            DataClassification = ToBeClassified;
        }
        field(8; statusCode; Code[50])
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(Pk; ID)
        {
            Clustered = true;
        }
    }

    // trigger OnInsert()
    // var
    //     SRSetup: Record "Sales & Receivables Setup";
    //     NoMgt: Codeunit NoSeriesManagement;
    // begin
    //     if ID = '' then begin
    //         SRSetup.Get();
    //         ID := NoMgt.GetNextNo(SRSetup."Customer Nos.", WorkDate(), true);
    //     end;
    // end;
}