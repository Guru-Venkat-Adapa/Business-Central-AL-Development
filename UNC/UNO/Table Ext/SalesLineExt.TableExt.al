tableextension 50116 "Sales Line Ext" extends "Sales Line"
{
    fields
    {
        field(50100; Name; Text[50])
        {
            Caption = 'Name';
        }
        field(50101; Address; Text[250])
        {
            Caption = 'Address';
        }
        field(50102; "Phone Number"; Text[10])
        {
            Caption = 'Phone Number';
        }
        field(50103; Email; Text[50])
        {
            Caption = 'Email';
        }
    }
}
