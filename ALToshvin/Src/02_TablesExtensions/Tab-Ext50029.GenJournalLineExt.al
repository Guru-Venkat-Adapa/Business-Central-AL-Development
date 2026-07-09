tableextension 50029 "Gen. Journal Line Ext" extends "Gen. Journal Line"
{
    fields
    {
        field(50000; "Mobile Handset"; Decimal)
        {
            Caption = 'Mobile Handset';
            DataClassification = CustomerContent;
        }
        field(50001; "Staff Award"; Integer)
        {
            Caption = 'Staff Award';
            DataClassification = CustomerContent;
        }
        field(50002; Training; Integer)
        {
            Caption = 'Training';
            DataClassification = CustomerContent;
        }
        field(50003; Conveyance; Integer)
        {
            Caption = 'Conveyance';
            DataClassification = CustomerContent;
        }
        field(50004; "Petrol Exp (2W)"; Integer)
        {
            Caption = 'Petrol Exp (2W)';
            DataClassification = CustomerContent;
        }
        field(50005; "Vehicle Maintenance (2W)"; Integer)
        {
            Caption = 'Vehicle Maintenance (2W)';
            DataClassification = CustomerContent;
        }
        field(50006; "Driver Salary"; Integer)
        {
            Caption = 'Driver Salary';
            DataClassification = CustomerContent;
        }
        field(50007; "Repair Charges"; Integer)
        {
            Caption = 'Repair Charges';
            DataClassification = CustomerContent;
        }
        field(50008; "Staff Welfare"; Integer)
        {
            Caption = 'Staff Welfare';
            DataClassification = CustomerContent;
        }
        field(50009; Entertainment; Integer)
        {
            Caption = 'Entertainment';
            DataClassification = CustomerContent;
        }
        field(50010; "Res-Telephone Exp"; Integer)
        {
            Caption = 'Res-Telephone Exp';
            DataClassification = CustomerContent;
        }
        field(50011; "Telephone Expense"; Integer)
        {
            Caption = 'Telephone Expense';
            DataClassification = CustomerContent;
        }
        field(50012; "mobile Expense"; Integer)
        {
            Caption = 'mobile Expense';
            DataClassification = CustomerContent;
        }
        field(50013; "Courier Charges"; Integer)
        {
            Caption = 'Courier Charges';
            DataClassification = CustomerContent;
        }
        field(50014; "Office Maintenance"; Integer)
        {
            Caption = 'Office Maintenance';
            DataClassification = CustomerContent;
        }
        field(50015; Postage; Integer)
        {
            Caption = 'Postage';
            DataClassification = CustomerContent;
        }
        field(50016; "Tender Fees"; Integer)
        {
            Caption = 'Tender Fees';
            DataClassification = CustomerContent;
        }
        field(50017; "Festival/Celebration Exp"; Integer)
        {
            Caption = 'Festival/Celebration Exp';
            DataClassification = CustomerContent;
        }
        field(50018; Stationary; Integer)
        {
            Caption = 'Stationary';
            DataClassification = CustomerContent;
        }
        field(50019; Printing; Integer)
        {
            Caption = 'Printing';
            DataClassification = CustomerContent;
        }
        field(50020; "Xerox Charges"; Integer)
        {
            Caption = 'Xerox Charges';
            DataClassification = CustomerContent;
        }
        field(50021; "Books & Periodicals (O)"; Integer)
        {
            Caption = 'Books & Periodicals (O)';
            DataClassification = CustomerContent;
        }
        field(50022; "Modes/Class Jrn"; Text[50])
        {
            Caption = 'Mode/Class Jrn';
            DataClassification = CustomerContent;
        }
        field(50023; "Departure Time"; Time)
        {
            Caption = 'Departure Time';
            DataClassification = CustomerContent;
        }
        field(50024; "From Place"; Text[50])
        {
            Caption = 'From Place';
            DataClassification = CustomerContent;
        }
        field(50025; "Arrival Time"; Time)
        {
            Caption = 'Arrival Time';
            DataClassification = CustomerContent;
        }
        field(50026; "To Place"; Text[50])
        {
            Caption = 'To Place';
            DataClassification = CustomerContent;
        }
        field(50027; "Dist in Kms"; Decimal)
        {
            Caption = 'Dist in Kms';
            DataClassification = CustomerContent;
        }
        field(50028; "Fare (Staff Travel)"; Decimal)
        {
            Caption = 'Fare (Staff Travel)';
            DataClassification = CustomerContent;
        }
        field(50029; "Lodging (Staff Travel)"; Decimal)
        {
            Caption = 'Lodging (Staff Travel)';
            DataClassification = CustomerContent;
        }
        field(50030; "Conveyance (Staff Travel)"; Decimal)
        {
            Caption = 'Conveyance (Staff Travel)';
            DataClassification = CustomerContent;
        }
        field(50031; "Borarding (Staff Travel)"; Decimal)
        {
            Caption = 'Borarding (Staff Travel)';
            DataClassification = CustomerContent;
        }
        field(50032; "Others (Staff Travel)"; Decimal)
        {
            Caption = 'Others (Staff Travel)';
            DataClassification = CustomerContent;
        }
        field(50033; "Car Exp Type"; Enum "Car Exp Type")
        {
            Caption = 'Car Exp Type';
            DataClassification = CustomerContent;
        }
        field(50034; "Per Km Rate"; Decimal)
        {
            Caption = 'Per Km Rate';
            DataClassification = CustomerContent;
        }
        field(50035; "Toll Rs."; Decimal)
        {
            Caption = 'Toll Rs.';
            DataClassification = CustomerContent;
        }
        field(50036; "Tour Type"; Enum "Tour Type")
        {
            DataClassification = ToBeClassified;
        }
        field(50037; "Mode/Class Jrn"; Enum "Tour Mode/Class Jrn")
        {
            Caption = 'Mode/Class Jrn';
            DataClassification = CustomerContent;
        }
        field(50038; "DepTime"; DateTime)
        {
            DataClassification = CustomerContent;
        }
        field(50039; "ArTime"; DateTime)
        {
            DataClassification = CustomerContent;
        }
        //TBC-905 --->
        field(50040; "Beneficiary Name"; Text[100])
        {
            Caption = 'Beneficiary Name';
            DataClassification = ToBeClassified;
        }
        //TBC-905 <---

        //TBc-947 --->
        field(50041; "UTR/Cheque No."; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        //TBC-947 <---
        //TBC-876 --->
        field(50042; "TripGain ID"; Code[1028])
        {
            Caption = '';
            DataClassification = ToBeClassified;
        }
        //TBC-876 <---
    }
}
