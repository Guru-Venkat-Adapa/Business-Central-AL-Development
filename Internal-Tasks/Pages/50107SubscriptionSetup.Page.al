page 50107 "Subscription Setup"
{
    PageType = Card;
    ApplicationArea = Basic, Suite;
    UsageCategory = Administration;
    SourceTable = "Subscription Setup";
    Caption = 'Subscription Setup';
    // DeleteAllowed = false;
    // InsertAllowed = false;

    layout
    {
        area(Content)
        {
            group("No. Series")
            {
                field("Subscription Nos."; Rec."Subscription No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Subscription Nos.';
                    ToolTip = 'Specifies the code for the number series';

                    trigger OnValidate()
                    begin
                        // LogUpTake('SCBF0004','Subscription Nos.');
                    end;
                }
                field("SCB Posted Subscription No."; Rec."SCB Posted Subscription Nos.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'SCB Posted Subscription Nos.';
                    ToolTip = 'Specifies the code for the number series';

                    trigger OnValidate()
                    begin
                        // LogUpTake('SCBF0004','SCB Posted Subscription Nos.');
                    end;
                }
            }
            group(Subscription)
            {
                field("SCB Calc End First Period"; Rec."SCB Calc End First Period")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Calculated End First Period';
                    ToolTip = 'Specifies which calcuation method to be set for time period';

                    trigger OnValidate()
                    begin
                        // LogUpTake('SCBF0004','SCBF Calc End First Period');
                    end;
                }
                field("SCB Sales Days per Month"; Rec."SCB Sales Days per Month")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Days per Month';
                    ToolTip = 'Specifies the number of sales days per month';

                    trigger OnValidate()
                    begin
                        // LogUpTake('SCBF0004','SCB Sales Days per Month');
                    end;
                }
                field("Default Subscr Text Languages"; Rec."Default Subscr Text Languages")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Default Subscription Text Languages';
                    ToolTip = 'Specifies the language that is used';

                    trigger OnValidate()
                    begin
                        // LogUpTake('SCBF0004','Default Subscr Text Languages');
                    end;
                }
            }
        }

    }

    actions
    {
        area(Navigation)
        {
            action("Subscription Text Translation")
            {
                ApplicationArea = All;
                Caption = 'Subscription Text Translation';
                ToolTip = 'Setup translation of the subscription';
                Image = Transactions;
                // RunObject=page "SCB Subscription Texts";
                trigger OnAction()
                begin

                end;
            }
        }
    }


    // trigger OnOpenPage()
    // begin
    //     if Rec."SCB Primary Key" = '' then begin
    //         Rec.DeleteAll();
    //         Rec.Init();
    //         Rec.Insert(true);
    //     end;
    // end;
    trigger OnOpenPage()
    begin
        if rec.IsEmpty() then
            Rec.Insert();
    end;

    var
        myInt: Integer;
}