tableextension 50101 "Sales Order Table Ext" extends "Sales Header"
{
    fields
    {
        // Add changes to table fields here
        field(50100; "No. of Lines"; Integer)
        {
            Caption = 'No. of Lines';
        }
        field(50101; "DropDown Country"; Text[100])
        {
            Caption = 'Country Name';
            TableRelation = "Country Table";
        }
        field(50102; "DropDown State"; Text[100])
        {
            Caption = 'State Name';
            // TableRelation = "State Table" where(Country=field("DropDown Country"));
        }
        field(50103; "DropDown City"; Text[100])
        {
            Caption = 'City Name';
            // TableRelation = "City table" where(state = field("DropDown State"));
        }
        field(50105; "Name Text"; Text[100])
        {
            Caption = 'Text For Name';
        }
        field(50106; ICCompantText; Text[100])
        {
            Caption = 'IcCompanyText';
        }
        field(50107; CusToSoData; Text[100])
        {
            Caption = 'Cus to SO data';
            DataClassification = CustomerContent;
        }
    }
    var
        myInt: Integer;

    // procedure ICPartnerSopo(SalesOrder:Record "Sales Header")
    // begin
    //     "No.":=SalesOrder."No.";
    // end;
    // [IntegrationEvent(false, false)]
    // local procedure OnAfterSalesOrder(var SalesOrder: Record "Sales Header"; PurchaseOrder: Record "Purchase Header")
    // begin
    // end;
}