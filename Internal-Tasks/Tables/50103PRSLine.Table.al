table 50103 "PRS Line"
{
    DataClassification = ToBeClassified;
    Caption = 'Purch Requisition Line';
    fields
    {
        field(1; "Documnet No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Documnet No';
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Line No.';
        }
        field(3; Type; Enum "MRS Line Type")
        {
            DataClassification = ToBeClassified;
            Caption = 'Type';
            trigger OnValidate()
            begin
                TestStatusOpen();
                ChangeStatus();
            end;
        }
        field(4; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
            TableRelation = IF (Type = CONST(" ")) "Standard Text"
            ELSE
            IF (Type = CONST("G/L Account")) "G/L Account" WHERE("Direct Posting" = CONST(true), "Account Type" = CONST(Posting), Blocked = CONST(false))
            ELSE
            IF (Type = CONST("G/L Account")) "G/L Account"
            ELSE
            IF (Type = CONST(Resource)) Resource
            ELSE
            IF (Type = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF (Type = CONST("Charge(Item)")) "Item Charge"
            ELSE
            IF (Type = CONST(Item), "Document Type" = FILTER(<> "Credit Memo" & <> "Return Order")) Item WHERE(Blocked = CONST(false), "Sales Blocked" = CONST(false))
            ELSE
            IF (Type = CONST(Item), "Document Type" = FILTER("Credit Memo" | "Return Order")) Item WHERE(Blocked = CONST(false));

            trigger OnValidate()
            var
                Item: Record Item;
                PRSHeader: Record "PRS Header";
                data: Code[20];
            begin
                TestStatusOpen();
                case Type of
                    Type::" ":
                        CopyFromStandardText();
                    Type::"G/L Account":
                        CopyFromGLAccount();
                    Type::Item:
                        CopyFromItem();
                    Type::Resource:
                        CopyFromResource();
                    Type::"Fixed Asset":
                        CopyFromFixedAsset();
                    Type::"Charge(Item)":
                        CopyFromItemCharge();
                end;

                if Rec."No." <> xRec."No." then begin
                    Clear(rec."Avaliable Stock");
                    data := Rec."No.";
                end;
                // PRSHeader.SetRange(PRSHeader."No.", "Documnet No.");
                // if PRSHeader.FindSet() then begin
                //     Rec.SetRange("Documnet No.", Rec."Documnet No.");
                //     if Rec.FindSet() then begin
                //         repeat
                //             item.SetRange(Item."No.", data);
                //             if item.FindSet() then begin
                //                 Clear(Rec."Vendor No.");
                //                 "Vendor No." := Item."Vendor No.";
                //             end;
                //         until Rec.Next() = 0;
                //     end;
                // end;
            end;
        }
        field(5; Description; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Description';
            TableRelation = IF (Type = CONST(" ")) "Standard Text"
            ELSE
            IF (Type = CONST("G/L Account")) "G/L Account"
            ELSE
            IF (Type = CONST(Item)) "Item"
            ELSE
            IF (Type = CONST("Resource")) "resource"
            ELSE
            IF (Type = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF (Type = CONST("Charge(Item)")) "Item Charge";
            trigger OnValidate()
            begin
                TestStatusOpen();
                if Description <> '' then
                    case type of
                        type::" ":
                            CopyFromStandardTextDes();
                        type::"G/L Account":
                            CopyFromGLAccountDes();
                        type::Item:
                            CopyFromItemDes();
                        type::Resource:
                            CopyFromResourceDes();
                        type::"Fixed Asset":
                            CopyFromFixedAssetDes();
                        type::"Charge(Item)":
                            CopyFromItemChargeDes();
                    end;
            end;
        }
        field(6; "Description 2"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Description 2';
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(7; "Unit of Measure Code"; Code[20])
        {
            Description = 'SAA3.0';
            DataClassification = ToBeClassified;
            Caption = 'Unit of Measure Code';
            NotBlank = true;
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("No."));
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(8; "Unit Price"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Editable = false;
            Caption = 'Unit Price';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                TestStatusOpen();
                CalcSums("Line Amount (LCY)");
            end;

        }
        field(9; "Requested Quantity"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Caption = 'Requested Quantity';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                TestStatusOpen();
                CalcSums("Line Amount (LCY)");
            end;
        }
        field(10; "Avaliable Stock"; Decimal)
        {
            // DataClassification = ToBeClassified;
            Caption = 'Avaliable Stock';
            DecimalPlaces = 1 : 1;
            // FieldClass = FlowField;
            Editable = false;
            NotBlank = true;
            // CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No.")));
        }
        field(11; "Qty to Order"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Caption = 'Qty to Order';
            trigger OnValidate()
            begin
                TestStatusOpen();
                // CheckRemainingQty();//calculation
            end;
        }
        field(12; "Line Amount (LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Line Amount (LCY)';
            Editable = false;
        }
        field(13; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            Editable = true;
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            trigger OnValidate()
            begin
                TestStatusOpen();
                // ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(14; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            trigger OnValidate()
            begin
                TestStatusOpen();
                // ValidateShortcutDimCode(1, "Shortcut Dimension 2 Code");
            end;
        }
        field(15; "Issue Dept."; Code[20])
        {
            Caption = 'Issue Dept.';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(16; "Issue Bus. Unit"; Code[20])
        {
            Caption = 'Issue Bus. Unit';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(17; "Indent Dept."; Code[20])
        {
            Caption = 'Indent Dept.';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(18; "Indent Bus. Unit"; Code[20])
        {
            Caption = 'Indent Bus. Unit';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(19; "Expected Delivery Date"; Date)
        {
            Description = 'SAA3.0';
            Caption = 'Expected Delivery Date';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(20; "Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity(Base)';
            DataClassification = ToBeClassified;
        }
        field(21; "Order Quantity (Base)"; Decimal)
        {
            // DataClassification = ToBeClassified;
            Editable = false;
            Caption = 'Order Quantity(Base)';
            // FieldClass=FlowField;
            // CalcFormula= Sum("Purchase Line"."Quantity (Base)" WHERE("Sub Document Type" = CONST("Purchase Req."), "Sub Document No." = FIELD("Document No."), "Sub Document Line No." = FIELD("Line No.")));
        }
        field(22; "Quantity Received(Base)"; Decimal)
        {
            Caption = 'Quantity Received(Base)';
            // FieldClass=FlowField;
            // CalcFormula= Sum("Purch. Rcpt. Line"."Quantity (Base)" WHERE("Sub Document Type" = CONST("Purchase Req."), "Sub Document No." = FIELD("Document No."), "Sub Document Line No." = FIELD("Line No.")));
        }

        field(23; "Comment"; Text[150])
        {
            Caption = 'Comment';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(24; "MRS No."; Code[20])
        {
            Description = 'SAA3.0';
            Editable = false;
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;

        }
        field(25; "MRS Line No."; Integer)
        {
            Description = 'SAA3.0';
            Caption = 'MRS Line No.';
            Editable = false;
            DataClassification = ToBeClassified;
            // TableRelation = MRSLine."SIT_Line No." WHERE( = FIELD("MRS No."));
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;

        }
        field(26; "Purchase Type"; Option)
        {
            Description = 'SAA3.0';
            Caption = 'Purchase Type';
            DataClassification = ToBeClassified;
            OptionMembers = " ",Import,"Local";
            OptionCaption = ' ,Import,Local';
        }
        field(27; "Document Type"; Enum "Sales Document Type")
        {
            DataClassification = ToBeClassified;
        }
        field(28; "Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor;
        }
        field(29; POCheck; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Documnet No.", "Line No.")
        {
            Clustered = true;
        }
    }
    procedure TestStatusOpen()
    var
        PRS: Record "PRS Header";
    begin
        Rec.Reset();
        PRS.SetRange("No.", Rec."Documnet No.");
        if PRS.FindSet() then
            PRS.TestField(Status, PRS.Status::Open);
    end;

    local procedure ChangeStatus()
    begin
        if "Line No." <> 0 then begin
            if Rec.Type <> xRec.Type then begin
                xRec."Documnet No." := Rec."Documnet No.";
                xRec."Line No." := Rec."Line No.";
                xRec.Type := Rec.Type;
                Clear(Rec);
                Rec."Documnet No." := xRec."Documnet No.";
                Rec."Line No." := xRec."Line No.";
                Rec.Type := xRec.Type;
                Rec.Modify(true);
            end;
        end else
            Rec.Validate("Documnet No.");
    end;

    local procedure CopyFromStandardText()
    var
        StandardText: Record "Standard Text";
    begin
        StandardText.Get("No.");
        Description := StandardText.Description;
    end;

    procedure GetItem(var Item: Record Item)
    begin
        TestField("No.");
        Item.Get("No.");
    end;

    local procedure CopyFromItem()
    var
        Item: Record Item;
        PrepaymentMgt: Codeunit "Prepayment Mgt.";
        IsHandled: Boolean;
    begin
        GetItem(Item);
        IsHandled := false;

        Description := Item.Description;
        "Description 2" := Item."Description 2";
        "Unit Price" := Item."Unit Price";
        "Unit of Measure Code" := Item."Base Unit of Measure";
    end;

    local procedure CopyFromGLAccount()
    begin
        GLAcc.Get("No.");
        GLAcc.CheckGLAcc;
        Description := GLAcc.Name;
    end;

    local procedure CopyFromResource()
    var
        IsHandled: Boolean;
    begin
        Res.Get("No.");
        Res.CheckResourcePrivacyBlocked(false);
        IsHandled := false;
        Description := Res.Name;
        "Description 2" := Res."Name 2";
        "Unit Price" := Res."Unit Price";
        "Unit of Measure Code" := Res."Base Unit of Measure";
    end;

    local procedure CopyFromFixedAsset()
    var
        FixedAsset: Record "Fixed Asset";
    begin
        FixedAsset.Get("No.");
        FixedAsset.TestField(Inactive, false);
        FixedAsset.TestField(Blocked, false);
        Description := FixedAsset.Description;
        "Description 2" := FixedAsset."Description 2";
    end;

    local procedure CopyFromItemCharge()
    begin
        ItemCharge.Get("No.");
        Description := ItemCharge.Description;
    end;

    local procedure CopyFromStandardTextDes()
    var
        StandardText: Record "Standard Text";
    begin
        StandardText.Get(Description);
        "No." := StandardText.Code;
        Description := StandardText.Description;
    end;

    local procedure CopyFromGLAccountDes()
    var
        GLAcc: Record "G/L Account";
    begin
        GLAcc.Get(Description);
        // GLAcc.CheckGLAcc;
        "No." := GLAcc."No.";
        Description := GLAcc.Name;
    end;

    local procedure CopyFromItemDes()
    var
        Item: Record "Item";
    begin
        if Description = '' then begin
            exit;
        end;
        Item.Get(Description);
        "No." := Item."No.";
        Description := item.Description;
        "Unit Price" := Item."Unit Price";
        "Unit of Measure Code" := Item."Base Unit of Measure";
    end;

    local procedure CopyFromResourceDes()
    var
        Res: Record Resource;
    begin
        Res.Get(Description);
        Res.CheckResourcePrivacyBlocked(false);
        "No." := Res."No.";
        Description := Res.Name;
        "Unit Price" := Res."Unit Price";
        "Unit of Measure Code" := Res."Base Unit of Measure";
    end;

    local procedure CopyFromFixedAssetDes()
    var
        FixedAsset: Record "Fixed Asset";
    begin
        FixedAsset.Get(Description);
        FixedAsset.TestField(Inactive, false);
        FixedAsset.TestField(Blocked, false);
        "No." := FixedAsset."No.";
        Description := FixedAsset.Description;
    end;

    local procedure CopyFromItemChargeDes()
    var
        ItemCharge: Record "Item Charge";
    begin
        ItemCharge.Get(Description);
        "No." := ItemCharge."No.";
        Description := ItemCharge.Description;
    end;


    var
        myInt: Integer;
        Res: Record Resource;
        MRSHeader: Record MRSHeader;
        GLAcc: Record "G/L Account";
        ItemCharge: Record "Item Charge";
        ReturnValue: Text[100];
        FindRecordMgt: Codeunit "Find Record Management";
}