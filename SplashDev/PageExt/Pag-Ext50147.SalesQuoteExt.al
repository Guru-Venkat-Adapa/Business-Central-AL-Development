pageextension 50147 SalesQuoteExt extends "Sales Quote"
{
    actions
    {
        // Add changes to page actions here
        modify("Print")
        {
            Visible = false;
        }
        addbefore(Email)
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
                    test: Record "Sales Header";
                begin
                    test.Reset();
                    test.SetRange("Document Type", Rec."Document Type");
                    test.SetRange("No.", Rec."No.");
                    if test.FindSet() then begin
                        if test."Currency Code" = '' then
                            ReportLayoutSelect.SetTempLayoutSelected('1304-000001')
                        else if test."Currency Code" <> '' then
                            ReportLayoutSelect.SetTempLayoutSelected('1304-000002');
                        Report.Run(Report::"Standard Sales - Quote", true, true, test);
                    end;
                end;


            }
        }
        addfirst(Category_Category9)
        {
            actionref("PrintName"; PrintCustom) { }
        }
    }
}
