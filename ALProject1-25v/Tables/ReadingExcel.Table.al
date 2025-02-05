table 50101 "Reading Excel"
{
    Caption = 'Reading Excel';
    fields
    {
        field(1; No; Code[10])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(2; "Description"; Text[250])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(3; "Box Serial"; Integer)
        {
            Caption = 'Box Serial';
            DataClassification = CustomerContent;
        }
        field(4; Length; Decimal)
        {
            Caption = 'Length';
            DataClassification = CustomerContent;
        }
        field(5; Width; Decimal)
        {
            Caption = 'Width';
            DataClassification = CustomerContent;
        }
        field(6; Height; Decimal)
        {
            Caption = 'Height';
            DataClassification = CustomerContent;
        }
        field(7; Weight; Decimal)
        {
            Caption = 'Weight';
            DataClassification = CustomerContent;
        }
        field(8; Cbm; Decimal)
        {
            Caption = 'Cbm';
            DataClassification = CustomerContent;
            DecimalPlaces = 8;
        }
    }
    keys
    {
        key(Pk; No)
        {
        }
    }
    // procedure GetSelectionFilterForItem(var DataExcel: Record "Reading Excel"): Text
    // var
    //     RecRef: RecordRef;
    //     SelectionFilterManagement: Codeunit SelectionFilterManagement;
    // begin
    //     RecRef.GetTable(Rec);
    //     exit(SelectionFilterManagement.GetSelectionFilter(RecRef, Rec.FieldNo("No")));
    // end;
}