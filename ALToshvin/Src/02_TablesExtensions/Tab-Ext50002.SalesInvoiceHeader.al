tableextension 50002 SalesInvoiceHeader extends "Sales Invoice Header"
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
            Caption = 'Dealer Customer Country';
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

        // Dont change fiedls ID its direct flow in Shipment Table ---
        field(50067; "Payment Term Details"; Text[1048])
        {
            DataClassification = CustomerContent;
            Caption = 'Payment Term Details';
        }

        field(50074; "Purchase Order No Ref."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50075; "Sales Order No. Ref."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50076; "Sale Invoice No. Ref."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50077; "Claim Order"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50078; "SHI Claim No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50079; "Order Master"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50081; "Claim Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50082; "Invoice Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50084; "Description of Trouble"; Text[1000])
        {
            DataClassification = ToBeClassified;
        }
        field(50085; "Claim Accept Ref. No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50086; "Trouble object"; Text[1000])
        {
            DataClassification = ToBeClassified;
        }
        field(50087; "Advance Received Date"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50088; "CMC Order"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50089; "AMC Order"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50090; "Service Type"; Enum "Service Type AMC/CMC")
        {
            DataClassification = ToBeClassified;
        }
        field(50091; "Service Description"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50092; "Contract Start Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50093; "Contract End Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50094; "No. of visits"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50095; "Visit Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50096; "Invoice Term"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50097; "Service Order"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50098; "Dealer Customer GST No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(50099; "Freight"; Enum "Freight Value")
        {
            Caption = 'freight';
        }
        field(50100; "Employee No."; code[20])
        {
            Caption = 'Handling';
        }
        field(50122; "Group Master"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Group Master";
        }
        field(50123; ORCInstrument; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50103; "No. of Visit"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50104; "TAPL Booking Month"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = Blank,January,February,March,April,May,June,July,August,September,October,November,December;
            OptionCaption = ' ,January,February,March,April,May,June,July,August,September,October,November,December';
        }
        field(50105; Year; Integer)
        {
            DataClassification = ToBeClassified;
            MinValue = 0;
            MaxValue = 2099;
        }

        field(50106; "Custom Assigned User ID"; Text[100])
        {
            DataClassification = ToBeClassified;
            ValidateTableRelation = true;
            TableRelation = Employee."No.";
            Caption = 'Assigned User ID';
        }
        field(50107; "Master Sales Order Number"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Master Sales Order No.';
        }
        field(50108; "Service_Type_"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = ServiceType;
        }
        field(50072; "Prepayment Amount"; Decimal)
        {
            Caption = 'Prepayment Amount';
            DataClassification = CustomerContent;
        }

        field(50068; "PBG Details"; Boolean)
        {
            Caption = 'PBG Details';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if not Rec."PBG Details" then begin
                    Rec."PBG No." := '';
                    Rec."PBG Date" := 0D;
                    Rec."PBG Due Date" := 0D;
                end;
            end;
        }
        field(50069; "PBG No."; Code[100])
        {
            Caption = 'PBG No.';
            DataClassification = CustomerContent;
        }
        field(50070; "PBG Date"; Date)
        {
            Caption = 'PBG Date';
            DataClassification = CustomerContent;
        }
        field(50071; "PBG Due Date"; Date)
        {
            Caption = 'PBG Due Date';
            DataClassification = CustomerContent;
        }
        field(50063; "EMD Details"; Boolean)
        {
            Caption = 'EMD Details';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if not Rec."EMD Details" then begin
                    Rec."EMD No." := '';
                    Rec."EMD Date" := 0D;
                    Rec."EMD Due Date" := 0D;
                end;
            end;
        }
        field(50064; "EMD No."; Code[100])
        {
            Caption = 'EMD No.';
            DataClassification = CustomerContent;
        }
        field(50065; "EMD Date"; Date)
        {
            Caption = 'EMD Date';
            DataClassification = CustomerContent;
        }
        field(50066; "EMD Due Date"; Date)
        {
            Caption = 'EMD Due Date';
            DataClassification = CustomerContent;
        }
        field(50109; "SEZ Instruction"; Text[50])
        {
            DataClassification = CustomerContent;
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
        // start of ticket no.- 918 on 30/03/26
        field(50130; "Deemed Export"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50131; "Deemed Export Instruction"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        // end of ticket no.- 918

        //TBC-503 -->
        field(50132; "Claim Narration"; Text[500])
        {
            DataClassification = CustomerContent;
        }
        field(50133; "Claim Inst. Model"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(50134; "Claim Inst Sr. No."; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(50135; "Claim Contact Person"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        //TBC-503 <--

        //TBC-973 -->
        field(50136; "Party PO Received Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        //TBC-973 <--

        //TBC-1020 --->
        field(50137; "Approved By"; Code[50])
        {
            DataClassification = CustomerContent;
        }
        field(50138; "Approval Date and Time"; DateTime)
        {
            DataClassification = CustomerContent;
        }
        //TBC-1020 <---

        //TBC-992 --->
        field(50140; "Advance Payment Received"; Decimal)
        {
            Caption = 'Advance Payment Received';
            DataClassification = CustomerContent;
        }
        //TBC-992 <---
    }
}
