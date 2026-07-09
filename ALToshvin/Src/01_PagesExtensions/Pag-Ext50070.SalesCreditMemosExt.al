pageextension 50070 "Sales Credit Memos Ext" extends "Sales Credit Memos"
{
    layout
    {
        modify("Location Code")
        {
            Caption = 'Warehouse Code';
        }
        //TBC-1069 ---->
        modify("Shortcut Dimension 1 Code")
        {
            Visible = true;
        }
        addafter("Shortcut Dimension 1 Code")
        {
            field(DepartmentName; DepartmentName)
            {
                ApplicationArea = All;
                Caption = 'Department Name';
            }
        }
        modify("Shortcut Dimension 2 Code")
        {
            Visible = true;
        }
        addafter("Shortcut Dimension 2 Code")
        {
            field(RegionName; RegionName)
            {
                ApplicationArea = All;
                Caption = 'Region Name';
            }
        }
        addafter(RegionName)
        {
            field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
            {
                ApplicationArea = All;
                Caption = 'Teams Code';
            }
            field(TeamsName; TeamsName)
            {
                ApplicationArea = All;
                Caption = 'Teams Name';
            }
        }
        modify("Applies-to Doc. Type")
        {
            Visible = true;
        }
        modify("External Document No.")
        {
            Visible = true;
            Caption = 'Customer PO#';
        }
        moveafter("Posting Date"; "External Document No.")

        addafter("Due Date")
        {
            field("Your Reference"; Rec."Your Reference")
            {
                ApplicationArea = All;
            }
            field("Reference Invoice No."; Rec."Reference Invoice No.")
            {
                ApplicationArea = All;
            }

            field("Applies-to Doc. No."; Rec."Applies-to Doc. No.")
            {
                ApplicationArea = All;
            }
            field("Applies-to ID"; Rec."Applies-to ID")
            {
                ApplicationArea = All;
            }
            field("Credit Note Type"; Rec."Credit Note Type")
            {
                ApplicationArea = All;
            }
            field("Location State Code"; Rec."Location State Code")
            {
                ApplicationArea = All;
            }

        }
        moveafter("Reference Invoice No."; "Applies-to Doc. Type")
        addafter(Amount)
        {
            field("Reason Code"; Rec."Reason Code")
            {
                ApplicationArea = All;
            }
        }
        //TBC-1069 <----
    }

    trigger OnAfterGetRecord()
    begin
        //TBC-1069 ---->
        Clear(DepartmentName);
        Clear(RegionName);
        Clear(TeamsName);

        DimesionValue.Reset();
        DimesionValue.SetRange(Code, Rec."Shortcut Dimension 1 Code");
        if DimesionValue.FindFirst() then
            DepartmentName := DimesionValue.Name;

        DimesionValue.Reset();
        DimesionValue.SetRange(Code, Rec."Shortcut Dimension 2 Code");
        if DimesionValue.FindFirst() then
            RegionName := DimesionValue.Name;

        DimesionValue.Reset();
        DimesionValue.SetRange(Code, Rec."Shortcut Dimension 3 Code");
        if DimesionValue.FindFirst() then
            TeamsName := DimesionValue.Name;
        //TBC-1069 <----
    end;

    var

        DimesionValue: Record "Dimension Value";
        DepartmentName: Text;
        RegionName: Text;
        TeamsName: Text;
}

