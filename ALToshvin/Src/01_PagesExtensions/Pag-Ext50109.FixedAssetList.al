pageextension 50109 "Fixed Asset List" extends "Fixed Asset List"
{
    layout
    {
        //TBC-1058 ---->
        modify("Search Description")
        {
            Visible = true;
            ApplicationArea = All;
        }
        moveafter(Description; "Search Description")

        addafter("Search Description")
        {
            field(DepreciationStartingDate; DepreciationStartingDate)
            {
                ApplicationArea = FixedAssets;
                Caption = 'Depreciation Starting Date';
                Visible = true;
                Editable = false;
            }
            field(NoOfDepreciationYears; NoOfDepreciationYears)
            {
                ApplicationArea = FixedAssets;
                Caption = 'No. of Depreciation Years';
                Visible = true;
                Editable = false;
            }
            field(BookValue; BookValue)
            {
                ApplicationArea = FixedAssets;
                Caption = 'Book Value';
                Visible = true;
                Editable = false;
            }
            field(AcquisitionCost; AcquisitionCost)
            {
                ApplicationArea = FixedAssets;
                Caption = 'Acquisition Cost';
                Visible = true;
                Editable = false;
            }
        }
        //TBC-1058 <----
    }

    trigger OnAfterGetRecord()
    begin
        //TBC-1058 ---->
        Clear(DepreciationStartingDate);
        Clear(NoOfDepreciationYears);
        Clear(BookValue);
        Clear(AcquisitionCost);

        FADepreciationBook.Reset();
        FADepreciationBook.SetRange("FA No.", Rec."No.");
        if FADepreciationBook.FindFirst() then begin
            DepreciationStartingDate := FADepreciationBook."Depreciation Starting Date";
            NoOfDepreciationYears := FADepreciationBook."No. of Depreciation Years";
            FADepreciationBook.CalcFields("Book Value", "Acquisition Cost");
            BookValue := FADepreciationBook."Book Value";
            AcquisitionCost := FADepreciationBook."Acquisition Cost";
        end;
        //TBC-1058 <----
    end;

    var
        FADepreciationBook: Record "FA Depreciation Book";
        DepreciationStartingDate: Date;
        NoOfDepreciationYears: Decimal;
        BookValue: Decimal;
        AcquisitionCost: Decimal;
}
