page 50103 "API Request Page"
{
    ApplicationArea = All;
    Caption = 'API Request Page';
    PageType = Card;
    SourceTable = "API Table";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field(Credential; Rec.Credential)
                {
                    Caption = 'User Credential';
                    ToolTip = 'Specifies the User credential values to fetch data from API';
                    Editable = true;
                }
                field(APILink; Rec.APILink)
                {
                    Caption = 'Reference Link';
                    ToolTip = 'Specifies the API Link to fetch data.';
                    Editable = true;
                }
            }
        }
    }
}
