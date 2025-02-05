// Report 50144 "Mgt Reports - VW"
// {
//     // Ken changed to Hilary 12/12/19

//     ProcessingOnly = true;
//     UseRequestPage = false;
//     ApplicationArea = all;
//     UsageCategory = ReportsAndAnalysis;

//     dataset
//     {
//         dataitem(DailySalesFlash; "Integer")
//         {
//             DataItemTableView = sorting(Number) where(Number = const(1));
//             column(ReportForNavId_1; 1)
//             {
//             }

//             trigger OnAfterGetRecord()
//             var
//                 LocationDesc: Text[10];
//             begin
//                 //Daily Sales Flash
//                 Clear(EMailAddress);
//                 Clear(LocationDesc);

//                 //All locations
//                 CreatePDF('', '', LocationDesc);
//                 if Testing then begin
//                     if SendEMail then begin
//                         //EMailAddress := 'mremy@teamt.com';
//                         EMailAddress := 'cfoster@visionwheel.com';
//                         if EMailAddress <> '' then
//                             CreateEmail(EMailAddress, LocationDesc, '');
//                     end;
//                 end else begin
//                     if SendEMail then 
//                         EMailAddress := 'VWDSF@visionwheel.com';
//                         //EMailAddress := 'hphillips@visionwheel.com;roger@visionwheel.com;dminor@visionwheel.com;jmathew@visionwheel.com';
//                         if EMailAddress <> '' then
//                             CreateEmail(EMailAddress, LocationDesc, 'rpippins@visionwheel.com');

//                 end;
//             end;
//         }
//         dataitem("DailySalesFlash-AL"; "Integer")
//         {
//             DataItemTableView = sorting(Number) where(Number = const(1));
//             column(ReportForNavId_2; 2)
//             {
//             }

//             trigger OnAfterGetRecord()
//             var
//                 LocationDesc: Text[10];
//             begin
//                 //Daily Sales Flash
//                 Clear(EMailAddress);
//                 Clear(LocationDesc);

//                 //AL location
//                 LocationDesc := 'AL';
//                 CreatePDF('11|11IHR|11H|ADJ11|CUST11|CUST11IHR|INT11|OSP11|03|OESS', '', LocationDesc);
//                 if Testing then begin
//                     if SendEMail then begin
//                         //EMailAddress := 'mremy@teamt.com';
//                         EMailAddress := 'cfoster@visionwheel.com';
//                         if EMailAddress <> '' then
//                             CreateEmail(EMailAddress, LocationDesc, '');
//                     end;
//                 end else begin
//                     if SendEMail then begin
//                         EMailAddress := 'cball@visionwheel.com;btempleton@visionwheel.com';
//                         if EMailAddress <> '' then
//                             CreateEmail(EMailAddress, LocationDesc, 'cfoster@visionwheel.com');
//                     end;
//                 end;
//             end;
//         }
//         dataitem("DailySalesFlash-CA"; "Integer")
//         {
//             DataItemTableView = sorting(Number) where(Number = const(1));
//             column(ReportForNavId_3; 3)
//             {
//             }

//             trigger OnAfterGetRecord()
//             var
//                 LocationDesc: Text[10];
//             begin
//                 //Daily Sales Flash
//                 Clear(EMailAddress);
//                 Clear(LocationDesc);

//                 //CA location
//                 LocationDesc := 'CA';
//                 CreatePDF('02|ADJ02|CUST02|INT02|OSP02|COR|cs-02', '', LocationDesc);
//                 if Testing then begin
//                     if SendEMail then begin
//                         //EMailAddress := 'mremy@teamt.com';
//                         EMailAddress := 'cfoster@visionwheel.com';
//                         if EMailAddress <> '' then
//                             CreateEmail(EMailAddress, LocationDesc, '');
//                     end;
//                 end else begin
//                     if SendEMail then begin
//                         EMailAddress := 'lflores@visionwheel.com;ken@visionwheel.com';
//                         if EMailAddress <> '' then
//                             CreateEmail(EMailAddress, LocationDesc, 'cfoster@visionwheel.com');
//                     end;
//                 end;
//             end;
//         }
//         dataitem("DailySalesFlash-IN"; "Integer")
//         {
//             DataItemTableView = sorting(Number) where(Number = const(1));
//             column(ReportForNavId_4; 4)
//             {
//             }

//             trigger OnAfterGetRecord()
//             var
//                 LocationDesc: Text[10];
//             begin
//                 //Daily Sales Flash
//                 Clear(EMailAddress);
//                 Clear(LocationDesc);

//                 //IN location
//                 LocationDesc := 'IN';
//                 CreatePDF('04|ADJ04|CUST04|INT04|OSP04', '', LocationDesc);
//                 if Testing then begin
//                     if SendEMail then begin
//                         //EMailAddress := 'mremy@teamt.com';
//                         EMailAddress := 'cfoster@visionwheel.com';
//                         if EMailAddress <> '' then
//                             CreateEmail(EMailAddress, LocationDesc, '');
//                     end;
//                 end else begin
//                     if SendEMail then begin
//                         EMailAddress := 'trobinson@visionwheel.com;aunger@visionwheel.com';
//                         if EMailAddress <> '' then
//                             CreateEmail(EMailAddress, LocationDesc, 'cfoster@visionwheel.com');
//                     end;
//                 end;
//             end;
//         }
//         dataitem("DailySalesFlash-NC"; "Integer")
//         {
//             DataItemTableView = sorting(Number) where(Number = const(1));
//             column(ReportForNavId_5; 5)
//             {
//             }

//             trigger OnAfterGetRecord()
//             var
//                 LocationDesc: Text[10];
//             begin
//                 //Daily Sales Flash
//                 Clear(EMailAddress);
//                 Clear(LocationDesc);

//                 //NC location
//                 LocationDesc := 'NC';
//                 CreatePDF('70', '', LocationDesc);
//                 if Testing then begin
//                     if SendEMail then begin
//                         //EMailAddress := 'mremy@teamt.com';
//                         EMailAddress := 'cfoster@visionwheel.com';
//                         if EMailAddress <> '' then
//                             CreateEmail(EMailAddress, LocationDesc, '');
//                     end;
//                 end else begin
//                     if SendEMail then begin
//                         EMailAddress := 'jvaughn@visionwheel.com';
//                         if EMailAddress <> '' then
//                             CreateEmail(EMailAddress, LocationDesc, 'cfoster@visionwheel.com');
//                     end;
//                 end;
//             end;
//         }
//         dataitem("DailySalesFlash-ON"; "Integer")
//         {
//             DataItemTableView = sorting(Number) where(Number = const(1));
//             column(ReportForNavId_6; 6)
//             {
//             }

//             trigger OnAfterGetRecord()
//             var
//                 LocationDesc: Text[10];
//             begin
//                 //Daily Sales Flash
//                 Clear(EMailAddress);
//                 Clear(LocationDesc);

//                 //ON location
//                 LocationDesc := 'ON';
//                 CreatePDF('61|adj61|60', '', LocationDesc);
//                 if Testing then begin
//                     if SendEMail then begin
//                         //EMailAddress := 'mremy@teamt.com';
//                         EMailAddress := 'cfoster@visionwheel.com';
//                         if EMailAddress <> '' then
//                             CreateEmail(EMailAddress, LocationDesc, '');
//                     end;
//                 end else begin
//                     if SendEMail then begin
//                         EMailAddress := 'cpotito@visionwheel.com';
//                         if EMailAddress <> '' then
//                             CreateEmail(EMailAddress, LocationDesc, 'cfoster@visionwheel.com');
//                     end;
//                 end;
//             end;
//         }
//         dataitem("DailySalesFlash-WA"; "Integer")
//         {
//             DataItemTableView = sorting(Number) where(Number = const(1));
//             column(ReportForNavId_7; 7)
//             {
//             }

//             trigger OnAfterGetRecord()
//             var
//                 LocationDesc: Text[10];
//             begin
//                 //Daily Sales Flash
//                 Clear(EMailAddress);
//                 Clear(LocationDesc);

//                 //WA location
//                 LocationDesc := 'WA';
//                 CreatePDF('ADJ80|80', '', LocationDesc);
//                 if Testing then begin
//                     if SendEMail then begin
//                         //EMailAddress := 'mremy@teamt.com';
//                         EMailAddress := 'cfoster@visionwheel.com';
//                         if EMailAddress <> '' then
//                             CreateEmail(EMailAddress, LocationDesc, '');
//                     end;
//                 end else begin
//                     if SendEMail then begin
//                         EMailAddress := 'svillegas@visionwheel.com';
//                         if EMailAddress <> '' then
//                             CreateEmail(EMailAddress, LocationDesc, 'cfoster@visionwheel.com');
//                     end;
//                 end;
//             end;
//         }
//         dataitem("DailySalesFlash-NJ"; "Integer")
//         {
//             DataItemTableView = sorting(Number) where(Number = const(1));
//             column(ReportForNavId_8; 8)
//             {
//             }

//             trigger OnAfterGetRecord()
//             var
//                 LocationDesc: Text[10];
//             begin
//                 //Daily Sales Flash
//                 Clear(EMailAddress);
//                 Clear(LocationDesc);

//                 //NJ location
//                 LocationDesc := 'NJ';
//                 CreatePDF('ADJ85|85', '', LocationDesc);
//                 if Testing then begin
//                     if SendEMail then begin
//                         //EMailAddress := 'mremy@teamt.com';
//                         EMailAddress := 'cfoster@visionwheel.com';
//                         if EMailAddress <> '' then
//                             CreateEmail(EMailAddress, LocationDesc, '');
//                     end;
//                 end else begin
//                     if SendEMail then begin
//                         EMailAddress := 'jmarafioti@visionwheel.com';
//                         if EMailAddress <> '' then
//                             CreateEmail(EMailAddress, LocationDesc, 'cfoster@visionwheel.com');
//                     end;
//                 end;
//             end;
//         }
//     }

//     requestpage
//     {

//         layout
//         {
//             area(content)
//             {
//                 group(Options)
//                 {
//                     Caption = 'Options';
//                 }
//             }
//         }

//         actions
//         {
//         }
//     }

//     labels
//     {
//     }

//     trigger OnPreReport()
//     begin
//         Testing := false;
//         SendEMail := true;
//         //DateFilterToUse := '10/26/2023..10/26/2023';   //Change this to date you need, then restart the service.
//         DateFilterToUse := Format(Today);

//         //get the folder to store the Daily Sales output
//         Clear(SRSetup);
//         Clear(FolderName);
//         if SRSetup.Get('') then;
//         if SRSetup."Folder for Daily Sales Flash" = '' then
//             if GuiAllowed then
//                 Error('Please specify folder location for generated Daily Sales Flash on S&R Setup');
//         FolderName := SRSetup."Folder for Daily Sales Flash";
//     end;

//     var
//         DateFilterToUse: Text[100];
//         Testing: Boolean;
//         SendEMail: Boolean;
//         SRSetup: Record "Sales & Receivables Setup";
//         FolderName: Text[250];
//         EMailAddress: Text[250];
//         AttachFileName: Text[250];


//     procedure CreatePDF(PassedLocationFilter: Code[100]; PassedCompany: Text[30]; PassedLocationDesc: Code[10])
//     var
//         OutPutFileName: Text[250];
//         DailySalesFlash: Report "Daily Sales Flash";
//         //==BullZip: Automation PDFPrinterSettings;
//         RunOnceFile: Text[1000];
//     begin
//         //Hey fix me
//         // Bullzip no longer used, need the report to go to pdf
//         /*
//         Clear(AttachFileName);
//         Clear(BullZip);
//         if PassedLocationDesc = '' then begin
//           if FILE.Exists(FolderName + '\' + 'Daily_Sales_Flash' + '.pdf') then
//             FILE.Erase(FolderName + '\' + 'Daily_Sales_Flash' + '.pdf');
//         end else begin
//           if FILE.Exists(FolderName + '\' + PassedLocationDesc + '_Daily_Sales_Flash' + '.pdf') then
//             FILE.Erase(FolderName + '\' + PassedLocationDesc + '_Daily_Sales_Flash' + '.pdf');
//         end;
//         if ISCLEAR(BullZip) then
//           Create(BullZip);
//         BullZip.Init;
//         BullZip.LoadSettings;
//         RunOnceFile := BullZip.GetSettingsFileName(true);
//         if PassedLocationDesc = '' then begin
//           BullZip.SetValue('Output',FolderName + '\' + 'Daily_Sales_Flash' + '.pdf');
//           AttachFileName := FolderName + '\' + 'Daily_Sales_Flash' + '.pdf';
//         end else begin
//           BullZip.SetValue('Output',FolderName + '\' + PassedLocationDesc + '_Daily_Sales_Flash' + '.pdf');
//           AttachFileName := FolderName + '\' + PassedLocationDesc + '_Daily_Sales_Flash' + '.pdf';
//         end;
//         BullZip.SetValue('Showsettings','never');
//         BullZip.SetValue('ShowPDF','no');
//         BullZip.SetValue('ShowSaveAs','never');
//         BullZip.SetValue('ShowProgress','no');
//         BullZip.SetValue('ShowProgressFinished','no');
//         BullZip.SetValue('SuppressErrors','yes');
//         BullZip.SetValue('ConfirmOverwrite','no');
//         BullZip.WriteSettings(true);

//         Clear(DailySalesFlash);
//         DailySalesFlash.UseRequestPage(false);
//         DailySalesFlash.SetJobQueueParameters(false,PassedLocationFilter,'',PassedCompany,PassedLocationDesc,DateFilterToUse);
//         DailySalesFlash.RunModal;
//         Sleep(3000);
//         Clear(BullZip);
//         */
//     end;


//     procedure CreateEmail(SendToEmail: Text[250]; PassedLocationDesc: Text[10]; CCSendToEmail: Text[250])
//     var
//         UserSetup: Record "User Setup";
//         SenderName: Text[100];
//         SenderAddress: Text[50];
//         Recipients: Text[1024];
//         Subject: Text[200];
//         Body: Text[1024];
//     //==SMTP: Codeunit UnknownCodeunit400;
//     begin
//         // send email
//         //hey fix me
//         /*
//         Clear(SMTP);
//         if Exists(AttachFileName) then begin
//             SenderAddress := SRSetup."From E-Mail Address";
//             SenderName := 'Vision Wheel';
//             Recipients := SendToEmail;
//             if PassedLocationDesc = '' then
//                 Subject := 'CONFIDENTIAL - ' + 'Daily Sales Flash ' + Format(Today, 0, '<Month,2>/<Day,2>/<Year>')
//             else
//                 Subject := 'CONFIDENTIAL - ' + PassedLocationDesc + ' Daily Sales Flash ' + Format(Today, 0, '<Month,2>/<Day,2>/<Year>');
//             Body := '';
//             SMTP.CreateMessage(SenderName, SenderAddress, Recipients, Subject, Body, true);
//             SMTP.AddAttachment(AttachFileName);
//             if (UserSetup.Get(UserId) and (UserSetup."E-Mail" <> '')) or (CCSendToEmail <> '') then begin
//                 if (UserSetup."E-Mail" <> '') and (CCSendToEmail <> '') then
//                     SMTP.AddCC(UserSetup."E-Mail" + ';' + CCSendToEmail)
//                 else if (UserSetup."E-Mail" <> '') and (CCSendToEmail = '') then
//                     SMTP.AddCC(UserSetup."E-Mail")
//                 else if (UserSetup."E-Mail" = '') and (CCSendToEmail <> '') then
//                     SMTP.AddCC(CCSendToEmail);
//             end;
//             SMTP.Send;
//             Clear(SMTP);
//         end;
//         */
//     end;
// }