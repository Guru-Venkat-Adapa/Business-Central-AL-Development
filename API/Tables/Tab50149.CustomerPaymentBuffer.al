// namespace Microsoft.Purchases.Payables;

// using Microsoft.Finance.Currency;
// using Microsoft.Finance.Dimension;
// using Microsoft.Finance.GeneralLedger.Journal;
// using Microsoft.Purchases.Remittance;
// using Microsoft.Sales.Receivables;
// using Microsoft.Sales.Customer;
// using Microsoft.Purchases.Vendor;
// table 50100 "Customer Payment Buffer"
// {
//     Caption = 'Customer Payment Buffer';
//     DataClassification = ToBeClassified;
//     ReplicateData = false;
//     TableType = Temporary;

//     fields
//     {
//         field(1; "Customer No."; Code[20])
//         {
//             Caption = 'Customer No.';
//             DataClassification = SystemMetadata;
//             TableRelation = Customer;
//         }
//         field(2; "Currency Code"; Code[10])
//         {
//             Caption = 'Currency Code';
//             DataClassification = SystemMetadata;
//             TableRelation = Currency;
//         }
//         field(3; "Cust. Ledg. Entry No."; Integer)
//         {
//             Caption = 'Cust. Ledg. Entry No.';
//             DataClassification = SystemMetadata;
//             TableRelation = "Cust. Ledger Entry";
//         }
//         field(4; "Dimension Entry No."; Integer)
//         {
//             Caption = 'Dimension Entry No.';
//             DataClassification = SystemMetadata;
//         }
//         field(5; "Global Dimension 1 Code"; Code[20])
//         {
//             CaptionClass = '1,1,1';
//             Caption = 'Global Dimension 1 Code';
//             DataClassification = SystemMetadata;
//             TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
//         }
//         field(6; "Global Dimension 2 Code"; Code[20])
//         {
//             CaptionClass = '1,1,2';
//             Caption = 'Global Dimension 2 Code';
//             DataClassification = SystemMetadata;
//             TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
//         }
//         field(7; "Document No."; Code[20])
//         {
//             Caption = 'Document No.';
//             DataClassification = SystemMetadata;
//         }
//         field(8; Amount; Decimal)
//         {
//             AutoFormatType = 1;
//             Caption = 'Amount';
//             DataClassification = SystemMetadata;
//         }
//         field(9; "Customer Ledg. Entry Doc. Type"; Enum "Gen. Journal Document Type")
//         {
//             Caption = 'Customer Ledg. Entry Doc. Type';
//             DataClassification = SystemMetadata;
//         }
//         field(10; "Customer Ledg. Entry Doc. No."; Code[20])
//         {
//             Caption = 'Customer Ledg. Entry Doc. No.';
//             DataClassification = SystemMetadata;
//         }
//         field(11; "Customer Posting Group"; Code[20])
//         {
//             Caption = 'Customer Posting Group';
//             DataClassification = SystemMetadata;
//         }
//         field(170; "Creditor No."; Code[20])
//         {
//             Caption = 'Creditor No.';
//             DataClassification = SystemMetadata;
//             TableRelation = "Vendor Ledger Entry"."Creditor No." where("Entry No." = field("Vendor Ledg. Entry No."));
//         }
//         field(171; "Payment Reference"; Code[50])
//         {
//             Caption = 'Payment Reference';
//             DataClassification = SystemMetadata;
//             TableRelation = "Cust. Ledger Entry"."Payment Reference" where("Entry No." = field("Cust. Ledg. Entry No."));
//         }
//         field(172; "Payment Method Code"; Code[10])
//         {
//             Caption = 'Payment Method Code';
//             DataClassification = SystemMetadata;
//             TableRelation = "Cust. Ledger Entry"."Payment Method Code" where("Customer No." = field("Customer No."));
//         }
//         field(173; "Applies-to Ext. Doc. No."; Code[35])
//         {
//             Caption = 'Applies-to Ext. Doc. No.';
//             DataClassification = SystemMetadata;
//         }
//         field(290; "Exported to Payment File"; Boolean)
//         {
//             Caption = 'Exported to Payment File';
//             DataClassification = SystemMetadata;
//             Editable = false;
//         }
//         field(480; "Dimension Set ID"; Integer)
//         {
//             Caption = 'Dimension Set ID';
//             DataClassification = SystemMetadata;
//             Editable = false;
//             TableRelation = "Dimension Set Entry";
//         }
//         field(1000; "Remit-to Code"; Code[20])
//         {
//             Caption = 'Remit-to Code';
//             DataClassification = SystemMetadata;
//             TableRelation = "Remit Address".Code where("Vendor No." = field("Vendor No."));
//         }
//     }

//     keys
//     {
//         key(Key1; "Customer No.", "Currency Code", "Cust. Ledg. Entry No.", "Dimension Entry No.", "Remit-to Code")
//         {
//             Clustered = true;
//         }
//         key(Key2; "Document No.")
//         {
//         }
//     }
//     procedure CopyFieldsFromVendorLedgerEntry(CustomerLedgerEntry: Record "Cust. Ledger Entry")
//     begin
//         "Creditor No." := CustomerLedgerEntry."Creditor No.";
//         "Payment Reference" := CustomerLedgerEntry."Payment Reference";
//         "Exported to Payment File" := CustomerLedgerEntry."Exported to Payment File";
//         "Applies-to Ext. Doc. No." := CustomerLedgerEntry."External Document No.";
//         "Customer Posting Group" := CustomerLedgerEntry."Customer Posting Group";
//         "Remit-to Code" := CustomerLedgerEntry."Remit-to Code";

//         OnCopyFieldsFromVendorLedgerEntry(CustomerLedgerEntry, Rec);
//     end;

//     procedure CopyFieldsToGenJournalLine(var GenJournalLine: Record "Gen. Journal Line")
//     begin
//         GenJournalLine."Creditor No." := "Creditor No.";
//         GenJournalLine."Payment Reference" := "Payment Reference";
//         GenJournalLine."Exported to Payment File" := "Exported to Payment File";
//         GenJournalLine."Applies-to Ext. Doc. No." := "Applies-to Ext. Doc. No.";
//         GenJournalLine."Posting Group" := "Customer Posting Group";
//         GenJournalLine."Remit-to Code" := "Remit-to Code";

//         OnCopyFieldsToGenJournalLine(Rec, GenJournalLine);
//     end;

// #if not CLEAN22
//     [Obsolete('Table Payment Buffer will be replaced by table Vendor Payment Buffer.', '22.0')]
//     procedure CopyFieldsFromPaymentBuffer(TempPaymentBuffer: Record "Payment Buffer")
//     begin
//         Rec.TransferFields(TempPaymentBuffer, true, true);
//     end;
// #endif

//     [IntegrationEvent(false, false)]
//     local procedure OnCopyFieldsFromVendorLedgerEntry(CustomerLedgerEntry: Record "Cust. Ledger Entry"; var PaymentBufferTarget: Record "Customer Payment Buffer")
//     begin
//     end;

//     [IntegrationEvent(false, false)]
//     local procedure OnCopyFieldsToGenJournalLine(PaymentBufferSource: Record "Customer Payment Buffer"; var GenJournalLineTarget: Record "Gen. Journal Line")
//     begin
//     end;

// }
