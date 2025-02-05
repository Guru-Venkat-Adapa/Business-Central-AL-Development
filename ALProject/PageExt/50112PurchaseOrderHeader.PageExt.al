pageextension 50112 "Purchase Order Header Ext" extends "Purchase Order"
{
    layout
    {
        // Add changes to page layout here
        addafter(Status)
        {
            field("Temp Text"; Rec."Temp Text")
            {
                Caption = 'Temporary Text';
                ApplicationArea = All;
            }
            field(ICCompantText; Rec.ICCompantText)
            {
                Caption = 'Text for IC Company';
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter("P&osting")
        {
            action(UpdatePo)
            {
                Caption = 'Update Purchase Order';
                Image = UpdateDescription;
                Promoted = true;
                PromotedCategory = New;
                ApplicationArea = All;

                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                    SalesLine: Record "Sales Line";
                    PurchaseLine: Record "Purchase Line";
                    Vendor: Record Vendor;
                    IcPartner: Record "IC Partner";
                    Data: text;
                    no: text;
                begin
                    Vendor.SetRange("No.", Rec."Buy-from Vendor No.");
                    if Vendor.FindSet() then begin
                        if Vendor."IC Partner Code" <> '' then begin
                            IcPartner.Get(Vendor."IC Partner Code");
                        end;

                        PurchaseLine.SetFilter("Document No.", Rec."No.");
                        if not PurchaseLine.FindSet() then begin
                            Message('There is no data avaliable');
                        end;
                        Data := Rec.ICCompantText;
                        no := rec."No.";

                        if IcPartner."Inbox Details" <> '' then begin
                            // if IcPartner.Code = Vendor."IC Partner Code" then begin
                            SalesHeader.ChangeCompany(IcPartner."Inbox Details");
                            SalesHeader.Reset();
                            SalesHeader.SetFilter("External Document No.", no);
                            if SalesHeader.FindFirst() then begin
                                SalesHeader.ICCompantText := Data;
                                SalesHeader.Modify();

                                SalesLine.ChangeCompany(IcPartner."Inbox Details");
                                SalesLine.SetFilter("Document No.", SalesHeader."No.");
                                if SalesLine.FindSet() then begin
                                    repeat
                                        SalesLine.SetRange("Line No.", PurchaseLine."Line No.");
                                        if SalesLine.FindSet() then begin

                                            SalesLine."No." := PurchaseLine."No.";
                                            SalesLine.Description := PurchaseLine.Description;
                                            SalesLine.Quantity := PurchaseLine.Quantity;
                                            SalesLine.Modify();
                                        end;
                                    until PurchaseLine.Next() = 0;
                                end;
                            end;
                            // end;
                        end;
                    end;
                end;
            }
        }
    }
}