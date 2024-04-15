query 50102 "Customer Join Sales Line"
{
    QueryType = Normal;
    Caption = 'Customer Join Sales Line Query';
    OrderBy = descending(Quantity);
    TopNumberOfRows = 10;
    QueryCategory = 'Customer List';
    elements
    {
        dataitem(Customer; Customer)
        {
            column(No_; "No.") { }
            column(Name; Name) { }
            column(Sales__LCY_; "Sales (LCY)") { }
            dataitem(Sales_Line; "Sales Line")
            {
                DataItemLink = "Sell-to Customer No." = Customer."No.";
                // SqlJoinType = InnerJoin;
                column(Quantity; Quantity)
                {
                    Method = Sum;
                }
            }
        }
    }
}