report 50022 "Posted Transfer Shipment"
{
    ApplicationArea = All;
    Caption = 'Stock Transfer Shipment';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'Src\04_Reports\Layouts\PostedTransferShipment.rdlc';
    dataset
    {
        dataitem(TransferShipmentHeader; "Transfer Shipment Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Transfer-from Code", "Transfer-to Code";
            RequestFilterHeading = 'Transfer Order';

            column(No_; "No.") { }
            column(Posting_Date; PostingDate) { }
            column(Transfer_Order_No_; "Transfer Order No.") { }
            column(Transfer_Order_Date; TransferOrderDt) { }
            column(Transporter; TransportMethod.Description) { }
            column(Mode_of_Transport; "Mode of Transport") { }
            column(LR_RR_No_; "LR/RR No.") { }
            column(LR_RR_Date; LRDate) { }
            //from transfer location
            column(Customer_Name; Customer_Name) { }
            column(FromLocCode; FromLocation.Code) { }
            column(FromLocName; FromLocation.Name) { }
            column(FromLocAdd; FromLocation.Address) { }
            column(FromLocAdd_2; FromLocation."Address 2") { }
            column(FromLocCity; FromLocation.City) { }
            column(FromLocPtcode; FromLocation."Post Code") { }
            column(FromLocGSTNo; FromLocation."GST Registration No.") { }
            column(Exec_Name; "Service Persion ID") { }
            //to transfer location
            column(ToLocCode; ToLocation.Code) { }
            column(ToLocName; ToLocation.Name) { }
            column(ToLocAdd; ToLocation.Address) { }
            column(ToLocAdd_2; ToLocation."Address 2") { }
            column(ToLocCity; ToLocation.City) { }
            column(ToLocPtCode; ToLocation."Post Code") { }
            column(ToLocGSTNo; ToLocation."GST Registration No.") { }
            // company Info
            column(CompanyName; CompanyInfo.Name) { }
            column(CompanyInfoPicture; CompanyInfo.Picture) { }
            column(CompanyInfoAddress; CompanyInfo.Address) { }
            column(CompanyInfoAddress2; CompanyInfo."Address 2") { }
            column(GSTNo; CompanyInfo."GST Registration No.") { }
            column(CompanyCity; companyinfo.City) { }
            column(CompanyPostCode; companyinfo."Post Code") { }
            //  footer, date and time
            column(Note; Note) { }
            column(Value_Declaration; "Value Declaration") { }
            column(ExecutionDate; ExecutionDate) { }
            column(ExecutionTime; ExecutionTime) { }
            dataitem(TransferShipmentLine; "Transfer Shipment Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document No.", "Line No.") where(Quantity = filter(<> 0));
                DataItemLinkReference = TransferShipmentHeader;
                column(Item_No_; "Item No.") { }
                column(Description; Description) { }
                column(Description_2; "Description 2") { }
                column(HSN_SAC_Code; "HSN/SAC Code") { }
                column(Quantity; Quantity) { }
                dataitem(ItemLedgerEntry; "Item Ledger Entry")
                {
                    DataItemLink = "Document No." = field("Document No."),
                        "Item No." = field("Item No."), "Document Line No." = field("Line No.");
                    DataItemTableView = sorting("Document No.", "Item No.")
                        where("Entry Type" = const(Transfer), "Lot No." = filter(<> ''));
                    DataItemLinkReference = TransferShipmentLine;
                    column(Item_Lot_No; "Lot No.") { }
                    column(Item_Lot_qty; Quantity) { }
                    trigger OnPreDataItem()
                    begin
                        SetRange("Document Line No.", TransferShipmentLine."Line No.");
                        SetFilter(Quantity, '<%1', 0);
                    end;
                }

            }
            trigger OnAfterGetRecord()
            begin
                Clear(PostingDate);
                Clear(TransferOrderDt);
                Clear(ExecutionDate);
                Clear(ExecutionTime);
                PostingDate := Format("Posting Date", 0, '<Day,2>/<Month,2>/<Year4>');
                LRDate := Format("LR/RR Date", 0, '<Day,2>/<Month,2>/<Year4>');
                TransferOrderDt := Format("Transfer Order Date", 0, '<Day,2>/<Month,2>/<Year4>');
                ExecutionDate := Format(Today, 0, '<Day,2>/<Month,2>/<Year4>');
                ExecutionTime := Time;
                TransportMethod.Reset();
                fromLocation.Reset();
                ToLocation.Reset();
                if FromLocation.Get("Transfer-from Code") then;
                if ToLocation.Get("Transfer-to Code") then;
                if TransportMethod.Get("Transport Method") then;
            end;
        }
    }
    trigger OnPreReport()

    begin
        CompanyInfo.get();
        CompanyInfo.CalcFields(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
        ItemLedgerEnt: Record "Item Ledger Entry";
        FromLocation: Record Location;
        ToLocation: Record Location;
        TransportMethod: Record "Transport Method";
        PostingDate: Text;
        TransferOrderDt: Text;
        LRDate: Text;
        ExecutionDate: Text;
        ExecutionTime: time;
}
