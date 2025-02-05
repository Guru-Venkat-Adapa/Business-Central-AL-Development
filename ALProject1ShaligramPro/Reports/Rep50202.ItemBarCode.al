report 50202 "Item BarCode"
{
    ApplicationArea = All;
    Caption = 'Item BarCode';
    UsageCategory = ReportsAndAnalysis;
    DefaultRenderingLayout = BarcodeLayout;
    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.";
            column(ItemNo_; "No.") { }
            column(Description; Description) { }
            column(Barcode; BarcodeValue) { }
            trigger OnAfterGetRecord()
            var
                BarcodeSymbol: Enum "Barcode Symbology 2D";
                BarcodeFontProvider: Interface "Barcode Font Provider 2D";
                BarcodeString: Text;
            begin
                BarcodeFontProvider := Enum::"Barcode Font Provider 2D"::IDAutomation2D;
                BarcodeSymbol := Enum::"Barcode Symbology 2D"::PDF417;
                BarcodeString := "No.";
                // BarcodeFontProvider.ValidateInput(BarcodeString, BarcodeSymbol);
                // BarcodeFontProvider.EncodeFont(BarcodeString, BarcodeSymbol);
                BarcodeValue := BarcodeFontProvider.EncodeFont(BarcodeString, BarcodeSymbol);
            end;
        }
    }
    rendering
    {
        layout(BarCodeLayout)
        {
            Type = RDLC;
            LayoutFile = 'ItemBarCodereport.rdl';
        }
    }
    var
        BarcodeValue: Text;
}
