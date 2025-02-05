page 50107 PuchAnalysisCuePage
{
    ApplicationArea = All;
    RefreshOnActivate = true;
    PageType = CardPart;
    Caption = 'Purchase Analysis';
    Editable = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            cuegroup(Chart)
            {
                Caption = 'Top 5 Data';
                field(TempChart; TempChart)
                {
                    Style = Favorable;
                    Caption = 'Purchase Analysis';
                    ToolTip = 'Contains the Purchase and Vendor information in Chart form';
                    trigger OnDrillDown()
                    var
                        PuchPage: Page "Purchase Analysis";
                    begin
                        PuchPage.Run();
                    end;
                }
            }
        }
    }
    var
        TempChart: Text;
}
