query 50100 "Top 10 Customers"
{
    QueryType = Normal;
    Caption = 'Top 10 Customers';
    OrderBy = descending(Sales__LCY_);
    TopNumberOfRows = 10;
    QueryCategory = 'Customer List';
    elements
    {
        dataitem(Customer; Customer)
        {
            column(No_; "No.") { }
            column(Name; Name) { }
            column(Location_Code; "Location Code") { }
            column(Contact; Contact) { }
            column(Balance__LCY_; "Balance (LCY)") { }
            column(Sales__LCY_; "Sales (LCY)") { }
            column(Payments__LCY_; "Payments (LCY)") { }
        }
    }
}