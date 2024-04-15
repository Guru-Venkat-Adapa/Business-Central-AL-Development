table 50101 MRSLine
{
    DataClassification = ToBeClassified;
    Caption = 'MRS Line';
    fields
    {
        field(1; "SIT_Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'MRS No.';
        }
        field(2; "SIT_Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'Line No.';
            AutoIncrement = false;
        }
        field(3; "SIT_MRS Type"; enum MRSType)
        {
            DataClassification = ToBeClassified;
            Description = 'MRS Type';
        }
        field(4; "SIT_Type"; Enum "MRS Line Type")
        {
            DataClassification = ToBeClassified;
            Description = 'Type';
            trigger OnValidate()
            begin
                ChangeStatus();
            end;
        }
        field(5; "SIT_No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Item No., G/L Account No., Fixed Asset No., etc...';
            TableRelation = IF (SIT_Type = CONST(" ")) "Standard Text"
            ELSE
            IF (SIT_Type = CONST("G/L Account")) "G/L Account" WHERE("Direct Posting" = CONST(true), "Account Type" = CONST(Posting), Blocked = CONST(false))
            ELSE
            IF (SIT_Type = CONST("G/L Account")) "G/L Account"
            ELSE
            IF (SIT_Type = CONST(Resource)) Resource
            ELSE
            IF (SIT_Type = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF (SIT_Type = CONST("Charge(Item)")) "Item Charge"
            ELSE
            IF (SIT_Type = CONST(Item), "Document Type" = FILTER(<> "Credit Memo" & <> "Return Order")) Item WHERE(Blocked = CONST(false), "Sales Blocked" = CONST(false))
            ELSE
            IF (SIT_Type = CONST(Item), "Document Type" = FILTER("Credit Memo" | "Return Order")) Item WHERE(Blocked = CONST(false));

            trigger OnValidate()
            begin
                TestStatusOpen();
                case SIT_Type of
                    SIT_Type::" ":
                        CopyFromStandardText();
                    SIT_Type::"G/L Account":
                        CopyFromGLAccount();
                    SIT_Type::Item:
                        CopyFromItem();
                    SIT_Type::Resource:
                        CopyFromResource();
                    SIT_Type::"Fixed Asset":
                        CopyFromFixedAsset();
                    SIT_Type::"Charge(Item)":
                        CopyFromItemCharge();
                end;

                if Rec."SIT_No." <> xRec."SIT_No." then begin
                    Clear(Rec."SIT_Location Code");
                    Clear(rec."SIT_Available Stock");
                end;
            end;
        }
        field(6; "SIT_Description"; text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'Description';
            TableRelation = IF ("SIT_Type" = CONST(" ")) "Standard Text" ELSE
            IF ("SIT_Type" = CONST("G/L Account")) "G/L Account" ELSE
            IF ("SIT_Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("SIT_Type" = CONST("Charge(Item)")) "Item Charge"
            ELSE
            IF ("SIT_Type" = CONST(Item)) Item WHERE(Blocked = CONST(false), "Purchasing Blocked" = CONST(false))
            ELSE
            IF ("SIT_Type" = CONST(Item)) Item WHERE(Blocked = CONST(false))
            else
            if ("SIT_Type" = const(Resource)) Resource;
            trigger OnValidate()
            begin
                TestStatusOpen();
                if SIT_Description <> '' then
                    case "SIT_Type" of
                        "SIT_Type"::" ":
                            CopyFromStandardTextDes();
                        "SIT_Type"::"G/L Account":
                            CopyFromGLAccountDes();
                        "SIT_Type"::Item:
                            CopyFromItemDes();
                        "SIT_Type"::Resource:
                            CopyFromResourceDes();
                        "SIT_Type"::"Fixed Asset":
                            CopyFromFixedAssetDes();
                        "SIT_Type"::"Charge(Item)":
                            CopyFromItemChargeDes();
                    end;

            end;
        }
        field(7; "SIT_Description2"; text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'Additional Description';
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(8; "SIT_Location Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Location Code';
            TableRelation = Location where("Use As In-Transit" = const(false));
            trigger OnValidate()
            var
                Item: Record Item;
                MRSHeader: Record MRSHeader;
            begin
                TestStatusOpen();
                if "SIT_No." <> '' then begin
                    Item.Reset;
                    Item.setfilter("Location Filter", "SIT_Location Code");
                    Item.setrange("No.", "SIT_No.");
                    if Item.FINDFIRST then begin
                        Item.CALCFIELDS(Inventory);
                        "SIT_Available Stock" := Item.Inventory;
                    end;
                end;
                MRSHeader.SetRange("SIT_MRS No.", Rec."SIT_Document No.");
                if MRSHeader.FindSet() then
                    MRSHeader."SIT_Location Code" := Rec."SIT_Location Code";
                MRSHeader.Modify(true);
            end;
        }
        field(9; "SIT_Unit of Measure Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Unit of Measure Code';
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(10; "SIT_Unit Cost"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Unit Cost';
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(11; "SIT_Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Quantity';
            trigger OnValidate()
            begin
                TestStatusOpen();
                "SIT_Line Amount(LCY)" := SIT_Quantity * "SIT_Unit Cost";
            end;
        }
        field(12; "SIT_Available Stock"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Available Stock';
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(13; "SIT_Qty. on Requisition"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Quantity on Purchase Requisition';

            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(14; "SIT_Line Amount(LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Line Amount in Local Currency';
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(15; "SIT_Shortcut Dimension 1 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Requisition Division';
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(16; "SIT_Shortcut Dimension 2 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Requisition Department';
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(17; "SIT_Issue Dept."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Issue Department';
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(18; "SIT_Issue Bus. Unit"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Issue Business Unit';
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(19; "SIT_Indent Dept."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Indent Department';
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(20; "SIT_Indent Bus. Unit"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Indent Business Unit';
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(21; "SIT_Expected Delivery Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'Expected Delivery Date';
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(22; "SIT_Comment"; Text[150])
        {
            DataClassification = ToBeClassified;
            Description = 'Comment';
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(23; "SIT_Created By"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Created By';
        }
        field(24; "SIT_Created Date"; DateTime)
        {
            DataClassification = ToBeClassified;
            Description = 'Created Date';
        }
        field(25; "SIT_Last Modified By"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Last Modified By';
        }
        field(26; "SIT_Last Modified Date"; DateTime)
        {
            DataClassification = ToBeClassified;
            Description = 'Last Modified Date';
        }
        field(27; "SIT_Acknowledged Issued Qty"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Acknowledged Issued Quantity';
        }
        field(28; "SIT_Issued Acknowledged By"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'Issued Acknowledged By';
        }
        field(29; "SIT_Issued AcknowLedged DtTime"; DateTime)
        {
            DataClassification = ToBeClassified;
            Description = 'Issued Acknowledged Date and Time';
        }
        field(30; "SIT_Return Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Return Quantity';
        }
        field(31; "SIT_Returned By"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'User Who Processed the Return';
        }
        field(32; "SIT_Returned DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
            Description = 'Date and Time of Return';
        }
        field(33; "SIT_Dimension Set ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'Dimension Set ID';
        }
        field(34; "SIT_Qty. to Issue"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Quantity to Issue';
        }
        field(35; "SIT_Quantity Issued"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Quantity Issued';
        }
        field(36; "SIT_Qty. to Request"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Purchase Request Quantity';
        }
        field(37; "SIT_Qty. Batched Not Issued"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Quantity Batched Not Issued';
        }
        field(38; "SIT_Total Item Qty Batched"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Total Quantity on Journal Lines';
        }
        field(39; "SIT_FA Posting Type"; Enum FAPostingType)
        {
            DataClassification = ToBeClassified;
            Description = 'Fixed Asset Posting Type';
        }
        field(40; "SIT_FA No."; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'Fixed Asset No.';
        }
        field(41; "SIT_Maintenance Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'Maintenance Code';
        }
        field(42; "SIT_Responsibility Center"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'Responsibility Center';
        }
        field(43; "SIT_Qty. to Return"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Quantity to Return';
        }
        field(44; "SIT_Qty Returned Acknowledged"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Quantity Returned Acknowledged';
        }
        field(45; "SIT_Item Category Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Item Category Code';
            TableRelation = "Item Category";
        }
        field(46; "SIT_Make Purch. Req. Doc"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'Make Purchase Requisition Document';
        }
        field(47; "SIT_PRS Created"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'Purchase Requisition Created';
        }
        field(48; "SIT_Purch. Req. Ref. No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Purchase Requisition Reference No.';
        }
        field(49; "SIT_Status"; Enum MRSStatus)
        {
            DataClassification = ToBeClassified;
            Description = 'MRS Line Status';
        }
        field(50; "SIT_Qty. On Order"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Quantity On Order';
        }
        field(51; "SIT_Qty. To Purchase"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Quantity To Purchase';
        }
        field(52; "SIT_Item Specification Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Item Specification';
        }
        field(53; "Document Type"; Enum "Sales Document Type")
        {
            Caption = 'Document Type';
        }

    }

    keys
    {
        key(Pk; "SIT_Document No.", "SIT_Line No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;
        Res: Record Resource;
        MRSHeader: Record MRSHeader;
        GLAcc: Record "G/L Account";
        ItemCharge: Record "Item Charge";
        ReturnValue: Text[100];
        FindRecordMgt: Codeunit "Find Record Management";

    procedure TestStatusOpen()
    var
        MRS: Record "MRSHeader";
    begin
        Rec.Reset();
        MRS.SetRange("SIT_MRS No.", Rec."SIT_Document No.");
        if MRS.FindSet() then
            MRS.TestField(SIT_Status, MRS.SIT_Status::Open);
    end;

    local procedure ChangeStatus()
    begin
        if "SIT_Line No." <> 0 then begin
            if Rec.SIT_Type <> xRec.SIT_Type then begin
                xRec."SIT_Document No." := Rec."SIT_Document No.";
                xRec."SIT_Line No." := Rec."SIT_Line No.";
                xRec.SIT_Type := Rec.SIT_Type;
                Clear(Rec);
                Rec."SIT_Document No." := xRec."SIT_Document No.";
                Rec."SIT_Line No." := xRec."SIT_Line No.";
                Rec.SIT_Type := xRec.SIT_Type;
                Rec.Modify(true);
            end;
        end else
            Rec.Validate("SIT_Document No.");
    end;

    local procedure CopyFromStandardText()
    var
        StandardText: Record "Standard Text";
    begin
        StandardText.Get("SIT_No.");
        SIT_Description := StandardText.Description;
    end;

    procedure GetItem(var Item: Record Item)
    begin
        TestField("SIT_No.");
        Item.Get("SIT_No.");
    end;

    local procedure CopyFromItem()
    var
        Item: Record Item;
        PrepaymentMgt: Codeunit "Prepayment Mgt.";
        IsHandled: Boolean;
    begin
        GetItem(Item);
        IsHandled := false;

        SIT_Description := Item.Description;
        SIT_Description2 := Item."Description 2";
        "SIT_Unit Cost" := Item."Unit Price";
        "SIT_Unit of Measure Code" := Item."Base Unit of Measure";
    end;

    local procedure CopyFromGLAccount()
    begin
        GLAcc.Get("SIT_No.");
        GLAcc.CheckGLAcc;
        SIT_Description := GLAcc.Name;
    end;

    local procedure CopyFromResource()
    var
        IsHandled: Boolean;
    begin
        Res.Get("SIT_No.");
        Res.CheckResourcePrivacyBlocked(false);
        IsHandled := false;
        SIT_Description := Res.Name;
        SIT_Description2 := Res."Name 2";
        "SIT_Unit Cost" := Res."Unit Price";
        "SIT_Unit of Measure Code" := Res."Base Unit of Measure";
    end;

    local procedure CopyFromFixedAsset()
    var
        FixedAsset: Record "Fixed Asset";
    begin
        FixedAsset.Get("SIT_No.");
        FixedAsset.TestField(Inactive, false);
        FixedAsset.TestField(Blocked, false);
        SIT_Description := FixedAsset.Description;
        SIT_Description2 := FixedAsset."Description 2";
    end;

    local procedure CopyFromItemCharge()
    begin
        ItemCharge.Get("SIT_No.");
        SIT_Description := ItemCharge.Description;
    end;

    local procedure CopyFromStandardTextDes()
    var
        StandardText: Record "Standard Text";
    begin
        StandardText.Get(SIT_Description);
        "SIT_No." := StandardText.Code;
        SIT_Description := StandardText.Description;
    end;

    local procedure CopyFromGLAccountDes()
    var
        GLAcc: Record "G/L Account";
    begin
        GLAcc.Get(SIT_Description);
        // GLAcc.CheckGLAcc;
        "SIT_No." := GLAcc."No.";
        SIT_Description := GLAcc.Name;
    end;

    local procedure CopyFromItemDes()
    var
        Item: Record "Item";
    begin
        if SIT_Description = '' then begin
            exit;
        end;
        Item.Get(SIT_Description);
        "SIT_No." := Item."No.";
        SIT_Description := item.Description;
        "SIT_Unit Cost" := Item."Unit Price";
        "SIT_Unit of Measure Code" := Item."Base Unit of Measure";
    end;

    local procedure CopyFromResourceDes()
    var
        Res: Record Resource;
    begin
        Res.Get(SIT_Description);
        Res.CheckResourcePrivacyBlocked(false);
        "SIT_No." := Res."No.";
        SIT_Description := Res.Name;
        "SIT_Unit Cost" := Res."Unit Price";
        "SIT_Unit of Measure Code" := Res."Base Unit of Measure";
    end;

    local procedure CopyFromFixedAssetDes()
    var
        FixedAsset: Record "Fixed Asset";
    begin
        FixedAsset.Get(SIT_Description);
        FixedAsset.TestField(Inactive, false);
        FixedAsset.TestField(Blocked, false);
        "SIT_No." := FixedAsset."No.";
        SIT_Description := FixedAsset.Description;
    end;

    local procedure CopyFromItemChargeDes()
    var
        ItemCharge: Record "Item Charge";
    begin
        ItemCharge.Get(SIT_Description);
        "SIT_No." := ItemCharge."No.";
        SIT_Description := ItemCharge.Description;
    end;
}