page 50114 "Cus SLine Join Query"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Cus Sale Line Join";
    Caption = 'Cust Join Sales Line Query';
    SourceTableView = sorting(Qty) order(descending);
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
                    Caption = 'Name';
                    ApplicationArea = All;
                }
                field("Sales (LCY)"; Rec."Sales (LCY)")
                {
                    Caption = 'Sales (LCY)';
                    ApplicationArea = All;
                }
                field(Qty; Rec.Qty)
                {
                    Caption = 'Quantity';
                    ApplicationArea = All;
                }
            }
        }
    }
    trigger OnOpenPage()
    var
        query: Query "Customer Join Sales Line";
    begin
        if query.Open() then begin
            while query.Read() do begin
                Rec.Init();
                Rec."No." := query.No_;
                Rec.Name := query.Name;
                Rec."Sales (LCY)" := query.Sales__LCY_;
                Rec.Qty := query.Quantity;
                Rec.Insert();
            end;
            query.Close();
        end;
    end;
}