tableextension 50206 "Gen. Journal Line Ext" extends "Gen. Journal Line"
{
    fields
    {
        field(50200; "Project reference"; Code[50])
        {
            Caption = 'Project reference';
            DataClassification = CustomerContent;
            // TableRelation = Job."No.";

        }
    }
    // procedure GetProjects()
    // var
    //     Projects: Record Job;
    // begin
    //     ChangeCompany('Testing');
    //     Projects.FindSet();
    // end;
}
