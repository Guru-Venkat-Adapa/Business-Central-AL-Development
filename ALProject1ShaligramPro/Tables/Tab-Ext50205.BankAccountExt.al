tableextension 50205 "Bank Account Ext" extends "Bank Account"
{
    fields
    {
        field(50200; "Company Releated"; Text[100])
        {
            Caption = 'Company Information';
            DataClassification = ToBeClassified;
            TableRelation = Company.Name;
            // trigger OnValidate()
            // var
            //     CompanyInfo: Record "Company Information";

            // begin
            //     ChangeCompany("Company Releated");
            //     if CompanyInfo.FindSet() then begin

            //     end;
            // end;
        }
    }
}
