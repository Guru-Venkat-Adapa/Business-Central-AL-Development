pageextension 50101 "Sales Order Page Ext" extends "Sales Order"
{
    layout
    {
        // Add changes to page layout here
        addafter("Opportunity No.")
        {
            field("No. of Lines"; Rec."No. of Lines")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the no. of sales lines for a single sales order';
            }
            field("DropDown Country"; Rec."DropDown Country")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the country name from the customer side';
                Caption = 'Country Name';
                LookupPageId = "Country Page";
                //using OnAfyterGetRecord Trigger
                trigger OnValidate()
                begin
                    dropDownState();
                end;
            }
            field("DropDown State"; Rec."DropDown State")
            {
                ApplicationArea = All;
                Caption = 'State Name';
                ToolTip = 'Specifies the state name as per customer wish';
                // LookupPageId="State Page";
                TableRelation = if ("DropDown Country" = const()) "State Table".Country else
                "State Table".StateName where(Country = field("DropDown Country"));
                //TableRelation = "State Table".StateName where(Country = field("DropDown Country"));
                Editable = StateCheck;
                //Using OnAfterGetRecord Trigger
                trigger OnValidate()
                begin
                    DropDownCity();
                end;
            }
            field("DropDown City"; Rec."DropDown City")
            {
                ApplicationArea = All;
                Caption = 'City Name';
                ToolTip = 'Specifies the country name as per customer request';
                // LookupPageId="City Page";
                TableRelation = if ("DropDown State" = const()) "City table".state else
                "City table".CityName where(state = field("DropDown State"));
                //TableRelation = "City table".CityName where(state = field("DropDown State"));
                Editable = CityCheck;
            }
            field("Name Text"; Rec."Name Text")
            {
                ApplicationArea = All;
                Caption = 'Text For Name';
            }
            field(CusToSoData; Rec.CusToSoData)
            {
                Caption = 'Cus to SO data';
                ApplicationArea = All;
                ToolTip = 'Custom Field to get data from customer to sales order based on specific customer';
            }
        }
        addafter(Status)
        {
            field(ICCompantText; Rec.ICCompantText)
            {
                ApplicationArea = All;
                Caption = 'Text for IC Company';
            }
        }
    }

    actions
    {
        addfirst(processing)
        {
            action("View Info")
            {
                Image = NewProperties;
                Promoted = true;
                PromotedCategory = New;
                ApplicationArea = All;
                Caption = 'View Info';
                ToolTip = 'Shows the oder id and its orders';

                trigger OnAction()
                var
                    orderid: Record "Sales Header";
                    Item: Record "Sales Line";
                    text1: Text;

                begin
                    orderid.SetRange("No.", Rec."No.");
                    if orderid.FindFirst() then begin
                        Message('Id: %1', orderid."No.");
                        Item.SetRange("Document No.", orderid."No.");
                        if Item.FindSet() then
                            repeat
                                text1 += (Item.Description + '(' + Format(Item.Quantity) + ')' + '\');
                            until Item.Next() = 0;
                        Message(text1);
                    end;
                end;
            }
            action(UpdateSo)
            {
                Image = UpdateDescription;
                Promoted = true;
                PromotedCategory = New;
                ApplicationArea = All;
                Caption = 'Update Sales Order';

                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                    PurchaseHeader: Record "Purchase Header";
                    SalesLine: Record "Sales Line";
                    PurchaseLine: Record "Purchase Line";
                    IcPartner: Record "IC Partner";
                    Customer: Record Customer;
                begin
                    Customer.SetRange("No.", Rec."Sell-to Customer No.");
                    if Customer.FindSet() then begin
                        if Customer."IC Partner Code" <> '' then begin
                            IcPartner.Get(Customer."IC Partner Code");
                        end;
                        SalesLine.SetFilter("Document No.", Rec."No.");
                        if not SalesLine.FindSet() then begin
                            Message('There is not data avaliable to modify');
                        end;

                        if IcPartner."Inbox Details" <> '' then begin
                            PurchaseHeader.ChangeCompany(IcPartner."Inbox Details");
                            PurchaseHeader.SetFilter("Vendor Order No.", Rec."No.");
                            if PurchaseHeader.FindFirst() then begin
                                PurchaseHeader.ICCompantText := Rec.ICCompantText;
                                PurchaseHeader.Modify();
                                PurchaseLine.ChangeCompany(IcPartner."Inbox Details");
                                PurchaseLine.SetFilter("Document No.", PurchaseHeader."No.");
                                if PurchaseLine.FindSet() then begin
                                    repeat
                                        PurchaseLine.SetRange("Line No.", SalesLine."Line No.");
                                        if PurchaseLine.FindSet() then begin
                                            PurchaseLine."No." := SalesLine."No.";
                                            PurchaseLine.Description := SalesLine.Description;
                                            PurchaseLine.Quantity := SalesLine.Quantity;
                                            PurchaseLine.Modify();
                                        end;
                                    until SalesLine.Next() = 0;
                                end;
                            end;
                        end;
                    end;
                end;
            }
            action(GetCusData)
            {
                Caption = 'Get Data From Cus';
                Image = DataEntry;
                Promoted = true;
                PromotedCategory = New;
                ApplicationArea = All;

                trigger OnAction()
                var
                    CusData: Record Customer;
                // SalOrder: Record "Sales Header";
                // varb: Text;
                // varb2: text;
                begin
                    CusData.SetRange(CusData."No.", Rec."Sell-to Customer No.");
                    if CusData.FindSet() then begin
                        if CusData."No." = Rec."Sell-to Customer No." then begin
                            Rec.CusToSoData := CusData.CusToSoData;
                        end;
                    end;
                end;
            }
            action(PostData)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Post Data Directly';
                Image = PostOrder;
                Promoted = true;
                PromotedCategory = New;
                ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';

                trigger OnAction()
                begin
                    Code(Rec, false);
                end;
            }
        }
    }
    var
        StateCheck: Boolean;
        CityCheck: Boolean;

    // trigger OnAfterGetRecord()
    // begin
    //     StateCheck := true;
    //     CityCheck := true;
    //     if Rec."DropDown Country" = '' then begin
    //         StateCheck := false;
    //         CityCheck := false;
    //     end
    //     else
    //         StateCheck := true;
    //     if rec."DropDown State" = '' then begin
    //         CityCheck := false;
    //     end
    //     else
    //         CityCheck := true;
    // end;

    trigger OnOpenPage()
    var
        sh: Record "Sales Header";
    begin
        if Rec."DropDown Country" <> '' then begin
            DropDownCheck();
        end;
        sh.SetRange("No.", Rec."No.");
        if sh.FindFirst() then
            Message('Sales Order Id :- %1', sh."No.");
        Message('Sales Order Date :- %1', Format(sh."Order Date"));
        Message('Current Date & Time :- %1', Format(CurrentDateTime));
    end;

    procedure DropDownCheck()
    begin
        StateCheck := false;
        CityCheck := false;
        Rec."DropDown State" := '';
        Rec."DropDown City" := '';
    end;

    procedure dropDownState()
    begin
        if Rec."DropDown Country" <> '' then begin
            StateCheck := true;
            CityCheck := false;
            Rec."DropDown State" := '';
            Rec."DropDown City" := '';
        end
        else
            DropDownCheck();
    end;

    procedure DropDownCity()
    begin
        if Rec."DropDown State" <> '' then begin
            CityCheck := true;
        end
        else
            CityCheck := false;
        Rec."DropDown City" := '';
    end;

    local procedure "Code"(var SalesHeader: Record "Sales Header"; PostAndSend: Boolean)
    var
        // SalesSetup: Record "Sales & Receivables Setup";
        // SalesPostViaJobQueue: Codeunit "Sales Post via Job Queue";
        // HideDialog: Boolean;
        // IsHandled: Boolean;
        // DefaultOption: Integer;
        SalesInvoiceHeader: Record "Sales Invoice Header";
        PostedSalesInvoice: Page "Posted Sales Invoice";
    begin
        SalesHeader.Invoice := true;
        SalesHeader.Ship := true;
        CODEUNIT.Run(CODEUNIT::"Sales-Post", SalesHeader);

        SalesInvoiceHeader.SetRange("Order No.", SalesHeader."No.");
        if SalesInvoiceHeader.FindFirst() then
            PostedSalesInvoice.SetRecord(SalesInvoiceHeader);
        PostedSalesInvoice.Run();
    end;
}


