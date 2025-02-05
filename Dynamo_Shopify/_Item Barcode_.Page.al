page 50126 "Item Barcode"
{
    Caption = 'Item Barcode';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = CardPart;
    SourceTable = Item;

    layout
    {
        area(content)
        {
            field("Item Barcode"; Rec."Item Barcode")
            {
                ApplicationArea = all;
                ShowCaption = false;
                ToolTip = 'Specifies the picture that has been inserted for the item.';
            }
        }
    }
    var Camera: Codeunit Camera;
    CameraAvailable: Boolean;
    OverrideImageQst: Label 'The existing picture will be replaced. Do you want to continue?';
    DeleteImageQst: Label 'Are you sure you want to delete the picture?';
    SelectPictureTxt: Label 'Select a picture to upload';
    DeleteExportEnabled: Boolean;
    HideActions: Boolean;
    MustSpecifyDescriptionErr: Label 'You must add a description to the item before you can import a picture.';
    MimeTypeTok: Label 'image/jpeg', Locked = true;
}
