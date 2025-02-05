page 50103 CopyPage
{
    ApplicationArea = All;
    Caption = 'Copy Page';
    PageType = List;
    SourceTable = CopyTable;
    UsageCategory = Lists;
    // DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Caption = 'Document No.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Caption = 'Name';
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                    Caption = 'Address';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(GetData)
            {
                ApplicationArea = All;
                Caption = 'Get Data from Original';
                Image = Insert;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    GetdataFrom();
                end;
            }
            action(PostData)
            {
                ApplicationArea = All;
                Caption = 'Post the data from Current Page';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    Original: Record OriginalTable;
                    Copy: Record CopyTable;
                begin
                    PostDataDel();
                    Copy.FindSet();
                    Original.FindSet();
                    Copy.DeleteAll();
                    Original.DeleteAll();
                end;
            }
        }
    }
    procedure GetdataFrom()
    var
        Original: Record OriginalTable;
        Copy: Record CopyTable;

    begin
        If Original.FindSet() then
            repeat
                Copy.Reset();
                Copy.Init();
                if Copy.Count = 0 then begin
                    NoSeries.SetRange(Code, 'CUSTOM');
                    If NoSeries.FindSet() then begin
                        NoSeriesLine.SetRange("Series Code", NoSeries.Code);
                        If NoSeriesLine.FindSet() then begin
                            DocNo := NoSeriesLine."Last No. Used";
                        end;
                    end;
                end else begin
                    Copy.Reset();
                    Copy.FindLast();
                    DocNo := IncStr(Copy."Document No.");
                end;
                Copy."Document No." := DocNo;
                Copy.Name := Original.Name;
                Copy.Address := Original.Address;
                Copy.Insert();
            until Original.Next() = 0;
    end;

    procedure PostDataDel()
    var
        Original: Record OriginalTable;
        Copy: Record CopyTable;
    begin
        Copy.FindLast();
        NoSeriesLine.SetRange("Series Code", 'CUSTOM');
        If NoSeriesLine.FindSet() then begin
            NoSeriesLine."Last No. Used" := Copy."Document No.";
            NoSeriesLine.Modify(false);
        end;
    end;

    var
        SalesSetup: Record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        NoSeries: Record "No. Series";
        DocNo: Code[20];
        LastNo: Code[20];
        NoSeriesLine: Record "No. Series Line";
        SalesOrder: Page "Sales Order";
}
