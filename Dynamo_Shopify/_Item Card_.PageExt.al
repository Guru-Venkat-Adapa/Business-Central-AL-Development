pageextension 50102 "Item Card" extends "Item Card"
{
    layout
    {
        addbefore("Item Category Code")
        {
            field("Parent Category Code"; Rec."Parent Category Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the category that the item belongs to. Parent Category Code also contain any assigned item attributes.';

                trigger OnValidate()
                begin
                end;
            }
            field("Sub Category Code"; Rec."Sub Category Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the category that the item belongs to. Sub Category Code also contain any assigned item attributes.';
            }
        }
        addafter(ItemPicture)
        {
            part(ItemBarcode; "Item Barcode")
            {
                ApplicationArea = All;
                Caption = 'Barcode';
                SubPageLink = "No."=field("No.");
            }
        }
    }
    actions
    {
        addafter(CopyItem)
        {
            action(ImportPictureFromURL)
            {
                ApplicationArea = All;
                Caption = 'Import From URL';
                Image = Import;
                ToolTip = 'Import a picture file from URL.';

                trigger OnAction()
                var
                    TrackingCard: Page "Order Tracking Dialog";
                    SH: Record "Sales Header";
                begin
                    IF SH.FindFirst()then;
                    Clear(TrackingCard);
                    TrackingCard.SetValue(SH."No.", SH."Document Type");
                    TrackingCard.Run();
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        //Message(StrSubstNo(ParseURL, Rec."No." + '&'));
        IF NOT Rec."Item Barcode".HasValue then ImportItemBarcodeFromURL(StrSubstNo(ParseURL, Rec."No." + '&'));
    end;
    procedure ImportItemBarcodeFromURL(PictureURL: Text)
    var
        Item: Record Item;
        Client: HttpClient;
        Content: HttpContent;
        Response: HttpResponseMessage;
        InStr: InStream;
    begin
        Client.Get(PictureURL, Response);
        Response.Content.ReadAs(InStr);
        if Item.Get(Rec."No.")then begin
            Clear(Item."Item Barcode");
            Item."Item Barcode".ImportStream(InStr, 'Demo picture for item ' + Format(Item."No."));
            Item.Modify(true);
        end;
    //CurrPage.Update();
    end;
    var ParseURL: Label 'https://barcode.tec-it.com/barcode.ashx?data=%1code=EANUCC128&translate-esc=on&dpi=96&dataseparator=,&download=true';
}
