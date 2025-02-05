pageextension 50124 "VAT Setup Ext" extends "VAT Setup"
{
    Caption = 'GST Setup';
    PromotedActionCategories = 'New,Process,Report,GST Posting Groups,GST Reporting,Other';
    layout
    {
        // Add changes to page layout here
        modify("Enable Non-Deductible VAT")
        {
            Caption = 'Enable Non-Deductible GST';
        }
        modify("Show Non-Ded. VAT In Lines")
        {
            Caption = 'Show Non-Ded. GST In Lines';
        }
        modify(VATDate)
        {
            Caption = 'GST Date';
        }
    }

    actions
    {
        modify(VATPostingSetup)
        {
            Caption = 'GST Posting Setup';
        }
        modify(VATBusinessPostingGroups)
        {
            Caption = 'GST Business Posting Groups';
        }
        modify(VATProductPostingGroups)
        {
            Caption = 'GST Product Posting Groups';
        }
        modify(VATClauses)
        {
            Caption = 'GST Clauses';
        }
        modify(VATReportSetup)
        {
            Caption = 'GST Report Setup';
        }
        modify(VATReportsConfiguration)
        {
            Caption = 'GST Reports Configuration';
        }
        modify(VATReturnPeriod)
        {
            Caption = 'GST Return Periods';
        }
        modify(VATReturn)
        {
            Caption = 'GST Returns';
        }
        modify(VATStatementTemplates)
        {
            Caption = 'GST Statement Templates';
        }
        modify(VATStatement)
        {
            Caption = 'GST Statements';
        }
        modify(VATVIESDeclarationDisk)
        {
            Caption = 'GST- VIES Declaration Disk';
        }
        modify(VATVIESDeclarationTaxAuth)
        {
            Caption = 'GST- VIES Declaration Tax Auth';
        }
        modify(VATRateChangeSetup)
        {
            Caption = 'GST Rate Change Setup';
        }
    }

}