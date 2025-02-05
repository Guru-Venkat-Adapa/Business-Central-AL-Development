// codeunit 50148 "Data Transfer"
// {
//     trigger OnRun()
//     var
//         caseheader: Record "Case Header nH";
//     begin
//         // caseheader.SetRange("Amendment Mode", caseheader."Amendment Mode"::Released);
//         if caseheader.FindSet() then
//             repeat
//                 transfer(caseheader."No.");
//             until caseheader.Next() = 0;
//     end;

//     procedure transfer(no: Code[20])
//     begin
//         DataTransferCaseToInq(no);
//         DataTranfEmailInbox(no);
//         TransfLinkedDoc(no);
//     end;


//     // [EventSubscriber(ObjectType::Table, Database::"Inquiry List", 'OnAfterInsertEvent', '', false, false)]
//     // local procedure MyProcedure(var Rec: Record "Inquiry List")
//     // begin
//     //     Rec.Inq_case := false;
//     //     Rec.Modify();
//     // end;


//     procedure DataTransferCaseToInq(no: Code[20])
//     var
//         Inq: Record "Inquiry List";
//         cas: Record "Case Header nH";
//         InqConnector: Record "Inq-case connector";
//     begin
//         cas.SetCurrentKey(SystemCreatedAt);
//         cas.SetAscending(SystemCreatedAt, true);
//         cas.Reset();
//         cas.SetFilter("No.", no);
//         if cas.FindSet() then
//             repeat
//                 Clear(Inq);
//                 Inq.Init();
//                 Inq."SIT Description" := cas.Description;
//                 inq."SIT Inquiry Date" := cas."Case Date";
//                 Inq."SIT Inquiry Time" := cas."Case Time";
//                 cas.CalcFields(Notes);
//                 Inq.SetNotes(cas.GetNotes());


//                 if getcontact(cas."Company Contact No.") then
//                     inq."SIT Company Contact No." := cas."Company Contact No.";

//                 inq."SIT Company Sales Person Code" := cas."Company Salesperson Code";
//                 if getcontact(cas."Person Contact No.") then
//                     Inq.Validate("SIT Person Contact No.", cas."Person Contact No.");
//                 // inq."SIT Person Contact No." := cas."Person Contact No.";


//                 inq."SIT Customer No." := cas."Customer No.";
//                 inq."SIT Inquiry Type" := cas.Type;
//                 inq.SLA := cas.SLA;
//                 inq."SIT Priority" := cas.Priority;
//                 inq."SIT Status Code" := cas.Status;


//                 if getcontact(cas."Created By Contact No.") then
//                     inq."SIT Created by Contact No." := cas."Created By Contact No.";


//                 if getcontact(cas."Owned By Contact No.") then
//                     inq."SIT Owned By Contact No." := cas."Owned By Contact No.";

//                 if getcontact(cas."Assigned To Contact No.") then
//                     inq."SIT Assigned Contact No." := cas."Assigned To Contact No.";


//                 Evaluate(Inq."SIT Owned By Area", Format(cas."Owned By Area"));
//                 Evaluate(Inq."Currently with", Format(cas."Currently With"));


//                 inq."SIT Target Resolution Duration" := cas."Target Closure Duration";
//                 inq."SIT Target Resolution Duration" := cas."Target Resolution Duration";
//                 inq."SIT Target Closure Date Time" := cas."Target Closure Date Time";
//                 inq."SIT Target Closure Duration " := cas."Target CLosure Duration";

//                 inq."SIT Resolved" := cas.Resolved;
//                 inq."SIT Resolved By " := cas."Resolved By";
//                 inq."SIT Resolved Date Time" := cas."Resolved Date Time";
//                 inq."Resolved Within SLA" := cas."Resolved Within SLA";
//                 inq."Needs Attention" := cas."Needs Attention";

//                 Evaluate(inq."Related-to", Format(cas."Related-to"));
//                 Evaluate(inq."Related-to Sales Doc. Type", Format(cas."Related-to Sales Doc. Type"));
//                 if getSalesDoc(cas."Related-to Sales Doc. No.") or (cas."Related-to Sales Doc. No." <> '') then
//                     inq."Related-to Sales Doc. No." := cas."Related-to Sales Doc. No.";


//                 inq."Related-to Sales Doc. Line No." := cas."Related-to Sales Doc. Line No.";
//                 inq."Related-to Sales Doc. Desc." := cas."Related-to Sales Doc. Desc.";
//                 Evaluate(inq."Related-to Purch. Doc. Type", Format(cas."Related-to Purch. Doc. Type"));
//                 if getPurchDoc(cas."Related-to Purch. Doc. No.") or (cas."Related-to Purch. Doc. No." <> '') then
//                     inq."Related-to Purch. Doc. No." := cas."Related-to Purch. Doc. No.";
//                 inq."Related-to Purch. Doc. Ln. No." := cas."Related-to Purch. Doc. Ln. No.";
//                 inq."Related-to Purch. Doc. Desc." := cas."Related-to Purch. Doc. Desc.";
//                 inq."SIT Days Start Time" := cas."Day Start Time";
//                 inq."SIT Day End Time" := cas."Day End Time";
//                 inq."SIT Include Weekends" := cas."Include Weekends";
//                 inq."SIT Vendor No." := cas."Vendor No.";
//                 inq."SIT Next Action Date" := cas."Next Action Date";
//                 inq."Inquiry Sub Status" := cas."Case Sub Status";
//                 inq."SIT Unread E-Mail" := cas."Un-Read Mail";
//                 Inq."Created By" := cas."Created By";
//                 inq."Created Date Time" := cas."Created Date Time";
//                 inq."SIT Modified By" := cas."Modified By";
//                 inq."Modified Date Time" := cas."Modified Date Time";
//                 inq."SIT Unread E-Mail" := cas."Un-Read Mail";
//                 Inq."Created By" := cas."Created By";
//                 inq."Created Date Time" := cas."Created Date Time";
//                 inq."SIT Modified By" := cas."Modified By";
//                 inq."Modified Date Time" := cas."Modified Date Time";
//                 // inq.Inq_case := true;
//                 inq.Insert(true);
//                 Evaluate(Inq."SIT Amendment Mode", Format(cas."Amendment Mode"));
//                 inq."SIT Closed" := cas.Closed;
//                 inq."SIT Closed By" := cas."Closed By";
//                 inq."SIT Closed Date/Time" := cas."Closed Date Time";
//                 inq."Closed Within SLA" := cas."Closed Within SLA";
//                 inq.Modify();

//                 InqConnector.Init();
//                 InqConnector."Case No." := cas."No.";
//                 InqConnector."Inq. No." := Inq."SIT Inquiry No.";
//                 InqConnector.Insert(true);

//             until cas.Next() = 0;
//     end;

//     procedure getcontact(cont: Code[20]): Boolean
//     var
//         contact: Record Contact;
//     begin
//         if cont = '' then
//             exit(true);
//         if contact.get(cont) then
//             exit(true)
//         else
//             exit(false);
//     end;

//     procedure getSalesDoc(cont: Code[20]): Boolean
//     var
//         contact: Record "Sales Header";
//     begin
//         if cont = '' then
//             exit(true);

//         contact.SetRange("No.", cont);
//         if contact.FindFirst() then
//             exit(true)
//         else
//             exit(false);
//     end;

//     procedure getPurchDoc(cont: Code[20]): Boolean
//     var
//         contact: Record "Purchase Header";
//     begin
//         if cont = '' then
//             exit(true);
//         contact.SetRange("No.", cont);
//         if contact.FindFirst() then
//             exit(true)
//         else
//             exit(false);
//     end;





//     // Modify this
//     procedure DataTranfEmailInbox(no: Code[20])
//     var
//         caseemail: Record "Email nH";
//         inqEmail: Record "Email Data";

//         InqLogs: Record "Details (Logs) Lines";
//         CaseLogs: Record "Case Interaction nH";

//         InqCaseConnector: Record "Inq-case connector";
//         sdspro: Record "SDS Processing Instance";
//         recordIdText: Text;

//         RecRef: RecordRef;
//         MyFieldRef: FieldRef;
//         RecID: RecordId;
//         emailid: list of [text];
//         id: Integer;
//     begin
//         CaseLogs.Reset();
//         CaseLogs.SetRange("Case No.", no);
//         if CaseLogs.FindSet() then begin
//             repeat
//                 if Format(CaseLogs."Email Record ID") <> '' then begin
//                     caseemail.SetCurrentKey(SystemCreatedAt);
//                     caseemail.SetAscending(SystemCreatedAt, true);
//                     caseemail.Reset();
//                     emailid := Format(caselogs."Email Record ID").Split(':');
//                     Evaluate(id, emailid.Get(2));
//                     caseemail.SetRange(ID, id);
//                     if caseemail.FindSet() then begin
//                         repeat
//                             Clear(inqEmail);
//                             if inqEmail.FindLast() then begin
//                                 inqEmail.ID := inqEmail.ID + 1;
//                             end;
//                             inqEmail.Init();
//                             inqEmail.Reference := caseemail.Reference;
//                             inqEmail."ID as Code" := Format(inqEmail.ID);
//                             inqEmail.Subject := caseemail.Subject;
//                             inqEmail."Sender Email" := caseemail."Sender Email";
//                             inqEmail."Sender Name" := caseemail."Sender Name";
//                             inqEmail.BCC := caseemail.BCC;
//                             inqEmail."Received Date Time" := caseemail."Received Date Time";
//                             inqEmail."Sent Date Time" := caseemail."Sent Date Time";
//                             inqEmail.Recipients := caseemail.Recipients;
//                             inqEmail."Contact No." := caseemail."Contact No.";
//                             inqEmail."Contact Name" := caseemail."Contact Name";

//                             caseemail.CalcFields(Body);
//                             inqEmail.Body := caseemail.Body;

//                             inqEmail."Body is HTML" := caseemail."Body is HTML";
//                             inqEmail."No. Attachments" := caseemail."No. Attachments";

//                             caseemail.CalcFields("HTML Body");
//                             inqEmail."HTML Body" := caseemail."HTML Body";
//                             inqEmail.Insert(true);


//                             Clear(InqLogs);
//                             InqLogs.Init();
//                             InqCaseConnector.Reset();
//                             InqCaseConnector.SetRange("Case No.", CaseLogs."Case No.");
//                             if InqCaseConnector.FindFirst() then begin
//                                 InqLogs.Validate("Inquiry No.", InqCaseConnector."Inq. No.");
//                                 InqLogs."Inquiry No." := InqCaseConnector."Inq. No.";
//                             end;

//                             CaseLogs.CalcFields(Notes);
//                             InqLogs.SetNotes(CaseLogs.GetNotes());

//                             InqLogs."Company Contact No." := CaseLogs."Company Contact No.";
//                             InqLogs."Person Contact No." := CaseLogs."Person Contact No.";
//                             InqLogs."Interaction Group Code" := CaseLogs."Interaction Group Code";
//                             InqLogs.Description := CaseLogs.Description;
//                             InqLogs.Closed := CaseLogs.Closed;


//                             if CaseLogs."Email Record ID".GetRecord().Caption = 'Sent Email' then begin
//                                 InqLogs."Email Record ID" := CaseLogs."Email Record ID";

//                             end else begin
//                                 // For RecordId
//                                 RecRef.Open(Database::"Email Data");
//                                 MyFieldRef := RecRef.Field(1);
//                                 MyFieldRef.Value := inqEmail.ID;
//                                 if RecRef.Find('=') then begin
//                                     InqLogs."Email Record ID" := RecRef.RecordId;
//                                     RecRef.Get(InqLogs."Email Record ID");
//                                 end;
//                                 RecRef.Close();
//                             end;


//                             // For RecordId
//                             // RecRef.Open(Database::"Email Data");
//                             // MyFieldRef := RecRef.Field(1);
//                             // MyFieldRef.Value := inqEmail.ID;
//                             // if RecRef.Find('=') then begin
//                             //     InqLogs."Email Record ID" := RecRef.RecordId;
//                             //     RecRef.Get(InqLogs."Email Record ID");
//                             // end;
//                             // RecRef.Close();

//                             InqLogs."Next Action Date" := CaseLogs."Next Action Date";
//                             InqLogs."Created By" := CaseLogs."Created By";
//                             InqLogs.Insert();

//                             sdspro.Init();
//                             sdspro.PID := inqEmail.ID;
//                             sdspro.isHandled := true;
//                             sdspro.Insert();

//                         until caseemail.Next() = 0;
//                     end else begin
//                         if emailid.Get(1) = 'Sent Email' then begin
//                             Clear(InqLogs);
//                             InqLogs.Init();
//                             InqCaseConnector.Reset();
//                             InqCaseConnector.SetRange("Case No.", CaseLogs."Case No.");
//                             if InqCaseConnector.FindFirst() then begin
//                                 InqLogs.Validate("Inquiry No.", InqCaseConnector."Inq. No.");
//                                 InqLogs."Inquiry No." := InqCaseConnector."Inq. No.";
//                             end;

//                             CaseLogs.CalcFields(Notes);
//                             InqLogs.SetNotes(CaseLogs.GetNotes());
//                             InqLogs."Email Record ID" := CaseLogs."Email Record ID";
//                             InqLogs."Company Contact No." := CaseLogs."Company Contact No.";
//                             InqLogs."Person Contact No." := CaseLogs."Person Contact No.";
//                             InqLogs."Interaction Group Code" := CaseLogs."Interaction Group Code";
//                             InqLogs.Description := CaseLogs.Description;
//                             InqLogs.Closed := CaseLogs.Closed;
//                             InqLogs."Email Record ID" := CaseLogs."Email Record ID";
//                             InqLogs."Next Action Date" := CaseLogs."Next Action Date";
//                             InqLogs."Created By" := CaseLogs."Created By";
//                             InqLogs.Insert();
//                         end;
//                     end;
//                 end else begin
//                     Clear(InqLogs);
//                     InqLogs.Init();
//                     InqCaseConnector.Reset();
//                     InqCaseConnector.SetRange("Case No.", CaseLogs."Case No.");
//                     if InqCaseConnector.FindFirst() then begin
//                         InqLogs.Validate("Inquiry No.", InqCaseConnector."Inq. No.");
//                         InqLogs."Inquiry No." := InqCaseConnector."Inq. No.";
//                     end;

//                     CaseLogs.CalcFields(Notes);
//                     InqLogs.SetNotes(CaseLogs.GetNotes());

//                     InqLogs."Company Contact No." := CaseLogs."Company Contact No.";
//                     InqLogs."Person Contact No." := CaseLogs."Person Contact No.";
//                     InqLogs."Interaction Group Code" := CaseLogs."Interaction Group Code";
//                     InqLogs.Description := CaseLogs.Description;
//                     InqLogs.Closed := CaseLogs.Closed;
//                     InqLogs."Email Record ID" := CaseLogs."Email Record ID";
//                     InqLogs."Next Action Date" := CaseLogs."Next Action Date";
//                     InqLogs."Created By" := CaseLogs."Created By";
//                     InqLogs.Insert();
//                 end;

//             until CaseLogs.Next() = 0;
//         end;



//     end;


//     procedure TransfLinkedDoc(no: Code[20])
//     var
//         InqLines: Record Lines;
//         CasLines: Record "Case Link nH";
//         InqCaseConnector: Record "Inq-case connector";

//     begin

//         CasLines.SetCurrentKey(SystemCreatedAt);
//         CasLines.SetAscending(SystemCreatedAt, true);

//         CasLines.Reset();
//         CasLines.SetRange("Case No.", no);

//         if CasLines.FindSet() then
//             repeat
//                 Clear(InqLines);
//                 InqCaseConnector.Reset();
//                 InqCaseConnector.SetRange("Case No.", CasLines."Case No.");
//                 if InqCaseConnector.FindFirst() then begin
//                     InqLines.Validate("Inquiry No.", InqCaseConnector."Inq. No.");
//                     InqLines."Inquiry No." := InqCaseConnector."Inq. No.";
//                 end;

//                 InqLines."Line No." := CasLines."Line No.";
//                 InqLines."Inquiry Link Type Code" := CasLines."Case Link Type Code";
//                 InqLines."Table ID" := CasLines."Table ID";
//                 InqLines."Table Caption" := CasLines."Table Caption";
//                 InqLines."Record Position" := CasLines."Record Position";
//                 InqLines."Record Desc" := CasLines."Record Description";
// #pragma warning disable AL0603
//                 InqLines.Source := CasLines.Source;
// #pragma warning restore AL0603
//                 InqLines.Description := CasLines.Description;
//                 InqLines."Original Record ID" := CasLines."Original Record ID";
//                 InqLines."Automatic Entry" := CasLines."Automatic Entry";
//                 InqLines."Created By" := CasLines."Created By";
//                 InqLines."Created Date Time" := CasLines."Created Date Time";
//                 InqLines."Modified By" := CasLines."Modified By";
//                 InqLines."Modified Date Time" := CasLines."Modified Date Time";


//                 InqLines.Insert(true);
//             until CasLines.Next() = 0;

//     end;


// }




// table 60148 "Inq-case connector"
// {
//     DataClassification = ToBeClassified;


//     fields
//     {
//         field(1; "Case No."; Code[20])
//         {
//             DataClassification = ToBeClassified;

//         }
//         field(2; "Inq. No."; Code[20])
//         {
//             DataClassification = ToBeClassified;

//         }
//     }

//     keys
//     {
//         key(Key1; "Inq. No.", "Case No.")
//         {
//             Clustered = true;
//         }
//     }

// }

// page 60100 "Inq-case connnector"
// {
//     PageType = Card;
//     ApplicationArea = All;
//     UsageCategory = Administration;
//     SourceTable = "Inq-case connector";
//     DeleteAllowed = true;

//     layout
//     {
//         area(Content)
//         {
//             repeater(GroupName)
//             {
//                 field("Case No."; Rec."Case No.")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Inq. No."; Rec."Inq. No.")
//                 {
//                     ApplicationArea = all;
//                 }
//             }
//         }
//     }
// }

