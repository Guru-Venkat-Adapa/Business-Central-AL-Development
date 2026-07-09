tableextension 50004 ExtSalesHeader extends "Sales Header"
{
    fields
    {
        //NavSoft_HG_24/04/2025 Sames Id and Field flow in Posted Sales Shipment,Posted Sales Invoice and Sales Order Archive  --->
        field(50001; "Sales Order Type"; Text[100])
        {
            Caption = 'Sales Order Type';
            DataClassification = ToBeClassified;
        }
        //NavSoft_HG_24/04/2025 Sames Id and Field flow in Posted Sales Shipment,Posted Sales Invoice and Sales Order Archive  <-----


        //T-Square Integration Fields ----->
        field(50002; "CRM Quote No."; Code[100])
        {
            DataClassification = CustomerContent;
        }
        field(50003; "Reference Number"; Text[200])
        {
            DataClassification = CustomerContent;
        }
        field(50004; "CRM Employee ID 1"; Text[100])
        {
            DataClassification = CustomerContent;
            ValidateTableRelation = false;
            TableRelation = Employee."No.";

            trigger OnValidate()
            var
                Emp: Record Employee;
            begin
                if Emp.Get(Rec."CRM Employee ID 1") then begin
                    Rec."CRM Employee ID 1" := Emp."First Name" + ' ' + Emp."Last Name";
                end;
            end;
        }
        field(50005; "CRM Employee ID 2"; Text[100])
        {
            DataClassification = CustomerContent;
            ValidateTableRelation = false;
            TableRelation = Employee."No.";

            trigger OnValidate()
            var
                Emp: Record Employee;
            begin
                if Emp.Get(Rec."CRM Employee ID 2") then begin
                    Rec."CRM Employee ID 2" := Emp."First Name" + ' ' + Emp."Last Name";
                end;
            end;
        }
        field(50006; "Discount Type"; Enum "Discount Type")
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                DiscountAmount: Decimal;
            begin
                Clear(DiscountAmount);
                if Rec."Discount Value" <> 0 then begin
                    if Rec."Discount Value" = 0 then
                        Rec."Order Value" := Rec."Original Order Value";

                    if "Original Order Value" = 0 then
                        "Original Order Value" := "Order Value";

                    if Rec."Discount Type" = Rec."Discount Type"::Percentage then begin
                        DiscountAmount := "Original Order Value" * Rec."Discount Value" / 100;
                        Rec."Order Value" := Rec."Original Order Value" - DiscountAmount;

                    end
                    else if Rec."Discount Type" = Rec."Discount Type"::Fixed then
                        Rec."Order Value" := "Original Order Value" - Rec."Discount Value";
                end;
            end;
        }
        field(50007; "Order Value"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50008; "Discount Value"; Integer)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                DiscountAmount: Decimal;
            begin
                Clear(DiscountAmount);
                if Rec."Discount Value" = 0 then
                    Rec."Order Value" := Rec."Original Order Value";

                if "Original Order Value" = 0 then
                    "Original Order Value" := "Order Value";

                if Rec."Discount Type" = Rec."Discount Type"::Percentage then begin
                    DiscountAmount := "Original Order Value" * Rec."Discount Value" / 100;
                    Rec."Order Value" := Rec."Original Order Value" - DiscountAmount;

                end
                else if Rec."Discount Type" = Rec."Discount Type"::Fixed then
                    Rec."Order Value" := "Original Order Value" - Rec."Discount Value";
            end;
        }
        field(50009; "Original Order Value"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50010; "Insurance And Freight"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Insurance & Freight';

            trigger OnValidate()
            var
                OldInsuranceFreight: Decimal;
            begin
                // Store the previous value
                OldInsuranceFreight := xRec."Insurance And Freight";

                // Adjust the Order Value
                Rec."Order Value" := Rec."Order Value" - OldInsuranceFreight + Rec."Insurance And Freight";
            end;

        }
        field(50011; "Handling Charges"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Handling Charges';

            trigger OnValidate()
            var
                OldHandlingCharge: Decimal;
            begin
                // Store the previous value
                OldHandlingCharge := xRec."Handling Charges";

                // Adjust the Order Value
                Rec."Order Value" := Rec."Order Value" - OldHandlingCharge + Rec."Handling Charges";
            end;
        }
        field(50012; "Others Charges"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Others Charges';

            trigger OnValidate()
            var
                OldOtherCharge: Decimal;
            begin
                // Store the previous value
                OldOtherCharge := xRec."Others Charges";
                // Adjust the Order Value
                Rec."Order Value" := Rec."Order Value" - OldOtherCharge + Rec."Others Charges";
            end;
        }
        field(50013; "Delivery Term"; Text[200])
        {
            DataClassification = ToBeClassified;
            ValidateTableRelation = true;
            TableRelation = "Delivery Terms".Name;
        }
        field(50014; "Freight Terms"; Text[200])
        {
            DataClassification = ToBeClassified;
            ValidateTableRelation = true;
            TableRelation = "Freight Term".Name;
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
            ValidateTableRelation = true;
            TableRelation = Employee."No.";

            trigger OnValidate()
            var
                Emp: Record Employee;
            begin
                if Emp.Get(Rec."Executive Master") then begin
                    Rec."Employee No." := Emp."No.";
                    Rec."Executive Master" := Emp."First Name" + ' ' + Emp."Last Name";
                end;
            end;

        }
        field(50025; "Executive Master2"; Text[100])
        {
            DataClassification = ToBeClassified;
            ValidateTableRelation = true;
            TableRelation = Employee."No.";

            trigger OnValidate()
            var
                Emp: Record Employee;
            begin
                if Emp.Get(Rec."Executive Master2") then begin
                    Rec."Employee No." := Emp."No.";
                    Rec."Executive Master2" := Emp."First Name" + ' ' + Emp."Last Name";
                end;
            end;
        }
        field(50026; "Executive Master3"; Text[100])
        {
            DataClassification = ToBeClassified;
            ValidateTableRelation = true;
            TableRelation = Employee."No.";

            trigger OnValidate()
            var
                Emp: Record Employee;
            begin
                if Emp.Get(Rec."Executive Master3") then begin
                    Rec."Employee No." := Emp."No.";
                    Rec."Executive Master3" := Emp."First Name" + ' ' + Emp."Last Name";
                end;
            end;
        }
        field(50027; "Executive Master4"; Text[100])
        {
            DataClassification = ToBeClassified;
            ValidateTableRelation = true;
            TableRelation = Employee."No.";

            trigger OnValidate()
            var
                Emp: Record Employee;
            begin
                if Emp.Get(Rec."Executive Master4") then begin
                    Rec."Employee No." := Emp."No.";
                    Rec."Executive Master4" := Emp."First Name" + ' ' + Emp."Last Name";
                end;
            end;
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

        field(50033; "Ship to Industry Caregory"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Ship-to Industry Category';
        }
        field(50034; "Customer PO No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Customer PO No.';
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

            trigger OnValidate()
            var
            begin
                Rec.CalcFields(Rec.Amount);
                if Rec."Advance Rec. Amt." <> 0 then
                    Rec."Prepayment %" := (Rec."Advance Rec. Amt." / Rec.Amount) * 100;
            end;
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
            //CaptionClass = '1,2,3';
            Caption = 'Teams Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3),
                                                          Blocked = const(false));

            trigger OnValidate()
            begin
                Rec.ValidateShortcutDimCode(3, "Shortcut Dimension 3 Code");
            end;
        }
        field(50041; "Sales Order Amount"; Decimal)
        {
            FieldClass = FlowField;
            Caption = 'Sales Order Amount';
            CalcFormula = sum("Sales Line"."Line Amount" where("Document Type" = field("Document Type"), "Document No." = field("No.")));
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

            trigger OnValidate()
            begin
                if not Rec."Dealer Customer" then begin
                    Rec."Dealer Customer Name" := '';
                    Rec."Dealer Customer Address" := '';
                    Rec."Dealer Customer Address 2" := '';
                    Rec."Dealer Customer City" := '';
                    Rec."Dealer Customer County" := '';
                    Rec."Dealer Country/Region Code" := '';
                    Rec."Dealer Customer Post Code" := '';
                    Rec."Dealer Customer GST No." := '';
                end;
            end;
        }
        field(50049; "Dealer Customer Name"; Text[100])
        {
            Caption = 'Dealer Customer Name';
            DataClassification = CustomerContent;
            TableRelation = Customer."No.";
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
        field(50060; "Total Amount Excl. GST"; Decimal)
        {
            Caption = 'Amount Excl. GST';
            FieldClass = FlowField;
            CalcFormula = sum("Sales Line"."Amount" where("Document Type" = field("Document Type"), "Document No." = field("No.")));
        }
        field(50061; "GST Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Line"."Total GST Amount"
                      where("Document Type" = field("Document Type"),
                            "Document No." = field("No.")));
        }
        field(50062; "Workflow Status"; Text[30])
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                INRSalesHeader: Record "Instrument Sales Header";
            begin
                INRSalesHeader.Reset();
                INRSalesHeader.SetRange("CRM No.", Rec."CRM Quote No.");
                if INRSalesHeader.FindFirst() then begin
                    case Rec."Workflow Status" of
                        'Approved',
                        'Rejected':
                            begin
                                INRSalesHeader."Workflow Status" := Rec."Workflow Status";
                                INRSalesHeader.Modify(false);
                            end;
                    end;
                end;
            end;
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
        field(50067; "Payment Term Details"; Text[1048])
        {
            DataClassification = CustomerContent;
            Caption = 'Payment Term Details';
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
        //Guru
        field(50072; "Prepayment Amount"; Decimal)
        {
            Caption = 'Prepayment Amount';
            DataClassification = CustomerContent;
        }
        field(50073; "No. Series Locked"; Boolean)
        {
            Caption = 'No. Series Locked';
            DataClassification = SystemMetadata;
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
        field(50080; "Inst. Model"; Text[50])
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
        field(50083; "Inst SR No."; Code[20])
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
        field(50108; "Service_Type_"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = ServiceType;
        }
        field(50091; "Service Description"; Text[250])
        {
            DataClassification = ToBeClassified;
            ValidateTableRelation = false;
            TableRelation = "Service Description".Description;
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
        field(50100; "Group Master"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Group Master";
        }
        field(50101; "Employee No."; code[20])
        {
            Caption = 'Handling';
        }
        field(50102; ORCInstrument; Boolean)
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
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(50105; Year; Integer)
        {
            DataClassification = ToBeClassified;
            MinValue = 0;
            MaxValue = 2099;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }

        //New Field
        field(50106; "Custom Assigned User ID"; Text[100])
        {
            DataClassification = ToBeClassified;
            ValidateTableRelation = true;
            TableRelation = Employee."No.";
            Caption = 'Assigned User ID';

            trigger OnValidate()
            var
                Emp: Record Employee;
            begin
                if Emp.Get(Rec."Custom Assigned User ID") then
                    Rec."Custom Assigned User ID" := Emp."First Name" + ' ' + Emp."Last Name";
            end;
        }
        field(50107; "Master Sales Order Number"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Master Sales Order No.';
            TableRelation = "Sales Header"."No." where("Document Type" = const(Order), "Sales Order Type" = field("Sales Order Type"));
        }
        field(50126; "Custom Ship-to"; Enum "Sales Ship-to Options")
        {
            Caption = 'Custom Ship-to';
            DataClassification = CustomerContent;
        }
        field(50109; "SEZ Instruction"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(50110; "Installation Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50111; "Commission Note"; Text[10])
        {
            DataClassification = ToBeClassified;
        }
        field(50112; "Commission Note Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50113; "CN Sent to SAP for Remit Dt"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50114; "CN Remittance Received Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50115; "CN Comments"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50116; "Inco Terms"; Option)
        {
            OptionMembers = ,FOB,CIF,CIP,FCA,DDP,DDU,DAP,"Ex-Works",CPT;
            DataClassification = ToBeClassified;
        }
        field(50117; "Shipping Method"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = ,Air,Sea;
        }
        field(50118; "Sales Note Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50119; "Sales Invoice Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50120; "Margin % (MS) "; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50121; "Margin Amount (MS)"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50127; "Custom GST No"; code[20])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                ValidateGSTNo("Custom GST No");
                if "Custom PAN No." <> '' then
                    ValidateGSTPANMatch("Custom GST No", "Custom PAN No.");
            end;
        }
        field(50128; "Custom PAN No."; Code[20])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                ValidatePANNo("Custom PAN No.");
                if "Custom GST No" <> '' then
                    ValidateGSTPANMatch("Custom GST No", "Custom PAN No.");
            end;
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
        //TBC-1034 --> This fields Related To Sales Credit Memo the 
        //flow in Posted Soumnet with Sames Name and COde
        field(50139; "Credit Note Type"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Credit Note Type';
            OptionMembers = " ",Internal,External;
        }
        //TBC-1034 <--

        //TBC-992 --->
        field(50140; "Advance Payment Received"; Decimal)
        {
            Caption = 'Advance Payment Received';
            DataClassification = CustomerContent;
        }
        //TBC-992 <---

    }
    procedure ValidateGSTNo(GSTNo: Code[15])
    var
        GSTRegEx: Text;
        InvalidGSTErr: Label 'GST No. %1 is not valid. GST must be 15 characters in format: 99AAAAA9999A9Z9.', Comment = '%1 = GST Number';
    begin
        if GSTNo = '' then
            exit;
        if StrLen(GSTNo) <> 15 then
            Error(InvalidGSTErr, GSTNo);

        if not IsNumeric(CopyStr(GSTNo, 1, 2)) then
            Error('GST No. %1 is invalid. First 2 characters must be numeric State Code.', GSTNo);

        ValidatePANNo(CopyStr(GSTNo, 3, 10));

        // Position 13: Entity Number (1-9 or A-Z)
        // Position 14: Must be 'Z'
        if CopyStr(GSTNo, 14, 1) <> 'Z' then
            Error('GST No. %1 is invalid. 14th character must be ''Z''.', GSTNo);

        // Position 15: Checksum (0-9 or A-Z)
        if not IsAlphaNumeric(CopyStr(GSTNo, 15, 1)) then
            Error('GST No. %1 is invalid. 15th character must be alphanumeric.', GSTNo);
    end;

    procedure ValidatePANNo(PANNo: Code[10])
    var
        InvalidPANErr: Label 'PAN No. %1 is not valid. PAN must be 10 characters in format: AAAAA9999A.', Comment = '%1 = PAN Number';
        i: Integer;
        Ch: Text[1];
    begin
        if PANNo = '' then
            exit;

        if StrLen(PANNo) <> 10 then
            Error(InvalidPANErr, PANNo);

        for i := 1 to 3 do begin
            Ch := CopyStr(PANNo, i, 1);
            if not IsAlpha(Ch) then
                Error('PAN No. %1 is invalid. Position %2 must be an alphabet.', PANNo, i);
        end;

        Ch := CopyStr(PANNo, 4, 1);
        if not IsAlpha(Ch) then
            Error('PAN No. %1 is invalid. Position 4 (PAN Type) must be an alphabet.', PANNo);

        Ch := CopyStr(PANNo, 5, 1);
        if not IsAlpha(Ch) then
            Error('PAN No. %1 is invalid. Position 5 must be an alphabet.', PANNo);

        for i := 6 to 9 do begin
            Ch := CopyStr(PANNo, i, 1);
            if not IsNumeric(Ch) then
                Error('PAN No. %1 is invalid. Position %2 must be numeric.', PANNo, i);
        end;

        Ch := CopyStr(PANNo, 10, 1);
        if not IsAlpha(Ch) then
            Error('PAN No. %1 is invalid. Position 10 must be an alphabet.', PANNo);
    end;

    procedure ValidateGSTPANMatch(GSTNo: Code[15]; PANNo: Code[10])
    var
        EmbeddedPAN: Code[10];
    begin
        if (GSTNo = '') or (PANNo = '') then
            exit;

        if StrLen(GSTNo) <> 15 then
            exit;

        EmbeddedPAN := CopyStr(GSTNo, 3, 10);

        if EmbeddedPAN <> PANNo then
            Error(
                'PAN No. %1 does not match the PAN embedded in GST No. %2 (Expected PAN: %3). Please ensure both are consistent.',
                PANNo, GSTNo, EmbeddedPAN
            );
    end;

    local procedure IsAlpha(Ch: Text[1]): Boolean
    begin
        exit(Ch in ['A' .. 'Z', 'a' .. 'z']);
    end;

    local procedure IsNumeric(Value: Text): Boolean
    var
        i: Integer;
    begin
        if Value = '' then
            exit(false);
        for i := 1 to StrLen(Value) do
            if not (Value[i] in ['0' .. '9']) then
                exit(false);
        exit(true);
    end;

    local procedure IsAlphaNumeric(Ch: Text[1]): Boolean
    begin
        exit(IsAlpha(Ch) or IsNumeric(Ch));
    end;
}
