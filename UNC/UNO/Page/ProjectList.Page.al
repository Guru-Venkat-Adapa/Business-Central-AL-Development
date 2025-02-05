page 50111 "Project List"
{
    ApplicationArea = All;
    Caption = 'Project List';
    PageType = ListPart;
    SourceTable = Job;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        job: Record job;
                    begin
                        job.ChangeCompany('My Copy Company');

                        if Page.RunModal(Page::"Job List", job) = Action::LookupOK then begin
                            Rec.TransferFields(job);
                            Rec.Modify(false);
                        end;
                    end;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies a short description of the project.';
                }
                field(Total_Budget; Total_Budget)
                {
                    Caption = 'Total Budget';
                    ToolTip = 'Specifies the Total Budget';
                }
                field(Total_Actual; Total_Actual)
                {
                    Caption = 'Total Actual';
                    ToolTip = 'Specifies the Total Actual';
                }
                field(Total_Billable; Total_Billable)
                {
                    Caption = 'Total Billable';
                    ToolTip = 'Specifies the Total Billable';

                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies a current status of the project. You can change the status for the project as it progresses. Final calculations can be made on completed projects.';
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ToolTip = 'Specifies the name of the customer who will receive the products and be billed by default.';
                }
                field("Sell-to Country/Region Code"; Rec."Sell-to Country/Region Code")
                {
                    ToolTip = 'Specifies the country or region of the address.';
                }
                field("Company"; Rec.CurrentCompany)
                {
                    Caption = 'Company Name';
                    ToolTip = 'Specifies the Company Name';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.ChangeCompany('Testing');
    end;

    var
        Total_Budget: Decimal;
        Total_Actual: Decimal;
        Total_Billable: Decimal;
}
