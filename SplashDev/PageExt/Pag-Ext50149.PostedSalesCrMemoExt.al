pageextension 50149 "PostedSaleCrMemosListExt" extends "Posted Sales Credit Memos"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        modify("&Print")
        {
            Visible = false;
        }
        addbefore("Send by &Email")
        {
            action("Print")
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Print';
                Image = Print;
                ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';
                trigger OnAction()
                var
                    ReportLayoutSelect: Record "Report Layout Selection";
                    test: Record "Sales Cr.Memo Header";
                begin
                    test.Reset();
                    test.SetRange("No.", Rec."No.");
                    if test.FindSet() then begin
                        if test."Currency Code" = '' then
                            ReportLayoutSelect.SetTempLayoutSelected('1307-000004')
                        else if test."Currency Code" <> '' then
                            ReportLayoutSelect.SetTempLayoutSelected('1307-000005');
                        Report.Run(Report::"Standard Sales - Credit Memo", true, true, test);
                    end;
                end;
            }
        }
        addfirst(Category_Category7)
        {
            actionref("PrintName"; print) { }
        }
    }
    var
        myInt: Integer;
}