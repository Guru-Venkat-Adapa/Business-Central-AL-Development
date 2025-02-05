pageextension 50122 "Item List Ext" extends "Item List"
{
    actions
    {
        addlast(Functions)
        {
            action(ExportItem)
            {
                Caption = 'Export Data';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Export;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Xmlport.Run(50100, true, false);
                end;
            }
            action(ImportItem)
            {
                Caption = 'Import Data';
                Promoted = true;
                PromotedCategory = Process;
                // PromotedIsBig = true;
                Image = Import;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Xmlport.Run(50101, false, true);
                end;
            }
        }
    }
}