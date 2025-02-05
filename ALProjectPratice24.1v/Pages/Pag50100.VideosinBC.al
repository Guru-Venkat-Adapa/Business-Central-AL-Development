page 50100 "Videos in BC"
{
    ApplicationArea = All;
    Caption = 'Videos in BC';
    PageType = List;
    SourceTable = "Videos in BC";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    trigger OnDrillDown()
                    var
                        Video: Codeunit Video;
                    begin
                        Video.Play(Rec.URL);
                        // Video.OnVideoPlayed(Rec."Table Num", Rec."System ID");
                    end;
                }
                field(URL; Rec.URL)
                {
                    ApplicationArea = All;
                    Caption = 'URL';
                }
                // field("Last Modified Date"; Rec."Last Modified Date")
                // {
                //     ApplicationArea = All;
                //     Caption = 'Last Modified Date';
                // }
            }
        }
    }
    actions
    {
        area(Creation)
        {
            action(ViewinBC)
            {
                Caption = 'View in BC';
                ApplicationArea = All;
                Image = Picture;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    video: Codeunit Video;
                begin
                    video.Play(Rec.URL);
                end;
            }
        }
    }
}
