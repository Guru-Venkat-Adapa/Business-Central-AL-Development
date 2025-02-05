page 50102 "Fund Transfer"
{
    ApplicationArea = All;
    Caption = 'Fund Transfer';
    PageType = Card;
    SourceTable = "Fund Transfer Header";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(No; Rec.No)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies No. Of the Fund Transfer';
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Description Of the Fund Transfer';
                    Editable = edit;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = all;
                    Caption = 'Created Date & Time';
                    ToolTip = 'Creation Date & time of Fund Transfer';
                    Editable = false;
                }
                group("From Company")
                {

                    field(From; Rec.FromCompany)
                    {
                        ApplicationArea = all;
                        ToolTip = 'Specifies From-Company Of the Fund Transfer';
                        Caption = 'Name';
                        Style = Strong;
                        Editable = edit;
                    }
                    field(FromCompAdd; Rec.FromCompAdd)
                    {
                        ApplicationArea = All;
                        Caption = 'Address';
                        ToolTip = 'Specifies Address of Of the Fund Transfer';
                        Editable = false;
                        Importance = Additional;

                    }
                    field(FromCompAdd2; Rec.FromCompAdd2)
                    {
                        ApplicationArea = All;
                        Caption = 'Address 2';
                        ToolTip = 'Specifies Address 2 of Of the Fund Transfer';
                        Editable = false;
                        Importance = Additional;
                    }
                    field(FromCompCity; Rec.FromCompCity)
                    {
                        ApplicationArea = All;
                        Caption = 'City';
                        ToolTip = 'Specifies City Of Of the Fund Transfer';
                        Editable = false;
                        Importance = Additional;
                    }
                    field(FromCompPostCode; Rec.FromCompPostCode)
                    {
                        ApplicationArea = All;
                        Caption = 'Post Code';
                        ToolTip = 'Specifies Post Code Of Of the Fund Transfer';
                        Editable = false;
                        Importance = Additional;
                    }
                    field(FromCompCount; Rec.FromCompCount)
                    {
                        ApplicationArea = All;
                        Caption = 'Country Code';
                        ToolTip = 'Specifies Country Code Of Of the Fund Transfer';
                        Editable = false;

                    }
                    field(FromCompPhNo; Rec.FromCompPhNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Ph Number';
                        ToolTip = 'Specifies Phone Number Of Of the Fund Transfer';
                        Editable = false;
                    }
                    field(FromCompEmail; Rec.FromCompEmail)
                    {
                        ApplicationArea = All;
                        Caption = 'Email';
                        ToolTip = 'Specifies Email ID Of Of the Fund Transfer';
                        Editable = false;
                    }
                }
                group("To Company")
                {
                    field(To; Rec.ToCompany)
                    {
                        ApplicationArea = all;
                        ToolTip = 'Specifies TO-Company Of the Fund Transfer';
                        Caption = 'Name';
                        Editable = edit;
                        Style = Strong;
                    }
                    field(ToCompAdd; Rec.ToCompAdd)
                    {
                        ApplicationArea = All;
                        Caption = 'Address';
                        ToolTip = 'Specifies Address of Of the Fund Transfer';
                        Editable = false;
                        Importance = Additional;
                    }
                    field(ToCompAdd2; Rec.ToCompAdd2)
                    {
                        ApplicationArea = All;
                        Caption = 'Address 2';
                        ToolTip = 'Specifies Address 2 of Of the Fund Transfer';
                        Editable = false;
                        Importance = Additional;
                    }
                    field(ToCompCity; Rec.ToCompCity)
                    {
                        ApplicationArea = All;
                        Caption = 'City';
                        ToolTip = 'Specifies City of Of the Fund Transfer';
                        Editable = false;
                        Importance = Additional;
                    }
                    field(ToCompPostCode; Rec.ToCompPostCode)
                    {
                        ApplicationArea = All;
                        Caption = 'Post Code';
                        Editable = false;
                        ToolTip = 'Specifies Post Code of Of the Fund Transfer';
                        Importance = Additional;
                    }
                    field(ToCompCount; Rec.ToCompCount)
                    {
                        ApplicationArea = All;
                        Caption = 'Country Code';
                        ToolTip = 'Specifies country Code of Of the Fund Transfer';
                        Editable = false;
                    }
                    field(ToCompPhNo; Rec.ToCompPhNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Ph Number';
                        ToolTip = 'Specifies Phone Number of Of the Fund Transfer';
                        Editable = false;
                    }
                    field(ToCompEmail; Rec.ToCompEmail)
                    {
                        ApplicationArea = All;
                        Caption = 'Email';
                        ToolTip = 'Specifies Email ID of Of the Fund Transfer';
                        Editable = false;
                    }
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Importance = Promoted;
                    StyleExpr = StatusStyleTxt;
                    QuickEntry = false;
                    ToolTip = 'Specifies Status of the Fund Transfer';
                }
                field(Projectfiled; Rec.Project)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Project to be funded';
                    Style = Strong;
                    NotBlank = true;
                    ShowMandatory = true;
                    Editable = edit;
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Projects: Record Job;
                        FundLine: Record "Fund Transfer Line";
                    begin
                        Rec.TestField(ToCompany);
                        FundLine.SetRange("Document No.", Rec.No);
                        // If FundLine.FindFirst() then
                        If not FundLine.IsEmpty() then
                            Error('Project can not be changed as already Fund Line Exists')
                        else begin
                            Projects.ChangeCompany(Rec.ToCompany);
                            Projects.FindSet();
                            if Page.RunModal(Page::"Job List", Projects) = Action::LookupOK then begin
                                Rec.Project := Projects."No.";
                                Proj := true;
                            end;
                        end;
                    end;
                }
                group(Notes)
                {
                    Caption = 'Note';
                    field(Note; Note)
                    {
                        ApplicationArea = All;
                        Importance = Additional;
                        MultiLine = true;
                        ShowCaption = false;
                        ToolTip = 'Specifies the products or service being offered.';
                        Editable = edit;
                        trigger OnValidate()
                        begin
                            Rec.SetWorkDescription(Note);
                        end;
                    }
                }
            }

            part(FundTransferSubform; "Fund Transfer Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field(no);
                Editable = (edit and proj);
            }

        }
    }

    actions
    {
        area(Processing)
        {
            group(Action21)
            {
                Caption = 'Release';
                Image = ReleaseDoc;

                action(Release)
                {
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    ToolTip = 'Specifies to Release the document';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Rec.Status := Rec.Status::Released;
                        edit := false;
                        Rec.Modify(false);
                    end;
                }
                action(ReOpen)
                {
                    Caption = 'Re&open';
                    ToolTip = 'Specifies to Re-Open the document';
                    Image = ReOpen;
                    ApplicationArea = All;
                    Enabled = Rec.Status <> Rec.Status::Open;

                    trigger OnAction()
                    begin
                        Rec.Status := Rec.Status::Open;
                        edit := true;
                        Rec.Modify(false);
                    end;
                }
            }
            group(Project)
            {
                Image = Create;
                action(CreateProject)
                {
                    Caption = 'Create Project';
                    Image = NewOrder;
                    ApplicationArea = All;
                    ToolTip = 'Creates a new Project in To-Company';

                    trigger OnAction()
                    var
                        Job: Record Job;
                        NoSeries: Record "No. Series";
                        NoseriesLine: Record "No. Series Line";
                        NoSeriesMag: Codeunit "No. Series";
                        JobCardPageID: Integer;
                        JobNo: Code[20];
                    begin
                        Rec.TestField(ToCompany);
                        if Rec.Project <> '' then
                            Message('Already a project is Selected to the Fund')
                        else begin
                            Job.ChangeCompany(Rec.ToCompany);
                            // NoSeries.ChangeCompany(Rec.ToCompany);
                            // if NoSeries.Get('JOB') then
                            //     JobNo := NoSeriesMag.GetNextNo(NoSeries.Code);

                            job.Init();
                            // Job.Validate("No.", JobNo);
                            Job.Validate("No.");
                            job.Insert(true);
                            Rec.Project := Job."No.";
                            Rec.Modify(false);
                            JobCardPageID := Page::"Job Card";
                            Page.Run(JobCardPageID, Job);
                        end;
                    end;
                }
            }
        }

        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';
                group(Category_Category4)
                {
                    ShowAs = SplitButton;

                    actionref("Release_Promoted"; Release)
                    {

                    }
                    actionref("Reopen_Promoted"; Reopen)
                    {

                    }
                }
                actionref("Create Project Promoted"; CreateProject)
                {

                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        if Rec.Status = Rec.Status::Open then
            edit := true
        else
            edit := false;
    end;

    // trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    // var
    // begin
    //     // Rec."Document Type" := Rec."Document Type"::Order;
    //     Rec.Status := Rec.Status::Open;
    // end;



    trigger OnAfterGetCurrRecord()
    begin
        If Rec.No <> '' then begin
            StatusStyleTxt := GetStatusStyleText();
            Note := Rec.GetWorkDescription();
        end;
    end;

    procedure GetStatusStyleText() StatusStyleText: Text
    begin
        if Rec.Status = Rec.Status::Open then
            StatusStyleText := 'Favorable'
        else
            StatusStyleText := 'Strong';
    end;

    trigger OnAfterGetRecord()
    begin
        if Rec.Status = Rec.Status::Open then
            edit := true
        else
            edit := false;
        if Rec.Project <> '' then
            proj := true
        else
            proj := false;
    end;

    var
        StatusStyleTxt: Text;
        Note: Text;
        edit: Boolean;
        proj: Boolean;


}
