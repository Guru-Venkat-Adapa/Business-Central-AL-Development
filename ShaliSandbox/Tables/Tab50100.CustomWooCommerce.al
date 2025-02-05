table 50101 "Custom Woo Commerce"
{
    Caption = 'Custom Woo Commerce';
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
            Description = 'The primary key of the setup entry';
            NotBlank = true;
        }
        field(2; "Consumer Key"; Text[50])
        {
            Caption = 'Consumer Key';
            DataClassification = CustomerContent;
            Description = 'The Consumer Key for the service you want to connect to.';
            ExtendedDatatype = Masked;

            trigger OnValidate()
            begin
                if "Consumer Key" <> '' then
                    Evaluate("Consumer Key", "Consumer Key".Trim());
            end;
        }
        field(3; "Consumer Secret"; Text[50])
        {
            Caption = 'Consumer Secret';
            DataClassification = CustomerContent;
            Description = 'The Consumer Secret of the service you want to connect to.';
            ExtendedDatatype = Masked;

            trigger OnValidate()
            begin
                if "Consumer Secret" <> '' then
                    Evaluate("Consumer Secret", "Consumer Secret".Trim());
            end;
        }
        field(4; "Service URL"; Text[250])
        {
            Caption = 'Service URL';
            DataClassification = CustomerContent;
            Description = 'The Service URL of the service you want to connect to.';
            ExtendedDataType = URL;
            trigger OnValidate()
            begin
                CheckWebstoreURL("Service URL");
            end;
        }
        field(5; "Webstore URL"; Text[250])
        {
            Caption = 'Webstore URL';
            DataClassification = CustomerContent;
            Description = 'The URL of your webstore you want to connect to.';
            ExtendedDataType = URL;
            trigger OnValidate()
            begin
                CheckWebstoreURL("Webstore URL");
                UpdateRESTAPIServiceURL();
            end;
        }
        field(7; Type; Enum "Woo Webstore Connector Type")
        {
            Caption = 'Type';
            DataClassification = CustomerContent;
            Description = 'The type of table you want to use.';
        }
        field(8; "Default Document Date"; Enum "Woo Default Document Date")
        {
            Caption = 'Default Document Date';
            DataClassification = CustomerContent;
            InitValue = WorkDate;
            ValuesAllowed = WorkDate, "Webstore Date Created";
        }
        field(9; "Default Posting Date"; Enum "Woo Default Document Date")
        {
            Caption = 'Default Posting Date';
            DataClassification = CustomerContent;
            InitValue = Default;
            ValuesAllowed = Default, "Webstore Date Created";
        }
        field(15; Enabled; Boolean)
        {
            Caption = 'Enabled';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                CurrentWebstoreSetup: Codeunit "Woo Current Webstore Setup";
            begin
                CurrentWebstoreSetup.Set(Rec.Code);
                EnableWebstoreIntegration();
            end;
        }
        field(20; "Item Last Synced"; DateTime)
        {
            Caption = 'Item Last Synced';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(21; "Customer Last Synced"; DateTime)
        {
            Caption = 'Customer Last Synced';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(22; "Order Last Synced"; DateTime)
        {
            Caption = 'Order Last Synced';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(23; "Coupon Last Synced"; DateTime)
        {
            Caption = 'Coupon Last Synced';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(28; "Return Order Last Synced"; DateTime)
        {
            Caption = 'Return Order Last Synced';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(25; "Last Sales Order Date Created"; Text[50])
        {
            ObsoleteState = Pending;
            ObsoleteReason = 'Field is no longer used. Replaced by Last Sales Order Date Modified';
            ObsoleteTag = '21.4.0.0';
            Caption = 'Last Sales Order Date Created';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(218; "Last Sales Order Date Modified"; Text[50])
        {
            Caption = 'Last Sales Order Date Modified';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(30; "Coupon Nos."; Code[20])
        {
            Caption = 'Coupon Nos.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(41; "Order Sync. Start Date"; Date)
        {
            Caption = 'Order Sync. Start Date';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Order Sync. Start Date" <> xRec."Order Sync. Start Date" then
                    ConfirmOrderSyncStartDateChangeIfAlreadySynced();
            end;
        }
        field(45; "Default Guest Customer No."; Code[20])
        {
            Caption = 'Default Guest Customer No.';
            DataClassification = CustomerContent;
            TableRelation = Customer;

            trigger OnValidate()
            var
                Customer: Record Customer;
                PostingSetupMgt: Codeunit PostingSetupManagement;
            begin
                if "Default Guest Customer No." <> '' then begin
                    Customer.Get("Default Guest Customer No.");
                    Customer.TestField("Customer Posting Group");
                    PostingSetupMgt.CheckCustPostingGroupReceivablesAccount(Customer."Customer Posting Group");
                end;
            end;
        }
        field(47; "Item Template Code"; Code[20])
        {
            Caption = 'Item Template Code';
            DataClassification = CustomerContent;
            TableRelation = "Item Templ.";

            trigger OnValidate()
            begin
                if "Item Template Code" <> '' then
                    CheckItemTemplate();
            end;
        }
        field(48; "Customer Template Code"; Code[20])
        {
            Caption = 'Customer Template Code';
            DataClassification = CustomerContent;
            TableRelation = "Customer Templ.";

            trigger OnValidate()
            begin
                if "Customer Template Code" <> '' then
                    CheckCustomerTemplate();
            end;
        }
        field(61; "Default Location Code"; Code[10])
        {
            Caption = 'Default Location Code';
            DataClassification = CustomerContent;
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(70; "Wizard Status"; Option)
        {
            Caption = 'Wizard Status';
            DataClassification = CustomerContent;
            OptionCaption = 'Not Completed,Completed,Not Started,Seen,Watched,Read, ';
            OptionMembers = "Not Completed","Completed","Not Started","Seen","Watched","Read"," ";
        }

        field(75; "Sales Orders - Synced"; Integer)
        {
            CalcFormula = count("Woo Sales Order Log" where("Woo Date Created" = field("Date Filter")));
            Caption = 'Webstore Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(32; "Return Orders"; Integer)
        {
            CalcFormula = count("Sales Header" where("Woo Webstore Code" = field(Code), "Document Type" = const("Return Order")));
            Caption = 'Webstore Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(76; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(85; "Webstore Customers"; Integer)
        {
            CalcFormula = count("Woo Cust. Webstore Connector" where("Webstore Code" = field(Code),
                                                                    "Use in Webstore" = const(true)));
            Caption = 'Webstore Customers';
            Editable = false;
            FieldClass = FlowField;
        }
        field(86; "Webstore Items"; Integer)
        {
            CalcFormula = count("Woo Item Webstore Connector" where("Webstore Code" = field(Code),
                                                                    "Use in Webstore" = const(true)));
            Caption = 'Webstore Items';
            Editable = false;
            FieldClass = FlowField;
        }
        field(87; "Webstore Coupons"; Integer)
        {
            CalcFormula = count("Woo Coupon Webstore Connector" where("Webstore Code" = field(Code)));
            Caption = 'Webstore Coupons';
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; "Webstore Item Categories"; Integer)
        {
            Caption = 'Webstore Item Categories';
            CalcFormula = count("Woo Item Cat. Web. Connector" where("Webstore Code" = field(Code),
                                                                    "Use in Webstore" = const(true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(12; "Webstore Orders"; Integer)
        {
            Caption = 'Webstore Orders';
            CalcFormula = count("Sales Header" where("Woo Webstore Code" = field(Code), "Woo Webstore Order" = const(true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(27; "Webstore Return Orders"; Integer)
        {
            Caption = 'Webstore Return Orders';
            CalcFormula = count("Sales Header" where("Woo Webstore Code" = field(Code), "Woo Webstore Return Order" = const(true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(120; "Item Sync. Errors"; Integer)
        {
            CalcFormula = count("Activity Log" where("Woo Syncronization Date" = field("Item Activity Date Filter"),
                                                    "Woo Syncronization Job Type" = const(Item),
                                                    Status = const(Failed)));
            Caption = 'Item Sync. Errors';
            Editable = false;
            FieldClass = FlowField;
        }
        field(121; "Customer Sync. Errors"; Integer)
        {
            CalcFormula = count("Activity Log" where("Woo Syncronization Date" = field("Customer Activity Date Filter"),
                                                    "Woo Syncronization Job Type" = const(Customer),
                                                    Status = const(Failed)));
            Caption = 'Customer Sync. Errors';
            Editable = false;
            FieldClass = FlowField;
        }
        field(122; "Order Sync. Errors"; Integer)
        {
            CalcFormula = count("Activity Log" where("Woo Syncronization Date" = field("Order Activity Date Filter"),
                                                    "Woo Syncronization Job Type" = const("Sales Order"),
                                                    Status = const(Failed)));
            Caption = 'Order Sync. Errors';
            Editable = false;
            FieldClass = FlowField;
        }
        field(29; "Return Order Sync. Errors"; Integer)
        {
            CalcFormula = count("Activity Log" where("Woo Syncronization Date" = field("Order Activity Date Filter"),
                                                    "Woo Syncronization Job Type" = const("Return Order"),
                                                    Status = const(Failed)));
            Caption = 'Return Order Sync. Errors';
            Editable = false;
            FieldClass = FlowField;
        }
        field(123; "Coupon Sync. Errors"; Integer)
        {
            CalcFormula = count("Activity Log" where("Woo Syncronization Date" = field("Coupon Activity Date Filter"),
                                                    "Woo Syncronization Job Type" = const(Coupon),
                                                    Status = const(Failed)));
            Caption = 'Coupon Sync. Errors';
            Editable = false;
            FieldClass = FlowField;
        }
        field(125; "Pull Webstore Items"; Enum "Woo Sync. Webstore Records")
        {
            Caption = 'Pull Webstore Items';
            DataClassification = SystemMetadata;
            ValuesAllowed = All, "Published Only", "Mapped Only", None;
        }
        field(126; "Pull Webstore Item Categories"; Enum "Woo Sync. Webstore Records")
        {
            Caption = 'Pull Webstore Item Categories';
            DataClassification = SystemMetadata;
            ValuesAllowed = All, "Mapped Only", None;
        }
        field(127; "Pull Webstore Customers"; Enum "Woo Sync. Webstore Records")
        {
            Caption = 'Pull Webstore Customers';
            DataClassification = SystemMetadata;
            ValuesAllowed = All, "Mapped Only", None;
        }
        field(136; "Pull Webstore Orders"; Enum "Woo Sync. Webstore Records")
        {
            Caption = 'Pull Webstore Orders';
            DataClassification = SystemMetadata;
            ValuesAllowed = All, None;
        }
        field(137; "Push Webstore Items"; Enum "Woo Sync. Webstore Records")
        {
            Caption = 'Push Webstore Items';
            DataClassification = SystemMetadata;
            InitValue = "Mapped Only";
            ValuesAllowed = "Mapped Only", None;
        }
        field(138; "Push Webstore Item Categories"; Enum "Woo Sync. Webstore Records")
        {
            Caption = 'Push Webstore Item Categories';
            DataClassification = SystemMetadata;
            InitValue = "Mapped Only";
            ValuesAllowed = "Mapped Only", None;
        }
        field(140; "Push Webstore Customers"; Enum "Woo Sync. Webstore Records")
        {
            Caption = 'Push Webstore Customers';
            DataClassification = SystemMetadata;
            InitValue = "Mapped Only";
            ValuesAllowed = "Mapped Only", None;
        }
        field(33; "Pull Webstore Return Orders"; Enum "Woo Sync. Webstore Records")
        {
            Caption = 'Pull Webstore Return Orders';
            DataClassification = SystemMetadata;
            ValuesAllowed = All, None;
        }
        field(141; "Length Attribute ID"; Integer)
        {
            Caption = 'Length Attribute ID';
            DataClassification = CustomerContent;
            TableRelation = "Item Attribute";
            ObsoleteState = Pending;
            ObsoleteReason = 'Product dimensions are no longer used as attributes.';
            ObsoleteTag = '21.4';
        }
        field(142; "Width Attribute ID"; Integer)
        {
            Caption = 'Width Attribute ID';
            DataClassification = CustomerContent;
            TableRelation = "Item Attribute";
            ObsoleteState = Pending;
            ObsoleteReason = 'Product dimensions are no longer used as attributes.';
            ObsoleteTag = '21.4';
        }
        field(143; "Height Attribute ID"; Integer)
        {
            Caption = 'Height Attribute ID';
            DataClassification = CustomerContent;
            TableRelation = "Item Attribute";
            ObsoleteState = Pending;
            ObsoleteReason = 'Product dimensions are no longer used as attributes.';
            ObsoleteTag = '21.4';
        }
        field(145; "Length Attribute Name"; Text[250])
        {
            Caption = 'Length Attribute Name';
            DataClassification = CustomerContent;
            TableRelation = "Item Attribute".Name;
            ValidateTableRelation = false;
            ObsoleteState = Pending;
            ObsoleteReason = 'Product dimensions are no longer used as attributes.';
            ObsoleteTag = '21.4';
        }
        field(146; "Width Attribute Name"; Text[250])
        {
            Caption = 'Width Attribute Name';
            DataClassification = CustomerContent;
            TableRelation = "Item Attribute".Name;
            ValidateTableRelation = false;
            ObsoleteState = Pending;
            ObsoleteReason = 'Product dimensions are no longer used as attributes.';
            ObsoleteTag = '21.4';
        }
        field(147; "Height Attribute Name"; Text[250])
        {
            Caption = 'Height Attribute Name';
            DataClassification = CustomerContent;
            TableRelation = "Item Attribute".Name;
            ValidateTableRelation = false;
            ObsoleteState = Pending;
            ObsoleteReason = 'Product dimensions are no longer used as attributes.';
            ObsoleteTag = '21.4';
        }
        field(170; "Item Sync. Logs"; Integer)
        {
            CalcFormula = count("Activity Log" where("Woo Syncronization Date" = field("Item Activity Date Filter"),
                                                    "Woo Syncronization Job Type" = const(Item),
                                                    Status = const(Success)));
            Caption = 'Item Sync. Logs';
            Editable = false;
            FieldClass = FlowField;
        }
        field(171; "Customer Sync. Logs"; Integer)
        {
            CalcFormula = count("Activity Log" where("Woo Syncronization Date" = field("Customer Activity Date Filter"),
                                                    "Woo Syncronization Job Type" = const(Customer),
                                                    Status = const(Success)));
            Caption = 'Customer Sync. Logs';
            Editable = false;
            FieldClass = FlowField;
        }
        field(172; "Order Sync. Logs"; Integer)
        {
            CalcFormula = count("Activity Log" where("Woo Syncronization Date" = field("Order Activity Date Filter"),
                                                    "Woo Syncronization Job Type" = const("Sales Order"),
                                                    Status = const(Success)));
            Caption = 'Order Sync. Logs';
            Editable = false;
            FieldClass = FlowField;
        }
        field(31; "Return Order Sync. Logs"; Integer)
        {
            CalcFormula = count("Activity Log" where("Woo Syncronization Date" = field("Order Activity Date Filter"),
                                                    "Woo Syncronization Job Type" = const("Return Order"),
                                                    Status = const(Success)));
            Caption = 'Return Order Sync. Logs';
            Editable = false;
            FieldClass = FlowField;
        }
        field(173; "Coupon Sync. Logs"; Integer)
        {
            CalcFormula = count("Activity Log" where("Woo Syncronization Date" = field("Coupon Activity Date Filter"),
                                                    "Woo Syncronization Job Type" = const(Coupon),
                                                    Status = const(Success)));
            Caption = 'Coupon Sync. Logs';
            Editable = false;
            FieldClass = FlowField;
        }
        field(190; "Item Activity Date Filter"; DateTime)
        {
            Caption = 'Item Activity Date Filter';
            FieldClass = FlowFilter;
        }
        field(191; "Customer Activity Date Filter"; DateTime)
        {
            Caption = 'Customer Activity Date Filter';
            FieldClass = FlowFilter;
        }
        field(192; "Order Activity Date Filter"; DateTime)
        {
            Caption = 'Order Activity Date Filter';
            FieldClass = FlowFilter;
        }
        field(193; "Coupon Activity Date Filter"; DateTime)
        {
            Caption = 'Coupon Activity Date Filter';
            FieldClass = FlowFilter;
        }
        field(205; "Webstore List Cache Time"; Integer)
        {
            Caption = 'Webstore List Cache Time';
            DataClassification = CustomerContent;
            MinValue = 0;
            BlankZero = true;
            InitValue = 60;
        }
        field(215; "Order Nos. Type"; Enum "Woo Order Nos. Type")
        {
            Caption = 'Order Nos. Type';
            DataClassification = CustomerContent;
            InitValue = "Default";
        }
        field(216; "Order Nos."; Code[20])
        {
            Caption = 'Order Nos';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(217; "Sales Tax Account No."; Code[20])
        {
            Caption = 'Sales Tax Account No.';
            DataClassification = CustomerContent;
            Description = 'G/L Account for posting Tax Amount';
            TableRelation = "G/L Account" where("Direct Posting" = const(true), Blocked = const(false), "Account Type" = const(Posting));
            ValidateTableRelation = true;
        }
        field(26; "Shipping Acount Type"; Enum "Sales Line Type")
        {
            Caption = 'Shipping Account Type';
            DataClassification = CustomerContent;
            Description = 'Acount type for posting total shipping amount.';
            InitValue = 'G/L Account';
            ValuesAllowed = "G/L Account", "Item", "Resource", "Fixed Asset", "Charge (Item)";

            trigger OnValidate()
            begin
                if "Shipping Account No." <> '' then
                    "Shipping Account No." := '';
            end;
        }
        field(6; "Shipping Account No."; Code[20])
        {
            Caption = 'Shipping Account No.';
            DataClassification = CustomerContent;
            Description = 'Account for posting Total Shipping Amount.';
            TableRelation = if ("Shipping Acount Type" = const("G/L Account")) "G/L Account" where("Direct Posting" = const(true)) else
            if ("Shipping Acount Type" = const("Item")) Item where(Blocked = const(false), "Gen. Prod. Posting Group" = filter(<> ''), "Sales Blocked" = const(false)) else
            if ("Shipping Acount Type" = const("Resource")) Resource where("Privacy Blocked" = const(false), Blocked = const(false)) else
            if ("Shipping Acount Type" = const("Fixed Asset")) "Fixed Asset" where(Inactive = const(false), Blocked = const(false)) else
            if ("Shipping Acount Type" = const("Charge (Item)")) "Item Charge";
            ValidateTableRelation = true;
        }
        field(14; "Complete Webstore Orders"; Boolean)
        {
            Caption = 'Complete Webstore Orders on Posting';
            DataClassification = CustomerContent;
        }
        field(10; "Webstore Status Filter"; Code[250])
        {
            Caption = 'Webstore Status Filter';
            DataClassification = CustomerContent;
        }
        field(13; "No. of Minutes between Runs"; Integer)
        {
            Caption = 'No. of Minutes between Runs';
            DataClassification = CustomerContent;
            InitValue = 15;
        }
        field(16; "Item Sync. Start Date"; Date)
        {
            Caption = 'Item Sync. Start Date';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if Rec."Item Sync. Start Date" <> xRec."Item Sync. Start Date" then
                    ConfirmItemSyncStartDateModification();
            end;
        }
        field(17; "Coupon Sync. Start Date"; Date)
        {
            Caption = 'Coupon Sync. Start Date';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if Rec."Coupon Sync. Start Date" <> xRec."Coupon Sync. Start Date" then
                    ConfirmCouponSyncStartDateModification();
            end;
        }
        field(219; "Item Last Modified"; Text[50])
        {
            Caption = 'Item Last Modified';
            DataClassification = CustomerContent;
        }
        field(19; "Coupon Last Modified"; Text[50])
        {
            Caption = 'Coupon Last Modified';
            DataClassification = CustomerContent;
        }
        field(18; "API Key as Query Param"; Boolean)
        {
            Caption = 'API Key as Query Param';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "API Key as Query Param" then
                    ConfirmAuthKeysAsParameter();
            end;
        }
        field(24; "Activity Log Retention Period"; Enum "Woo Activity Log Ret. Period")
        {
            Caption = 'Activity Log Retention Period';
            DataClassification = CustomerContent;
        }
        field(34; "Webstore Weight"; Enum "Woo Item Webstore Weight")
        {
            Caption = 'Webstore Weight';
            DataClassification = CustomerContent;
        }
        field(35; "Regular Price"; Enum "Woo Regular Price")
        {
            DataClassification = CustomerContent;
            Caption = 'Regular Price';
        }

        field(36; "Customer Price Group"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Customer Price Group';
            TableRelation = "Customer Price Group";
        }
        field(37; "Marketing Text"; Enum "Woo Marketing Text")
        {
            DataClassification = CustomerContent;
            Caption = 'Marketing Text';
        }
        field(38; "Push Webstore Coupons"; Enum "Woo Sync. Webstore Records")
        {
            Caption = 'Push Webstore Coupons';
            DataClassification = CustomerContent;
            ValuesAllowed = "All", None;
        }
        field(39; "Pull Webstore Coupons"; Enum "Woo Sync. Webstore Records")
        {
            Caption = 'Pull Webstore Coupons';
            DataClassification = CustomerContent;
            ValuesAllowed = "All", None;
        }
        field(40; "Customer Note Sync"; Enum "Woo Customer Note Sync")
        {
            DataClassification = CustomerContent;
            Caption = 'Customer Note Sync';
        }
        field(42; "Customer Role Filter"; Enum "Woo Customer Role Filter")
        {
            Caption = 'Customer Role Filter';
            DataClassification = CustomerContent;
            InitValue = "Customer";
        }
        field(43; "Item Nos. Type"; Enum "Woo Item Nos Type")
        {
            Caption = 'Item Nos. Type';
            DataClassification = CustomerContent;
            InitValue = "Default";
        }
        field(44; "Item Nos."; Code[20])
        {
            Caption = 'Item Nos.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(46; "Default Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = CustomerContent;
            TableRelation = "Customer";

            trigger OnValidate()
            var
                Customer: Record Customer;
                PostingSetupMgt: Codeunit PostingSetupManagement;
            begin
                if "Default Customer No." <> '' then begin
                    Customer.Get("Default Customer No.");
                    Customer.TestField("Customer Posting Group");
                    PostingSetupMgt.CheckCustPostingGroupReceivablesAccount(Customer."Customer Posting Group");
                end;
            end;
        }
    }


    keys
    {
        key(PrimaryKey; Code)
        {
            Clustered = true;
        }
        key(Key2; Type)
        {
        }
        key(Key3; "Order Last Synced")
        {
        }
    }

    var
        HideDialog: Boolean;
        ItemDefaultNosNotTrueErr: Label 'Default Nos. must be ''Yes'' in No. Series: Code=%1 used for items. Current Value is ''No''. This can be changed in No. Series Table', Comment = '%1 = Item Nos.';
        CustomerDefaultNosNotTrueErr: Label 'Default Nos. must be ''Yes'' in No. Series: Code=%1 used for customers. Current Value is ''No''. This can be changed in No. Series Table', Comment = '%1 = Customer Nos.';
        OrderDefaultNosNotTrueErr: Label 'Default Nos. must be ''Yes'' in No. Series: Code=%1 used for orders. Current Value is ''No''. This can be changed in No. Series Table', Comment = '%1 = Order Nos.';

    trigger OnInsert();
    begin
        SetWebstoreConnectorSetupType();
        SetNoOfMinutesBetweenRun();
        SetCouponNoSeries();
        SetActivityLogRetentionPeriod();
    end;

    trigger OnDelete()
    var
        DeleteMainWebstoreConnectorSetupErr: Label 'You can''t delete Main WooCommerce Connector Setup';
        DeleteWebstoreConnectorWhileEnabledErr: Label 'You can''t delete WooCommerce Connector Setup while Background Jobs are active.';
    begin
        if Rec.Type = Rec.Type::Main then
            Error(DeleteMainWebstoreConnectorSetupErr);

        if Rec."Enabled" then
            Error(DeleteWebstoreConnectorWhileEnabledErr);

        DeleteWebstoreConnectors();
    end;

    trigger OnRename()

    begin
        if not "Enabled" then
            exit;

        // CancelJobQueueEntries(xRec);
        // ScheduleJobQueueEntries(Rec);
    end;

    trigger OnModify()
    var
        CurrentWebstoreSetup: Codeunit "Woo Current Webstore Setup";
    begin
        CurrentWebstoreSetup.Set(Rec.Code);
    end;

    local procedure SetWebstoreConnectorSetupType()
    var
        MainWebstoreConnectorSetup: Record "Woo Webstore Connector Setup";
    begin
        if MainWebstoreConnectorSetup.FindMain() then
            Rec.Type := MainWebstoreConnectorSetup.Type::Additional;
    end;

    local procedure EnableWebstoreIntegration()
    begin
        if "Enabled" then begin
            CheckWebstoreSetup();
            OnBeforeEnableWebstoreIntegration();
            TestConnection(HideDialog, true);
            Modify();
            //     ScheduleJobQueueEntries(Rec);
            // end else
            //     CancelJobQueueEntries(Rec);
        end;
    end;

    local procedure DeleteWebstoreConnectors()
    var
        CurrentWebstoreSetup: Codeunit "Woo Current Webstore Setup";
    begin
        if CurrentWebstoreSetup.IsMultiStoreEnvironment() then begin
            DeleteItemWebstoreConnector();
            DeleteCustomerWebstoreConnector();
            DeleteCouponWebstoreConnector();
            DeleteItemAttributeWebstoreConnector();
            DeleteItemAttributeValueWebstoreConnector();
            DeleteItemVariantWebstoreConnector();
            DeleteItemCategoryWebstoreConnector();
        end;
    end;


    local procedure DeleteItemWebstoreConnector()
    var
        ItemWebstoreConnector: Record "Woo Item Webstore Connector";
    begin
        ItemWebstoreConnector.SetCurrentKey("Webstore Code");
        ItemWebstoreConnector.SetRange("Webstore Code", Rec.Code);
        ItemWebstoreConnector.DeleteAll(true);
    end;

    local procedure DeleteCustomerWebstoreConnector()
    var
        CustomerWebstoreConnector: Record "Woo Cust. Webstore Connector";
    begin
        CustomerWebstoreConnector.SetCurrentKey("Webstore Code");
        CustomerWebstoreConnector.SetRange("Webstore Code", Rec.Code);
        CustomerWebstoreConnector.DeleteAll(true);
    end;

    local procedure DeleteCouponWebstoreConnector()
    var
        CouponWebstoreConnector: Record "Woo Coupon Webstore Connector";
    begin
        CouponWebstoreConnector.SetCurrentKey("Webstore Code");
        CouponWebstoreConnector.SetRange("Webstore Code", Rec.Code);
        CouponWebstoreConnector.DeleteAll(true);
    end;

    local procedure DeleteItemAttributeWebstoreConnector()
    var
        ItemAttributeWebstoreConnector: Record "Woo Item Att. Web. Connector";
    begin
        ItemAttributeWebstoreConnector.SetCurrentKey("Webstore Code");
        ItemAttributeWebstoreConnector.SetRange("Webstore Code", Rec.Code);
        ItemAttributeWebstoreConnector.DeleteAll(true);
    end;

    local procedure DeleteItemAttributeValueWebstoreConnector()
    var
        ItemAttributeValueWebstoreConnector: Record "Woo Item Att. Val. Web. Conn";
    begin
        ItemAttributeValueWebstoreConnector.SetCurrentKey("Webstore Code");
        ItemAttributeValueWebstoreConnector.SetRange("Webstore Code", Rec.Code);
        ItemAttributeValueWebstoreConnector.DeleteAll(true);
    end;

    local procedure DeleteItemVariantWebstoreConnector()
    var
        ItemVariantWebstoreConnector: Record "Woo Item Var. Web. Connector";
    begin
        ItemVariantWebstoreConnector.SetCurrentKey("Webstore Code");
        ItemVariantWebstoreConnector.SetRange("Webstore Code", Rec.Code);
        ItemVariantWebstoreConnector.DeleteAll(true);
    end;

    local procedure DeleteItemCategoryWebstoreConnector()
    var
        ItemCategoryWebstoreConnector: Record "Woo Item Cat. Web. Connector";
    begin
        ItemCategoryWebstoreConnector.SetCurrentKey("Webstore Code");
        ItemCategoryWebstoreConnector.SetRange("Webstore Code", Rec.Code);
        ItemCategoryWebstoreConnector.DeleteAll(true);
    end;

    local procedure UpdateRESTAPIServiceURL()
    begin
        if xRec."Webstore URL" = "Webstore URL" then
            exit;

        if "Webstore URL" <> '' then
            Validate("Service URL", "Webstore URL" + GetSuffixForRESTAPIService())
        else
            Validate("Service URL", '');
    end;

    local procedure GetSuffixForRESTAPIService(): Text[20]
    begin
        exit('/wp-json/wc/v3');
    end;

    procedure GetProductAPIURL(): Text;
    begin
        TestField("Service URL");

        exit("Service URL" + '/products');
    end;

    procedure GetCouponAPIURL(): Text;
    begin
        TestField("Service URL");

        exit("Service URL" + '/coupons');
    end;

    procedure GetProductCategoriesAPIURL(): Text;
    begin
        TestField("Service URL");

        exit("Service URL" + '/products/categories');
    end;

    procedure GetProductAttributesAPIURL(): Text;
    begin
        TestField("Service URL");

        exit("Service URL" + '/products/attributes');
    end;

    procedure GetProductAttributeTermsAPIURL(AttributeWebstoreID: Integer): Text;
    begin
        TestField("Service URL");

        exit("Service URL" + '/products/attributes/' + Format(AttributeWebstoreID) + '/terms');
    end;

    procedure GetProductAttributeTermsAPIURL(AttributeWebstoreID: Integer; AttributeValueWebstoreID: Integer): Text;
    begin
        TestField("Service URL");

        exit("Service URL" + '/products/attributes/' + Format(AttributeWebstoreID) + '/terms/' + Format(AttributeValueWebstoreID));
    end;

    procedure GetProductVariantsAPIURL(ProductWebstoreID: Integer): Text;
    begin
        TestField("Service URL");

        exit("Service URL" + '/products/' + Format(ProductWebstoreID) + '/variations');
    end;

    procedure GetProductVariantsAPIURL(ProductWebstoreID: Integer; ProductvariationWebstoreID: Integer): Text;
    begin
        TestField("Service URL");

        exit("Service URL" + '/products/' + Format(ProductWebstoreID) + '/variations/' + Format(ProductvariationWebstoreID));
    end;

    procedure GetCustomerRequestURL(): Text;
    begin
        TestField("Service URL");

        exit("Service URL" + '/customers');
    end;

    procedure GetOrderRequestURL(): Text;
    begin
        TestField("Service URL");

        exit("Service URL" + '/orders');
    end;

    procedure GetReturnOrderRequestURL(WebstoreOrderID: Integer): Text;
    begin
        TestField("Service URL");

        exit("Service URL" + '/orders/' + Format(WebstoreOrderID) + '/refunds');
    end;

    procedure GetPaymentMethodRequestURL(): Text;
    begin
        TestField("Service URL");

        exit("Service URL" + '/payment_gateways');
    end;

    [NonDebuggable]
    procedure GetBasicAuthText(): Text;
    var
        WooServiceAuthorization: Codeunit "Woo Service Authorization";
    begin
        TestField("Consumer Key");
        TestField("Consumer Secret");

        exit(WooServiceAuthorization.GetBasicAuthorization("Consumer Key", "Consumer Secret"));
    end;

    procedure GetWebstoreListCacheTimeInMilliseconds(): Integer
    begin
        // return time in milliseconds (1 minute = 60000 milliseconds)
        exit("Webstore List Cache Time" * 60000);
    end;

    procedure TestConnection(DoHideDialog: Boolean; HideSuccessMessage: Boolean);
    var
        WooTestConnection: Codeunit "Woo Test Connection";
    begin
        //  WooTestConnection.TestConnection(Rec, DoHideDialog, HideSuccessMessage);
    end;

    procedure IsServiceEnabled(): Boolean;
    begin
        if not "Enabled" then
            exit(false);

        if "Service URL" = '' then
            exit(false);

        exit(true);
    end;

    procedure CheckWebstoreSetupCredentials()
    begin
        TestField("Consumer Key");
        TestField("Consumer Secret");
        TestField("Service URL");
    end;

    procedure CheckWebstoreSetup()
    begin
        CheckWebstoreSetupForItemSync();
        CheckWebstoreSetupForCustomerSync();
        CheckWebstoreSetupForOrderSync();
        TestField("Coupon Nos.");

        OnAfterCheckWebstoreSetup();
    end;

    procedure CheckWebstoreSetupForItemSync()
    begin
        CheckWebstoreSetupCredentials();

        TestField("Item Template Code");

        if Rec."Regular Price" = Enum::"Woo Regular Price"::"Customer Price Group" then
            TestField("Customer Price Group");

        CheckItemNoSeries();
    end;

    procedure CheckWebstoreSetupForCustomerSync()
    begin
        CheckWebstoreSetupCredentials();

        TestField("Customer Template Code");

        CheckCustomerNoSeries();
    end;

    procedure CheckWebstoreSetupForOrderSync()
    begin
        CheckOrderNoSeries();
    end;

    local procedure CheckItemNoSeries()
    var
        InventorySetup: Record "Inventory Setup";
        NoSeries: Record "No. Series";
        ItemTemplate: Record "Item Templ.";
    begin
        if ItemTemplate.Get(Rec."Item Template Code") then
            if ItemTemplate."No. Series" <> '' then begin
                NoSeries.Get(ItemTemplate."No. Series");
                CheckDefaultNoSeries(NoSeries."Default Nos.", ItemDefaultNosNotTrueErr, NoSeries.Code);
            end
            else begin
                InventorySetup.SetLoadFields("Item Nos.");
                InventorySetup.Get();
                InventorySetup.TestField("Item Nos.");
                NoSeries.Get(InventorySetup."Item Nos.");
                CheckDefaultNoSeries(NoSeries."Default Nos.", ItemDefaultNosNotTrueErr, InventorySetup."Item Nos.");
            end;
    end;

    local procedure CheckCustomerNoSeries()
    var
        SalesAndRecivablesSetup: Record "Sales & Receivables Setup";
        NoSeries: Record "No. Series";
        CustomerTemplate: Record "Customer Templ.";
    begin
        if CustomerTemplate.Get(Rec."Customer Template Code") then
            if CustomerTemplate."No. Series" <> '' then begin
                NoSeries.Get(CustomerTemplate."No. Series");
                CheckDefaultNoSeries(NoSeries."Default Nos.", CustomerDefaultNosNotTrueErr, NoSeries.Code);
            end else begin
                SalesAndRecivablesSetup.SetLoadFields("Customer Nos.");
                SalesAndRecivablesSetup.Get();
                SalesAndRecivablesSetup.TestField("Customer Nos.");
                NoSeries.Get(SalesAndRecivablesSetup."Customer Nos.");
                CheckDefaultNoSeries(NoSeries."Default Nos.", CustomerDefaultNosNotTrueErr, SalesAndRecivablesSetup."Customer Nos.");
            end;
    end;

    local procedure CheckOrderNoSeries()
    var
        SalesAndRecivablesSetup: Record "Sales & Receivables Setup";
        NoSeries: Record "No. Series";
        OrderNos: Code[20];
    begin
        if "Order Nos. Type" = "Order Nos. Type"::WebstoreID then
            exit;

        if "Order Nos. Type" = "Order Nos. Type"::"Webstore Order No." then
            exit;

        if "Order Nos. Type" = "Order Nos. Type"::Custom then begin
            TestField("Order Nos.");
            NoSeries.Get("Order Nos.");
            OrderNos := "Order Nos.";
        end;

        if "Order Nos. Type" = "Order Nos. Type"::Default then begin
            SalesAndRecivablesSetup.SetLoadFields("Order Nos.");
            SalesAndRecivablesSetup.Get();
            SalesAndRecivablesSetup.TestField("Order Nos.");
            NoSeries.Get(SalesAndRecivablesSetup."Order Nos.");
            OrderNos := SalesAndRecivablesSetup."Order Nos.";
        end;
        CheckDefaultNoSeries(NoSeries."Default Nos.", OrderDefaultNosNotTrueErr, OrderNos);
    end;

    local procedure CheckDefaultNoSeries(DefaultNos: Boolean; ErrorMessage: Text; NumberSeries: Code[20])
    var
        NoSeriesErrorHandler: Codeunit "Woo NoSeries Error Handler";
        DefaultNosError: ErrorInfo;
        DefaultNosErrorTitleLbl: Label 'Invalid No. Series Configuration';
        DefaultNosErrorActionLbl: Label 'Set value to Yes';
    begin
        if not DefaultNos then begin
            DefaultNosError.DataClassification := DefaultNosError.DataClassification::CustomerContent;
            DefaultNosError.ErrorType := DefaultNosError.ErrorType::Client;
            DefaultNosError.Verbosity := DefaultNosError.Verbosity::Error;
            DefaultNosError.Title := DefaultNosErrorTitleLbl;
            DefaultNosError.Message := StrSubstNo(ErrorMessage, NumberSeries);
            //  NoSeriesErrorHandler.SetNumberSeries(NumberSeries);
            DefaultNosError.AddAction(DefaultNosErrorActionLbl, Codeunit::"Woo NoSeries Error Handler", 'SetDefaultNosToTrue');
            Error(DefaultNosError);
        end;
    end;

    local procedure CheckWebstoreURL(var WebServiceURL: Text[250])
    var
        HttpWebRequestMgt: Codeunit "Http Web Request Mgt.";
    begin
        if WebServiceURL = '' then
            exit;

        Evaluate(WebServiceURL, WebServiceURL.Trim());
        HttpWebRequestMgt.CheckUrl(WebServiceURL);
        while (STRLEN(WebServiceURL) > 8) AND (WebServiceURL[StrLen(WebServiceURL)] = '/') DO
            WebServiceURL := CopyStr(CopyStr(WebServiceURL, 1, StrLen(WebServiceURL) - 1), 1, MaxStrLen(WebServiceURL));
    end;

    local procedure ConfirmOrderSyncStartDateChangeIfAlreadySynced()
    var
        ConfirmManagement: Codeunit "Confirm Management";
        ConfrirmOrderSyncStartDateQst: Label 'Sales Orders were already synced from webstore after the %1. Changin %2 will reset last order sync. time which could cause some of the exising orders to be picked for integration again.\\Are you sure you want to continue?', Comment = '%1 = Woo Order Sync. Start Date, %2 = Woo Order Sync. Start Date caption';
    begin
        if "Order Sync. Start Date" = 0D then
            exit;

        TestField("Enabled", false);

        if ("Order Sync. Start Date" < DT2Date("Order Last Synced")) and ("Order Last Synced" <> 0DT) then begin
            if not ConfirmManagement.GetResponseOrDefault(
                StrSubstNo(
                    ConfrirmOrderSyncStartDateQst,
                        "Order Sync. Start Date",
                        FieldCaption("Order Sync. Start Date")),
                    true)
            then
                Error('');

            "Order Last Synced" := 0DT;
            "Last Sales Order Date Modified" := '';
        end;
    end;

    local procedure ConfirmItemSyncStartDateModification()
    var
        ConfirmManagement: Codeunit "Confirm Management";
        TypeHelper: Codeunit "Type Helper";
        SableSortableFormatTxt: Label 's', Locked = true;
        Variable: Variant;
        ItemLastModified: Date;
        ConfrirmItemSyncStartDateQst: Label 'Items were already synced from webstore after the %1. Changin %2 will reset item last sync. \\Are you sure you want to continue?', Comment = '%1 = Item Sync. Start Date, %2 = Item Sync. Start Date caption';
    begin
        if "Item Sync. Start Date" = 0D then
            exit;

        if "Item Last Modified" = '' then
            exit;

        TestField("Enabled", false);

        ItemLastModified := 0D;

        Variable := ItemLastModified;
        if TypeHelper.Evaluate(Variable, "Item Last Modified", SableSortableFormatTxt, '') then
            ItemLastModified := Variable;

        if "Item Sync. Start Date" < ItemLastModified then begin
            if not ConfirmManagement.GetResponseOrDefault(StrSubstNo(ConfrirmItemSyncStartDateQst,
                                ItemLastModified,
                                FieldCaption("Item Sync. Start Date")),
                                true)
                            then
                Error('');

            "Item Last Modified" := ''
        end;
    end;

    local procedure ConfirmCouponSyncStartDateModification()
    var
        ConfirmManagement: Codeunit "Confirm Management";
        TypeHelper: Codeunit "Type Helper";
        SableSortableFormatTxt: Label 's', Locked = true;
        Variable: Variant;
        CouponLastModified: Date;
        ConfrirmCouponSyncStartDateQst: Label 'Coupons were already synced from webstore after the %1. Changin %2 will reset coupon last sync. \\Are you sure you want to continue?', Comment = '%1 = Coupon Sync. Start Date, %2 = Coupon Sync. Start Date caption';
    begin
        if "Coupon Sync. Start Date" = 0D then
            exit;

        if "Coupon Last Modified" = '' then
            exit;

        TestField("Enabled", false);

        CouponLastModified := 0D;

        Variable := CouponLastModified;
        if TypeHelper.Evaluate(Variable, "Coupon Last Modified", SableSortableFormatTxt, '') then
            CouponLastModified := Variable;

        if "Coupon Sync. Start Date" < CouponLastModified then begin
            if not ConfirmManagement.GetResponseOrDefault(StrSubstNo(ConfrirmCouponSyncStartDateQst,
                                CouponLastModified,
                                FieldCaption("Coupon Sync. Start Date")),
                                true)
                            then
                Error('');

            "Coupon Last Modified" := ''
        end;
    end;

    local procedure ScheduleJobQueueEntries(var WooCommerceConnectorSetup: Record "Woo Webstore Connector Setup")
    var
        ScheduleJob: Codeunit "Woo Schedule Job";
    begin
        ScheduleJob.ScheduleJobQueueEntries(WooCommerceConnectorSetup);
    end;

    local procedure CancelJobQueueEntries(var WooCommerceConnectorSetup: Record "Woo Webstore Connector Setup")
    var
        ScheduleJob: Codeunit "Woo Schedule Job";
    begin
        ScheduleJob.CancelJobQueueEntries(WooCommerceConnectorSetup);
    end;

    procedure ShowJobQueueEntry()
    var
        ScheduleJob: Codeunit "Woo Schedule Job";
    begin
        // ScheduleJob.ShowJobQueueEntry(Rec);
    end;

    procedure RescheduleJobQueueEntries(HideConfirmDialog: Boolean)
    var
        ProductMgt: Codeunit "Woo Product Mgt.";
        ResetJobQueueEntriesConfirmQst: Label 'This will reset jobs for %1 synchronization.\\Are you sure that you want to continue?', Comment = '%1 = product name';
        SetupSuccessfulMsg: Label 'The reset of %1 synchronization jobs has completed successfully.', Comment = '%1 = product name';
    begin
        if GuiAllowed() and (not HideConfirmDialog) then
            if not Confirm(ResetJobQueueEntriesConfirmQst, false, ProductMgt.GetProductName()) then
                exit;

        //ScheduleJobQueueEntries(Rec);
        Message(SetupSuccessfulMsg, ProductMgt.GetProductName());
    end;

    [Obsolete('Function is no longer in use. Use CountWebstoreJobQueueEntries(Record "Woo Webstore Connector Setup";integer;integer) instead', '19.5')]
    procedure CountWebstoreJobQueueEntries(var ActiveJobs: Integer; var TotalJobs: Integer)
    begin
    end;

    procedure CountWooCommerceJobQueueEntries(var ActiveJobs: Integer; var TotalJobs: Integer)
    var
        ScheduleJob: Codeunit "Woo Schedule Job";
    begin
        // ScheduleJob.CountWebstoreJobQueueEntries(Rec, ActiveJobs, TotalJobs);
    end;

    procedure ShowActivityLog()
    var
        ActivityLog: Record "Activity Log";
    begin
        ActivityLog.ShowEntries(Rec);
    end;

    procedure ShowSalesOrderLog()
    var
        SalesOrderLog: Record "Woo Sales Order Log";
    begin
        SalesOrderLog.ShowEntriesForCurrMonth();
    end;

    local procedure CheckItemTemplate()
    var
        ItemTempl: Record "Item Templ.";
    begin
        ItemTempl.Get("Item Template Code");
        ItemTempl.TestField("Gen. Prod. Posting Group");
        ItemTempl.TestField("Inventory Posting Group");
        ItemTempl.TestField("Base Unit of Measure");
    end;

    local procedure CheckCustomerTemplate()
    var
        CustomerTempl: Record "Customer Templ.";
    begin
        CustomerTempl.Get("Customer Template Code");
        CustomerTempl.TestField("Customer Posting Group");
        CustomerTempl.TestField("Gen. Bus. Posting Group");
    end;

    procedure ErrorIfWebstoreUrlIsEmpty()
    var
        WebstoreUrlShouldNotBeEmptyErr: Label 'You must specify the URL of your online store solution.';
    begin
        if "Webstore URL" = '' then
            Error(WebstoreUrlShouldNotBeEmptyErr);
    end;

    procedure ErrorIfWebstoreKeyIsEmpty()
    var
        WebstoreKeyShouldNotBeEmptyErr: Label 'You must specify the consumer key of your online store solution.';
    begin
        if "Consumer Key" = '' then
            Error(WebstoreKeyShouldNotBeEmptyErr);
    end;

    procedure ErrorIfWebstoreSecretIsEmpty()
    var
        WebstoreSecretShouldNotBeEmptyErr: Label 'You must specify the consumer secret of your online store solution.';
    begin
        if "Consumer Secret" = '' then
            Error(WebstoreSecretShouldNotBeEmptyErr);
    end;

    procedure ErrorIfMandatorySetupFieldIsEmpty(FieldValue: Text; FieldCaption: Text)
    var
        MandatorySetupFieldIsEmptyErr: Label 'You must specify the %1 that will be used in integration.', Comment = '%1 - field name, %2 - field caption';
    begin
        if FieldValue = '' then
            Error(MandatorySetupFieldIsEmptyErr, FieldCaption);
    end;

    procedure GetHideDialog(): Boolean
    begin
        exit(HideDialog);
    end;

    procedure SetHideDialog(NewHideDialog: Boolean);
    begin
        HideDialog := NewHideDialog;
    end;

    procedure SetCurrMonthFilter(StartDate: Date; EndDate: Date);
    begin
        SetRange("Date Filter", StartDate, EndDate);
    end;

    procedure GetItemLastSyncDateTime(): DateTime
    begin
        exit("Item Last Synced");
    end;

    procedure GetCustomerLastSyncDateTime(): DateTime
    begin
        exit("Customer Last Synced");
    end;

    procedure GetCouponLastSyncDateTime(): DateTime
    begin
        exit("Coupon Last Synced");
    end;

    procedure GetOrderLastSyncDateTime(): DateTime
    begin
        exit("Order Last Synced");
    end;

    procedure GetSalesOrderSyncStartDateTime(): Text
    begin
        exit(GetSyncStartDateTime("Last Sales Order Date Modified", "Order Sync. Start Date"))
    end;

    procedure GetItemSyncStartDateTime(): Text
    begin
        exit(GetSyncStartDateTime("Item Last Modified", "Item Sync. Start Date"));
    end;

    procedure GetCouponSyncStartDateTime(): Text
    begin
        exit(GetSyncStartDateTime("Coupon Last Modified", "Coupon Sync. Start Date"));
    end;

    local procedure GetSyncStartDateTime(LastModifiedTxt: Text; RecordSyncDate: Date): Text
    var
        RecordSyncDateTime: DateTime;
    begin
        if LastModifiedTxt = '' then begin
            if RecordSyncDate <> 0D then begin
                RecordSyncDateTime := CreateDateTime(RecordSyncDate, 0T);
                exit(Format(RecordSyncDateTime, 0, '<Year4>-<Month,2>-<Day,2>T<Hours24,2>:<Minutes,2>:<Seconds,2>'));
            end;

            exit('')
        end;

        exit(LastModifiedTxt);
    end;

    procedure UpdateSalesOrderSyncStartTime(OrderSyncStartDate: DateTime)
    begin
        if "Order Sync. Start Date" = 0D then
            exit;

        "Order Sync. Start Date" := DT2Date(OrderSyncStartDate);
    end;

    local procedure UpdateItemSyncStartDate(ItemSyncStartDate: DateTime)
    begin
        if "Item Sync. Start Date" = 0D then
            exit;

        "Item Sync. Start Date" := DT2Date(ItemSyncStartDate);
    end;

    local procedure UpdateCouponSyndStartDate(CouponSyncStartDate: DateTime)
    begin
        if "Coupon Sync. Start Date" = 0D then
            exit;

        "Coupon Sync. Start Date" := DT2Date(CouponSyncStartDate);
    end;

    procedure SetItemLastSyncDateTime(SyncTime: DateTime)
    begin
        "Item Last Synced" := SyncTime;
    end;

    procedure SetCustomerLastSyncDateTime(SyncTime: DateTime)
    begin
        "Customer Last Synced" := SyncTime;
    end;

    procedure SetCouponLastSyncDateTime(SyncTime: DateTime)
    begin
        "Coupon Last Synced" := SyncTime;
    end;

    procedure SetReturnOrderLastSyncDateTime(SyncTime: DateTime)
    begin
        "Return Order Last Synced" := SyncTime;
    end;

    procedure SetOrderLastSyncDateTime(SyncTime: DateTime)
    begin
        "Order Last Synced" := SyncTime;
    end;

    procedure SetOrderLastModifiedDateTime(SyncTime: DateTime; LastSalesOrderDateModified: Text[50])
    var
        TypeHelper: Codeunit "Type Helper";
        LastSalesOrderDateModifiedDT: DateTime;
        NewLastSalesOrderDateModifiedDT: DateTime;
        Variable: Variant;
        SableSortableFormatTxt: Label 's', Locked = true;
    begin
        if LastSalesOrderDateModified <> '' then begin
            LastSalesOrderDateModifiedDT := 0DT;
            NewLastSalesOrderDateModifiedDT := 0DT;

            Variable := LastSalesOrderDateModifiedDT;
            if TypeHelper.Evaluate(Variable, "Last Sales Order Date Modified", SableSortableFormatTxt, '') then
                LastSalesOrderDateModifiedDT := Variable;

            Variable := NewLastSalesOrderDateModifiedDT;
            if TypeHelper.Evaluate(Variable, LastSalesOrderDateModified, SableSortableFormatTxt, '') then
                NewLastSalesOrderDateModifiedDT := Variable;

            if NewLastSalesOrderDateModifiedDT > LastSalesOrderDateModifiedDT then
                "Last Sales Order Date Modified" := LastSalesOrderDateModified;

            UpdateSalesOrderSyncStartTime(NewLastSalesOrderDateModifiedDT);
        end;
    end;

    internal procedure SetItemLastModified(ItemLastModified: Text[50])
    var
        TypeHelper: Codeunit "Type Helper";
        SableSortableFormatTxt: Label 's', Locked = true;
        Variable: Variant;
        ItemlastModifiedDT: DateTime;
        NewItemLastModifiedDT: DateTime;
    begin
        if ItemLastModified = '' then
            exit;

        NewItemLastModifiedDT := 0DT;
        ItemlastModifiedDT := 0DT;

        Variable := ItemlastModifiedDT;
        if TypeHelper.Evaluate(Variable, "Item Last Modified", SableSortableFormatTxt, '') then
            ItemlastModifiedDT := Variable;

        Variable := NewItemLastModifiedDT;
        if TypeHelper.Evaluate(Variable, ItemLastModified, SableSortableFormatTxt, '') then
            NewItemLastModifiedDT := Variable;

        if NewItemLastModifiedDT > ItemlastModifiedDT then
            "Item Last Modified" := ItemLastModified;

        UpdateItemSyncStartDate(NewItemLastModifiedDT);
    end;

    internal procedure SetCouponLastModified(CouponLastModified: Text[50])
    var
        TypeHelper: Codeunit "Type Helper";
        SableSortableFormatTxt: Label 's', Locked = true;
        Variable: Variant;
        CouponlastModifiedDT: DateTime;
        NewCouponLastModifiedDT: DateTime;
    begin
        if CouponLastModified = '' then
            exit;

        CouponlastModifiedDT := 0DT;
        NewCouponLastModifiedDT := 0DT;

        Variable := CouponlastModifiedDT;
        if TypeHelper.Evaluate(Variable, "Coupon Last Modified", SableSortableFormatTxt, '') then
            CouponlastModifiedDT := Variable;

        Variable := NewCouponLastModifiedDT;
        if TypeHelper.Evaluate(Variable, CouponLastModified, SableSortableFormatTxt, '') then
            NewCouponLastModifiedDT := Variable;

        if NewCouponLastModifiedDT > CouponlastModifiedDT then
            "Coupon Last Modified" := CouponLastModified;

        UpdateCouponSyndStartDate(NewCouponLastModifiedDT);
    end;

    local procedure SetNoOfMinutesBetweenRun()
    begin
        if "No. of Minutes between Runs" = 0 then
            "No. of Minutes between Runs" := 15;
    end;

    local procedure SetCouponNoSeries()
    var
        CouponMgt: Codeunit "Woo Coupon Mgt.";
    begin
        if "Coupon Nos." = '' then
            "Coupon Nos." := CouponMgt.CreateCouponNoSeries();
    end;

    local procedure SetActivityLogRetentionPeriod()
    begin
        if Rec."Activity Log Retention Period".AsInteger() = 0 then
            Rec."Activity Log Retention Period" := "Activity Log Retention Period"::"30 Days";
    end;

    local procedure ConfirmAuthKeysAsParameter()
    var
        ConfirmManagement: Codeunit "Confirm Management";
        EnableAPIKeyasQueryParamMsg: Label 'Please be advised that using this method is not secure as passing API Keys in Authorization Header. However, you may still use it. We highly recommend that you prioritize fixing the server-side problem as soon as possible to ensure the safety and security of your data. Are you sure you want to use consumer key and secret in the URL instead of passing them in header? ';
    begin
        if not ConfirmManagement.GetResponse(EnableAPIKeyasQueryParamMsg, true) then
            Error('');
    end;

    procedure FindMain(): Boolean
    begin
        SetCurrentKey(Type);
        SetRange(Type, Enum::"Woo Webstore Connector Type"::Main);
        exit(FindFirst());
    end;

    [Obsolete('Function is no longer in use. Replaced by SetOrderLastModifiedDateTime to match function name with functionality.', '21.5.0.0')]
    procedure SetOrderLastSyncDateTime(SyncTime: DateTime; LastSalesOrderDateModified: Text[50])
    begin
    end;

    [Obsolete('Function is no longer used. Changed to GetSalesOrderSyncStartDateTime(): Text', '21.4.0.0')]
    procedure GetOrderSyncStartDateTime(): DateTime
    begin
    end;

    [Obsolete('Function is no longer used. Changed to UpdateSalesOrderSyncStartTime()', '21.4.0.0')]
    procedure UpdateOrderSyncStartTime()
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeEnableWebstoreIntegration()
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCheckWebstoreSetup()
    begin
    end;
}
