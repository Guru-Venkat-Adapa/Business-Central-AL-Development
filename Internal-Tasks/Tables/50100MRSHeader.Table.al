table 50100 MRSHeader
{
    DataClassification = ToBeClassified;
    Caption = 'MRS Header';
    fields
    {
        field(1; "SIT_MRS No."; Code[20])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CheckStatus();
            end;
        }
        field(2; "SIT_Document Date"; Date)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CheckStatus();
            end;
        }
        field(3; "SIT_Date of MRS"; Date)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CheckStatus();
            end;
        }
        field(4; "SIT_Manual MRS No."; Code[30])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CheckStatus();
            end;
        }
        field(5; "SIT_Location Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CheckStatus();
            end;
        }
        field(6; "SIT_Issue Dept."; Code[20])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CheckStatus();
            end;
        }
        field(7; "SIT_Issue Bus. Unit"; Code[20])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CheckStatus();
            end;
        }
        field(8; "SIT_Indent Dept."; Code[20])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CheckStatus();
            end;
        }
        field(9; "SIT_Indent Bus. Unit"; Code[20])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CheckStatus();
            end;
        }
        field(10; "SIT_Requistion Division"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                Data.ValidateShortcutDimCode(1, Rec."SIT_Requistion Division", Rec);
            end;
        }
        field(11; "SIT_Requistion Department"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                Data.ValidateShortcutDimCode(2, "SIT_Requistion Department", Rec);
            end;
        }
        field(12; "SIT_Expected Delivery Date"; Date)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CheckStatus();
            end;
        }
        field(13; "SIT_Issued Date"; Date)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CheckStatus();
            end;
        }
        field(14; "SIT_Status"; Enum MRSStatus)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(15; "SIT_Comment"; Text[250])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CheckStatus();
            end;
        }
        field(16; "SIT_No. Series"; Code[10])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CheckStatus();
            end;
        }
        field(17; "SIT_No. of Copies Printed"; Integer)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CheckStatus();
            end;
        }
        field(18; "SIT_Created By"; Code[20])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CheckStatus();
            end;
        }
        field(19; "SIT_Created Date"; DateTime)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CheckStatus();
            end;
        }
        field(20; "SIT_Last Modified By"; Code[20])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CheckStatus();
            end;
        }
        field(21; "SIT_Last Modified Date"; DateTime)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CheckStatus();
            end;
        }
        field(22; "SIT_Purch. Req. Ref. No."; code[20])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CheckStatus();
            end;
        }
        field(23; "SIT_Dim. Document Type"; Enum DimDoctype)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CheckStatus();
            end;
        }
        field(24; "SIT_Project Ref. No."; code[10])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CheckStatus();
            end;
        }
        field(25; "SIT_Project Stage Code"; code[10])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CheckStatus();
            end;
        }
        field(26; "SIT_Project Budget Ref."; code[10])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CheckStatus();
            end;
        }
        field(27; "SIT_Dimension Setup ID"; Integer)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CheckStatus();
            end;
        }
        field(28; "SIT_Responsibility Center"; Code[10])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CheckStatus();
            end;
        }
        field(29; "SIT_From-Location Code"; code[20])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CheckStatus();
            end;
        }
        field(30; "SIT_Document Type"; Enum "Sales Document Type")
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CheckStatus();
            end;
        }
        field(31; "SIT_Materials Issued To"; Code[20])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CheckStatus();
            end;
        }
        field(32; "SIT_Staff Name"; Text[30])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CheckStatus();
            end;
        }
        field(33; "SIT_Received By"; Code[30])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CheckStatus();
            end;
        }
        field(34; "SIT_Project Task No."; code[20])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CheckStatus();
            end;
        }
        field(35; "SIT_MRS Released By"; Code[20])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CheckStatus();
            end;
        }
    }

    keys
    {
        key(Pk; "SIT_MRS No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;

    trigger OnInsert()
    var
        // setup: Record "No. Series Setup MRS Header";
        SRSetup: Record "Sales & Receivables Setup";
        NoMgt: Codeunit NoSeriesManagement;
    begin
        if "SIT_MRS No." = '' then begin
            SRSetup.Get();
            "SIT_MRS No." := NoMgt.GetNextNo(SRSetup.MRS, WorkDate(), true);
            SIT_Status := SIT_Status::Open;
        end;
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

    procedure CheckStatus()
    begin
        TestField(SIT_Status, SIT_Status::Open);
    end;

    var
        Data: Page "MRS Card Page";

}