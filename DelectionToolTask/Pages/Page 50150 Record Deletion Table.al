page 50100 "Record Deletion Table"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Record Deletion Table";
    AccessByPermission = page "Record Deletion Table" = x;
    Permissions = tabledata 17 = imd;
    Caption = 'Record Deletion Tool';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Delete Records"; Rec."Delete Records")
                {
                    ApplicationArea = All;
                    Width = 7;
                }
                field("Table ID"; Rec."Table ID")
                {
                    ApplicationArea = All;
                    Width = 7;
                }
                field("Table Name"; Rec."Table Name")
                {
                    ApplicationArea = All;
                    Width = 30;
                }
                field("No. of Records"; Rec."No. of Records")
                {
                    ApplicationArea = All;
                }
                field("No. of Table Relation Errors"; Rec."No. of Table Relation Errors")
                {
                    ApplicationArea = All;
                }
                field(Company; Rec.Company)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Action1)
            {
                ApplicationArea = All;
                Caption = 'Insert/Update Tables';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = Refresh;
                trigger OnAction();
                var
                    RecordDletionMgmt: Codeunit "Record Deletion Mgmt";
                    Rec_RecordDeletionTable: Record "Record Deletion Table";
                begin
                    RecordDletionMgmt.InsertUpdateTables;
                    Rec_RecordDeletionTable.Reset();
                    if Rec_RecordDeletionTable.FindSet() then
                        repeat
                            IF TryGetRecordCount(Rec_RecordDeletionTable."Table ID") then;
                        until Rec_RecordDeletionTable.Next() = 0;
                end;
            }
            action(Action2)
            {
                ApplicationArea = All;
                Caption = 'Suggest Records to Delete';
                Image = Suggest;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                trigger OnAction();
                var
                    RecordDletionMgmt: Codeunit "Record Deletion Mgmt";
                begin
                    RecordDletionMgmt.SuggestRecordsToDelete;
                end;
            }
            action(Action3)
            {
                ApplicationArea = All;
                Image = ClearLog;
                Caption = 'Clear Records to Delete';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                trigger OnAction();
                var
                    RecordDletionMgmt: Codeunit "Record Deletion Mgmt";
                begin
                    RecordDletionMgmt.ClearRecordsToDelete;
                end;
            }
            action(Action4)
            {
                ApplicationArea = All;
                Image = Delete;
                Caption = 'Delete Records';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                trigger OnAction();
                var
                    RecordDletionMgmt: Codeunit "Record Deletion Mgmt";
                begin
                    RecordDletionMgmt.DeleteRecords();
                end;
            }
            action(Action5)
            {
                ApplicationArea = All;
                Image = Relationship;
                Caption = 'Check Table Relations';
                Visible = false;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                trigger OnAction();
                var
                    RecordDletionMgmt: Codeunit "Record Deletion Mgmt";
                begin
                    RecordDletionMgmt.CheckTableRelations();
                end;
            }
            action(Action6)
            {
                ApplicationArea = All;
                Image = Table;
                Caption = 'View Records';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Visible = false;
                trigger OnAction();
                var
                    RecordDletionMgmt: Codeunit "Record Deletion Mgmt";
                begin
                    RecordDletionMgmt.ViewRecords(Rec);
                end;
            }
            action(Action7)
            {
                Image = Select;
                Caption = 'Deleted selective Records';
                ApplicationArea = All;
                trigger OnAction()
                var
                    ReportDataDeletionTool: Report DataDeletionTool;
                begin
                    ReportDataDeletionTool.GetTableNo(Rec."Table ID");
                    ReportDataDeletionTool.Run();
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        Rec_RecordDeletionTable: Record "Record Deletion Table";
    begin
        Rec_RecordDeletionTable.Reset();
        Rec_RecordDeletionTable.SetRange("No. of Records", 0);
        if Rec_RecordDeletionTable.FindSet() then
            repeat
                IF TryGetRecordCount(Rec_RecordDeletionTable."Table ID") then;
            until Rec_RecordDeletionTable.Next() = 0;
    end;

    [TryFunction]
    procedure TryGetRecordCount(TableId: Integer)
    var
        RecRef: RecordRef;
        Rec_RDT: Record "Record Deletion Table";
    begin
        Clear(Rec_RDT);
        Clear(RecRef);
        Rec_RDT.Reset();
        Rec_RDT.SetRange("Table ID", TableId);
        If Rec_RDT.FindFirst() then begin
            RecRef.Open(Rec_RDT."Table ID", false, CompanyName());
            Rec_RDT."No. of Records" := RecRef.Count();
            Rec_RDT.Modify(true);
            RecRef.Close();
        end;
    end;
}