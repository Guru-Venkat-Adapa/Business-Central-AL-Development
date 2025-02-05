page 50105 "Purchase Analysis"
{
    ApplicationArea = All;
    Caption = 'Purchase Analysis';
    PageType = Card;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            grid(FirstRow)
            {
                part(TopVendorsByPurchases; "Top Vendors Chart Column")
                {
                    ApplicationArea = All;
                }
                part(TopVendorsByQuantity2; "Top Vendors by Quantity")
                {
                    ApplicationArea = All;
                }
            }
            grid(SecondRow)
            {
                part(ItemPeriod; "Item_Chart_Column")
                {
                    ApplicationArea = All;
                }
                part(ItemChart_Doughnut; ItemChart_Doughnut)
                {
                    ApplicationArea = All;
                }
                part(Purchase_Posting_Group; Purchase_Posting_Group)
                {
                    ApplicationArea = All;
                }
            }
            grid(ThirdRow)
            {
                part(TopVendorsByPurchasesList; "Purch Chart Details List")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}