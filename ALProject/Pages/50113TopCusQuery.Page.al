page 50113 "Top 10 Cus Query Page"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Top 10 Cus Query";
    Caption = 'Top 10 Customers Using Query Page';
    SourceTableView = sorting("Sales (LCY)") order(descending);

    layout
    {
        area(Content)
        {
            repeater(Control)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'No.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Caption = 'Name';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    Caption = 'Location Code';
                }
                field(Contact; Rec.Contact)
                {
                    ApplicationArea = All;
                    Caption = 'Contact';
                }
                field("Sales (LCY)"; Rec."Sales (LCY)")
                {
                    ApplicationArea = All;
                    Caption = 'Sales (LCY)';
                }
                field("Balance (LCY)"; Rec."Balance (LCY)")
                {
                    ApplicationArea = All;
                    Caption = 'Balance (LCY)';
                }
                field("Payments (LCY)"; Rec."Payments (LCY)")
                {
                    ApplicationArea = All;
                    Caption = 'Payments (LCY)';
                }
            }
        }
    }
    trigger OnOpenPage()
    var
        CustomerTop: Query "Top 10 Customers";
    begin
        if CustomerTop.Open() then begin
            while CustomerTop.Read() do begin
                Rec.Init();
                Rec."No." := CustomerTop.No_;
                Rec.Name := CustomerTop.Name;
                Rec."Location Code" := CustomerTop.Location_Code;
                Rec.Contact := CustomerTop.Contact;
                Rec."Sales (LCY)" := CustomerTop.Sales__LCY_;
                Rec."Balance (LCY)" := CustomerTop.Balance__LCY_;
                Rec."Payments (LCY)" := CustomerTop.Payments__LCY_;
                Rec.Insert();
            end;
            CustomerTop.Close();
        end;
    end;
}