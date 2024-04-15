pageextension 50103 "New Headline " extends "Headline RC Business Manager"
{
    layout
    {
        // Add changes to page layout here
        addafter(Control2)
        {
            field(HeadLine;HeadLine)
            {
                ApplicationArea=All;
                //Caption='HeadLine';
            }
        }
    }
    
    actions
    {
        // Add changes to page actions here
    }
    
    var
        HeadLine: Text;
        trigger OnOpenPage()
        var
        Head:Codeunit Headlines;
        CustManagement: Codeunit "Customer Management";
        begin
            HeadLine:='Number of Customers without assigned Category:'+ Format(CustManagement.GetTotalCustomerWithoutCategory());
        end;
}