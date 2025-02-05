report 50102 "Custom Word For Customer List"
{
    ApplicationArea = All;
    Caption = 'Custom Word For Customer List';
    UsageCategory = Lists;
    DefaultLayout = Word;
    WordLayout = 'CustomCust.List.docx';
    dataset
    {
        dataitem(Customer; Customer)
        {
            column(No_; "No.") { }
            column(Name; Name) { }
            column(Balance; Balance) { }
            column(Location_Code; "Location Code") { }
            column(url_Url; url) { }
            column(Total; Total) { }
            trigger OnAfterGetRecord()
            var
                temp: Code[20];
            begin
                url := 'https://www.shaligraminfotech.com/';
                if temp <> Customer."No." then
                    Total += Balance;
                temp := Customer."No.";
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
    var
        url: Text;
        Total: Decimal;
}
