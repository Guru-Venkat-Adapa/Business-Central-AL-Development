xmlport 50100 "Export Item"
{
    Format = VariableText;
    Direction = Export;
    TextEncoding = UTF8;
    UseRequestPage = true;
    TableSeparator = '';
    schema
    {
        textelement(Control)
        {
            tableelement(Integer; Integer)
            {
                XmlName = 'ItemsData';
                SourceTableView = sorting(Number) where(Number = const(1));
                textelement(ItemsNo)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ItemsNo := Item.FieldCaption("No.");
                    end;
                }
                textelement(ItemDesc)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ItemDesc := item.FieldCaption(Description);
                    end;
                }
                textelement(ItemType)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ItemType := item.FieldCaption(Type);
                    end;
                }
                textelement(ItemInventory)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ItemInventory := item.FieldCaption(Inventory);
                    end;
                }
                textelement(ItemBaseUnitMeasure)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ItemBaseUnitMeasure := Item.FieldCaption("Base Unit of Measure");
                    end;
                }
                textelement(ItembaseCost)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ItembaseCost := Item.FieldCaption("Cost is Adjusted");
                    end;
                }
                textelement(ItemUnitCost)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ItemUnitCost := item.FieldCaption("Unit Cost");
                    end;
                }
                textelement(ItemUnitPrice)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ItemUnitPrice := item.FieldCaption("Unit Price");
                    end;
                }
                textelement(ItemVendorNo)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ItemVendorNo := Item.FieldCaption("Vendor No.");
                    end;
                }
            }
            tableelement(Item; Item)
            {
                XmlName = 'Item';
                RequestFilterFields = "No.";
                fieldelement(No; Item."No.") { }
                fieldelement(Description; Item.Description) { }
                fieldelement(Type; Item.Type) { }
                fieldelement(Inventory; Item.Inventory) { }
                fieldelement(BaseUnit; Item."Base Unit of Measure") { }
                fieldelement(CostIsAdjusted; Item."Cost is Adjusted") { }
                fieldelement(UnitCost; Item."Unit Cost") { }
                fieldelement(UnitPrice; Item."Unit Price") { }
                fieldelement(VendorNo; Item."Vendor No.") { }

            }
        }
    }
}