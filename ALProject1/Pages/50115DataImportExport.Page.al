page 50115 "Custom data"
{
    PageType = Worksheet;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Custom Data";
    Caption = 'Custom data';

    layout
    {
        area(Content)
        {
            repeater(Control)
            {
                // field("No."; Rec."No.")
                // {
                //     ApplicationArea = All;
                //     Caption = 'No.';
                // }
                field(Series; Rec.Series)
                {
                    ApplicationArea = All;
                    Caption = 'No.';

                    trigger OnAssistEdit()
                    begin
                        if Rec.Series = '' then
                            Rec.GetData(Rec);
                    end;
                }
                field(FileName; Rec.FileName)
                {
                    Caption = 'File Name';
                    ApplicationArea = All;
                }
                field(FileExtension; Rec.FileExtension)
                {
                    Caption = 'File Extension';
                    ApplicationArea = All;
                }
                field(Attachmentdate; Rec.Attachmentdate)
                {
                    Caption = 'Attachment Date';
                    ApplicationArea = All;
                }
                field(avaliable; Rec.avaliable)
                {
                    Caption = 'Avaliable';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Import File")
            {
                ApplicationArea = All;
                Image = Import;
                trigger OnAction()
                var
                    FilePath: Text;
                    InDocument: InStream;
                begin
                    if UploadIntoStream('Select File..', '', '', FilePath, InDocument) then
                        UploadFile(InDocument, FilePath);
                end;
            }
            action("Export File")
            {
                ApplicationArea = All;
                Image = Export;
                trigger OnAction()
                begin
                    DownLoadfile();
                end;
            }
        }
    }
    procedure UploadFile(InDocument: InStream; ImportFile: Text)
    var
        fileMnt: Codeunit "File Management";
        OutDocument: OutStream;
    begin
        if rec.Series = '' then begin
            rec.Init();
            Rec.Validate(Rec.FileExtension, fileMnt.GetExtension(ImportFile));
            Rec.Validate(Rec.FileName, fileMnt.GetFileNameWithoutExtension(ImportFile));
            Rec.Content.CreateOutStream(OutDocument);
            CopyStream(OutDocument, InDocument);
            Rec.avaliable := true;
            Rec.insert(true);
        end else begin
            Rec.Validate(Rec.FileExtension, fileMnt.GetExtension(ImportFile));
            Rec.Validate(Rec.FileName, fileMnt.GetFileNameWithoutExtension(ImportFile));
            Rec.Content.CreateOutStream(OutDocument);
            CopyStream(OutDocument, InDocument);
            Rec.avaliable := true;
            Rec.Modify(true);
        end;

    end;

    procedure DownLoadfile()
    var
        InDocument: InStream;
        ExportFile: Text;
    begin
        ExportFile := Rec.FileName + '.' + Rec.FileExtension;
        Rec.CalcFields(Content);
        if not Rec.Content.HasValue then begin
            Message('There are no files to export');
            exit;
        end;
        Rec.Content.CreateInStream(InDocument);
        DownloadFromStream(InDocument, '', '', '', ExportFile);
    end;
}