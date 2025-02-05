pageextension 50148 PostedSalesCrMemoExt extends "Posted Sales Credit Memo"
{
    actions
    {
        // Add changes to page actions here
        modify("Print")
        {
            Visible = false;
        }
        addbefore("Send by &Email")
        {
            action("PrintCustom")
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Print';
                Image = Print;
                ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';
                trigger OnAction()
                var
                    ReportLayoutSelect: Record "Report Layout Selection";
                begin
                    Rec.Reset();
                    CurrPage.SetSelectionFilter(Rec);
                    if Rec.FindSet() then begin
                        if Rec."Currency Code" = '' then begin
                            ReportLayoutSelect.SetTempLayoutSelected('1307-000004');
                            Report.Run(Report::"Standard Sales - Credit Memo", true, true, Rec);
                        end else begin
                            ReportLayoutSelect.SetTempLayoutSelected('1307-000005');
                            Report.Run(Report::"Standard Sales - Credit Memo", true, true, Rec);
                        end;
                    end;
                end;
            }
        }
        addfirst(Category_Category7)
        {
            actionref("PrintName"; PrintCustom) { }
        }
    }
}
