table 50117 "Customer Category"
{
    DataClassification = ToBeClassified;
    Caption = 'Customer Category';
    DrillDownPageId="Customer Category List";
    LookupPageId="Customer Category List";

    fields
    {
        field(1; No; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No.';
        }
        field(2; Description; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Discription';
        }
        field(3; Default; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Default';
        }
        field(4; TotalCustomerForCategory; Integer)
        {

            Caption = 'Total Customers For Category';
            FieldClass=FlowField;
            CalcFormula=count (Customer where ("Customer Category SDM"=field(No)));
        }
        field(5; EnableNewsletter; Option)
        {
            Caption = 'Enable Newsletter';
            OptionMembers = "","Full","Limited";
            OptionCaption = ' ,fULL,Limited';
            DataClassification = CustomerContent;
        }
        field(6; FreeGiftsAvaliable; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Free Gifts Avaliable';
        }
    }
    keys
    {
        key(Pk; No)
        {
            Clustered = true;
        }
    }
}