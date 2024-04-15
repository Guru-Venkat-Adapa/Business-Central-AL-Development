tableextension 50111 "Purchase Header" extends "Purchase Header"
{
    fields
    {
        // Add changes to table fields here
        field(50100; "Temp Text"; Text[100])
        {
            Caption = 'Temp Text';
            DataClassification = CustomerContent;
        }
        field(50106; ICCompantText; Text[100])
        {
            Caption = 'IcCompanyText';
            
        }
    }
}