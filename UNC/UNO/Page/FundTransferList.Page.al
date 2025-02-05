page 50103 "Fund Transfer List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Fund Transfer Header";
    CardPageId = "Fund Transfer";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(List)
            {
                field(No; Rec.No)
                {
                    ToolTip = 'Specifies the No the Fund Transfer Document';
                }
                field(FromCompany; Rec.FromCompany)
                {
                    ToolTip = 'Specifies From which company the fund has to be Transfered';
                }
                field(ToCompany; Rec.ToCompany)
                {
                    ToolTip = 'Specifies To which company the fund has to be Transfered';
                }
                field(Project; Rec.Project)
                {
                    ApplicationArea = All;
                    Style = Strong;
                    ToolTip = 'Specifies to Which project the fund is Tranfered';
                }
                field(TotalFunds; Rec.TotalFunds)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Total Funds';
                    Style = Strong;
                    ToolTip = 'Specifies the total Fund raised for the Fund Transfer Document';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the status the Fund Transfer Document';
                }
            }
        }
    }
    // actions
    // {
    //     area(Processing)
    //     {
    //         action(DeleteAll)
    //         {
    //             ApplicationArea = All;
    //             Caption = 'Delete All the Fund Transfer Document';
    //             Promoted = true;
    //             PromotedCategory = New;
    //             PromotedIsBig = true;
    //             ToolTip = 'Delete All the Fund Transfer Document';
    //             trigger OnAction()
    //             var
    //                 FundLine: Record "Fund Transfer Line";
    //             begin
    //                 FundLine.DeleteAll();
    //             end;
    //         }
    //     }
    // }
}