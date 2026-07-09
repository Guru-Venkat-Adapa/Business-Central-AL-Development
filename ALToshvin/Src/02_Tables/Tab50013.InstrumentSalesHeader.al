table 50013 "Instrument Sales Header"
{
    Caption = 'Instrument Sales Header';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "CRM No."; Code[50])
        {
            Caption = 'CRM No.';
            DataClassification = CustomerContent;
        }
        field(2; "Office"; Text[50])
        {
            Caption = 'Office';
            DataClassification = CustomerContent;
        }
        field(3; "Date"; Date)
        {
            Caption = 'Date';
            DataClassification = CustomerContent;
        }
        field(4; "Campaign"; Text[250])
        {
            Caption = 'Campaign';
            DataClassification = CustomerContent;
        }
        field(5; "Campaign Details"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Campaign Details';
        }
        field(6; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = CustomerContent;


            trigger OnValidate()
            var
                Cust: Record Customer;
            begin
                Cust.Reset();
                Cust.SetRange("No.", Rec."Customer No.");
                if Cust.FindFirst() then begin
                    Rec."Customer Name" := Cust.Name;
                    Rec."Primary Contact No." := Cust."Primary Contact No.";
                    Rec."Customer GST Reg. No" := Cust."GST Registration No.";
                end;
            end;
        }
        field(7; "Bill-to Name"; Text[100])
        {
            Caption = 'Bill-to Name';
            DataClassification = CustomerContent;
        }
        field(8; "Bill-to Address"; Text[100])
        {
            Caption = 'Bill-to Address';
            DataClassification = CustomerContent;
        }
        field(9; "Bill-to Address 2"; Text[50])
        {
            Caption = 'Bill-to Address 2';
            DataClassification = CustomerContent;
        }
        field(10; "Bill-to City"; Text[30])
        {
            Caption = 'Bill-to City';
            DataClassification = CustomerContent;
        }
        field(11; "Bill-to County"; Text[30])
        {
            Caption = 'Bill-to County';
            DataClassification = CustomerContent;
        }
        field(12; "Bill-to Country/Region Code"; Code[10])
        {
            Caption = 'Bill-to Country/Region Code';
            DataClassification = CustomerContent;
        }
        field(13; "Bill-to Post Code"; Code[20])
        {
            Caption = 'Bill-to Post Code';
            DataClassification = CustomerContent;
        }
        field(14; "Ship-to Name"; Text[100])
        {
            Caption = 'Ship-to Name';
            DataClassification = CustomerContent;
        }
        field(15; "Ship-to Address"; Text[100])
        {
            Caption = 'Ship-to Address';
            DataClassification = CustomerContent;
        }
        field(16; "Ship-to Address 2"; Text[50])
        {
            Caption = 'Ship-to Address 2';
            DataClassification = CustomerContent;
        }
        field(17; "Ship-to City"; Text[30])
        {
            Caption = 'Ship-to City';
            DataClassification = CustomerContent;
        }
        field(18; "Ship-to County"; Text[30])
        {
            Caption = 'Ship-to County';
            DataClassification = CustomerContent;
        }
        field(19; "Ship-to Country/Region Code"; Code[10])
        {
            Caption = 'Ship-to Country/Region Code';
            DataClassification = CustomerContent;
        }
        field(20; "Ship-to Post Code"; Code[20])
        {
            Caption = 'Ship-to Post Code';
            DataClassification = CustomerContent;
        }
        field(21; "Ship-to Phone No."; Text[30])
        {
            Caption = 'Ship-to Phone No.';
            DataClassification = CustomerContent;
        }
        field(22; "Contact Name"; Text[100])
        {
            Caption = 'Contact Name';
            DataClassification = CustomerContent;
        }
        field(23; "Contact Email"; Text[80])
        {
            Caption = 'Contact Email';
            DataClassification = CustomerContent;
        }
        field(24; "Contact Phone No."; Text[30])
        {
            Caption = 'Contact Phone No.';
            DataClassification = CustomerContent;
        }
        field(25; "PO No."; Code[20])
        {
            Caption = 'PO No.';
            DataClassification = CustomerContent;
        }
        field(26; "PO Date"; Date)
        {
            Caption = 'PO Date';
            DataClassification = CustomerContent;
        }
        field(27; "Performance Bank Guarantee"; Text[500])
        {
            Caption = 'Performance Bank Guarantee';
            DataClassification = CustomerContent;
        }
        field(28; "Corporate Guarantee"; Text[250])
        {
            Caption = 'Corporate Guarantee';
            DataClassification = CustomerContent;
        }
        field(29; "Insurance"; Text[250])
        {
            Caption = 'Insurance';
            DataClassification = CustomerContent;
        }
        field(30; "Packing & Forwarding"; Text[250])
        {
            Caption = 'Packing & Forwarding';
            DataClassification = CustomerContent;
        }
        field(31; "Payment Terms"; Code[10])
        {
            Caption = 'Payment Terms';
            DataClassification = CustomerContent;
            TableRelation = "Payment Terms".Code;
        }
        field(32; "Any Specific Instructions"; Text[2048])
        {
            Caption = 'Any Specific Instructions';
            DataClassification = CustomerContent;
        }
        field(33; "Service Remark"; Text[500])
        {
            Caption = 'Service Remark';
            DataClassification = CustomerContent;
        }
        field(34; "Sector"; Text[30])
        {
            Caption = 'Sector';
            DataClassification = CustomerContent;
            TableRelation = "Business Sector";
        }
        field(35; "Industry"; Text[100])
        {
            Caption = 'Industry';
            DataClassification = CustomerContent;
            TableRelation = Industry."Industry Description";
        }
        field(36; "Application"; Text[100])
        {
            Caption = 'Application';
            DataClassification = CustomerContent;
            TableRelation = Application."Application Description";
        }
        field(37; "Application Sub Segment"; Text[100])
        {
            Caption = 'Application Sub Segment';
            DataClassification = CustomerContent;
            TableRelation = "Application Sub-Segment"."App Sub-Seg Description";
        }
        field(38; "Executive Master 1%"; Decimal)
        {
            Caption = 'Executive Master 1%';
            DataClassification = CustomerContent;
        }
        field(39; "Executive Master 2%"; Decimal)
        {
            Caption = 'Executive Master 2%';
            DataClassification = CustomerContent;
        }
        field(40; "Executive Master 3%"; Decimal)
        {
            Caption = 'Executive Master 3%';
            DataClassification = CustomerContent;
        }
        field(41; "Executive Master 4%"; Decimal)
        {
            Caption = 'Executive Master 4%';
            DataClassification = CustomerContent;
        }
        field(42; "Executive Master 1"; Text[30])
        {
            Caption = 'Executive Master 1';
            DataClassification = CustomerContent;
        }
        field(43; "Executive Master 2"; Text[30])
        {
            Caption = 'Executive Master 2';
            DataClassification = CustomerContent;
        }
        field(44; "Executive Master 3"; Text[30])
        {
            Caption = 'Executive Master 3';
            DataClassification = CustomerContent;
        }
        field(45; "Executive Master 4"; Text[30])
        {
            Caption = 'Executive Master 4';
            DataClassification = CustomerContent;
        }
        field(46; "Dealer Customer"; Boolean)
        {
            Caption = 'Dealer Customer';
            DataClassification = CustomerContent;
        }
        field(47; "Dealer Customer Name"; Text[100])
        {
            Caption = 'Dealer Customer Name';
            DataClassification = CustomerContent;
        }
        field(48; "Dealer Customer Address"; Text[100])
        {
            Caption = 'Dealer Customer Address';
            DataClassification = CustomerContent;
        }
        field(49; "Dealer Customer Address 2"; Text[100])
        {
            Caption = 'Dealer Customer Address 2';
            DataClassification = CustomerContent;
        }
        field(50; "Dealer Customer City"; Text[30])
        {
            Caption = 'Dealer Customer City';
            DataClassification = CustomerContent;
        }

        field(51; "Dealer Customer County"; Text[30])
        {
            Caption = 'Dealer Customer County';
            DataClassification = CustomerContent;
        }
        field(52; "Dealer Country/Region Code"; Code[30])
        {
            Caption = 'Dealer Country/Region Code';
            DataClassification = CustomerContent;
        }
        field(53; "Dealer Customer Post Code"; Code[20])
        {
            Caption = 'Dealer Customer Post Code';
            DataClassification = CustomerContent;
        }
        field(54; "Customer Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Customer Name';
        }
        field(55; "Sales Order Type"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Sales Order Type';
            TableRelation = "Sales Order Type";
        }
        field(56; "Bill-to Contact No."; Code[20])
        {
            Caption = 'Bill-to Contact No.';
            DataClassification = CustomerContent;
        }
        field(57; "Sales Order Created"; Boolean)
        {
            Caption = 'Sales Order Created';
            DataClassification = CustomerContent;
        }
        field(58; "Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                InstSalesLine: Record "Instrument Sales Line";
            begin
                if Rec."Sales Order No." <> '' then begin
                    InstSalesLine.Reset();
                    InstSalesLine.SetRange("CRM No.", Rec."CRM No.");
                    if InstSalesLine.FindSet() then
                        repeat
                            InstSalesLine."Sales Order No." := Rec."Sales Order No.";
                            InstSalesLine.Modify(false);
                        until InstSalesLine.Next() = 0;
                end;
            end;

        }
        field(59; "Industry Sub-Segment"; Text[100])
        {
            Caption = 'Industry Sub-Segment';
            DataClassification = CustomerContent;
        }
        field(60; "New Customer"; Boolean)
        {
            Caption = 'New Customer';
            DataClassification = CustomerContent;
        }
        field(61; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            DataClassification = CustomerContent;
        }
        field(62; "Status"; Text[50])
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(63; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
            DataClassification = CustomerContent;
        }
        field(64; "Creation Time"; Time)
        {
            Caption = 'Creation Time';
            DataClassification = CustomerContent;
        }
        field(65; "Workflow Status"; Text[30])
        {
            Caption = 'Workflow Status';
            DataClassification = CustomerContent;
        }
        field(66; "Error Message"; Text[2048])
        {
            Caption = 'Error Message';
            DataClassification = CustomerContent;
        }
        field(67; "Raw JSON Input"; Blob)
        {
            SubType = Memo;
        }
        field(68; "EMD Details"; Boolean)
        {
            Caption = 'EMD Details';
            DataClassification = CustomerContent;
        }
        field(69; "EMD No."; Code[100])
        {
            Caption = 'EMD No.';
            DataClassification = CustomerContent;
        }
        field(70; "EMD Date"; Date)
        {
            Caption = 'EMD Date';
            DataClassification = CustomerContent;
        }
        field(71; "EMD Due Date"; Date)
        {
            Caption = 'EMD Due Date';
            DataClassification = CustomerContent;
        }
        field(72; "PBG Details"; Boolean)
        {
            Caption = 'PBG Details';
            DataClassification = CustomerContent;
        }
        field(73; "PBG No."; Code[100])
        {
            Caption = 'PBG No.';
            DataClassification = CustomerContent;
        }
        field(74; "PBG Date"; Date)
        {
            Caption = 'PBG Date';
            DataClassification = CustomerContent;
        }
        field(75; "PBG Due Date"; Date)
        {
            Caption = 'PBG Due Date';
            DataClassification = CustomerContent;
        }
        field(76; "Payment Terms Details"; Text[1048])
        {
            Caption = 'Payment Terms Details';
            DataClassification = CustomerContent;
        }
        field(77; "Primary Contact No."; Code[20])
        {
            Caption = 'Primary Contact No.';
            DataClassification = CustomerContent;
        }
        field(78; "Bill-to GST Reg. No."; Code[20])
        {
            Caption = 'Bill-to GST Reg. No.';
            DataClassification = CustomerContent;
        }
        field(79; "Ship-to GST Reg. No."; Code[20])
        {
            Caption = 'Ship-to GST Reg. No.';
            DataClassification = CustomerContent;
        }
        field(80; "Raw JSON Input Size"; Integer)
        {
            Caption = 'Raw JSON Input Size';
            DataClassification = CustomerContent;
        }
        field(81; "Customer GST Reg. No"; Code[20])
        {
            Caption = 'Customer GST Reg. No';
            DataClassification = CustomerContent;
        }
        field(82; "Dealer Customer GST No."; Code[20])
        {
            Caption = 'Dealer Customer GST No.';
            DataClassification = CustomerContent;
        }

    }
    keys
    {
        key(PK; "CRM No.")
        {
            Clustered = true;
        }
        key(key2; "Creation Date") { }
        key(key3; "Creation Time") { }
    }
    procedure GetWebInputRequest(): Text
    var
        InStream: InStream;
        ResultText: Text;
    begin
        CalcFields("Raw JSON Input");

        if "Raw JSON Input".HasValue then begin
            "Raw JSON Input".CreateInStream(InStream, TEXTENCODING::UTF8);
            InStream.ReadText(ResultText);
            exit(ResultText);
        end;

        exit('');
    end;
}
