pageextension 50106 "SalesOrderCard" extends "Sales Order"
{
    layout
    {
        addafter(General)
        {
            group("Shopify Order Details")
            {
                field("Customer Type"; Rec."Customer Type")
                {
                    Caption = 'Customer Type';
                    ToolTip = 'Type of Customer';
                    ApplicationArea = all;
                //Editable = false;
                }
                field(Stages; Rec.Stages)
                {
                    Caption = 'Stages';
                    ToolTip = 'Order Current Status';
                    ApplicationArea = all;
                //Editable = false;
                }
                field("Referral Source"; Rec."Referral Source")
                {
                    Caption = 'Referral Source';
                    ToolTip = 'Source of Order';
                    ApplicationArea = all;
                //Editable = false;
                }
                field("Order Margin"; Rec."Order Margin")
                {
                    Caption = 'Order Margin';
                    ToolTip = 'margin of order';
                    ApplicationArea = all;
                // Editable = false;
                }
                field("Payment Received %"; Rec."Payment Received %")
                {
                    Caption = 'Payment Received %';
                    ToolTip = 'Payment Received %';
                    ApplicationArea = all;
                //Editable = false;
                }
            }
        }
        addafter(Status)
        {
            field("Sent Order Confirmation"; Rec."Sent Order Confirmation")
            {
                ApplicationArea = all;
                Caption = 'Sent Order Confirmation';
                ToolTip = 'boolean is Mark as TRUE is Order Confirmation already sent to Customer';
            }
            field("Tacking Type"; Rec."Tacking Type")
            {
                ApplicationArea = all;
                Caption = 'Tacking Type';
                ToolTip = 'Select the Tracking site name';

                trigger OnValidate()
                begin
                    Rec."Tracking reference No.":='';
                end;
            }
            field("Tracking reference No."; Rec."Tracking reference No.")
            {
                ApplicationArea = all;
                Caption = 'Tracking reference No.';
                ToolTip = 'enter the Tracking reference No.';
            }
        }
        addbefore("Prices Including VAT")
        {
            field("Tax Liable"; Rec."Tax Liable")
            {
                Caption = 'Tax Liable';
                ToolTip = 'Tax Liable';
                ApplicationArea = all;
            }
            field("Tax Area Code"; Rec."Tax Area Code")
            {
                Caption = 'Tax Area Code';
                ToolTip = 'Tax Area Code';
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        modify(SendEmailConfirmation)
        {
            Visible = false;
        }
        addafter(SendEmailConfirmation)
        {
            action("Email Confirmation Custom")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Email Confirmation';
                Ellipsis = true;
                Promoted = true;
                PromotedIsBig = true;
                Image = Email;
                ToolTip = 'Send an order confirmation by email. The Send Email window opens prefilled for the customer so you can add or change information before you send the email.';

                trigger OnAction()
                var
                    Evgmgt: Codeunit "Event Managment";
                begin
                    Evgmgt.SendOrderConfirmation(Rec);
                end;
            }
            action(Tracking)
            {
                ApplicationArea = All;
                Caption = 'Track Order';
                Image = Track;

                trigger OnAction()
                var
                    TrackingCard: Page "Order Tracking Dialog";
                    TNTTracking: Page "TNT Order Tracking";
                begin
                    Clear(TrackingCard);
                    IF Rec."Tacking Type" = Rec."Tacking Type"::Mainfreight then begin
                        TrackingCard.SetValue(Rec."No.", Rec."Document Type");
                        TrackingCard.Run();
                    end
                    else IF Rec."Tacking Type" = Rec."Tacking Type"::TNT then begin
                            TNTTracking.SetValue(Rec."No.");
                            TNTTracking.Run();
                        end end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        UpdateTimelineNotes();
    end;
    local procedure UpdateTimelineNotes()
    var
        LineNo: Integer;
        RecordLink: Record "Record Link";
        Item: Record Item;
        RecordLinkMgt: Codeunit "Record Link Management";
        AutBomExplode: Codeunit "Auto ExplodBOM";
        NoteList: List of[Text];
        RowNo: Integer;
        ShopifyNote: Text;
        FindLink: Integer;
    begin
        Clear(AutBomExplode);
        IF Rec."Shpfy Order Id" <> 0 then begin
            NoteList:=AutBomExplode.GetTimeLine(Format(Rec."Shpfy Order Id"));
            RecordLink.Reset();
            RecordLink.SetRange(RecordLink."Record ID", Rec.RecordId);
            IF RecordLink.FindSet()then RecordLink.DeleteAll();
            foreach ShopifyNote in NoteList do begin
                LastLinkID:=0;
                GetLastLinkID();
                LastLinkID+=1;
                RecordLink.Init();
                RecordLink."Link ID":=LastLinkID;
                RecordLink.Insert();
                RecordLink.Company:=CompanyName;
                RecordLink.Type:=RecordLink.Type::Note;
                RecordLink.Created:=CurrentDateTime;
                RecordLink."User ID":=UserId;
                RecordLink."Record ID":=Rec.RecordId;
                FindLink:=StrPos(ShopifyNote, '<');
                IF FindLink > 0 then RecordLinkMgt.WriteNote(RecordLink, CopyStr(ShopifyNote, 1, FindLink - 1))
                else
                    RecordLinkMgt.WriteNote(RecordLink, ShopifyNote);
                RecordLink.Modify();
            end;
        end;
    end;
    local procedure GetLastLinkID()
    var
        RecordLink: Record "Record Link";
    begin
        RecordLink.Reset();
        if RecordLink.FindLast()then LastLinkID:=RecordLink."Link ID"
        else
            LastLinkID:=0;
    end;
    var LastLinkID: Integer;
}
