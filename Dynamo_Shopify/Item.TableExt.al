tableextension 50100 Item extends Item
{
    fields
    {
        modify("Item Category Code")
        {
        trigger OnBeforeValidate()
        begin
            Rec.TestField("Parent Category Code");
            Rec.TestField("Sub Category Code");
        end;
        }
        field(50100; "Parent Category Code"; Code[20])
        {
            Caption = 'Parent Category Code';
            TableRelation = "Item Category".Code where(Indentation=filter(=0));
        }
        field(50101; "Sub Category Code"; Code[20])
        {
            Caption = 'Sub Category Code';
            TableRelation = "Item Category".Code where(Indentation=filter(=0));
        }
        field(50102; "Item Barcode"; Media)
        {
            Caption = 'Item Barcode';
        //SubType = Bitmap;
        }
    }
    keys
    {
    // Add changes to keys here
    }
    fieldgroups
    {
    // Add changes to field groups here
    }
    var myInt: Integer;
}
