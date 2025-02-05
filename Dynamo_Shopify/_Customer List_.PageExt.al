pageextension 50100 "Customer List" extends "Customer List"
{
    layout
    {
        addafter(Name)
        {
            field("Name_2"; Rec."Name 2")
            {
                ApplicationArea = all;
                Caption = 'Name 2';
            }
        }
    }
}
