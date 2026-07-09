namespace Toshvin.Toshvin;

page 50008 "GST Rate %"
{
    ApplicationArea = All;
    Caption = 'GST Rate %';
    PageType = List;
    SourceTable = "Gst Rate Percentage";
    UsageCategory = Lists;
    RefreshOnActivate = true;


    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("GST Group Code"; Rec."GST Group Code")
                {
                    ToolTip = 'Specifies the value of the GST Group Code field.', Comment = '%';
                }
                field("HSN/SAC"; Rec."HSN/SAC")
                {
                    ToolTip = 'Specifies the value of the HSN/SAC field.', Comment = '%';
                }
                field("From State"; Rec."From State")
                {
                    ToolTip = 'Specifies the value of the From State field.', Comment = '%';
                }
                field("Location State Code"; Rec."Location State Code")
                {
                    ToolTip = 'Specifies the value of the Location State Code field.', Comment = '%';
                }
                field("Date From"; Rec."Date From")
                {
                    ToolTip = 'Specifies the value of the Date From field.', Comment = '%';
                }
                field("SGST Percentage"; Rec."SGST Percentage")
                {
                    ToolTip = 'Specifies the value of the SGST % field.', Comment = '%';
                }
                field("CGST Percentage"; Rec."CGST Percentage")
                {
                    ToolTip = 'Specifies the value of the CGST % field.', Comment = '%';
                }
                field("IGST Percentage"; Rec."IGST Percentage")
                {
                    ToolTip = 'Specifies the value of the IGST % field.', Comment = '%';
                }
                field("KFloodCess Percentage"; Rec."KFloodCess Percentage")
                {
                    ToolTip = 'Specifies the value of the KFloodCess % field.', Comment = '%';
                }
                field("Date To"; Rec."Date To")
                {
                    ToolTip = 'Specifies the value of the Date To field.', Comment = '%';
                }
                field("POS Out Of India"; Rec."POS Out Of India")
                {
                    ToolTip = 'Specifies the value of the POS Out Of India field.', Comment = '%';
                }
                field("POS as Vendor State"; Rec."POS as Vendor State")
                {
                    ToolTip = 'Specifies the value of the POS as Vendor State field.', Comment = '%';
                }
            }
        }
    }
}
