report 50103 "Header in EveryPage"
{
    ApplicationArea = All;
    Caption = 'Header in EveryPage';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'TestingRowHeaderinMultiPages.rdlc';
    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = sorting("No.");
            column(No_; "No.") { }
            column(Description; Description) { }
            column(Inventory; Inventory) { }
            column(itemNo_label; itemNo_label) { }
            column(Description_label; Description_label) { }
            column(Inventory_label; Inventory_label) { }
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
    var
        itemNo_label: Label 'Item No.';
        Description_label: Label 'Description';
        Inventory_label: Label 'Inventory';

}
