tableextension 50010 Employee extends Employee
{
    fields
    {
        field(50000; "CRM Employee ID"; Code[20])
        {
            Caption = 'CRM Employee ID';
            DataClassification = ToBeClassified;
        }
        field(50001; "Password"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Password';
            ExtendedDatatype = Masked;
        }
        field(50002; "Original Password"; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(50003; "User ID"; Text[80])
        {
            DataClassification = CustomerContent;
        }
        field(50004; "Approver Manager"; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }
    fieldgroups
    {
        addlast(DropDown; "Global Dimension 2 Code")
        {
        }
        addlast(Brick; "Global Dimension 2 Code")
        {

        }
    }
}
