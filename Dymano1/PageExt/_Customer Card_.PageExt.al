pageextension 50101 "Customer Card" extends "Customer Card"
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
        //Khushil Code
        }
    }
}
