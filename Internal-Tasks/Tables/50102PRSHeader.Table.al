table 50102 "PRS Header"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(2; "Document Date"; Date)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(3; "Date of MRS"; Date)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(4; "Manual MRS. No."; Code[30])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(5; "Issue Dept."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            trigger OnValidate()
            begin
                TestStatusOpen();
                //  UpdatePurchReqLine(FIELDNAME("Issue Dept."));
            end;
        }
        field(6; "Issue Bus. Unit"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            trigger OnValidate()
            begin
                TestStatusOpen();
                // UpdatePurchReqLine(FIELDNAME("Issue Bus. Unit"));
            end;
        }
        field(7; "Indent Dept."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            trigger OnValidate()
            begin
                TestStatusOpen();
                // UpdatePurchReqLine(FIELDNAME("Indent Dept."));
            end;
        }
        field(8; "Indent Bus. Unit"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            trigger OnValidate()
            begin
                TestStatusOpen();
                // UpdatePurchReqLine(FIELDNAME("Indent Bus. Unit"));
            end;
        }
        field(9; "Shortcut Dim 1 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            CaptionClass = '1,2,1';
            Editable = true;
            trigger OnValidate()
            begin
                TestStatusOpen();
                // ValidateShortcutDimCode(1, "Shortcut Dim 1 Code");
            end;
        }
        field(10; "Shortcut Dim 2 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            CaptionClass = '1,2,2';
            Editable = true;
            trigger OnValidate()
            begin
                TestStatusOpen();
                // ValidateShortcutDimCode(2, "Shortcut Dim 2 Code");
            end;
        }
        field(11; "Expected Delivery Date"; Date)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(12; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(13; "Status"; Enum MRSStatus)
        {
            DataClassification = ToBeClassified;
            Editable = false;

        }
        field(14; "Comment"; Text[250])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(15; "No. Series"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(16; "No. of Copies Printed"; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(17; "Created By"; Code[20])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(18; "Created Date"; DateTime)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(19; "Last Modified By"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(20; "Last Modified Date"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(21; "Closed Date"; DateTime)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(22; "Closed By"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(23; "Project Ref. No."; Code[10])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
            // TableRelation = Job."No." WHERE("Approval Status" = FILTER(<> Blocked));
        }
        field(24; "Project Stage Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(25; "Project Budget Ref."; Code[10])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        // field(26; "Request Type"; Enum "Request Type")
        // {
        //     DataClassification = ToBeClassified;
        // }
        field(27; "LPO Ref. No."; Code[20])
        {
            // DataClassification = ToBeClassified;
            // FieldClass = FlowField;
            // CalcFormula = Lookup("Purchase Header"."No." WHERE("Purch Req. Ref. No." = FIELD("No.")));
            Editable = false;
        }
        // field(28; "LPO Status"; Enum "LPO Status")
        // {
        //     //DataClassification = ToBeClassified;
        //     CalcFormula = Lookup("Purchase Header".Status WHERE("Purch Req. Ref. No." = FIELD("No.")));
        //     Editable = true;
        //     FieldClass = FlowField;
        // }
        field(29; "GRN Process"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(30; "Dimension Set ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Dimension Set Entry";
            // trigger OnLookup()
            // begin
            //     ShowDocDim;
            // end;

            trigger OnValidate()
            begin
                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dim 1 Code", "Shortcut Dim 2 code")
            end;
        }
    }
    trigger OnInsert()
    var
        SRSetup: Record "Sales & Receivables Setup";
        NoMgt: Codeunit NoSeriesManagement;
    begin
        if "No." = '' then begin
            SRSetup.Get();
            "No." := NoMgt.GetNextNo(SRSetup.PRS, WorkDate(), true);
        end;
    end;

    local procedure TestStatusOpen()
    begin
        TestField(Status, Status::Open);
    end;

    // local procedure ShowDocDim()
    // begin
    // end;

    var
        DimMgt: Codeunit DimensionManagement;

}