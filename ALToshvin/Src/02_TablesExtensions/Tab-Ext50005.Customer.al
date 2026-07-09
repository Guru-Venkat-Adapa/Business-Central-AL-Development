tableextension 50005 ExtCustomer extends "Customer"
{
    fields
    {
        field(50000; "Industry Type"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Type of Tax Payers"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Customer Type"; Enum "Customer Type")
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Is MSME"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50004; "MSME No"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "MSME Validity Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50006; "Type of Enterprises"; Enum "Enterprise Type")
        {
            DataClassification = ToBeClassified;
        }
        field(50007; "Group Master"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Group Master";
        }
        field(50008; "Virtual Account"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50009; TIN; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50010; CIN; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50011; "KEY/NON KEY(Schimatzu)"; Enum Principal)
        {
            DataClassification = ToBeClassified;

        }
        field(50012; "KEY/NON KEY(Restek)"; Enum Principal)
        {
            DataClassification = ToBeClassified;
        }
        field(50013; "KEY/NON KEY(Principal Wise)"; Enum Principal)
        {
            DataClassification = ToBeClassified;
        }
        field(50014; "Finance Email"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50015; "CRM Customer No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(50016; "Focus Customer No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(50017; "TAN No."; Code[10])
        {
            DataClassification = CustomerContent;
        }

    }
    fieldgroups
    {
        addlast(DropDown; Address, "GST Registration No.") { }
    }
}
