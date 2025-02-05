report 50104 "Customer Category"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption='Customer Category Report';
    RDLCLayout='CustomerCategoryRdlc.Report.RDL';
   WordLayout='CustomerCategoryWord.Report.Docx';
    dataset
    {
        dataitem("Customer Category";"Customer Category")
        {
            column(No;No)
            {
            }
            column(Description;Description)
            {

            }
            column(TotalCustomerForCategory;TotalCustomerForCategory)
            {}
            column(FreeGiftsAvaliable;FreeGiftsAvaliable)
            {}
            trigger OnAfterGetRecord()
            begin
                CalcFields(TotalCustomerForCategory);
            end;
        }
    }
}