pageextension 50002 CustomerCard extends "Customer Card"
{
    layout
    {
        addafter("No.")
        {
            field("Focus Customer No."; Rec."Focus Customer No.")
            {
                ApplicationArea = All;
                Caption = 'Focus Customer No.';
                ToolTip = 'Specifies the value of the Focus Customer No. field.';
            }
        }
        addlast(General)
        {
            field("Industry Type"; Rec."Industry Type")
            {
                ApplicationArea = All;
                Caption = 'Industry Type';
                ToolTip = 'Specifies the value of the industry type field.';
            }
            field("Is MSME"; Rec."Is MSME")
            {
                ApplicationArea = All;
                Caption = 'IS MSME';
                ToolTip = 'Specifies the value of the is MSME field.';
            }
            group(MSME)
            {
                Caption = '';
                Visible = Rec."Is MSME";
                field("MSME No"; Rec."MSME No")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'MSME NO';
                    ToolTip = 'Specifies the value of the MSME number field.';
                }
            }

            field("MSME Validity Date"; Rec."MSME Validity Date")
            {
                ApplicationArea = All;
                Caption = 'MSME Validity Date';
                ToolTip = 'Specifies the value of the MSME validity date field.';
            }
            field("Type of Enterprises"; Rec."Type of Enterprises")
            {
                ApplicationArea = All;
                Caption = 'Types of Enterprises';
                ToolTip = 'Specifies the value of the types of enterprises field.';
            }
            field("KEY/NON KEY(Schimatzu)"; Rec."KEY/NON KEY(Schimatzu)")
            {
                ApplicationArea = All;
                Caption = 'KEY/NON KEY(Schimatzu)';
                ToolTip = 'Specifies the value of the key/non-key(schimatzu) field.';
            }
            field("KEY/NON KEY(Restek)"; Rec."KEY/NON KEY(Restek)")
            {
                ApplicationArea = All;
                Caption = 'KEY/NON KEY(Restek)';
                ToolTip = 'Specifies the value of the key/non-key(restek) field.';
            }
            field("KEY/NON KEY(Principal Wise)"; Rec."KEY/NON KEY(Principal Wise)")
            {
                ApplicationArea = All;
                Caption = 'KEY/NON KEY(Principal Wise)';
                ToolTip = 'Specifies the value of the key/non-key(principal wise) field.';
            }
            field("Group Master"; Rec."Group Master")
            {
                ApplicationArea = All;
                Caption = 'Group Master';
                ToolTip = 'Specifies the value of the group master field.';
            }
            field("Virtual Account"; Rec."Virtual Account")
            {
                ApplicationArea = All;
                Caption = 'Virtual Account';
                ToolTip = 'Specifies the value of the virtual account field.';
            }
            field("Finance Email"; Rec."Finance Email")
            {
                ApplicationArea = All;
                Caption = 'Finance Email';
                ToolTip = 'Specifies the value of the finance email field.';
            }
        }
        addlast("PAN Details")
        {
            field("Type of Tax Payers"; Rec."Type of Tax Payers")
            {
                ApplicationArea = All;
                Caption = 'Types of Tax Payers';
                ToolTip = 'Specifies the value of the type of tax payers field.';
                Visible = false;
            }
            field("Customer Type"; Rec."Customer Type")
            {
                ApplicationArea = All;
                Caption = 'Customer Type';
                ToolTip = 'Specifies the value of the customer type field.';
                Visible = false;
            }
            field(TIN; Rec.TIN)
            {
                ApplicationArea = All;
                Caption = 'TIN';
                ToolTip = 'Specifies the value of the TIN field.';
            }
            field(CIN; Rec.CIN)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the CIN field.';
            }
            field("TAN No."; Rec."TAN No.")
            {
                ApplicationArea = All;
                Caption = 'TAN No.';
                ToolTip = 'Specifies the value of the TAN No. field.';
            }
        }
    }
}
