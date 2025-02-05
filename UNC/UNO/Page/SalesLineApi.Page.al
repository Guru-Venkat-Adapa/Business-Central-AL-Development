page 50113 "Sales Line Api "
{
    APIGroup = 'salesLIneGroup';
    APIPublisher = 'guruPublisher';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'salesLineApi';
    DelayedInsert = true;
    EntityName = 'salesLineEntity';
    EntitySetName = 'salesLineEntitySet';
    PageType = API;
    SourceTable = "Sales Line";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(documentType; Rec."Document Type")
                {
                    Caption = 'Document Type';
                }
                field(documentNo; Rec."Document No.")
                {
                    Caption = 'Sales Order No.';
                }
                field(no; Rec."No.")
                {
                    Caption = 'Item No.';
                }

                field(lineNo; Rec."Line No.")
                {
                    Caption = 'Line No.';
                }

                field(name; Rec.Name)
                {
                    Caption = 'Name';
                }
                field(address; Rec.Address)
                {
                    Caption = 'Address';
                }
                field(phoneNumber; Rec."Phone Number")
                {
                    Caption = 'Phone Number';
                }
                field(email; Rec.Email)
                {
                    Caption = 'Email';
                }
            }
        }
    }
}
