page 50101 ApiPageName
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "API Table";
    Caption = 'Api Data';

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(statusCode; Rec.statusCode)
                {
                    ApplicationArea = All;
                    Caption = 'Status Code';
                }
                field(Status; Rec.Status)
                {
                    Caption = 'Status';
                    ApplicationArea = All;
                }
                field(Date; Rec.Date)
                {
                    Caption = 'Date';
                    ApplicationArea = All;
                }
                field(Time; Rec.Time)
                {
                    Caption = 'Time';
                    ApplicationArea = All;
                }
                field(Depot; Rec.Depot)
                {
                    Caption = 'Depot';
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Getdata)
            {
                Caption = 'GetData';
                ApplicationArea = All;
                Image = Info;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    code: Codeunit Apidata;
                begin
                    code.WriteTable(Rec);
                end;
            }
            action(SeeData)
            {
                Caption = 'See Data in msg';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    code: Codeunit Apidata;
                begin
                    code.GetTrackingDetails();
                end;
            }
            action(XMLData)
            {
                Caption = 'Get XML Data';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    code: Codeunit Apidata;
                begin
                    code.GETXMLData(Rec);
                end;
            }
        }
    }
}