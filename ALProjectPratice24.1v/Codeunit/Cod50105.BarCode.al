codeunit 50105 BarCode
{
    procedure GetBarCodeForItem(ItemNo: Code[20]; Symbol: text; Type: Text)
    var
        HttpClient: HttpClient;
        Response: HttpResponseMessage;
        Instream: InStream;
        URLLabel: Label 'https://barcode.tec-it.com/barcode.ashx?data=%1code=EANUCC128&translate-esc=on&dpi=96&dataseparator=,&download=true';
        Url: Text;
        Item: Record Item;
    begin
        Url := StrSubstNo(URLLabel, ItemNo, Symbol, Type);
        if HttpClient.Get(Url, Response) then begin
            Response.Content.ReadAs(Instream);
            Item.SetRange("No.", ItemNo);
            if Item.FindFirst() then begin
                item."Bar Code".ImportStream(Instream, '');
                Item.Modify(true);
            end;
        end else begin
            Error('Getting error while getting data . Errors are: %1, %2', Response.IsSuccessStatusCode, Response.ReasonPhrase);
        end;
    end;

    //  procedure ImportItemBarcodeFromURL(PictureURL: Text)
    // var
    //     Item: Record Item;
    //     Client: HttpClient;
    //     Content: HttpContent;
    //     Response: HttpResponseMessage;
    //     InStr: InStream;
    // begin
    //     Client.Get(PictureURL, Response);
    //     Response.Content.ReadAs(InStr);
    //     if Item.Get(Rec."No.") then begin
    //         Clear(Item."Item Barcode");
    //         Item."Item Barcode".ImportStream(InStr, 'Demo picture for item ' + Format(Item."No."));
    //         Item.Modify(true);
    //     end;
    //     //CurrPage.Update();
    // end;

    // var
    //     ParseURL: Label 'https://barcode.tec-it.com/barcode.ashx?data=%1code=EANUCC128&translate-esc=on&dpi=96&dataseparator=,&download=true';
}
