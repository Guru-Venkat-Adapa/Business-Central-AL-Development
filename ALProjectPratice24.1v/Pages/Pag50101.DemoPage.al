page 50101 "Demo Page"
{
    ApplicationArea = All;
    Caption = 'Demo Page';
    PageType = List;
    SourceTable = DeletingSelectedFiled;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field(Email; Rec.Email)
                {
                    ToolTip = 'Specifies the value of the Email field.';
                }
            }
        }
    }
    actions
    {
        area(Creation)
        {
            action(DeleteEmail)
            {
                Caption = 'Delete Email';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Delete;
                trigger OnAction()
                begin
                    DeleteEmailData();
                end;
            }
        }
    }
    procedure DeleteEmailData()
    var
        Demo: Record DeletingSelectedFiled;
    begin
        // Demo.Get(Demo."No.");
        // if Demo.FindSet() then begin
        //     repeat
        //         Message('%1', Demo.Email);
        //     until Demo.Next() = 0;
        // end;
    end;
}
