query 50101 "top N Customers"
{
    QueryType = Normal;
    Caption = 'Top N Customers Query';
    OrderBy = descending(Balance__LCY_);
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

    trigger OnBeforeOpen()
    begin

    end;
}