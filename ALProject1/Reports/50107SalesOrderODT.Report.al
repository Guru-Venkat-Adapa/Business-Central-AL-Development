report 50107 "sales order"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Sales Order Report';
    DefaultLayout = RDLC;
    RDLCLayout = 'SalesOrderReportOrgDupTri.RDL';


    dataset
    {
        dataitem(CopyLoop; "Integer")
        {
            DataItemTableView = SORTING(Number);
            dataitem(PageLoop; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                dataitem("Sales Header"; "Sales Header")
                {
                    DataItemTableView = sorting("No.", "Document Type");
                    RequestFilterFields = "No.", "Bill-to Customer No.";
                    column(No_; "No.")
                    { }
                    column(Sell_to_Customer_No_; "Sell-to Customer No.")
                    {
                        IncludeCaption = true;
                    }
                    column(Bill_to_Customer_No_; "Bill-to Customer No.")
                    {
                        IncludeCaption = true;
                    }
                    column(Bill_to_Name; "Bill-to Name")
                    {
                        IncludeCaption = true;
                    }
                    column(SalesNo_; "No.")
                    {
                        IncludeCaption = true;
                    }
                    column(Status; Status)
                    {
                        IncludeCaption = true;
                    }
                    column(Sell_to_Contact_No_; "Sell-to Contact No.")
                    {
                        IncludeCaption = true;
                    }
                    column(Document_Date; "Document Date")
                    {
                        IncludeCaption = true;
                    }
                    column(Sell_to_Address; "Sell-to Address")
                    {
                        IncludeCaption = true;
                    }
                    column(Ship_to_Address; "Ship-to Address")
                    {
                        IncludeCaption = true;
                    }
                    column(Sell_to_City; "Sell-to City")
                    { }
                    column(VAT_Country_Region_Code; "VAT Country/Region Code")
                    { }
                    column(Ship_to_Post_Code; "Ship-to Post Code")
                    {
                        IncludeCaption = true;
                    }
                    column(Shipment_Date; "Shipment Date")
                    {
                        IncludeCaption = true;
                    }
                    column(Sell_to_E_Mail; "Sell-to E-Mail")
                    {
                        IncludeCaption = true;
                    }
                    column(Sell_to_Phone_No_; "Sell-to Phone No.")
                    {
                        IncludeCaption = true;
                    }

                    dataitem("Sales Line"; "Sales Line")
                    {
                        DataItemTableView = sorting("Document Type", "Document No.", "Line No.");
                        DataItemLink = "Document No." = field("No.");
                        column(Document_No_; "Document No.")
                        { }
                        column(Line_No_; "Line No.")
                        { }
                        column(Description; Description)
                        { }
                        column(ItemType; Type)
                        { }
                        column(Unit_Price; "Unit Price")
                        { }
                        column(Quantity; Quantity)
                        { }
                        column(Line_Discount__; "Line Discount %")
                        { }
                        column(Line_Discount_Amount; "Line Discount Amount")
                        { }
                        column(Line_Amount; "Line Amount")
                        { }
                        column(CompanyName; Company.Name)
                        { }
                        column(CompanyAddress; Company.Address)
                        { }
                        column(columnhead; columnhead)
                        { }
                        column(OutputNo; OutputNo) { }
                        column(SlNo; SlNo) { }
                        trigger OnAfterGetRecord()
                        begin
                            SlNo += 1;
                        end;

                        trigger OnPreDataItem()
                        begin
                            SlNo := 0;
                        end;
                    }
                }
            }
            trigger OnAfterGetRecord();
            begin
                if Number > 1 then begin
                    CopyText := FormatDocument.GetCOPYText;
                    OutputNo += 1;
                end;
                if Original = true then begin
                    myarray[1] := 'Original';
                    Original := false;
                end else begin
                    if Duplicate = true then begin
                        myarray[1] := 'Duplicate';
                        Duplicate := false;
                    end else begin
                        if Triplicate = true then begin
                            myarray[1] := 'Triplicate';
                            Triplicate := false;
                        end;
                    end;
                end;
                columnhead := myarray[1];
            end;

            trigger OnPreDataItem();
            begin
                if (Original = true and Duplicate = true) then begin
                    NoOfLoops := 2;
                    SETRANGE(Number, 1, NoOfLoops);
                    OutputNo := 1;
                end;
                if (Original = true and Triplicate = true) then begin
                    NoOfLoops := 2;
                    SETRANGE(Number, 1, NoOfLoops);
                    OutputNo := 1;
                end;
                if (Triplicate = true and Duplicate = true) then begin
                    NoOfLoops := 2;
                    SETRANGE(Number, 1, NoOfLoops);
                    OutputNo := 1;
                end;
                if Original = true and Duplicate = true and Triplicate = true then begin
                    NoOfLoops := 3;
                    SETRANGE(Number, 1, NoOfLoops);
                    OutputNo := 1;
                end;
                begin
                    if (Original = true) and (Duplicate = false) and (Triplicate = false) then
                        NoOfLoops := 1;
                    SETRANGE(Number, 1, NoOfLoops);
                    OutputNo := 1;
                    if (Duplicate = true) and (Original = false) and (Triplicate = false) then
                        NoOfLoops := 1;
                    SETRANGE(Number, 1, NoOfLoops);
                    OutputNo := 1;
                    if (Triplicate = true) and (Original = false) and (Duplicate = false) then
                        NoOfLoops := 1;
                    SETRANGE(Number, 1, NoOfLoops);
                    OutputNo := 1;
                end;
                begin
                    if (Original = false) and (Duplicate = false) and (Triplicate = false) then begin
                        Error('Please select atleast anyone of the option');
                        NoOfLoops := 0;
                    end;
                end;

                if "Sales Header".IsEmpty then
                    Error('There is not matching data found');
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(options)
                {
                    Caption = 'Options';
                    field(Original; Original)
                    {
                        Caption = 'Original';
                        ApplicationArea = All;
                        ToolTip = 'Specfies the report type is original';
                    }
                    field(Duplicate; Duplicate)
                    {
                        Caption = 'Duplicate';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the report type is duplicate';
                    }
                    field(Triplicate; Triplicate)
                    {
                        Caption = 'Triplicate';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the report type is triplicate';
                    }
                }
            }
        }
    }
    trigger OnPreReport()
    begin
        Company.get();
    end;

    var
        Original: Boolean;
        Duplicate: Boolean;
        Triplicate: Boolean;
        Company: Record "Company Information";
        CompanyName: Text[200];
        CompanyAddress: Text[100];
        SlNo: Integer;
        myarray: array[3] of Text;
        NoOfLoops: Integer;
        CopyText: Text[30];
        OutputNo: Integer;
        FormatDocument: Codeunit "Format Document";
        columnhead: Text;
        cus: Record Customer;
}

