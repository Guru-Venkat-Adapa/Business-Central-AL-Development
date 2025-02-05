report 50103 "Order confirmation"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = Word;
    WordLayout = 'ORDERConfirmation.docx';

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            RequestFilterFields = "No.";

            column(No_; "No.")
            {
            }
            column(CompLogo; CompanyInfo.Picture)
            {
            }
            column(DateNow; DateNow)
            {
            }
            column(Sell_to_Customer_Name; "Sell-to Customer Name")
            {
            }
            column(Ship_to_Address; "Ship-to Address")
            {
            }
            column(Bill_to_Address; "Bill-to Address")
            {
            }
            column(finalTotal; finalTotal)
            {
            }
            column(Currency_Code; "Currency Code")
            {
            }
            // column(Tracking_UrlText; TrackingUrlText)
            // {
            // }
            column(Tracking_Url; Tracking_Url)
            {
            }
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document No."=field("No.");

                column(Description; Description)
                {
                }
                column(Line_Amount; "Line Amount")
                {
                }
                column(content; ItemImage.Content)
                {
                }
                column(vat; vat)
                {
                }
                column(total; total)
                {
                }
                trigger OnAfterGetRecord()
                var
                    Item: Record Item;
                    lineNo: Integer;
                begin
                    // total += "Line Amount";
                    // inVat += "Amount Including VAT";
                    // vat += "Amount Including VAT" - Amount;
                    if Type = Type::Item then if Item.Get("No.")then if Item.Picture.Count > 0 then begin
                                ItemImage.Get(Item.Picture.Item(1));
                                ItemImage.CalcFields(Content);
                            end;
                end;
            }
            trigger OnPreDataItem()
            begin
                DateNow:=System.CurrentDateTime;
                CompanyInfo.GET();
                CompanyInfo.CalcFields(Picture);
            end;
            trigger OnAfterGetRecord()
            var
                salesline: Record "Sales Line";
                inVat: Decimal;
            begin
                //TrackingUrlText := Hyperlink('https://www.mainfreight.com/en-nz/tracking?trackingnumber=' + "Sales Header"."No.");
                // TrackingUrlText := 'https://www.mainfreight.com/en-nz/tracking?trackingnumber=' + "Sales Header"."No.";
                Tracking_Url:='https://www.mainfreight.com/en-nz/tracking?trackingnumber=' + "Sales Header"."No.";
                salesline.SetRange("Document No.", "Sales Header"."No.");
                if salesline.FindSet()then begin
                    repeat total+=salesline."Line Amount";
                        inVat+=salesline."Amount Including VAT";
                        vat+=salesline."Amount Including VAT" - Amount;
                    until salesline.Next() = 0;
                    finalTotal:=inVat;
                end;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
                action(LayoutName)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    var total: Decimal;
    DateNow: DateTime;
    ItemImage: Record "Tenant Media";
    vat: Decimal;
    finalTotal: Decimal;
    TrackingUrlText: Text;
    Tracking_Url: Text;
    CompanyInfo: Record "Company Information";
}
