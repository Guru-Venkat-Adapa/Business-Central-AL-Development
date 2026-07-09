tableextension 50003 SalesOrderArchive extends "Sales Header Archive"
{
    fields
    {
        field(50001; "Sales Order Type"; Text[100])
        {
            Caption = 'Sales Order Type';
            DataClassification = CustomerContent;
        }
        field(50002; "CRM Quote No."; Code[100])
        {
            Caption = 'CRM Quote No.';
            DataClassification = CustomerContent;
        }
        field(50003; "Reference Number"; Text[200])
        {
            DataClassification = CustomerContent;
        }
        field(50004; "CRM Employee ID 1"; Text[30])
        {
            DataClassification = CustomerContent;
            TableRelation = Employee;
        }
        field(50005; "CRM Employee ID 2"; Text[30])
        {
            DataClassification = CustomerContent;
            TableRelation = Employee;
        }
        field(50006; "Discount Type"; Enum "Discount Type")
        {
            DataClassification = CustomerContent;
        }
        field(50007; "Order Value"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50008; "Discount Value"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(50009; "Original Order Value"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50010; "Insurance And Freight"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Insurance & Freight';
        }
        field(50011; "Handling Charges"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Handling Charges';
        }
        field(50012; "Others Charges"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Others Charges';
        }
        // Dont change fiedls ID its direct flow in Shipment Table ---
        field(50013; "Delivery Term"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(50014; "Freight Terms"; Text[200])
        {
            DataClassification = ToBeClassified;
            // ValidateTableRelation = true;
            // TableRelation = "Freight Term".Name;
        }
        field(50015; "Special Instruction"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50016; "Special Remark-Sez"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50017; "RDC No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50018; "RDC Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50019; "Business Sector"; Text[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Business Sector".Description;
            ValidateTableRelation = true;
        }
        field(50020; Industry; Text[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = Industry;
        }
        field(50021; "Industry Sub-Segment"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50022; Application; Text[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = Application."Application Description";
        }
        field(50023; "Appliaction Sub-Segment"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50024; "Executive Master"; Text[100])
        {
            DataClassification = ToBeClassified;
            ValidateTableRelation = false;
            TableRelation = Employee."First Name";

        }
        field(50025; "Executive Master2"; Text[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee."First Name";
            ValidateTableRelation = false;
        }
        field(50026; "Executive Master3"; Text[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee."First Name";
            ValidateTableRelation = false;
        }
        field(50027; "Executive Master4"; Text[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee."First Name";
            ValidateTableRelation = false;
        }
        field(50028; "Share Of Exe Master"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50029; "Share Of Exe Master2"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50030; "Share Of Exe Master3"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50031; "Share Of Exe Master4"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50032; "KEY/NON KEY(Principal Wise)"; Enum Principal)
        {
            DataClassification = ToBeClassified;
        }
        field(50034; "Customer PO No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Customer PO No.';
        }
        field(50033; "Ship to Industry Caregory"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Ship-to Industry Category';
        }
        field(50035; "Customer PO Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Customer PO Date';
        }
        field(50036; "Key/Non-Key"; Enum Principal)
        {
            DataClassification = CustomerContent;
            Caption = 'Key/Non-Key';
        }
        field(50037; "Advance Rec. Amt."; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Advance Rec. Amt.';
        }
        field(50038; "Approval Ref"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Approval Reference';
        }
        field(50039; "Quotation Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Quotation Date';
        }
        field(50040; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Teams Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
        }
        field(50042; "Campaign Details"; Text[250])
        {
            Caption = 'Campaign Details';
            DataClassification = CustomerContent;
        }
        field(50043; "Performance Bank Guarantee"; Text[500])
        {
            Caption = 'Performance Bank Guarantee';
            DataClassification = CustomerContent;
        }
        field(50044; "Corporate Guarantee"; Text[250])
        {
            Caption = 'Corporate Guarantee';
            DataClassification = CustomerContent;
        }
        field(50045; "Insurance"; Text[250])
        {
            Caption = 'Insurance';
            DataClassification = CustomerContent;
        }
        field(50046; "Packing & Forwarding"; Text[250])
        {
            Caption = 'Packing & Forwarding';
            DataClassification = CustomerContent;
        }
        field(50047; "Service Remark"; Text[500])
        {
            Caption = 'Service Remark';
            DataClassification = CustomerContent;
        }
        field(50048; "Dealer Customer"; Boolean)
        {
            Caption = 'Dealer Customer';
            DataClassification = CustomerContent;
        }
        field(50049; "Dealer Customer Name"; Text[100])
        {
            Caption = 'Dealer Customer Name';
            DataClassification = CustomerContent;
        }
        field(50050; "Dealer Customer Address"; Text[100])
        {
            Caption = 'Dealer Customer Address';
            DataClassification = CustomerContent;
        }
        field(50051; "Dealer Customer Address 2"; Text[100])
        {
            Caption = 'Dealer Customer Address 2';
            DataClassification = CustomerContent;
        }
        field(50052; "Dealer Customer City"; Text[30])
        {
            Caption = 'Dealer Customer City';
            DataClassification = CustomerContent;
        }
        field(50053; "Dealer Customer County"; Text[30])
        {
            Caption = 'Dealer Customer County';
            DataClassification = CustomerContent;
        }
        field(50054; "Dealer Country/Region Code"; Code[30])
        {
            Caption = 'Dealer Customer Country/Region Code';
            DataClassification = CustomerContent;
        }
        field(50055; "Dealer Customer Post Code"; Code[20])
        {
            Caption = 'Dealer Customer Post Code';
            DataClassification = CustomerContent;
        }
        field(50056; "Campaign"; Text[250])
        {
            Caption = 'Campaign';
            DataClassification = CustomerContent;
        }
        field(50057; "New Customer"; Boolean)
        {
            Caption = 'New Customer';
            DataClassification = CustomerContent;
        }
        field(50058; "Spare Order"; Boolean)
        {
            Caption = 'Spare Order';
            DataClassification = CustomerContent;
        }
        field(50059; "Instrument Order"; Boolean)
        {
            Caption = 'Instrument Order';
            DataClassification = CustomerContent;
        }
        field(50067; "Payment Term Details"; Text[1048])
        {
            DataClassification = CustomerContent;
            Caption = 'Payment Term Details';
        }
        field(50108; "Service_Type_"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = ServiceType;
        }
        field(50126; "Custom Ship-to"; Enum "Sales Ship-to Options")
        {
            Caption = 'Custom Ship-to';
            DataClassification = CustomerContent;
        }
        field(50127; "Custom GST No"; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50128; "Custom PAN No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50129; "Custom State"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = State;
        }
    }
}
