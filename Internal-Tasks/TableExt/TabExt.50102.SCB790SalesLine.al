tableextension 50102 "SCB 790 Sales Line" extends "Sales Line" //37
{
    fields
    {
        // Add changes to table fields here
        field(6082664; "SCB Starting Date"; Date)
        {
            Caption = 'Starting Date';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
            begin
                SalesHeader.GET("Document Type", "Document No.");
                SubscriptionSetup.Get('');
                if Format("SCB Invoicing frequency DF") = '' then
                    VALIDATE("SCB Invoicing frequency DF", SalesHeader."SCB Invoicing Frequency DF")
                ELSE
                    VALIDATE("SCB Invoicing frequency DF");
                IF (("SCB Starting date" < SalesHeader."SCB Next invoicing date") AND ("SCB Starting date" <> 0D)) OR
                (SalesHeader."SCB Next invoicing date" = 0D) THEN BEGIN
                    IF ("Document Type" = "Document Type"::"Blanket Order") AND
                        (SalesHeader.Status = SalesHeader.Status::Released) THEN
                        ERROR(Text001Err);
                    SalesHeader."SCB Next invoicing date" := "SCB Starting date";
                    SalesHeader.MODIFY();
                END;
                Rec."SCB Next Invoicing Date" := CALCDATE('<+1D>', "SCB End date first period");
            end;
        }
        field(6082665; "SCB Invoicing frequency"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Invoicing Frequency';
            DateFormula = true;
            ObsoleteState = Pending;
            ObsoleteReason = 'Replaced with "SCB Invoicing Frequency DF" DateFormula field';
        }
        field(6082666; "SCB Next Invoicing Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Next Invoicing Date';

            trigger OnValidate()
            var
            begin
                SalesHeader.Get("Document Type", "Document No.");
                IF (("SCB Next invoicing date" < SalesHeader."SCB Next invoicing date") AND ("SCB Next invoicing date" <> 0D)) THEN BEGIN
                    IF ("Document Type" = "Document Type"::"Blanket Order") AND
                    (SalesHeader.Status = SalesHeader.Status::Released) THEN
                        ERROR(Text001Err);
                    MESSAGE(STRSUBSTNO(Text002Msg, FIELDCAPTION("SCB Next invoicing date"), SalesHeader.FIELDCAPTION("SCB Next invoicing date")));
                END;
                TestNextInvoicingDate();
            end;
        }
        field(6082667; "SCB Ending Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Ending Date';

            trigger OnValidate()
            var
            begin
                if ("SCB Ending date" < "SCB End date first period") AND ("SCB Ending date" <> 0D) then
                    "SCB End date first period" := "SCB Ending date"
                else
                    if (xRec."SCB Ending date" = "SCB End date first period") AND ("SCB End date first period" <> 0D) then
                        VALIDATE("SCB Invoicing frequency DF");
                TestNextInvoicingDate();
            end;
        }
        field(6082668; "SCB End Date First Period"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'End Date First Period';

            trigger OnValidate()
            var
            begin
                if ("SCB End date first period" <> 0D) AND ("SCB End date first period" < "SCB Starting date") THEN
                    ERROR(Text003Err);
            end;
        }
        field(6082669; "SCB Subscription No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Subscription No.';
        }
        field(6082670; "SCB Subscription Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Subscription Line No.';
        }
        field(6082671; "SCB Old Next Invoicing Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Old Next Invoicing Date';
        }
        field(6082672; "SCB Sales Amount per Year"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Sales Amount per Year';
        }
        field(6082673; "SCB Cost Amount per Year"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Cost Amount per Year';
        }
        field(6082674; "SCB Profit Amount per Year"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Profit Amount per Year';
        }
        field(6082675; "SCB Date Filter 1"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date Filter 1';
        }
        field(6082676; "SCB Date Filter 2"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date Filter 2';
        }
        field(6082677; "SCB Subscription Info"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Subscription Info';
        }
        field(6083562; "SCB Blanket Order Type"; enum "SCB 790 Blanket Order Type")
        {
            Editable = false;
            Caption = 'Blanket Order Type';
            DataClassification = CustomerContent;
        }
        field(6082790; "SCB Invoicing frequency DF"; DateFormula)
        {
            DataClassification = CustomerContent;
            Caption = 'Invoicing Frequency';

            trigger OnValidate()
            var
                NoOfMonths: Integer;
            begin
                if (Format("SCB Invoicing frequency DF") <> '') AND ("SCB Starting date" <> 0D) then begin
                    SubscriptionSetup.Get();
                    NoOfMonths := DATE2DMY(CALCDATE("SCB Invoicing frequency DF", 19991231D), 2);
                    CASE SubscriptionSetup."SCB Calc End First Period" OF
                        SubscriptionSetup."SCB Calc End First Period"::"End current period":
                            CASE NoOfMonths OF
                                1:
                                    begin
                                        "SCB End date first period" := Rec."SCB Starting date";
                                        "SCB End date first period" := CALCDATE("SCB Invoicing frequency DF", "SCB End date first period");
                                        "SCB End date first period" := CALCDATE('<-1D>', "SCB End date first period");
                                    end;
                                3:
                                    "SCB End date first period" := "SCB Starting date";
                                6:
                                    BEGIN
                                        "SCB End date first period" := CALCDATE('<CQ>', "SCB Starting date");
                                        IF (DATE2DMY("SCB End date first period", 2) <> 6) AND (DATE2DMY("SCB End date first period", 2) <> 12) THEN
                                            "SCB End date first period" := CALCDATE('<1D + CQ>', "SCB End date first period");
                                    END;
                                12:
                                    "SCB End date first period" := CALCDATE('<CY>', "SCB Starting date");
                                ELSE
                                    "SCB End date first period" := CALCDATE('<CM>', "SCB Starting date");
                            END;
                        SubscriptionSetup."SCB Calc End First Period"::"End month":
                            BEGIN
                                "SCB End date first period" := Rec."SCB Starting date";
                                "SCB End date first period" := CALCDATE("SCB Invoicing frequency DF", "SCB End date first period");
                                "SCB End date first period" := CALCDATE('<-1D>', "SCB End date first period");
                            END;
                    //TODO: [SCB790-95]: Change to enum but make sure not to break schema, might need to update to new field to change enum options
                    //SubscriptionSetup."SCB Calc. End First Period"::"Manual calculation":
                    //    "SCB End date first period" := 0D;
                    END;
                    IF ("SCB Ending date" < "SCB End date first period") AND ("SCB Ending date" <> 0D) THEN
                        "SCB End date first period" := "SCB Ending date";
                END;

            end;
        }
    }
    local procedure TestNextInvoicingDate()
    begin
        if ("SCB Next Invoicing Date" >= "SCB Ending Date") AND ("SCB Ending Date" <> 0D) then
            "SCB Next Invoicing Date" := 0D;
    end;

    var
        SalesHeader: Record "Sales Header";
        SubscriptionSetup: Record "Subscription Setup";

        // Text000: Label 'There can only be made accrual on G/L accounts and items';
        Text001Err: Label 'It is not possible to make changes to a realeased blanket order\reopen the order and try again';
        Text002Msg: Label '%1 is before %2 in the header - remember to change it in header if needed';
        Text003Err: Label 'Ending date first period should be after starting date';

}