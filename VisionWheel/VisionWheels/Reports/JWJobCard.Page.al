// page 50100 "JW Job Card"
// {
//     // //HO BC01 update metal date , re-calculate
//     // 
//     // ---------------------------------------------------
//     // Silverware Inc. - info@silverw.com
//     // ---------------------------------------------------
//     // ID           Date       Author
//     // ---------------------------------------------------
//     // SW10         03/15/22   Andrew Baxter
//     //                         Add actions "Send to Help Scout" and "Update Factbox Images"
//     // jp001 02/03/23 As per requirement added 3 Actions - Subcontractor Envelope Repair,Subcontractor Envelope Polish,Subcontractor Envelope Setting
//     // jp001 27/04/2023  Added New field CAD Price for Display in Jw Job Card Page
//     // Jp002 07/05/2023 Added New Action Send to Nifty - New CAD
//     // JP001 04/12/2023 added new field - Pre Posting Date for functionality New Field and code to populate the date PRE POST action is run for a Job. Create the field, add to page and add the code to the function PRE POST existing in Job Card.
//     // JP 03/01/24 added new action job estimation for requirement Create Report / codeunit to replicate “Print Customer Estimation” for Jobs

//     Caption = 'JW Job Card';
//     DeleteAllowed = false;
//     InsertAllowed = false;
//     PageType = Document;
//     RefreshOnActivate = true;
//     SourceTable = Table14022550;
//     SourceTableView = WHERE (Job Type=FILTER(Stock|Lot|Regular));

//     layout
//     {
//         area(content)
//         {
//             group(General)
//             {
//                 Caption = 'General';
//                 field("Customer Name";"Customer Name")
//                 {
//                 }
//                 field("Job No.";"Job No.")
//                 {
//                     Caption = 'Job No.';
//                     Editable = false;
//                     Visible = true;
//                 }
//                 field("Item No.";"Item No.")
//                 {
//                     Editable = false;
//                     TableRelation = Item;
//                     Visible = true;
//                 }
//                 field("Job Type";"Job Type")
//                 {
//                     Editable = false;
//                 }
//                 field(Description;Description)
//                 {
//                     Visible = true;
//                 }
//                 field(Markup;Markup)
//                 {
//                     Importance = Additional;
//                     Visible = false;

//                     trigger OnValidate()
//                     begin
//                         MarkupOnAfterValidate;
//                     end;
//                 }
//                 field("Unit Cost(LCY)";"Unit Cost(LCY)")
//                 {
//                     Editable = "Unit Cost(LCY)Editable";
//                     Importance = Additional;
//                     Visible = "Unit Cost(LCY)Visible";

//                     trigger OnValidate()
//                     begin
//                         IF SecCheckPermission() THEN //BCSEC1.1 121608
//                           Security.SecGetFieldModify(14022550,14022249,FIELDNO("Unit Cost"));
//                           UnitCostLCYOnAfterValidate;
//                     end;
//                 }
//                 field("Unit Price(LCY)";"Unit Price(LCY)")
//                 {
//                     Editable = false;
//                     Importance = Additional;

//                     trigger OnValidate()
//                     begin
//                         UnitPriceLCYOnAfterValidate;
//                     end;
//                 }
//                 field("Total Cost(LCY)";"Total Cost(LCY)")
//                 {
//                     Visible = "Total Cost(LCY)Visible";
//                 }
//                 field("Total Price(LCY)";"Total Price(LCY)")
//                 {
//                 }
//                 field("Override Unit Price";"Override Unit Price")
//                 {
//                     Editable = OverrideUnitPriceEdit;
//                 }
//                 field("Quoted Price";"Quoted Price")
//                 {
//                 }
//                 field("CAD Price";"CAD Price")
//                 {
//                 }
//                 field("Insurance Value";"Insurance Value")
//                 {
//                 }
//                 field(Pieces;Pieces)
//                 {
//                     Visible = true;

//                     trigger OnValidate()
//                     begin
//                         PiecesOnAfterValidate;
//                     end;
//                 }
//                 field("Pieces To Close";"Pieces To Close")
//                 {
//                     Visible = true;
//                 }
//                 field(Weight;Weight)
//                 {

//                     trigger OnValidate()
//                     begin
//                         WeightOnAfterValidate;
//                     end;
//                 }
//                 field("Weight To Close";"Weight To Close")
//                 {
//                     Importance = Additional;
//                 }
//                 field("Type Class Code";"Type Class Code")
//                 {
//                     Caption = 'Service Type';
//                     Importance = Additional;
//                 }
//                 field(locationtxt;"Location Code")
//                 {
//                     Caption = 'Location Code';
//                     Importance = Standard;
//                 }
//                 field("Start Date";"Start Date")
//                 {
//                 }
//                 field("<Closing Date>";"Closing Date")
//                 {
//                     Caption = 'Posting Date';
//                 }
//                 field("Pre Posting date";"Pre Posting date")
//                 {
//                 }
//                 field("Due Date";"Due Date")
//                 {
//                 }
//                 field("Promised Delivery Date";"Promised Delivery Date")
//                 {
//                     Editable = false;
//                 }
//                 field("Estimation Id";"Estimation Id")
//                 {
//                     Editable = false;
//                 }
//                 group()
//                 {
//                     Visible = RingSizeVis;
//                     field("Ring Size";"Ring Size")
//                     {
//                         Importance = Standard;
//                         ShowMandatory = RingSizeVis;
//                     }
//                 }
//                 field(Category;Category)
//                 {

//                     trigger OnValidate()
//                     begin
//                         CLEAR(Rec."Extra Jump Rings Lengths");
//                         CLEAR(Rec."Length Requested");
//                         CLEAR(Rec."Inner Diameter Dimensions");
//                         CLEAR(Rec."Bail/Jump Ring for Chain");
//                         CLEAR(Rec."MM diameter of chain bail");
//                         CLEAR(Rec."Clasp or Lock Type");
//                         CLEAR(Rec."Ring Size");
//                         CLEAR(Rec."Bangle Size");
//                         CurrPage.UPDATE(TRUE);
//                     end;
//                 }
//                 field("Category 2";"Category 2")
//                 {
//                 }
//                 field("Category 5";"Category 5")
//                 {
//                 }
//                 field("Head Size";"Head Size")
//                 {
//                     Importance = Additional;
//                 }
//                 field("Center Stone";"Center Stone")
//                 {
//                     Importance = Additional;
//                 }
//                 field("Tag Markup";"Tag Markup")
//                 {
//                     Importance = Additional;
//                 }
//                 field("Tag Price";"Tag Price")
//                 {
//                     Importance = Additional;
//                 }
//                 field("Metal Type Code";"Metal Type Code")
//                 {
//                     Importance = Standard;
//                 }
//                 field("Metal Code";"Metal Code")
//                 {
//                     Importance = Standard;
//                 }
//                 field("Metal Color";"Metal Color")
//                 {
//                     Importance = Standard;
//                 }
//                 field("SP Ship Inst.";"SP Ship Inst.")
//                 {
//                 }
//                 field(Firm;Firm)
//                 {
//                 }
//                 field(Rush;Rush)
//                 {
//                 }
//                 field(Duplication;Duplication)
//                 {
//                 }
//                 field("Stock Style";"Stock Style")
//                 {
//                 }
//                 field("Include Pricing Breakdowns";"Include Pricing Breakdowns")
//                 {
//                     Editable = false;
//                 }
//                 field("Customer Logo";"Customer Logo")
//                 {
//                     Editable = false;
//                 }
//                 field("Customer PO No.";"Customer PO No.")
//                 {
//                 }
//                 field("Conversation ID";"Conversation ID")
//                 {

//                     trigger OnValidate()
//                     begin
//                         UpdateConversationIDOnJobs(Rec);
//                     end;
//                 }
//                 field("Total Metal Weight";"Total Metal Weight")
//                 {
//                     BlankZero = true;
//                     Importance = Additional;
//                 }
//                 field("Total Carat Weight";"Total Carat Weight")
//                 {
//                     BlankZero = true;
//                     Importance = Additional;
//                 }
//                 field("Quantity Produced (Base)";"Quantity Produced (Base)")
//                 {
//                     Caption = 'Quantity Produced';
//                 }
//                 field("Remaining Quantity";"Remaining Quantity (Base)")
//                 {
//                     Caption = 'Remaining Quantity';
//                 }
//                 field(Status;Status)
//                 {
//                 }
//                 field("Bin Code";"Bin Code")
//                 {
//                     Importance = Additional;
//                     Visible = false;
//                 }
//                 field("Unit Cost from BOM W/Linked";"Unit Cost from BOM W/Linked")
//                 {
//                     Caption = 'Unit Cost';
//                     Editable = false;
//                     Importance = Additional;
//                     Style = Unfavorable;
//                     StyleExpr = TRUE;
//                     Visible = UnitCostfromBOMWLinkedVisible;
//                 }
//                 field("Unit Price from BOM W/Linked";"Unit Price from BOM W/Linked")
//                 {
//                     Caption = 'Unit Price';
//                     Editable = false;
//                     Importance = Additional;
//                     Style = Unfavorable;
//                     StyleExpr = TRUE;
//                     Visible = true;
//                 }
//                 field("Thinkspace Link";"Vntana Link")
//                 {
//                 }
//                 field("Customer Stage Name";"Customer Stage Name")
//                 {
//                 }
//                 field("Customer Stage Id";"Customer Stage Id")
//                 {
//                 }
//                 field("CAD Version Approved";"CAD Version Approved")
//                 {
//                     ToolTip = 'This field is used to Indicate which CAD version was approved i.e. V2';
//                 }
//                 field("Customer Supply Center";"Customer Supply Center")
//                 {
//                     Caption = 'Customer Supply Center(s)';
//                     ShowMandatory = true;
//                 }
//                 field("Mfg Supply Component";"Mfg Supply Component")
//                 {
//                     Caption = 'Mfg supply special components or findings';
//                     ToolTip = 'Insert links or item description to the part like "finger fit" shanks, posts, or chains (include length if chain) for anything MFG is supp';
//                 }
//                 field("Customer Supply Component";"Customer Supply Component")
//                 {
//                     Caption = 'Customer supply special components or findings';
//                     ToolTip = 'Insert links or item description to the part like "finger fit" shanks, posts, or chains (include length if chain) for anything customer is supp';
//                 }
//                 field("Are we setting Center Stone?";"Are we setting Center Stone?")
//                 {
//                     Caption = 'Are we setting Center Stone?';
//                     ShowMandatory = true;
//                 }
//                 group()
//                 {
//                     Visible = BangleSizeVis;
//                     field("Bangle Size";"Bangle Size")
//                     {
//                         ShowMandatory = BangleSizeVis;
//                         Style = Unfavorable;
//                         StyleExpr = BangleSizeVis;
//                         ToolTip = 'Enter size of Bangle (Small, Med, Large)';
//                     }
//                 }
//                 group()
//                 {
//                     Visible = ExtraJumpRingLenVis;
//                     field("Extra Jump Rings Lengths";"Extra Jump Rings Lengths")
//                     {
//                         Caption = 'Extra Jump Rings Lengths If Requested';
//                         ShowMandatory = JumpRingLenMand;
//                         Style = Unfavorable;
//                         StyleExpr = ExtraJumpRingLenVis;
//                         ToolTip = 'We can put numbers and notes on where the extra JR goes';
//                     }
//                 }
//                 group()
//                 {
//                     Visible = LengthReqVis;
//                     field("Length Requested";"Length Requested")
//                     {
//                         Caption = 'Length Requested';
//                         ShowMandatory = LengthReqMand;
//                         Style = Unfavorable;
//                         StyleExpr = LengthReqMand;
//                         ToolTip = ' Enter any Length requirements';
//                     }
//                 }
//                 field("Width Requested";"Width Requested")
//                 {
//                     Caption = 'Width Requested';
//                     ShowMandatory = WidthReqMand;
//                     Style = Unfavorable;
//                     StyleExpr = WidthReqMand;
//                     ToolTip = ' Enter any Width requirements';
//                 }
//                 group()
//                 {
//                     Visible = InnerDiameterDimVis;
//                     field("Inner Diameter Dimensions";"Inner Diameter Dimensions")
//                     {
//                         Caption = 'Inner Diameter Dimensions';
//                         ShowMandatory = InnerDiameterDimMand;
//                         Style = Unfavorable;
//                         StyleExpr = InnerDiameterDimMand;
//                         ToolTip = ' Enter inner diameter dimensions for bangle';
//                     }
//                 }
//                 group()
//                 {
//                     Visible = BailJumpRingChainVis;
//                     field("Bail/Jump Ring for Chain";"Bail/Jump Ring for Chain")
//                     {
//                         Caption = 'Bail/Jump Ring for Chain';
//                         ShowMandatory = BailJumpRingChainMand;
//                         Style = Unfavorable;
//                         StyleExpr = BailJumpRingChainMand;
//                     }
//                 }
//                 group()
//                 {
//                     Visible = MMDiameterVis;
//                     field("MM diameter of chain bail";"MM diameter of chain bail")
//                     {
//                         Caption = 'MM diameter of chain bail or opening will slide through';
//                         ShowMandatory = MMDiameterMand;
//                         Style = Unfavorable;
//                         StyleExpr = MMDiameterMand;
//                         ToolTip = 'Enter MM diamater of bail opening where chain will slide through';
//                     }
//                 }
//                 group()
//                 {
//                     Visible = ClaspLockTypeVis;
//                     field("Clasp or Lock Type";"Clasp or Lock Type")
//                     {
//                         Caption = 'Clasp or Lock Type';
//                         ShowMandatory = ClaspLockTypeMand;
//                         Style = Unfavorable;
//                         StyleExpr = ClaspLockTypeMand;
//                         ToolTip = 'Insert photo or supplier website links or item description for type of clasp/lock to be used';
//                     }
//                 }
//                 field("Engraving Instructions";"Engraving Instructions")
//                 {
//                     Caption = 'Engraving Instructions';
//                     ToolTip = 'Enter written text or attach link to vectorized file';
//                 }
//                 field("Reference Job Number";"Reference Job Number")
//                 {
//                     Caption = 'Reference Job Number';
//                     ToolTip = 'Ho Brothers internal Job Number used to reference old job number or number for a matching set to job number';
//                 }
//                 field("Exclusive Style Reference No.";"Exclusive Style Reference No.")
//                 {
//                     Caption = 'Exclusive Style Reference Number';
//                     ToolTip = 'If job is a customization of an Exclusive Style, please enter that Exclusive style Item Code here i.e. GAGE-ER-ALEXA. Do not enter on this field if it isn''t a customization of ES, only enter if service type i customization i.e. FS & REV2FIN of Exclusive Style.';
//                 }
//                 field("Stone Instructions";"Stone Instructions")
//                 {
//                     OptionCaption = ' ,No stones,Mfg Supply All Stones,Customer supply all stones & do not supply additional,Customer supply all stones & customer supply additional,Customer supply partial & Mfg supply additional';
//                     ShowMandatory = true;
//                     ToolTip = 'This field is used to define stone instruction from dropdown list';

//                     trigger OnValidate()
//                     begin
//                         CurrPage.UPDATE(TRUE);
//                         ModifyStoneSpecs();
//                     end;
//                 }
//                 group("Stone Instructions")
//                 {
//                     Caption = 'Stone Instructions';
//                     ShowCaption = false;
//                     Visible = StoneOptionVisibilty or ViewForBoth;
//                     field("Lab Or Natural";"Lab Or Natural")
//                     {
//                         Caption = 'Lab Or Natural (Diamonds)';
//                         ShowMandatory = true;
//                         ToolTip = 'Specify whether the stones being supplied are lab or natural';
//                     }
//                     field("Genuine Lab Imitation";"Genuine Lab Imitation")
//                     {
//                         Caption = 'Genuine or Lab or Imitation (color stones)';
//                         ShowMandatory = true;
//                     }
//                     field("Quality Diamond";"Quality Diamond")
//                     {
//                         Caption = 'Specify Diamond Quality';
//                         ShowMandatory = true;
//                         ToolTip = 'Enter color & clarity requirements. For example: GH/SI or FG/VS. If no diamonds put N/A';
//                     }
//                     field("Quality Color Diamond";"Quality Color Diamond")
//                     {
//                         Caption = 'Specify Color Stone Quality';
//                         OptionCaption = 'if yes, what quality color stone';
//                         ShowMandatory = true;
//                         ToolTip = 'Enter color stone quality. For example: AA. If no color stones put N/A';
//                     }
//                 }
//                 group("Stone Instructions1")
//                 {
//                     Caption = 'Stone Instructions1';
//                     ShowCaption = false;
//                     Visible = StoneOptionVisibilty or ViewForBoth;
//                     field(StoneSpecs;StoneSpecs)
//                     {
//                         ApplicationArea = Basic,Suite;
//                         Caption = 'Stone (specs & Quantity) mfg to supply';
//                         MultiLine = true;
//                         ShowMandatory = true;
//                         ToolTip = 'Put in stone quantity dimensions, and/or ctw (if applicable) of what MFG to supply.';
//                         Visible = StoneOptionVisibilty;

//                         trigger OnValidate()
//                         begin
//                             SetWorkStoneSpec(StoneSpecs);
//                         end;
//                     }
//                 }
//                 group("Stone Instructions2")
//                 {
//                     Caption = 'Stone Instructions2';
//                     ShowCaption = false;
//                     Visible = ViewForBoth or StoneBolb or StoneColoVisi;
//                     field("<Stone Specification>";StoneSpec1)
//                     {
//                         Caption = 'What stone (Specs & Quantity) are being supplied by customer?';
//                         MultiLine = true;
//                         ShowMandatory = true;
//                         ToolTip = 'Put measurements, quantity or the scan STL file name or URL link to file. This include center stone scan or measurement. For example: (10) 1.5mm RBC dia, (12) 1.2mm round Rubies';

//                         trigger OnValidate()
//                         begin
//                             SetWorkStoneSpecNew(StoneSpec1);
//                         end;
//                     }
//                 }
//                 group("Additional Stone Specs")
//                 {
//                     Caption = 'Additional Stone Specs';
//                     ShowCaption = false;
//                     Visible = StoneColoVisi;
//                     field("<Additional Stone Specification>";AdditionalStoneSpec)
//                     {
//                         Caption = 'Addtional stone (Specs & Quality) customer to Supply';
//                         MultiLine = true;
//                         ShowMandatory = true;
//                         ToolTip = 'Put in stone quantity dimensions, and/or ctw (if applicable) of the ADDITIONAL stone customer supply.';

//                         trigger OnValidate()
//                         begin
//                             SetAddStoneSpecNew(AdditionalStoneSpec)
//                         end;
//                     }
//                 }
//                 group("Special Instructions")
//                 {
//                     Caption = 'Special Instructions';
//                     field(WorkDescription;WorkDescription)
//                     {
//                         ApplicationArea = Basic,Suite;
//                         Importance = Standard;
//                         MultiLine = true;
//                         ShowCaption = false;
//                         ToolTip = 'Specifies the products or service being offered.';

//                         trigger OnValidate()
//                         begin
//                             SetWorkDescription(WorkDescription);
//                             //CurrPage.UPDATE(FALSE);
//                         end;
//                     }
//                 }
//             }
//             group(Instructions)
//             {
//                 Caption = 'Instructions';
//                 grid()
//                 {
//                     group()
//                     {
//                         field(CADkDescription;CADkDescription)
//                         {
//                             ApplicationArea = Basic,Suite;
//                             Caption = 'CAD';
//                             MultiLine = true;
//                             ShowCaption = true;

//                             trigger OnValidate()
//                             begin
//                                 SetCADDesc(CADkDescription);
//                                 //CurrPage.UPDATE(FALSE);
//                             end;
//                         }
//                         field(JewelerDescription;JewelerDescription)
//                         {
//                             ApplicationArea = Basic,Suite;
//                             Caption = 'Jeweler';
//                             MultiLine = true;
//                             ShowCaption = true;

//                             trigger OnValidate()
//                             begin
//                                 SetJewelerDesc(JewelerDescription);
//                                 //CurrPage.UPDATE(FALSE);
//                             end;
//                         }
//                         field(SetterDescription;SetterDescription)
//                         {
//                             ApplicationArea = Basic,Suite;
//                             Caption = 'Setter';
//                             MultiLine = true;
//                             ShowCaption = true;

//                             trigger OnValidate()
//                             begin
//                                 SetSetterDesc(SetterDescription);
//                                 //CurrPage.UPDATE(FALSE);
//                             end;
//                         }
//                         field(PolisherDescription;PolisherDescription)
//                         {
//                             ApplicationArea = Basic,Suite;
//                             Caption = 'Polisher';
//                             MultiLine = true;
//                             ShowCaption = true;

//                             trigger OnValidate()
//                             begin
//                                 SetPolisherDesc(PolisherDescription);
//                                 //CurrPage.UPDATE(FALSE);
//                             end;
//                         }
//                     }
//                 }
//                 field(Blocked;Blocked)
//                 {
//                     Importance = Additional;
//                 }
//             }
//             part(JobLines;14022551)
//             {
//                 Caption = 'Lines';
//                 SubPageLink = Job No.=FIELD(Job No.),
//                               Job Type=FIELD(Job Type);
//             }
//             group("Posting Options")
//             {
//                 Caption = 'Posting Options';
//                 field("Consume Comp.On Close Job";"Consume Comp.On Close Job")
//                 {
//                 }
//                 field("Consume Allocated On Close";"Consume Allocated On Close")
//                 {
//                 }
//                 field("Use Job Consumption";"Use Job Consumption")
//                 {
//                     Editable = true;
//                 }
//                 field("Use Job Allocation";"Use Job Allocation")
//                 {
//                     Editable = true;
//                 }
//                 field("Use Resource Consumption";"Use Resource Consumption")
//                 {
//                     Editable = true;
//                 }
//                 field("PO Consumption On Close Job";"PO Consumption On Close Job")
//                 {
//                 }
//             }
//             group("Current Status")
//             {
//                 Caption = 'Current Status';
//                 field("Sales Document No.";"Sales Document No.")
//                 {
//                     Editable = false;
//                     Importance = Promoted;
//                 }
//                 field("Sales Line No.";"Sales Line No.")
//                 {
//                     Editable = false;
//                     Importance = Promoted;
//                 }
//                 field("Purchase Document No.";"Purchase Document No.")
//                 {
//                 }
//                 field("Purchase Line No.";"Purchase Line No.")
//                 {
//                 }
//                 field("Customer No.";"Customer No.")
//                 {
//                 }
//                 field("Contact No.";"Contact No.")
//                 {
//                 }
//                 field("Description 2";"Description 2")
//                 {
//                     Importance = Additional;
//                 }
//                 field("Description 3";"Description 3")
//                 {
//                     Importance = Additional;
//                 }
//                 field("Item Type";"Item Type")
//                 {
//                     Editable = false;
//                     Importance = Additional;
//                 }
//             }
//             group("Metal Information")
//             {
//                 Caption = 'Metal Information';
//                 grid()
//                 {
//                     GridLayout = Rows;
//                     group()
//                     {
//                         field("Metal Type Code 1";"Metal Type Code 1")
//                         {
//                             Caption = 'Metal Type 1';
//                             Importance = Promoted;

//                             trigger OnValidate()
//                             begin
//                                 MetalType1OnAfterValidate;
//                             end;
//                         }
//                         field("Metal Price 1";"Metal Price 1")
//                         {
//                             Caption = 'Metal Price';
//                             Importance = Promoted;

//                             trigger OnValidate()
//                             begin
//                                 MetalPrice1OnAfterValidate;
//                             end;
//                         }
//                         field("Premium 1";"Premium 1")
//                         {
//                             Caption = 'Premium';

//                             trigger OnValidate()
//                             begin
//                                 Premium1OnAfterValidate;
//                             end;
//                         }
//                         field("Daily Price 1";"Daily Price 1")
//                         {
//                             Caption = 'Daily Price';
//                         }
//                     }
//                 }
//                 grid()
//                 {
//                     GridLayout = Rows;
//                     group()
//                     {
//                         field("Metal Type Code 2";"Metal Type Code 2")
//                         {
//                             Caption = 'Metal Type 2';
//                             Importance = Promoted;

//                             trigger OnValidate()
//                             begin
//                                 MetalType1OnAfterValidate;
//                             end;
//                         }
//                         field("Metal Price 2";"Metal Price 2")
//                         {
//                             Caption = 'Metal Price';
//                             Importance = Promoted;

//                             trigger OnValidate()
//                             begin
//                                 MetalPrice2OnAfterValidate;
//                             end;
//                         }
//                         field("Premium 2";"Premium 2")
//                         {
//                             Caption = 'Premium';

//                             trigger OnValidate()
//                             begin
//                                 Premium2OnAfterValidate;
//                             end;
//                         }
//                         field("Daily Price 2";"Daily Price 2")
//                         {
//                             Caption = 'Daily Price';
//                         }
//                         field("Metal Date";"Metal Date")
//                         {
//                         }
//                     }
//                 }
//                 grid()
//                 {
//                     GridLayout = Rows;
//                     group()
//                     {
//                         field("Metal Type Code 3";"Metal Type Code 3")
//                         {
//                             Caption = 'Metal Type 3';
//                             Importance = Promoted;

//                             trigger OnValidate()
//                             begin
//                                 MetalType1OnAfterValidate;
//                             end;
//                         }
//                         field("Metal Price 3";"Metal Price 3")
//                         {
//                             Caption = 'Metal Price';

//                             trigger OnValidate()
//                             begin
//                                 MetalPrice3OnAfterValidate;
//                             end;
//                         }
//                         field("Premium 3";"Premium 3")
//                         {
//                             Caption = 'Premium';

//                             trigger OnValidate()
//                             begin
//                                 Premium3OnAfterValidate;
//                             end;
//                         }
//                         field("Daily Price 3";"Daily Price 3")
//                         {
//                             Caption = 'Daily Price';
//                         }
//                     }
//                 }
//             }
//             group("Foreign Trade")
//             {
//                 Caption = 'Foreign Trade';
//                 field("Currency Code";"Currency Code")
//                 {
//                 }
//                 field("Currency Factor";"Currency Factor")
//                 {
//                 }
//                 field("Unit Cost";"Unit Cost")
//                 {
//                     Visible = "Unit CostVisible";
//                 }
//                 field("Unit Price";"Unit Price")
//                 {
//                 }
//                 field("Total Cost";"Total Cost")
//                 {
//                     Visible = "Total CostVisible";
//                 }
//                 field("Total Price";"Total Price")
//                 {
//                 }
//             }
//             group("Control Information")
//             {
//                 Caption = 'Control Information';
//                 label()
//                 {
//                     CaptionClass = Text19078446;
//                     Style = Strong;
//                     StyleExpr = TRUE;
//                 }
//                 field("Last Time Modified";"Last Time Modified")
//                 {
//                 }
//                 field("Last Date Modified";"Last Date Modified")
//                 {
//                 }
//                 field("Last Modified By";"Last Modified By")
//                 {
//                 }
//                 field("Last Resource No";"Last Resource No")
//                 {
//                     Editable = true;
//                 }
//                 field("Time Created";"Time Created")
//                 {
//                 }
//                 field("Date Created";"Date Created")
//                 {
//                 }
//                 field("Salespers./Purch. Code";"Salespers./Purch. Code")
//                 {
//                     Editable = false;
//                 }
//                 field("Created By";"Created By")
//                 {
//                 }
//             }
//         }
//         area(factboxes)
//         {
//             part(;14022151)
//             {
//                 SubPageLink = Item No.=FIELD(Item No.),
//                               Job No.=FIELD(Job No.);
//             }
//             part(;50003)
//             {
//                 SubPageLink = Document No.=FIELD(Job No.);
//             }
//             part(;14022150)
//             {
//                 SubPageLink = Job No.=FIELD(Job No.);
//             }
//             part(;14022111)
//             {
//                 SubPageLink = No.=FIELD(Item No.);
//             }
//             systempart(;Links)
//             {
//                 Visible = false;
//             }
//             systempart(;Notes)
//             {
//                 Visible = true;
//             }
//             part("Component Supply and Demand";14022111)
//             {
//                 Caption = 'Component Supply and Demand';
//                 Provider = JobLines;
//                 SubPageLink = No.=FIELD(No.);
//             }
//         }
//     }

//     actions
//     {
//         area(navigation)
//         {
//             group(ItemButton)
//             {
//                 Caption = '&Item';
//                 action("Item Card")
//                 {
//                     Caption = 'Item Card';
//                     Image = Item;

//                     trigger OnAction()
//                     var
//                         ItemFormSelection: Codeunit "14022599";
//                     begin
//                         // J5-0003 Date 0060607
//                         Item.GET("Item No.") ;
//                         ItemFormSelection.SelectForm(Item) ;
//                     end;
//                 }
//             }
//             group(BothJobButton)
//             {
//                 Caption = '&Job';
//                 group(Entries)
//                 {
//                     Caption = 'Entries';
//                     Image = Entries;
//                     action("Item Ledger Entries")
//                     {
//                         Caption = 'Item Ledger Entries';
//                         Image = ItemLedger;
//                         RunObject = Page 38;
//                                         RunPageLink = Item No.=FIELD(Item No.),
//                                       JW Job No.=FIELD(Job No.);
//                         RunPageView = SORTING(Item No.,JW Job No.,Variant Code,Job Line Ref. No.,Job Consumption,Job Output,Location Code,Posting Date);
//                     }
//                     action("PW Ledger Entries")
//                     {
//                         Caption = 'PW Ledger Entries';
//                         Image = ItemLedger;
//                         RunObject = Page 14052298;
//                                         RunPageLink = Item No.=FIELD(Item No.),
//                                       Job No.=FIELD(Job No.);
//                         RunPageView = SORTING(Item No.,Job No.);
//                     }
//                     action("Job Ledger Entries")
//                     {
//                         Caption = 'Job Ledger Entries';
//                         Image = ItemLedger;
//                         RunObject = Page 14052269;
//                                         RunPageLink = Job No.=FIELD(Job No.);
//                         RunPageView = SORTING(Job No.,Posting Date);
//                     }
//                 }
//                 action("Additional Images")
//                 {
//                     Caption = 'Additional Images';
//                     Image = Picture;
//                     RunObject = Page 50005;
//                                     RunPageLink = Document No.=FIELD(Job No.);
//                     RunPageView = SORTING(Document No.,Line No.);
//                 }
//                 action(Dimensions)
//                 {
//                     Caption = 'Dimensions';
//                     Image = Dimensions;

//                     trigger OnAction()
//                     begin
//                         ShowDocDim();
//                     end;
//                 }
//                 action("Co&mments")
//                 {
//                     Caption = 'Co&mments';
//                     Image = ViewComments;
//                     //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                     //PromotedCategory = New;
//                     RunObject = Page 124;
//                                     RunPageLink = Table Name=CONST(Jobs),
//                                   No.=FIELD(Job No.);
//                     ShortCutKey = 'Ctrl+N';
//                 }
//                 action(Picture)
//                 {
//                     Caption = 'Picture';
//                     Image = Picture;
//                     Promoted = false;
//                     //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                     //PromotedCategory = Process;
//                     RunObject = Page 14022152;
//                                     RunPageLink = Item No.=FIELD(Item No.),
//                                   Job No.=FIELD(Job No.);

//                     trigger OnAction()
//                     begin
//                         CurrPage.SAVERECORD;
//                     end;
//                 }
//                 action("Tracking Entries")
//                 {
//                     Caption = 'Tracking Entries';
//                     Image = Track;

//                     trigger OnAction()
//                     begin
//                         JWJobTracking.SETRANGE("Job No.","Job No.");
//                         IF "Routing Code" = '' THEN
//                           PAGE.RUNMODAL(PAGE::"JW Job Tracking List",JWJobTracking);
//                         IF "Routing Code" <> '' THEN
//                           PAGE.RUNMODAL(14052908,JWJobTracking);
//                     end;
//                 }
//                 action("Routing Lines")
//                 {
//                     Caption = 'Routing Lines';
//                     Image = Route;
//                     RunObject = Page 14052904;
//                                     RunPageLink = JW Job No.=FIELD(Job No.),
//                                   Routing No.=FIELD(Routing Code);
//                 }
//                 action("BOM Calculation Card")
//                 {
//                     Image = Calculate;
//                     RunObject = Page 14052196;
//                                     RunPageLink = No.=FIELD(Item No.);
//                     RunPageView = SORTING(No.);
//                 }
//                 action("Send to Help Scout")
//                 {
//                     Image = Email;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     PromotedIsBig = true;
//                 }
//                 action(SendNewCAD)
//                 {
//                     Caption = 'Send to Nifty - New CAD';
//                     Image = SendTo;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     PromotedIsBig = true;

//                     trigger OnAction()
//                     var
//                         HelpScoutMgt: Codeunit "50007";
//                         JWJobEmailHeaderText: Record "50008";
//                         JWJobEmailBodyText: Record "50007";
//                     begin
//                         //IF JWJobEmailHeaderText.GET(Rec."Job No.") THEN BEGIN
//                           HelpScoutMgt.SendToHelpScoutNewCAD(Rec);
//                         //END;
//                     end;
//                 }
//             }
//             group("Take Job Pictures")
//             {
//                 Caption = 'Take Job Pictures';
//                 Image = Camera;
//                 action("Take Picture 1")
//                 {
//                     Caption = 'Take Picture 1';
//                     Image = Camera;

//                     trigger OnAction()
//                     begin
//                         TakePictureFromCamera(1);
//                     end;
//                 }
//                 action("Take Picture 2")
//                 {
//                     Caption = 'Take Picture 2';
//                     Image = Camera;

//                     trigger OnAction()
//                     begin
//                         TakePictureFromCamera(2);
//                     end;
//                 }
//                 action("Take Picture 3")
//                 {
//                     Caption = 'Take Picture 3';
//                     Image = Camera;

//                     trigger OnAction()
//                     begin
//                         TakePictureFromCamera(3);
//                     end;
//                 }
//                 action("Take Picture 4")
//                 {
//                     Caption = 'Take Picture 4';
//                     Image = Camera;

//                     trigger OnAction()
//                     begin
//                         TakePictureFromCamera(4);
//                     end;
//                 }
//             }
//             group(Import)
//             {
//                 Caption = 'Import Job Pictures';
//                 Image = Confirm;
//                 action("Import Picture 1")
//                 {
//                     Caption = 'Import Picture 1';
//                     Image = Import;
//                     //The property 'PromotedOnly' can only be set if the property 'Promoted' is set to 'true'
//                     //PromotedOnly = true;

//                     trigger OnAction()
//                     begin
//                         ImportFromDevice(1);    //SW10
//                     end;
//                 }
//                 action("Import Picture 2")
//                 {
//                     Caption = 'Import Picture 2';
//                     Image = Import;
//                     //The property 'PromotedOnly' can only be set if the property 'Promoted' is set to 'true'
//                     //PromotedOnly = true;

//                     trigger OnAction()
//                     begin
//                         ImportFromDevice(2);    //SW10
//                     end;
//                 }
//                 action("Import Picture 3")
//                 {
//                     Caption = 'Import Picture 3';
//                     Image = Import;
//                     //The property 'PromotedOnly' can only be set if the property 'Promoted' is set to 'true'
//                     //PromotedOnly = true;

//                     trigger OnAction()
//                     begin
//                         ImportFromDevice(3);    //SW10
//                     end;
//                 }
//                 action("Import Picture 4")
//                 {
//                     Caption = 'Import Picture 4';
//                     Image = Import;

//                     trigger OnAction()
//                     begin
//                         ImportFromDevice(4);    //SW10
//                     end;
//                 }
//             }
//             group(Delete)
//             {
//                 Caption = 'Delete Job Pictures';
//                 Image = ExecuteBatch;
//                 action("Delete Picture 1")
//                 {
//                     Caption = 'Delete Picture 1';
//                     Image = Delete;

//                     trigger OnAction()
//                     begin
//                         DeleteItemPicture(1);    //SW10
//                     end;
//                 }
//                 action("Delete Picture 2")
//                 {
//                     Caption = 'Delete Picture 2';
//                     Image = Delete;

//                     trigger OnAction()
//                     begin
//                         DeleteItemPicture(2);    //SW10
//                     end;
//                 }
//                 action("Delete Picture 3")
//                 {
//                     Caption = 'Delete Picture 3';
//                     Image = Delete;

//                     trigger OnAction()
//                     begin
//                         DeleteItemPicture(3);    //SW10
//                     end;
//                 }
//                 action("Delete Picture 4")
//                 {
//                     Caption = 'Delete Picture 4';
//                     Image = Delete;

//                     trigger OnAction()
//                     begin
//                         DeleteItemPicture(4);    //SW10
//                     end;
//                 }
//             }
//             group(Document)
//             {
//                 Caption = 'Document';
//                 action("Sales Order")
//                 {
//                     Caption = 'Sales Order';
//                     Image = Document;

//                     trigger OnAction()
//                     begin
//                         ShowSalesOrder()
//                     end;
//                 }
//                 action("Purchase Order")
//                 {
//                     Caption = 'Purchase Order';
//                     Image = Document;

//                     trigger OnAction()
//                     begin
//                         ShowPurchaseOrder()
//                     end;
//                 }
//             }
//         }
//         area(processing)
//         {
//             group()
//             {
//                 Caption = 'P&osting';
//                 action("P&ost")
//                 {
//                     Caption = 'P&ost';
//                     Image = PostOrder;
//                     Promoted = true;
//                     PromotedCategory = Process;

//                     trigger OnAction()
//                     begin
//                         Post(CODEUNIT::"JW Post Job");
//                     end;
//                 }
//                 action("Pre-Post")
//                 {
//                     Caption = 'Pre-Post';
//                     Image = PostOrder;
//                     Promoted = true;
//                     PromotedCategory = Process;

//                     trigger OnAction()
//                     var
//                         JWPostJob: Codeunit "14022549";
//                     begin
//                         CurrPage.SAVERECORD();
//                         JWPostJob.Prepost(Rec);
//                         CurrPage.UPDATE(FALSE);
//                     end;
//                 }
//                 action("Post and &Print")
//                 {
//                     Caption = 'Post and &Print';
//                     Image = PostPrint;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     Visible = false;

//                     trigger OnAction()
//                     begin
//                         Post(CODEUNIT::"JW Post and Print Job");
//                     end;
//                 }
//                 action("Assign To Shop")
//                 {
//                     Caption = 'Assign To Shop';
//                     Image = AssemblyOrder;

//                     trigger OnAction()
//                     var
//                         JWRoutingMgt: Codeunit "14052900";
//                     begin
//                         JWJobTracking.SETRANGE("Job No.","Job No.");
//                         TESTFIELD("Routing Code");
//                         JWRoutingMgt.AssignShopFloor(Rec,TRUE);
//                         //IF "Routing Code" <> '' THEN
//                         //  PAGE.RUNMODAL(14052908,JWJobTracking);
//                     end;
//                 }
//             }
//             group("Auto Fill To")
//             {
//                 Caption = 'Auto Fill To';
//                 Image = AutofillQtyToHandle;
//                 action(Allocate)
//                 {
//                     Caption = 'Allocate';
//                     Image = AutofillQtyToHandle;

//                     trigger OnAction()
//                     begin
//                         AutoFillAllocation();
//                         CurrPage.UPDATE(FALSE);
//                     end;
//                 }
//                 action(Consume)
//                 {
//                     Caption = 'Consume';
//                     Image = AutofillQtyToHandle;

//                     trigger OnAction()
//                     begin
//                         AutoFillConsumption() ;
//                         CurrPage.UPDATE(FALSE);
//                     end;
//                 }
//                 action("Consume Allocated")
//                 {
//                     Caption = 'Consume Allocated';
//                     Image = AutofillQtyToHandle;

//                     trigger OnAction()
//                     begin
//                         AutoFillConsFromAlloc() ;
//                         CurrPage.UPDATE(FALSE);
//                     end;
//                 }
//                 action("Consume  By Close Pcs.")
//                 {
//                     Caption = 'Consume  By Close Pcs.';
//                     Image = AutofillQtyToHandle;

//                     trigger OnAction()
//                     var
//                         J5Trans: Codeunit "14022522";
//                         RecordRefTo: RecordRef;
//                     begin
//                         //J5-0008 011409  FillConsFromAllocCloseQty
//                         AutoFillConsFromAllocCloseQty() ;
//                         CurrPage.UPDATE(FALSE);
//                         /*
//                         Item.GET("Item No.") ;
//                         RecordRefTo.GETTABLE(Rec) ;
//                         J5Trans.CopyTest(Item,RecordRefTo)
//                         */

//                     end;
//                 }
//             }
//             group(FunctionButton)
//             {
//                 Caption = '&Function';
//                 action("Copy Document")
//                 {
//                     Caption = 'Copy Document';
//                     Image = CopyDocument;
//                     Visible = true;

//                     trigger OnAction()
//                     begin
//                         JobMaint.ReCalcJobCost(Rec)
//                     end;
//                 }
//                 action("Create Sub Jobs")
//                 {
//                     Caption = 'Create Sub Jobs';
//                     Image = CreateDocument;
//                     //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
//                     //PromotedCategory = Process;
//                     Visible =  "Main JobVisible";

//                     trigger OnAction()
//                     begin
//                         CLEAR(JobMaint) ;
//                         JobMaint.CreateSubJobFromJC(Rec)
//                     end;
//                 }
//                 action("Sub Job List")
//                 {
//                     Caption = 'Sub Job List';
//                     Image = List;
//                     RunObject = Page 14022553;
//                                     RunPageLink = Main Job No.=FIELD(Job No.);
//                     RunPageView = SORTING(Job No.);
//                     Visible =  "Main JobVisible";
//                 }
//                 action("Track Job")
//                 {
//                     Caption = 'Track Job';
//                     Image = Track;

//                     trigger OnAction()
//                     begin
//                         JWJobTracking.SETRANGE("Job No.","Job No.");
//                         IF JWJobTracking.FINDFIRST THEN;
//                         IF "Routing Code" = '' THEN
//                           PAGE.RUNMODAL(PAGE::"JW Job Tracking Sheet",JWJobTracking);
//                         IF "Routing Code" <> '' THEN
//                           PAGE.RUNMODAL(14052908,JWJobTracking);
//                     end;
//                 }
//                 separator("------------------------")
//                 {
//                     Caption = '------------------------';
//                 }
//                 group("Calculate Job")
//                 {
//                     Caption = 'Calculate Job';
//                     Image = CalculateWIP;
//                     action("Unit Cost and Unit Price")
//                     {
//                         Caption = 'Unit Cost and Unit Price';
//                         Visible =  "Main JobVisible";

//                         trigger OnAction()
//                         begin
//                             JobMaint.ReCalcJobCost(Rec);
//                             JobMaint.ReCalcJobPrice(Rec);
//                             CurrPage.UPDATE(TRUE);
//                             //J5-0018 120908
//                             UpdateUnitCostSalesLine();
//                             UpdateUnitCostPurchLine();
//                             UpdateUnitPriceSalesLine();
//                             UpdateUnitPricePurchLine();
//                         end;
//                     }
//                     action("Unit Cost")
//                     {
//                         Caption = 'Unit Cost';
//                         ShortCutKey = 'Ctrl+S';

//                         trigger OnAction()
//                         begin
//                             JobMaint.ReCalcJobCost(Rec);
//                             CurrPage.UPDATE(TRUE);
//                             //J5-0018 120908
//                             UpdateUnitCostSalesLine();
//                             UpdateUnitCostPurchLine();

//                             CheckUnitCostPO();//J5-0008 110608 Purchase unit cost  update
//                         end;
//                     }
//                     action("Unit Price")
//                     {
//                         Caption = 'Unit Price';

//                         trigger OnAction()
//                         begin
//                             JobMaint.ReCalcJobPrice(Rec);
//                             CurrPage.UPDATE(TRUE);
//                             //J5-0018 120908
//                             UpdateUnitPriceSalesLine();
//                             UpdateUnitPricePurchLine();
//                         end;
//                     }
//                     action("Update Metal data")
//                     {
//                         Caption = 'Update Metal data';
//                         Visible = true;

//                         trigger OnAction()
//                         begin
//                             UpdatemetalData();//HO BC01 update metal date , re-calculate
//                         end;
//                     }
//                 }
//                 group("Update Sales Line")
//                 {
//                     Caption = 'Update Sales Line';
//                     Image = Change;
//                     Visible =  "Main JobVisible";
//                     action(" Unit Cost")
//                     {
//                         Caption = ' Unit Cost';
//                         Visible =  "Main JobVisible";

//                         trigger OnAction()
//                         begin
//                             TESTFIELD("Sales Document No.");
//                             TESTFIELD("Sales Line No.");
//                             UpdateUnitCostSalesLine1();
//                         end;
//                     }
//                     action("Unit Price")
//                     {
//                         Caption = 'Unit Price';
//                         Visible =  "Main JobVisible";

//                         trigger OnAction()
//                         begin
//                             TESTFIELD("Sales Document No.");
//                             TESTFIELD("Sales Line No.");
//                             UpdateUnitPriceSalesLine1()
//                         end;
//                     }
//                     action(Information)
//                     {
//                         Caption = 'Information';
//                         Visible =  "Main JobVisible";

//                         trigger OnAction()
//                         begin
//                             TESTFIELD("Sales Document No.");
//                             TESTFIELD("Sales Line No.");
//                             UpdateSalesLineFromJob();
//                         end;
//                     }
//                 }
//                 group("Update Purchase Line")
//                 {
//                     Caption = 'Update Purchase Line';
//                     Image = Change;
//                     Visible =  "Main JobVisible";
//                     action("Unit Cost")
//                     {
//                         Caption = 'Unit Cost';
//                         Visible =  "Main JobVisible";

//                         trigger OnAction()
//                         begin
//                             TESTFIELD("Purchase Document No.");
//                             TESTFIELD("Purchase Line No.");
//                             UpdateUnitCostPurchLine1();
//                         end;
//                     }
//                     action("Unit Price")
//                     {
//                         Caption = 'Unit Price';
//                         Visible =  "Main JobVisible";

//                         trigger OnAction()
//                         begin
//                             TESTFIELD("Purchase Document No.");
//                             TESTFIELD("Purchase Line No.");
//                             UpdateUnitPricePurchLine1();
//                         end;
//                     }
//                     action(Information)
//                     {
//                         Caption = 'Information';
//                         Visible =  "Main JobVisible";

//                         trigger OnAction()
//                         begin
//                             TESTFIELD("Purchase Document No.");
//                             TESTFIELD("Purchase Line No.");
//                             UpdatePurchLineFromJob();
//                         end;
//                     }
//                 }
//                 group("Update Job From Sales Line")
//                 {
//                     Caption = 'Update Job From Sales Line';
//                     Image = Change;
//                     Visible =  "Main JobVisible";
//                     action("Unit Cost")
//                     {
//                         Caption = 'Unit Cost';
//                         Visible =  "Main JobVisible";

//                         trigger OnAction()
//                         begin
//                             TESTFIELD("Sales Document No.");
//                             TESTFIELD("Sales Line No.");
//                             UpdateUnitCostJobFromSOLine1();
//                             CurrPage.UPDATE(TRUE);
//                         end;
//                     }
//                     action("Unit Price")
//                     {
//                         Caption = 'Unit Price';
//                         Visible =  "Main JobVisible";

//                         trigger OnAction()
//                         begin
//                             TESTFIELD("Sales Document No.");
//                             TESTFIELD("Sales Line No.");
//                             UpdateUnitPriceJobFromSOLine1();
//                             CurrPage.UPDATE(TRUE);
//                         end;
//                     }
//                     action(Information)
//                     {
//                         Caption = 'Information';
//                         Visible =  "Main JobVisible";

//                         trigger OnAction()
//                         begin
//                             TESTFIELD("Sales Document No.");
//                             TESTFIELD("Sales Line No.");
//                             SalesLine.GET(SalesLine."Document Type"::Order,"Sales Document No.","Sales Line No.");
//                             UpdateJobFromSalesLine(SalesLine);
//                             CurrPage.UPDATE(TRUE);
//                         end;
//                     }
//                 }
//                 group("Update Job From Purchase Line")
//                 {
//                     Caption = 'Update Job From Purchase Line';
//                     Image = Change;
//                     Visible =  "Main JobVisible";
//                     action("Unit Cost")
//                     {
//                         Caption = 'Unit Cost';
//                         Visible =  "Main JobVisible";

//                         trigger OnAction()
//                         begin
//                             TESTFIELD("Purchase Document No.");
//                             TESTFIELD("Purchase Line No.");
//                             UpdateUnitCostJobFromPOLine1();
//                             CurrPage.UPDATE(TRUE);
//                         end;
//                     }
//                     action("Unit Price")
//                     {
//                         Caption = 'Unit Price';
//                         Visible =  "Main JobVisible";

//                         trigger OnAction()
//                         begin
//                             TESTFIELD("Purchase Document No.");
//                             TESTFIELD("Purchase Line No.");
//                             UpdateUnitPriceJobFromPOLine1();
//                             CurrPage.UPDATE(TRUE);
//                         end;
//                     }
//                     action(Information)
//                     {
//                         Caption = 'Information';
//                         Visible =  "Main JobVisible";

//                         trigger OnAction()
//                         begin
//                             TESTFIELD("Purchase Document No.");
//                             TESTFIELD("Purchase Line No.");
//                             PurchLine.GET(PurchLine."Document Type"::Order,"Purchase Document No.","Purchase Line No.");
//                             UpdateJobFromPurchLine(PurchLine);
//                             CurrPage.UPDATE(TRUE);
//                         end;
//                     }
//                 }
//             }
//             group(PrintJobButton)
//             {
//                 Caption = '&Print';
//                 action("Requirement and Availability")
//                 {
//                     Caption = 'Requirement and Availability';
//                     Image = "Report";

//                     trigger OnAction()
//                     var
//                         RJobRec: Record "14022550";
//                     begin
//                         RJobRec.SETRANGE("Job No.","Job No.");
//                         RJobRec.SETRANGE("Job Type","Job Type");
//                         REPORT.RUN(14052041,TRUE,FALSE,RJobRec)
//                     end;
//                 }
//                 action("Job Envelope")
//                 {
//                     Caption = 'Job Envelope';
//                     Image = "Report";

//                     trigger OnAction()
//                     begin
//                         J5PrintDocument.PrintJobDocument(Rec,2)
//                     end;
//                 }
//                 action("Subcontractor Envelope Repair")
//                 {
//                     Caption = 'Subcontractor Envelope Jeweler';
//                     Description = 'jp001 02/03/23';
//                     Image = "Report";

//                     trigger OnAction()
//                     var
//                         Jobs_lRec: Record "14022550";
//                     begin
//                          Jobs_lRec.SETRANGE("Item No.",Rec."Item No.");
//                          Jobs_lRec.SETRANGE("Job No.",Rec."Job No.");
//                          Jobs_lRec.SETRANGE("Job Type",Rec."Job Type");
//                          IF Jobs_lRec.FINDFIRST THEN
//                            REPORT.RUNMODAL(REPORT::"Subcontractor Envelope-Repair",TRUE,FALSE,Jobs_lRec);

//                     end;
//                 }
//                 action("Subcontractor Envelope Setting")
//                 {
//                     Description = 'jp001 02/03/23';
//                     Image = "Report";

//                     trigger OnAction()
//                     var
//                         JobslRec: Record "14022550";
//                     begin
//                         JobslRec.SETRANGE("Item No.",Rec."Item No.");
//                         JobslRec.SETRANGE("Job No.",Rec."Job No.");
//                         JobslRec.SETRANGE("Job Type",Rec."Job Type");
//                         IF JobslRec.FINDFIRST THEN
//                           REPORT.RUNMODAL(REPORT::"Subcontractor Envelope-Setting",TRUE,FALSE,JobslRec);
//                     end;
//                 }
//                 action("Subcontractor Envelope Polish")
//                 {
//                     Description = 'jp001 02/03/2023';
//                     Image = "Report";

//                     trigger OnAction()
//                     var
//                         Job_LRec: Record "14022550";
//                     begin
//                          Job_LRec.SETRANGE("Item No.",Rec."Item No.");
//                          Job_LRec.SETRANGE("Job No.",Rec."Job No.");
//                          Job_LRec.SETRANGE("Job Type",Rec."Job Type");
//                           IF Job_LRec.FINDFIRST THEN
//                             REPORT.RUNMODAL(REPORT::"Subcontractor Envelope-Polish",TRUE,FALSE,Job_LRec);
//                     end;
//                 }
//                 action("Job Details")
//                 {
//                     Caption = 'Job Details';
//                     Image = "Report";

//                     trigger OnAction()
//                     var
//                         JobDetails: Report "14052048";
//                                         Jobs: Record "14022550";
//                     begin
//                         Jobs.RESET;
//                         Jobs.SETRANGE("Job No.","Job No.");
//                         JobDetails.SETTABLEVIEW(Jobs);
//                         JobDetails.RUNMODAL;
//                         CLEAR(JobDetails);
//                     end;
//                 }
//                 action("Enlarge Job Image")
//                 {
//                     Caption = 'Enlarge Job Image';
//                     Image = "Report";

//                     trigger OnAction()
//                     var
//                         EnlargedJobPictures: Report "50011";
//                                                  Jobs: Record "14022550";
//                     begin
//                         Jobs.RESET;
//                         Jobs.SETRANGE("Job No.","Job No.");
//                         EnlargedJobPictures.SETTABLEVIEW(Jobs);
//                         EnlargedJobPictures.RUNMODAL;
//                         //CLEAR(JobDetails);
//                     end;
//                 }
//                 action(ValuablesReport)
//                 {
//                     Image = "Report";

//                     trigger OnAction()
//                     var
//                         ValuablesReport: Report "50025";
//                                              Jobs: Record "14022550";
//                     begin
//                         Jobs.RESET;
//                         Jobs.SETRANGE("Job No.","Job No.");
//                         ValuablesReport.SETTABLEVIEW(Jobs);
//                         ValuablesReport.RUNMODAL;
//                         CLEAR(ValuablesReport);
//                     end;
//                 }
//                 action("Time Details")
//                 {
//                     Caption = 'Time Details';
//                     Image = Timesheet;
//                     Promoted = true;
//                     PromotedCategory = "Report";

//                     trigger OnAction()
//                     var
//                         Jobs: Record "14022550";
//                     begin
//                         Jobs.SETRANGE("Job No.","Job No.");
//                         IF Jobs.FINDFIRST THEN
//                           REPORT.RUNMODAL(14052052,TRUE,FALSE,Jobs);
//                     end;
//                 }
//                 action("Job Card")
//                 {
//                     Caption = 'Job Card';
//                     Image = Job;

//                     trigger OnAction()
//                     var
//                         JobCard: Report "14052214";
//                                      Jobs: Record "14022550";
//                     begin
//                         Jobs.RESET;
//                         Jobs.SETRANGE("Job No.","Job No.");
//                         JobCard.SETTABLEVIEW(Jobs);
//                         JobCard.RUNMODAL;
//                         CLEAR(JobCard);
//                     end;
//                 }
//                 action("Job Estimation ")
//                 {
//                     Caption = 'Job Estimation';
//                     Description = 'JP 03/01/24';
//                     Image = Report2;
//                     Promoted = true;
//                     PromotedCategory = "Report";
//                     PromotedIsBig = true;
//                     RunPageOnRec = false;

//                     trigger OnAction()
//                     var
//                         Jobs_lRec: Record "14022550";
//                     begin
//                         //jp 03/01/2024 ++
//                         Jobs_lRec.SETRANGE("Job No.","Job No.");
//                         IF Jobs_lRec.FINDFIRST THEN
//                           REPORT.RUNMODAL(50033,TRUE,FALSE,Jobs_lRec);
//                         //jp 03/01/2024 --
//                     end;
//                 }
//             }
//         }
//     }

//     trigger OnAfterGetRecord()
//     begin
//         //SETRANGE("Item No.");//J5-0008 100308
//         //J5-0008 100308
//         ActivateFields() ;

//         OnAfterGetCurrRecord;
//         WorkDescription := GetWorkDescription;
//         CADkDescription := GetCADDesc;
//         JewelerDescription := GetJewelerDesc;
//         SetterDescription := GetSetterDesc;
//         PolisherDescription := GetPolisherDesc;
//         StoneSpecs := GetWorkStoneSpec; //SIT@29032024
//         StoneSpec1 := GetWorkStoneSpecNew; //SIT@29032024
//         AdditionalStoneSpec := GetAddStoneSpecNew; //SIT29032024


//         StoneOptionVisibilty := FALSE;
//         StoneColoVisi := FALSE;
//         StoneBolb := FALSE;
//         BothStoneSpec := FALSE;
//         ViewForBoth := FALSE;

//         CASE "Stone Instructions" OF
//           "Stone Instructions"::"Mfg Supply All Stones":StoneOptionVisibilty := TRUE;
//           "Stone Instructions"::"Customer supply partial & Mfg supply additional":ViewForBoth := TRUE;
//           "Stone Instructions"::"Customer supply all stones & do not supply additional":StoneBolb := TRUE;
//           "Stone Instructions"::"Customer supply all stones & customer supply additional":StoneColoVisi := TRUE;
//         END;

//         SetJewelryCategoryFieldsVisible(Rec.Category); //SIT220424
//     end;

//     trigger OnDeleteRecord(): Boolean
//     begin
//         //J5-0016 050608 BC01 Delete job
//         CheckDeleteJob() ;
//     end;

//     trigger OnFindRecord(Which: Text): Boolean
//     begin
//         IF FIND(Which) THEN
//           EXIT(TRUE)
//         ELSE BEGIN
//           SETRANGE("Job No.");
//           EXIT(FIND(Which));
//         END;
//     end;

//     trigger OnInit()
//     begin
//         "Unit Cost(LCY)Editable" := FALSE;
//         "Main Job No.Visible" := TRUE;
//         SubJobButtonVisible := TRUE;
//         "Main JobVisible" := TRUE;
//         UnitCostfromBOMWLinkedVisible := TRUE;
//         "Unit CostVisible" := TRUE;
//         "Total CostVisible" := TRUE;
//         "Total Cost(LCY)Visible" := TRUE;
//         "Unit Cost(LCY)Visible" := TRUE;
//         OverrideUnitPriceEdit := TRUE;
//     end;

//     trigger OnModifyRecord(): Boolean
//     begin
//         CloseJobCard := CloseBool;
//     end;

//     trigger OnNewRecord(BelowxRec: Boolean)
//     begin
//         OnAfterGetCurrRecord;
//     end;

//     trigger OnOpenPage()
//     begin
//         ActivateFields() ;
//     end;

//     trigger OnQueryClosePage(CloseAction: Action): Boolean
//     begin
//         //SIT290424
//         IF CheckMandatoryFields(Rec.Category) THEN BEGIN
//           EXIT(TRUE);
//         END ELSE BEGIN
//           EXIT(FALSE);
//         END;
//     end;

//     var
//         SalesLine: Record "37";
//         ReportSelection: Record "77";
//         SLine: Record "37";
//         JobComp: Record "14022551";
//         Item: Record "27";
//         Job: Record "14022550";
//         UserSetup: Record "91";
//         PurchLine: Record "39";
//         JobMaint: Codeunit "14022529";
//         J5PrintDocument: Codeunit "14022531";
//         SalesLineFound: Boolean;
//         CloseBool: Boolean;
//         CloseJobCard: Boolean;
//         Text002: Label 'In order to close job %1, You have to receive PO # Line No. %3.';
//         PictureExists: Boolean;
//         Text009: Label 'Do you want to replace the existing picture of %1 %2?';
//         Text010: Label 'Do you want to delete the picture of %1 %2?';
//         "**BCSEC1.1": Integer;
//         TempSecSetupLine: Record "14102451" temporary;
//         Security: Codeunit "14102453";
//         Text005: Label 'Job unit price calculation By BOM. You cannot change job unit price.';
//         [InDataSet]
//         "Unit Cost(LCY)Visible": Boolean;
//         [InDataSet]
//         "Total Cost(LCY)Visible": Boolean;
//         [InDataSet]
//         "Total CostVisible": Boolean;
//         [InDataSet]
//         "Unit CostVisible": Boolean;
//         [InDataSet]
//         UnitCostfromBOMWLinkedVisible: Boolean;
//         [InDataSet]
//         "Main JobVisible": Boolean;
//         [InDataSet]
//         SubJobButtonVisible: Boolean;
//         [InDataSet]
//         "Main Job No.Visible": Boolean;
//         [InDataSet]
//         "Unit Cost(LCY)Editable": Boolean;
//         Text19078446: Label '------------------ Modified -----------------';
//         Text19001787: Label 'Metal';
//         Text19025908: Label '------------------ Created ------------------';
//         Text19068687: Label 'By BOM';
//         Text19052120: Label 'Item Reservation';
//         Text19020270: Label 'Cost and Price Calculation';
//         Text19040248: Label 'With/ Linked';
//         JWJobTracking: Record "14022587";
//         WorkDescription: Text;
//         OverrideUnitPriceEdit: Boolean;
//         CADkDescription: Text;
//         JewelerDescription: Text;
//         SetterDescription: Text;
//         PolisherDescription: Text;
//         OverrideImageQst: Label 'The existing picture will be replaced. Do you want to continue?';
//         DeleteImageQst: Label 'Are you sure you want to delete the picture?';
//         SelectPictureTxt: Label 'Select a picture to upload';
//         MustSpecifyDescriptionErr: Label 'You must add a description to the item before you can import a picture.';
//         Picture2Visible: Boolean;
//         Picture3Visible: Boolean;
//         Picture4Visible: Boolean;
//         CameraDevice: Label 'camera device not available in System. ';
//         [RunOnClient]
//         [WithEvents]
//         Camera: DotNet CameraProvider;
//     [RunOnClient]
//     [WithEvents]

//     CameraOptions: DotNet CameraOptions;
//     CameraAvailable: Boolean;
//     StoneSpecs: Text;
//     StoneSpecsCaption: Text;
//         [InDataSet]
//         StoneOptionVisibilty: Boolean;
//         [InDataSet]
//         StoneColoVisi: Boolean;
//         [InDataSet]
//         StoneBolb: Boolean;
//         BothStoneSpec: Boolean;
//         RecJobs: Record "14022550";
//         StoneSpec1: Text;
//         ViewForBoth: Boolean;
//         AdditionalStoneSpec: Text;
//         ExtraJumRing: Boolean;
//         ExtraJumpRingLenVis: Boolean;
//         LengthReqVis: Boolean;
//         InnerDiameterDimVis: Boolean;
//         BailJumpRingChainVis: Boolean;
//         MMDiameterVis: Boolean;
//         ClaspLockTypeVis: Boolean;
//         BangleSizeVis: Boolean;
//         RingSizeVis: Boolean;
//         LengthReqMand: Boolean;
//         WidthReqMand: Boolean;
//         InnerDiameterDimMand: Boolean;
//         BailJumpRingChainMand: Boolean;
//         MMDiameterMand: Boolean;
//         ClaspLockTypeMand: Boolean;
//         JumpRingLenMand: Boolean;

//     local procedure Post(PostingCodeunitID: Integer)
//     begin
//         CODEUNIT.RUN(PostingCodeunitID,Rec);
//         CurrPage.UPDATE(FALSE);
//     end;

//     [Scope('Internal')]
//     procedure SetFilter(JobLine: Record "37")
//     begin
//     end;

//     [Scope('Internal')]
//     procedure GetSalesLine1() SalesLineFound: Boolean
//     begin
//     end;

//     [Scope('Internal')]
//     procedure CloseFormAfterCloseJob(CloseBool: Boolean)
//     begin
//         //CloseFormAfterCloseJob
//         CloseJobCard := CloseBool;
//     end;

//     [Scope('Internal')]
//     procedure ActivateFields()
//     begin
//         //
//         IF (UserSetup.GET(USERID)) AND (UserSetup."No Cost" = TRUE) THEN BEGIN
//           "Unit Cost(LCY)Visible" := FALSE;
//           "Total Cost(LCY)Visible" := FALSE;
//           "Total CostVisible" := FALSE;
//           "Unit CostVisible" := FALSE;
//         END;
//         EnableSecFields() ;//BCSEC1.1 121608
//         IF "Main Job" THEN BEGIN
//           "Main JobVisible" := TRUE ;
//           SubJobButtonVisible := TRUE;
//           "Main Job No.Visible" := FALSE ;
//         END ELSE BEGIN
//           "Main JobVisible" := FALSE ;
//           SubJobButtonVisible := FALSE  ;
//           IF "Main Job No." <> '' THEN
//             "Main Job No.Visible" := TRUE
//           ELSE
//             "Main Job No.Visible" := FALSE ;
//         END ;
//         OverrideUnitPriceEdit := NOT ("Include Pricing Breakdowns") ;
//     end;

//     [Scope('Internal')]
//     procedure ShowSalesOrder()
//     var
//         SalesHeader: Record "36";
//     begin
//         TESTFIELD("Sales Document No.");
//         TESTFIELD("Sales Line No.");
//         SalesHeader.SETRANGE("Document Type", SalesHeader."Document Type"::Order) ;
//         SalesHeader.SETRANGE("No.", "Sales Document No.") ;
//         PAGE.RUN(PAGE::"Sales Order", SalesHeader);
//     end;

//     [Scope('Internal')]
//     procedure ShowPurchaseOrder()
//     var
//         PurchHeader: Record "38";
//     begin
//         TESTFIELD("Purchase Document No.");
//         TESTFIELD("Purchase Line No.");
//         PurchHeader.SETRANGE("Document Type",PurchHeader."Document Type"::Order) ;
//         PurchHeader.SETRANGE("No.", "Purchase Document No.") ;
//         PAGE.RUN(PAGE::"Purchase Order",PurchHeader);
//     end;

//     [Scope('Internal')]
//     procedure SecCheckPermission(): Boolean
//     var
//         SecSetupLine: Record "14102451";
//     begin
//         //BCSEC1.1 121608
//         IF SecSetupLine.READPERMISSION THEN
//           EXIT(TRUE)
//         ELSE
//           EXIT(FALSE);
//     end;

//     [Scope('Internal')]
//     procedure SecFieldEdieHide(LFieldID: Integer): Boolean
//     begin
//         //BCSEC1.1 121608
//         TempSecSetupLine.SETRANGE(FieldID,LFieldID);
//         IF TempSecSetupLine.FINDFIRST THEN
//           EXIT(TRUE)
//         ELSE
//           EXIT(FALSE)
//     end;

//     [Scope('Internal')]
//     procedure EnableSecFields()
//     begin
//         IF SecCheckPermission THEN BEGIN //BCSEC1.1 121608
//           IF NOT TempSecSetupLine.FINDFIRST THEN
//             Security.SecGetFieldHide(TempSecSetupLine,14022549);
//           IF SecFieldEdieHide(FIELDNO("Unit Cost(LCY)")) THEN BEGIN
//             "Unit Cost(LCY)Editable" := NOT TempSecSetupLine."Field Not Editable" ;
//             "Unit Cost(LCY)Visible" := NOT TempSecSetupLine."Hide Field" ;
//           END ;
//           IF SecFieldEdieHide(FIELDNO("Unit Cost")) THEN
//             "Unit CostVisible" := NOT TempSecSetupLine."Hide Field" ;
//           IF SecFieldEdieHide(FIELDNO("Total Cost")) THEN
//             "Total CostVisible" := NOT TempSecSetupLine."Hide Field" ;
//           IF SecFieldEdieHide(FIELDNO("Total Cost(LCY)")) THEN
//             "Total Cost(LCY)Visible" := NOT TempSecSetupLine."Hide Field" ;
//           IF SecFieldEdieHide(FIELDNO("Unit Cost from BOM W/Linked")) THEN
//             UnitCostfromBOMWLinkedVisible := NOT TempSecSetupLine."Hide Field" ;
//         END ;
//     end;

//     local procedure UnitCostLCYOnAfterValidate()
//     begin
//         UpdateUnitCostSalesLine();
//         UpdateUnitCostPurchLine();
//     end;

//     local procedure UnitPriceLCYOnAfterValidate()
//     begin
//         UpdateUnitPriceSalesLine(); //J5-0018 120908
//         UpdateUnitPricePurchLine();
//     end;

//     local procedure CancellationDateOnAfterValidat()
//     begin
//         CurrPage.UPDATE;
//     end;

//     local procedure PiecesOnAfterValidate()
//     begin
//         CurrPage.JobLines.PAGE.UpdateForm(FALSE)
//     end;

//     local procedure GlobalDimension1CodeOnAfterVal()
//     begin
//         CurrPage.JobLines.PAGE.UpdateForm(FALSE)
//     end;

//     local procedure GlobalDimension2CodeOnAfterVal()
//     begin
//         CurrPage.JobLines.PAGE.UpdateForm(FALSE)
//     end;

//     local procedure WeightOnAfterValidate()
//     begin
//         CurrPage.JobLines.PAGE.UpdateForm(FALSE)
//     end;

//     local procedure MarkupOnAfterValidate()
//     begin
//         //MAY 061608
//         Item.GET("Item No.");
//         IF Item."Job Unit Price Calculation" = Item."Job Unit Price Calculation"::"By BOM" THEN
//          ERROR(Text005);
//     end;

//     local procedure UnitofMeasureCodeOnAfterValida()
//     begin
//         CALCFIELDS("Unit Cost from BOM","Unit Price from BOM","Unit Cost from BOM W/Linked","Unit Price from BOM W/Linked");
//         CurrPage.JobLines.PAGE.UpdateForm(FALSE);
//     end;

//     local procedure MetalType3OnAfterValidate()
//     begin
//         CurrPage.UPDATE(TRUE) ;
//     end;

//     local procedure MetalType2OnAfterValidate()
//     begin
//         CurrPage.UPDATE(TRUE) ;
//     end;

//     local procedure MetalType1OnAfterValidate()
//     begin
//         CurrPage.UPDATE(TRUE) ;
//     end;

//     local procedure MetalPrice3OnAfterValidate()
//     begin
//         CurrPage.UPDATE(TRUE) ;
//     end;

//     local procedure MetalPrice2OnAfterValidate()
//     begin
//         CurrPage.UPDATE(TRUE) ;
//     end;

//     local procedure MetalPrice1OnAfterValidate()
//     begin
//         CurrPage.UPDATE(TRUE) ;
//     end;

//     local procedure Premium3OnAfterValidate()
//     begin
//         CurrPage.UPDATE(TRUE) ;
//     end;

//     local procedure Premium2OnAfterValidate()
//     begin
//         CurrPage.UPDATE(TRUE) ;
//     end;

//     local procedure Premium1OnAfterValidate()
//     begin
//         CurrPage.UPDATE(TRUE) ;
//     end;

//     local procedure OnAfterGetCurrRecord()
//     begin
//         xRec := Rec;
//         CALCFIELDS("Unit Cost from BOM W/Linked","Unit Price from BOM W/Linked","Unit Cost from BOM","Unit Price from BOM");
//     end;

//     local procedure JobLinesOnDeactivate()
//     begin
//         IF NOT CloseBool THEN;
//     end;

//     [Scope('Internal')]
//     procedure ImportFromDevice(PictureNo: Integer)
//     var
//         FileManagement: Codeunit "419";
//         FileName: Text;
//         ClientFileName: Text;
//     begin
//         //SW10-NS
//         FIND;
//         TESTFIELD("Job No.");
//         IF Description = '' THEN
//           ERROR(MustSpecifyDescriptionErr);

//         CASE PictureNo OF
//           1:
//             BEGIN
//               IF Picture.COUNT > 0 THEN
//                 IF NOT CONFIRM(OverrideImageQst) THEN
//                   ERROR('');

//               ClientFileName := '';
//               FileName := FileManagement.UploadFile(SelectPictureTxt,ClientFileName);
//               IF FileName = '' THEN
//                 ERROR('');

//               CLEAR(Picture);
//               Picture.IMPORTFILE(FileName,ClientFileName);
//               IF MODIFY(TRUE) THEN;
//             END;
//           2:
//             BEGIN
//               IF "Picture 2".COUNT > 0 THEN
//                 IF NOT CONFIRM(OverrideImageQst) THEN
//                   ERROR('');

//               ClientFileName := '';
//               FileName := FileManagement.UploadFile(SelectPictureTxt,ClientFileName);
//               IF FileName = '' THEN
//                 ERROR('');

//               CLEAR("Picture 2");
//               "Picture 2".IMPORTFILE(FileName,ClientFileName);
//               IF MODIFY(TRUE) THEN;
//             END;
//           3:
//             BEGIN
//               IF "Picture 3".COUNT > 0 THEN
//                 IF NOT CONFIRM(OverrideImageQst) THEN
//                   ERROR('');

//               ClientFileName := '';
//               FileName := FileManagement.UploadFile(SelectPictureTxt,ClientFileName);
//               IF FileName = '' THEN
//                 ERROR('');

//               CLEAR("Picture 3");
//               "Picture 3".IMPORTFILE(FileName,ClientFileName);
//               IF MODIFY(TRUE) THEN;
//             END;
//           4:
//             BEGIN
//               IF "Picture 4".COUNT > 0 THEN
//                 IF NOT CONFIRM(OverrideImageQst) THEN
//                   ERROR('');

//               ClientFileName := '';
//               FileName := FileManagement.UploadFile(SelectPictureTxt,ClientFileName);
//               IF FileName = '' THEN
//                 ERROR('');

//               CLEAR("Picture 4");
//               "Picture 4".IMPORTFILE(FileName,ClientFileName);
//               IF MODIFY(TRUE) THEN;
//             END;
//         END;

//         IF FileManagement.DeleteServerFile(FileName) THEN;
//         //SW10-NE
//     end;

//     procedure DeleteItemPicture(PictureNo: Integer)
//     begin
//         //SW10-NS
//         TESTFIELD("Job No.");

//         IF NOT CONFIRM(DeleteImageQst) THEN
//           EXIT;

//         CASE PictureNo OF
//           1:
//             BEGIN
//               CLEAR(Picture);
//               MODIFY(TRUE);
//             END;
//           2:
//             BEGIN
//               CLEAR("Picture 2");
//               MODIFY(TRUE);
//             END;
//           3:
//             BEGIN
//               CLEAR("Picture 3");
//               MODIFY(TRUE);
//             END;
//           4:
//             BEGIN
//               CLEAR("Picture 4");
//               MODIFY(TRUE);
//             END;
//         END;
//         //SW10-NE
//     end;

//     local procedure SetPictureVisibility()
//     begin
//         //SW10-NS
//         Picture2Visible := FALSE;
//         Picture3Visible := FALSE;
//         Picture4Visible := FALSE;
//         IF "Picture 2".COUNT > 0 THEN
//           Picture2Visible := TRUE;
//         IF "Picture 3".COUNT > 0 THEN
//           Picture3Visible := TRUE;
//         IF "Picture 4".COUNT > 0 THEN
//           Picture4Visible := TRUE;
//         //SW10-NE
//     end;

//     [Scope('Internal')]
//     procedure TakePictureFromCamera(PictureNo: Integer)
//     var
//         FileManagement: Codeunit "419";
//         FileName: Text;
//         ClientFileName: Text;
//         CameraInteraction: Page "1910";
//                                PictureStream: InStream;
//     begin
//         //JP 001 - End
//         FIND;
//         TESTFIELD("Job No.");
//         IF Description = '' THEN
//           ERROR(MustSpecifyDescriptionErr);

//         CASE PictureNo OF
//           1:
//             BEGIN
//               IF Picture.COUNT > 0 THEN
//                 IF NOT CONFIRM(OverrideImageQst) THEN
//                   ERROR('');



//               CameraInteraction.AllowEdit(TRUE);
//               CameraInteraction.Quality(100);
//               CameraInteraction.EncodingType('PNG');
//               CameraInteraction.RUNMODAL;

//               CameraInteraction.GetPicture(PictureStream);
//               CLEAR(Picture);
//               Picture.IMPORTSTREAM(PictureStream,CameraInteraction.GetPictureName());
//               IF NOT INSERT(TRUE) THEN
//                 MODIFY(TRUE);
//             END;
//           2:
//             BEGIN
//               CameraInteraction.AllowEdit(TRUE);
//               CameraInteraction.Quality(100);
//               CameraInteraction.EncodingType('PNG');
//               CameraInteraction.RUNMODAL;

//               CameraInteraction.GetPicture(PictureStream);
//               CLEAR("Picture 2");
//               "Picture 2".IMPORTSTREAM(PictureStream,CameraInteraction.GetPictureName());
//               IF NOT INSERT(TRUE) THEN
//                 MODIFY(TRUE);
//              END;
//           3:
//            BEGIN
//               CameraInteraction.AllowEdit(TRUE);
//               CameraInteraction.Quality(100);
//               CameraInteraction.EncodingType('PNG');
//               CameraInteraction.RUNMODAL;


//               CameraInteraction.GetPicture(PictureStream);
//               CLEAR("Picture 3");
//               "Picture 3".IMPORTSTREAM(PictureStream,CameraInteraction.GetPictureName());
//               IF NOT INSERT(TRUE) THEN
//                  MODIFY(TRUE);
//            END;
//           4:
//            BEGIN
//               CameraInteraction.AllowEdit(TRUE);
//               CameraInteraction.Quality(100);
//               CameraInteraction.EncodingType('PNG');
//               CameraInteraction.RUNMODAL;

//               CameraInteraction.GetPicture(PictureStream);
//               CLEAR("Picture 4");
//               "Picture 4".IMPORTSTREAM(PictureStream,CameraInteraction.GetPictureName());
//               IF NOT INSERT(TRUE) THEN
//                  MODIFY(TRUE);
//            END;
//         END;

//         //JP 001 - start
//     end;

//     local procedure UpdateConversationIDOnJobs(var Rec: Record "14022550"): Text
//     var
//         SalesLine: Record "37";
//         Jobs: Record "14022550";
//         CID: Text[30];
//         OldJobs: Record "14022550";
//     begin
//         IF Rec."Conversation ID" <> xRec."Conversation ID" THEN BEGIN
//           CID := Rec."Conversation ID";
//           IF GUIALLOWED THEN
//           IF CONFIRM('Do you want to update conversation id on sales line', TRUE, Rec."Job No.") THEN BEGIN
//           SalesLine.RESET;
//           SalesLine.SETRANGE("JW Job No.", Rec."Job No.");
//           SalesLine.SETRANGE("No.", Rec."Item No.");
//           SalesLine.SETRANGE("Line No.", Rec."Sales Line No.");
//           IF SalesLine.FINDSET THEN BEGIN
//             IF Rec."Job Type" = Rec."Job Type"::Regular THEN
//             SalesLine."Conversation ID" := Rec."Conversation ID";
//             SalesLine.MODIFY;
//           END ELSE
//             Job.RESET;
//             Job.SETRANGE("Job No.", Rec."Job No.");
//             Job.SETRANGE("Item No.", Rec."Item No.");
//             IF Job.FINDSET() THEN
//               Job."Conversation ID" := CID;
//               Job.MODIFY;
//             END ELSE BEGIN
//             OldJobs.RESET;
//             OldJobs.SETRANGE("Job No.", Rec."Job No.");
//             OldJobs.SETRANGE("Item No.", Rec."Item No.");
//             IF OldJobs.FINDSET() THEN
//                 OldJobs."Conversation ID" := xRec."Conversation ID";
//                 OldJobs.MODIFY;
//             END;
//         END;
//         CurrPage.UPDATE(FALSE);

//         /*CLEAR(CID);
//         IF Rec."Conversation ID" <> xRec."Conversation ID" THEN BEGIN
//           CID := Rec."Conversation ID";
//         IF CONFIRM('Do you want to update conversation id on job %1', TRUE, Rec."Job No.") THEN BEGIN
//           Jobs.RESET;
//           Jobs.SETRANGE("Job No.", Rec."JW Job No.");
//           Jobs.SETRANGE("Item No.", Rec."No.");
//           Jobs.SETRANGE("Sales Line No.", Rec."Line No.");
//           IF Jobs.FINDSET THEN BEGIN
//             Jobs."Conversation ID" := Rec."Conversation ID";
//             Jobs.MODIFY;
//           END ELSE
//           IF SalesLine.GET("Document Type", "Document No.", "Line No.") THEN
//               SalesLine."Conversation ID" := CID;
//               SalesLine.MODIFY;
//             END ELSE BEGIN
//               IF OldSalesLine.GET("Document Type", "Document No.", "Line No.") THEN
//               OldSalesLine."Conversation ID" := xRec."Conversation ID";
//               OldSalesLine.MODIFY;
//             END;
//         END;
//         CurrPage.UPDATE(FALSE);*/

//     end;

//     local procedure ModifyStoneSpecs()
//     begin
//         Rec.SETAUTOCALCFIELDS("Stone Specifications");
//         Rec.SETAUTOCALCFIELDS("Stone Specifications1");
//         Rec.SETAUTOCALCFIELDS("Additional Stone Specs");
//         IF (Rec."Stone Instructions" <> xRec."Stone Instructions")
//           AND (Rec."Stone Instructions" <> Rec."Stone Instructions"::"No stones")
//           AND (Rec."Stone Instructions" <> Rec."Stone Instructions"::" ")
//           AND ((Rec."Quality Diamond" <> '') OR (Rec."Quality Color Diamond" <> '') OR (Rec."Stone Specifications".HASVALUE) OR (Rec."Stone Specifications1".HASVALUE) OR (Rec."Additional Stone Specs".HASVALUE)) THEN
//           IF CONFIRM('Do you want to clear stone instruction details for %1', TRUE, Rec."Stone Instructions") THEN BEGIN
//               Rec."Stone Instructions" := Rec."Stone Instructions";
//               Rec."Lab Or Natural" := Rec."Lab Or Natural"::" ";
//               Rec."Quality Diamond" := '';
//               Rec."Quality Color Diamond" := '';
//               CLEAR(Rec."Stone Specifications");
//               CLEAR(Rec."Stone Specifications1");
//               CLEAR(Rec."Additional Stone Specs");
//               Rec.MODIFY;
//             END ELSE BEGIN
//               Rec."Stone Instructions" := xRec."Stone Instructions";
//               Rec."Lab Or Natural" := xRec."Lab Or Natural";
//               Rec."Quality Diamond" := xRec."Quality Diamond";
//               Rec."Quality Color Diamond" := xRec."Quality Color Diamond";
//               Rec."Stone Specifications" := xRec."Stone Specifications";
//               Rec."Stone Specifications1" := xRec."Stone Specifications1";
//               Rec."Additional Stone Specs" := xRec."Additional Stone Specs";
//               Rec.MODIFY;
//               END;
//     end;

//     local procedure SetJewelryCategoryFieldsVisible(JewelryCategory: Code[20])
//     begin
//         //SIT220424
//         CASE JewelryCategory OF
//           'RING':
//             BEGIN
//               ExtraJumpRingLenVis := FALSE;
//               LengthReqVis := TRUE;
//               InnerDiameterDimVis := FALSE;
//               BailJumpRingChainVis := FALSE;
//               MMDiameterVis := FALSE;
//               ClaspLockTypeVis := FALSE;
//               //SIT250424
//               RingSizeVis := TRUE;
//               BangleSizeVis := FALSE;

//               //mandatory fields SIT250424
//               JumpRingLenMand := FALSE;
//               LengthReqMand := FALSE;
//               WidthReqMand := FALSE;
//               InnerDiameterDimMand := FALSE;
//               BailJumpRingChainMand := FALSE;
//               MMDiameterMand := FALSE;
//               ClaspLockTypeMand := FALSE;

//             END;
//           'BRACELET':
//             BEGIN
//               ExtraJumpRingLenVis := TRUE;
//               LengthReqVis := TRUE;
//               InnerDiameterDimVis := FALSE;
//               BailJumpRingChainVis := TRUE;
//               MMDiameterVis := FALSE;
//               ClaspLockTypeVis := TRUE;
//               RingSizeVis := FALSE;
//               BangleSizeVis := FALSE;

//               //mandatory fields SIT250424
//               JumpRingLenMand := FALSE;
//               LengthReqMand := TRUE;
//               WidthReqMand := FALSE;
//               InnerDiameterDimMand := FALSE;
//               BailJumpRingChainMand := FALSE;
//               MMDiameterMand := FALSE;
//               ClaspLockTypeMand := TRUE;

//             END;
//           'BANGLE':
//             BEGIN
//               ExtraJumpRingLenVis := FALSE;
//               LengthReqVis := FALSE;
//               InnerDiameterDimVis := TRUE;
//               BailJumpRingChainVis := FALSE;
//               MMDiameterVis := FALSE;
//               ClaspLockTypeVis := TRUE;
//               RingSizeVis := FALSE;
//               BangleSizeVis := TRUE;

//               //mandatory fields SIT250424
//               JumpRingLenMand := FALSE;
//               LengthReqMand := FALSE;
//               WidthReqMand := FALSE;
//               InnerDiameterDimMand := TRUE;
//               BailJumpRingChainMand := FALSE;
//               MMDiameterMand := FALSE;
//               ClaspLockTypeMand := FALSE;
//             END;
//           'NECKLACE':
//             BEGIN
//               ExtraJumpRingLenVis := TRUE;
//               LengthReqVis := TRUE;
//               InnerDiameterDimVis := FALSE;
//               BailJumpRingChainVis := TRUE;
//               MMDiameterVis := TRUE;
//               ClaspLockTypeVis := TRUE;
//               RingSizeVis := FALSE;
//               BangleSizeVis := FALSE;

//               //mandatory fields SIT250424
//               JumpRingLenMand := TRUE;
//               LengthReqMand := TRUE;
//               WidthReqMand := FALSE;
//               InnerDiameterDimMand := FALSE;
//               BailJumpRingChainMand := TRUE;
//               MMDiameterMand := TRUE;
//               ClaspLockTypeMand := TRUE;
//             END;
//           'CHARM':
//             BEGIN
//               ExtraJumpRingLenVis := FALSE;
//               LengthReqVis := TRUE;
//               InnerDiameterDimVis := FALSE;
//               BailJumpRingChainVis := TRUE;
//               MMDiameterVis := TRUE;
//               ClaspLockTypeVis := FALSE;
//               RingSizeVis := FALSE;
//               BangleSizeVis := FALSE;

//               //mandatory fields SIT250424
//               JumpRingLenMand := FALSE;
//               LengthReqMand := TRUE;
//               WidthReqMand := TRUE;
//               InnerDiameterDimMand := FALSE;
//               BailJumpRingChainMand := TRUE;
//               MMDiameterMand := FALSE;
//               ClaspLockTypeMand := FALSE;
//             END;
//           'EARRING':
//             BEGIN
//               ExtraJumpRingLenVis := FALSE;
//               LengthReqVis := TRUE;
//               InnerDiameterDimVis := FALSE;
//               BailJumpRingChainVis := FALSE;
//               MMDiameterVis := FALSE;
//               ClaspLockTypeVis := FALSE;
//               RingSizeVis := FALSE;
//               BangleSizeVis := FALSE;

//               //mandatory fields SIT250424
//               JumpRingLenMand := FALSE;
//               LengthReqMand := FALSE;
//               WidthReqMand := FALSE;
//               InnerDiameterDimMand := FALSE;
//               BailJumpRingChainMand := FALSE;
//               MMDiameterMand := FALSE;
//               ClaspLockTypeMand := FALSE;
//             END;
//           'PENDANT':
//             BEGIN
//              ExtraJumpRingLenVis := FALSE;
//               LengthReqVis := TRUE;
//               InnerDiameterDimVis := FALSE;
//               BailJumpRingChainVis := TRUE;
//               MMDiameterVis := TRUE;
//               ClaspLockTypeVis := FALSE;
//               RingSizeVis := FALSE;
//               BangleSizeVis := FALSE;

//               //mandatory fields SIT250424
//               JumpRingLenMand := FALSE;
//               LengthReqMand := TRUE;
//               WidthReqMand := TRUE;
//               InnerDiameterDimMand := FALSE;
//               BailJumpRingChainMand := TRUE;
//               MMDiameterMand := TRUE;
//               ClaspLockTypeMand := FALSE;
//             END;
//           'BROACH-PIN':
//             BEGIN
//               ExtraJumpRingLenVis := FALSE;
//               LengthReqVis := TRUE;
//               InnerDiameterDimVis := FALSE;
//               BailJumpRingChainVis := FALSE;
//               MMDiameterVis := FALSE;
//               ClaspLockTypeVis := FALSE;
//               RingSizeVis := FALSE;
//               BangleSizeVis := FALSE;

//               //mandatory fields SIT250424
//               JumpRingLenMand := FALSE;
//               LengthReqMand := TRUE;
//               WidthReqMand := TRUE;
//               InnerDiameterDimMand := FALSE;
//               BailJumpRingChainMand := FALSE;
//               MMDiameterMand := FALSE;
//               ClaspLockTypeMand := FALSE;
//             END;
//           'CUFFLINKS':
//             BEGIN
//               ExtraJumpRingLenVis := FALSE;
//               LengthReqVis := TRUE;
//               InnerDiameterDimVis := FALSE;
//               BailJumpRingChainVis := FALSE;
//               MMDiameterVis := FALSE;
//               ClaspLockTypeVis := FALSE;
//               RingSizeVis := FALSE;
//               BangleSizeVis := FALSE;

//              //mandatory fields SIT250424
//               JumpRingLenMand := FALSE;
//               LengthReqMand := TRUE;
//               WidthReqMand := TRUE;
//               InnerDiameterDimMand := FALSE;
//               BailJumpRingChainMand := FALSE;
//               MMDiameterMand := FALSE;
//               ClaspLockTypeMand := FALSE;
//             END;
//           'MISC':
//             BEGIN
//               ExtraJumpRingLenVis := TRUE;
//               LengthReqVis := TRUE;
//               InnerDiameterDimVis := TRUE;
//               BailJumpRingChainVis := TRUE;
//               MMDiameterVis := TRUE;
//               ClaspLockTypeVis := TRUE;
//               RingSizeVis := FALSE;
//               BangleSizeVis := FALSE;

//              //mandatory fields SIT250424
//               JumpRingLenMand := FALSE;
//               LengthReqMand := FALSE;
//               WidthReqMand := FALSE;
//               InnerDiameterDimMand := FALSE;
//               BailJumpRingChainMand := FALSE;
//               MMDiameterMand := FALSE;
//               ClaspLockTypeMand := FALSE;
//             END;
//           ELSE
//             BEGIN
//               ExtraJumpRingLenVis := TRUE;
//               LengthReqVis := TRUE;
//               InnerDiameterDimVis := TRUE;
//               BailJumpRingChainVis := TRUE;
//               MMDiameterVis := TRUE;
//               ClaspLockTypeVis := TRUE;
//               RingSizeVis := FALSE;
//               BangleSizeVis := FALSE;

//              //mandatory fields SIT250424
//               JumpRingLenMand := FALSE;
//               LengthReqMand := FALSE;
//               WidthReqMand := FALSE;
//               InnerDiameterDimMand := FALSE;
//               BailJumpRingChainMand := FALSE;
//               MMDiameterMand := FALSE;
//               ClaspLockTypeMand := FALSE;
//             END;
//         END;
//         //CurrPage.UPDATE(TRUE);
//     end;

//     local procedure CheckMandatoryFields(JewelryCategory: Code[20]): Boolean
//     begin
//         CASE JewelryCategory OF
//           'RING':
//             BEGIN
//               Rec.TESTFIELD("Ring Size");
//               Rec.TESTFIELD("Customer Supply Center");
//               Rec.TESTFIELD("Are we setting Center Stone?");
//               EXIT(TRUE);
//             END;
//           'BRACELET':
//             BEGIN
//               Rec.TESTFIELD("Customer Supply Center");
//               Rec.TESTFIELD("Are we setting Center Stone?");
//               Rec.TESTFIELD("Extra Jump Rings Lengths");
//               Rec.TESTFIELD("Length Requested");
//               Rec.TESTFIELD("Clasp or Lock Type");
//               EXIT(TRUE);
//             END;

//           'BANGLE':
//             BEGIN
//               Rec.TESTFIELD("Customer Supply Center");
//               Rec.TESTFIELD("Are we setting Center Stone?");
//               Rec.TESTFIELD("Bangle Size");
//               Rec.TESTFIELD("Inner Diameter Dimensions");
//               EXIT(TRUE);
//             END;

//           'NECKLACE':
//             BEGIN
//               Rec.TESTFIELD("Customer Supply Center");
//               Rec.TESTFIELD("Are we setting Center Stone?");
//               Rec.TESTFIELD("Extra Jump Rings Lengths");
//               Rec.TESTFIELD("Length Requested");
//               Rec.TESTFIELD("Bail/Jump Ring for Chain");
//               Rec.TESTFIELD("MM diameter of chain bail");
//               Rec.TESTFIELD("Clasp or Lock Type");
//               EXIT(TRUE);
//             END;

//           'CHARM':
//             BEGIN
//               Rec.TESTFIELD("Customer Supply Center");
//               Rec.TESTFIELD("Are we setting Center Stone?");
//               Rec.TESTFIELD("Length Requested");
//               Rec.TESTFIELD("Width Requested");
//               Rec.TESTFIELD("Bail/Jump Ring for Chain");
//               EXIT(TRUE);
//             END;

//           'EARRING':
//             BEGIN
//               Rec.TESTFIELD("Customer Supply Center");
//               Rec.TESTFIELD("Are we setting Center Stone?");
//               EXIT(TRUE);
//             END;

//           'PENDANT':
//             BEGIN
//               Rec.TESTFIELD("Customer Supply Center");
//               Rec.TESTFIELD("Are we setting Center Stone?");
//               Rec.TESTFIELD("Length Requested");
//               Rec.TESTFIELD("Width Requested");
//               Rec.TESTFIELD("Bail/Jump Ring for Chain");
//               Rec.TESTFIELD("MM diameter of chain bail");
//               EXIT(TRUE);
//             END;

//           'BROACH-PIN':
//             BEGIN
//               Rec.TESTFIELD("Customer Supply Center");
//               Rec.TESTFIELD("Are we setting Center Stone?");
//               Rec.TESTFIELD("Length Requested");
//               Rec.TESTFIELD("Width Requested");
//               EXIT(TRUE);
//             END;

//           'CUFFLINKS':
//             BEGIN
//               Rec.TESTFIELD("Customer Supply Center");
//               Rec.TESTFIELD("Are we setting Center Stone?");
//               Rec.TESTFIELD("Length Requested");
//               Rec.TESTFIELD("Width Requested");
//               EXIT(TRUE);
//             END;

//           'MISC':
//             BEGIN
//               Rec.TESTFIELD("Customer Supply Center");
//               Rec.TESTFIELD("Are we setting Center Stone?");
//               //Rec.TESTFIELD("Extra Jump Rings Lengths");
//               EXIT(TRUE);
//             END;

//           ELSE
//             BEGIN
//              EXIT(TRUE);
//             END;
//           EXIT(TRUE);
//         END;
//     end;

//     trigger Camera::PictureAvailable(PictureName: Text;PictureFilePath: Text)
//     var
//         File: File;
//         Instream: InStream;
//     begin
//     end;
// }

