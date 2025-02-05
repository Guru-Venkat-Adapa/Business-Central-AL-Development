page 50120 DemoXmlFilePage
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = DemoXmlFile;

    layout
    {
        area(Content)
        {
            repeater(EmployeeDetails)
            {
                field(EmpId; Rec.EmpId)
                {
                    ApplicationArea = All;
                    Caption = 'Employee Id';
                }
                field(EmpName; Rec.EmpName)
                {
                    ApplicationArea = All;
                    Caption = 'Employee Name';
                }
                field(Technology; Rec.Technology)
                {
                    ApplicationArea = All;
                }
                field(Phno; Rec.Phno)
                {
                    Caption = 'Phone Number';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ExportData)
            {
                ApplicationArea = All;
                Caption = 'Export Data';
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;
                Image = ExportFile;
                trigger OnAction()
                begin
                    Xmlport.Run(50103, true, false);
                end;
            }
            action(ImportData)
            {
                ApplicationArea = All;
                Caption = 'Import Data';
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;
                Image = Import;
                trigger OnAction()
                begin
                    Xmlport.Run(50103, false, true);
                end;
            }
        }
    }

    var
        myInt: Integer;
}