reportextension 50001 "Get Sales Orders" extends "Get Sales Orders"
{
    //TBC-975 ---->
    requestpage
    {
        layout
        {
            addafter(GetDim)
            {
                group("No. Series")
                {
                    Caption = '';
                    field(NoSeriesCode; NoSeriesCode)
                    {
                        ApplicationArea = All;
                        Caption = 'No. Series';
                        TableRelation = "No. Series".Code
                            where("PO Order No. Series" = const(true));
                    }
                }
            }
        }

        trigger OnOpenPage()
        begin
            NoSeriesCode := '';
        end;

        trigger OnQueryClosePage(CloseAction: Action): Boolean
        begin
            if CloseAction = Action::OK then begin
                if NoSeriesCode = '' then
                    Error('Please select a No. Series.');
            end;

            exit(true);
        end;
    }

    procedure GetSelectedNoSeries(): Code[20]
    begin
        exit(NoSeriesCode);
    end;

    var
        NoSeriesCode: Code[20];

    //TBC-975 <---
}

