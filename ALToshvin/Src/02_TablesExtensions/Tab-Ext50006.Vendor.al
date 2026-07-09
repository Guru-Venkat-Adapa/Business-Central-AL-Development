tableextension 50006 ExtVendor extends Vendor
{
    fields
    {
        // NavSoft HG 11-04-2025  --------------->
        field(50000; "Industry Type"; Code[10])
        {
            Caption = 'Industry Type';
            DataClassification = CustomerContent;
        }
        field(50001; "CRM Vendor No."; Code[20])
        {
            Caption = 'CRM Vendor No.';
            DataClassification = ToBeClassified;
        }

        field(50002; "Focus Vendor No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(50003; "Balance As Of"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50004; "MSME No"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "Is MSME"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }
    fieldgroups
    {
        addlast(DropDown; Address, "GST Registration No.") { }
    }
}
