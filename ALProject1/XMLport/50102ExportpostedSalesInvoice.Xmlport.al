xmlport 50102 SalesInvoice
{
    Caption = 'SalesInvoice';
    Format = Xml;
    Encoding = UTF8;
    Direction = Export;
    UseDefaultNamespace = true;
    UseRequestPage = false;
    DefaultNamespace = 'urn:oasis:names:specification:ubl:schema:xsd:Invoice-2';
    Namespaces = cbc = 'urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2', cac = 'urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2', ns4 = 'urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2', xsi = 'http://www.w3.org/2001/XMLSchema-instance';


    //UseDefaultNamespace = false;

    schema
    {

        tableelement(Invoice; "Sales Invoice Header")
        {
            //RequestFilterFields = "No.";
            //AutoSave = false;
            // RequestFilterHeading = 'Posted Sales Invoice';


            //RequestFilterFields = "Document No.";{


            // NamespacePrefix = 'bc';
            // textelement(tcc)
            // {

            textelement(CustomizationID)
            {
                NamespacePrefix = 'cbc';

                trigger OnBeforePassVariable()
                begin
                    CustomizationID := 'urn:cen.eu:en16931:2017#compliant#urn:efactura.mfinante.ro:CIUS-RO:1.0.1';
                end;

            }
            fieldelement(ID; Invoice."No.")
            {
                NamespacePrefix = 'cbc';

                // fieldattribute(name; Invoice."Order No.") { }

            }
            // }

            // fieldelement(Type; Invoice."Bill-to Customer No.")
            // {

            // }

            textelement(IssueDate)
            {
                NamespacePrefix = 'cbc';
                trigger OnBeforePassVariable()
                begin
                    IssueDate := FORMAT(Invoice."Document Date", 0, 9);
                end;
            }
            // fieldelement(IssueDate; Invoice."Document Date")
            // {
            //     NamespacePrefix = 'cbc';


            // }
            textelement(DueDate)
            {
                NamespacePrefix = 'cbc';
                trigger OnBeforePassVariable()
                begin
                    DueDate := FORMAT(Invoice."Due Date", 0, 9);
                end;
            }
            // fieldelement(DueDate; Invoice."Due Date")
            // {
            //     NamespacePrefix = 'cbc';
            // }


            textelement(InvoiceTypeCode)
            {
                NamespacePrefix = 'cbc';
                trigger OnBeforePassVariable()
                begin
                    InvoiceTypeCode := '380';
                end;
            }

            textelement(TaxPointDate)
            {
                NamespacePrefix = 'cbc';
                trigger OnBeforePassVariable()
                begin
                    // TaxPointDate := FORMAT(Invoice."VAT Reporting Date", 0, 9);
                end;
            }
            // fieldelement(TaxPointDate; Invoice."VAT Reporting Date")
            // {
            //     NamespacePrefix = 'cbc';
            // }

            fieldelement(DocumentCurrencyCode; Invoice."Currency Code")
            {
                NamespacePrefix = 'cbc';
                trigger OnBeforePassField()
                begin
                    if Invoice."Currency Code" = '' then begin
                        Invoice."Currency Code" := 'RON';
                    end;
                end;
            }

            //             textelement(OrderReference)
            //             {
            //                 NamespacePrefix = 'cac'
            // ;
            //                 fieldelement(ID; Invoice."Order No.")
            //                 {
            //                     NamespacePrefix = 'cbc';
            //                 }
            //             }
            textelement(AccountingSupplierParty)
            {


                NamespacePrefix = 'cac';
                tableelement(Party; "Company Information")
                {
                    SourceTableView = SORTING("Primary Key");
                    NamespacePrefix = 'cac';
                    textelement(PostalAddress)
                    {
                        NamespacePrefix = 'cac';


                        textelement(StreetName1)
                        {

                            XmlName = 'StreetName';
                            NamespacePrefix = 'cbc';


                            trigger OnBeforePassVariable()
                            begin
                                StreetName1 := Party.Address + Party."Address 2";
                            end;

                        }
                        // fieldelement(StreetName; Party.Address)
                        // {
                        //     XmlName = 'StreetName';
                        //     NamespacePrefix = 'cbc';


                        //     trigger OnBeforePassField()
                        //     begin
                        //         StreetName := Party."Address" + Party."Address 2";
                        //     end;

                        // }
                        // fieldelement(StreetName; Party.Address)
                        // {
                        //     NamespacePrefix = 'cbc';

                        // }
                        textelement(CityName)
                        {
                            NamespacePrefix = 'cbc';
                            trigger OnBeforePassVariable()
                            begin
                                if Party.City = 'Bucuresti' then begin
                                    CityName := Party.County;
                                end
                                else begin
                                    CityName := Party.City;
                                end;
                            end;

                        }
                        fieldelement(PostalZone; Party."Post Code")
                        {
                            NamespacePrefix = 'cbc';

                        }
                        textelement(CountrySubentity)
                        {
                            NamespacePrefix = 'cbc';
                            // trigger OnBeforePassVariable()
                            // var
                            //     PosCode: Record "Post Code";
                            // begin
                            //     PosCode.SetRange(City, Party.City);
                            //     if PosCode.FindFirst() then begin
                            //         CountrySubentity := PosCode."ISO Code";
                            //     end;

                            // end;
                        }
                        textelement(Country)
                        {
                            NamespacePrefix = 'cac';
                            fieldelement(IdentificationCode; Party."Country/Region Code")
                            {
                                NamespacePrefix = 'cbc';
                            }
                        }

                    }
                    textelement(PartyTaxScheme)
                    {
                        NamespacePrefix = 'cac';
                        fieldelement(CompanyID; Party."VAT Registration No.")
                        {
                            XmlName = 'CompanyID';
                            NamespacePrefix = 'cbc';
                        }
                        textelement(TaxScheme)
                        {
                            NamespacePrefix = 'cac';
                            XmlName = 'TaxScheme';
                            textelement(ID3)
                            {
                                XmlName = 'ID';
                                NamespacePrefix = 'cbc';
                                trigger OnBeforePassVariable()
                                begin
                                    ID3 := 'VAT';
                                end;
                            }
                        }
                    }

                    textelement(PartyLegalEntity)
                    {
                        NamespacePrefix = 'cac';
                        fieldelement(RegistrationName; Party.Name)
                        {
                            NamespacePrefix = 'cbc';
                        }
                        fieldelement(CompanyID; Party."Registration No.")
                        {
                            NamespacePrefix = 'cbc';
                        }
                    }
                    textelement(Contact)
                    {
                        NamespacePrefix = 'cac';
                        fieldelement(Name; Party."Contact Person")
                        {
                            NamespacePrefix = 'cbc';
                        }
                        fieldelement(Telephone; Party."Phone No.")
                        {
                            NamespacePrefix = 'cbc';
                        }
                        fieldelement(ElectronicMail; Party."E-Mail")
                        {
                            NamespacePrefix = 'cbc';
                        }
                    }



                }
            }

            textelement(AccountingCustomerParty)
            {
                NamespacePrefix = 'cac';

                textelement(Party1)
                {
                    XmlName = 'Party';
                    NamespacePrefix = 'cac';
                    textelement(PostalAddress1)
                    {
                        XmlName = 'PostalAddress';
                        NamespacePrefix = 'cac';

                        textelement(StreetName2)
                        {

                            XmlName = 'StreetName';
                            NamespacePrefix = 'cbc';


                            trigger OnBeforePassVariable()
                            begin
                                StreetName2 := Invoice."Bill-to Address" + Invoice."Bill-to Address 2";
                            end;

                        }
                        // fieldelement(StreetName; Invoice."Bill-to Address")
                        // {
                        //     NamespacePrefix = 'cbc';
                        // }
                        fieldelement(CityName; Invoice."Bill-to City")
                        {
                            NamespacePrefix = 'cbc';
                        }
                        fieldelement(PostalZone; Invoice."Bill-to Post Code")
                        {
                            NamespacePrefix = 'cbc';
                        }
                        fieldelement(CountrySubentity; Invoice."Bill-to County")
                        {
                            NamespacePrefix = 'cbc';
                        }
                        textelement(Country1)
                        {
                            XmlName = 'Country';
                            NamespacePrefix = 'cac';
                            fieldelement(IdentificationCode; Invoice."Bill-to Country/Region Code")
                            {
                                NamespacePrefix = 'cbc';
                            }
                        }
                    }
                    textelement(PartyTaxScheme1)
                    {
                        XmlName = 'PartyTaxScheme';
                        NamespacePrefix = 'cac';
                        fieldelement(CompanyID; Invoice."VAT Registration No.")
                        {
                            NamespacePrefix = 'cbc';
                            trigger OnBeforePassField()
                            begin
                                Invoice."VAT Registration No." := Invoice."VAT Country/Region Code" + Invoice."VAT Registration No.";
                            end;
                        }
                        textelement(TaxScheme1)
                        {
                            XmlName = 'TaxScheme';
                            NamespacePrefix = 'cac';
                            textelement(ID4)
                            {
                                XmlName = 'ID';
                                NamespacePrefix = 'cbc';
                                trigger OnBeforePassVariable()
                                begin
                                    ID4 := 'VAT';
                                end;
                            }
                        }

                    }
                    textelement(PartyLegalEntity1)
                    {
                        XmlName = 'PartyLegalEntity';
                        NamespacePrefix = 'cac';
                        fieldelement(RegistrationName; Invoice."Bill-to Name")
                        {
                            NamespacePrefix = 'cbc';
                        }
                        // fieldelement(CompanyID; )
                        // tableelement(CompanyID; Customer)
                        // {
                        //     LinkTable = Invoice;
                        //     NamespacePrefix = 'cbc';
                        //     LinkFields = "No." = field("Sell-to Customer No.");
                        //     fieldelement(CompanyID; CompanyID."Registration Number")
                        //     {

                        //     }
                        // }
                        textelement(CompanyID)
                        {
                            NamespacePrefix = 'cbc';

                            // trigger OnBeforePassVariable()
                            // var
                            //     Customer: Record Customer;
                            // begin
                            //     Customer.SetRange("No.", Invoice."Sell-to Customer No.");
                            //     if Customer.FindFirst() then begin
                            //         CompanyID := Customer."Registration Number";
                            //     end;
                            // end;
                        }

                    }

                    textelement(Contact1)
                    {
                        XmlName = 'Contact';
                        NamespacePrefix = 'cac';
                        fieldelement(Name; Invoice."Bill-to Contact")
                        {
                            NamespacePrefix = 'cbc';
                        }

                        // fieldelement(Telephone; Invoice."Sell-to Phone No.")
                        // {
                        //     NamespacePrefix = 'cbc';
                        // }
                        fieldelement(ElectronicMail; Invoice."Sell-to E-Mail")
                        {
                            NamespacePrefix = 'cbc';
                        }
                    }

                }
                // fieldelement(ShipmentDate; Invoice."Shipment Date")
                // {

                // }

                // fieldelement(VATReportingDate; Invoice."VAT Reporting Date")
                // {

                // }
                // fieldelement(selltoContactNo; Invoice."Sell-to Contact No.")
                // {

                // }
                // tableelement(SalesLine; "Sales Invoice Line")
                // {
                //     LinkTable = Invoice;
                //     LinkFields = "Document No." = field("No.");
                //     fieldelement(documen; SalesLine."Document No.")
                //     {

                //     }
                // }


            }
            textelement(Delivery)
            {
                NamespacePrefix = 'cac';
                // fieldelement(ActualDeliveryDate; Invoice."Shipment Date")
                // {
                //     NamespacePrefix = 'cbc';
                // }

                textelement(ActualDeliveryDate)
                {
                    NamespacePrefix = 'cbc';
                    trigger OnBeforePassVariable()
                    begin
                        ActualDeliveryDate := Format(Invoice."Shipment Date", 0, 9)
                    end;
                }
                // textelement(DeliveryLocation)
                // {
                //     NamespacePrefix = 'cac';
                //     textelement(Address2)
                //     {
                //         XmlName = 'Address';
                //         NamespacePrefix = 'cac';
                //         textelement(StreetName)
                //         {

                //             NamespacePrefix = 'cbc';


                //             trigger OnBeforePassVariable()
                //             begin
                //                 StreetName := Invoice."Ship-to Address" + Invoice."Ship-to Address 2";
                //             end;

                //         }
                //         fieldelement(CityName; Invoice."Ship-to City")
                //         {
                //             NamespacePrefix = 'cbc';
                //         }
                //         fieldelement(PostalZone; Invoice."Ship-to Post Code")
                //         {
                //             NamespacePrefix = 'cbc';
                //         }
                //         textelement(Country2)
                //         {
                //             XmlName = 'Country';
                //             NamespacePrefix = 'cac';

                //             // trigger OnBeforePassVariable()
                //             // begin
                //             //     Country2 := 'test';
                //             // end;
                //             fieldelement(IdentificationCode; Invoice."Ship-to County")
                //             {
                //                 NamespacePrefix = 'cbc';
                //             }

                //             // textelement(testconst; localTextConst)
                //             // {

                //             // }

                //         }
                //     }
                // }
            }
            textelement(PaymentMeans)
            {
                NamespacePrefix = 'cac';
                textelement(PaymentMeansCode)
                {
                    NamespacePrefix = 'cbc';
                    // trigger OnBeforePassVariable()
                    // var
                    //     paymentmethodcode: Record "Payment Method";
                    // begin
                    //     paymentmethodcode.SetRange(Code, Invoice."Payment Method Code");
                    //     if paymentmethodcode.FindFirst() then begin
                    //         PaymentMeansCode := paymentmethodcode."Code for e-invoice";
                    //     end;
                    //     // if Invoice."Payment Method Code" = '' then begin
                    //     //     PaymentMeansCode := '42';
                    //     // end else
                    //     // begin

                    //     // end;
                    // end;
                }
                // fieldelement(PaymentID; Invoice."Payment Reference")
                // {
                //     NamespacePrefix = 'cbc';
                // }
                // tableelement(PayeeFinancialAccount; "Company Information")
                // {

                //     NamespacePrefix = 'cac';
                //     fieldelement(ID; PayeeFinancialAccount.IBAN)
                //     {
                //         NamespacePrefix = 'cbc';
                //     }
                //     // fieldelement(ID; add.IBAN)
                //     // {
                //     //     NamespacePrefix = 'cbc';
                //     // }
                // }
            }
            textelement(TaxTotal)
            {
                NamespacePrefix = 'cac';
                textelement(TaxAmount)
                {
                    NamespacePrefix = 'cbc';

                    fieldattribute(currencyID; Invoice."Currency Code")
                    {

                    }
                    trigger OnBeforePassVariable()
                    var
                        incl: Decimal;
                        excl: Decimal;
                        Taxam: Decimal;
                    begin
                        incl := 0;
                        excl := 0;
                        SalesLine.SetRange("Document No.", Invoice."No.");
                        if SalesLine.FindSet() then begin
                            repeat
                                incl := incl + SalesLine."Amount Including VAT";
                                excl := excl + SalesLine."Line Amount";
                                if Invoice."Currency Code" = '' then begin
                                    Invoice."Currency Code" := 'RON';
                                end;
                            until SalesLine.Next() = 0;
                            Taxam := incl - excl;
                            TaxAmount := Format(Taxam, 0, 1);
                        end;
                    end;
                }

                textelement(TaxSubtotal)
                {
                    NamespacePrefix = 'cac';
                    textelement(TaxableAmount)
                    {
                        NamespacePrefix = 'cbc';
                        fieldattribute(currencyID; Invoice."Currency Code")
                        {

                        }
                        trigger OnBeforePassVariable()
                        var
                            incl: Decimal;
                            excl: Decimal;
                            Taxam: Decimal;
                        begin
                            incl := 0;
                            excl := 0;
                            SalesLine.SetRange("Document No.", Invoice."No.");
                            if SalesLine.FindSet() then begin
                                repeat
                                    //incl := incl + SalesLine."Amount Including VAT";
                                    excl := excl + SalesLine."Line Amount";
                                until SalesLine.Next() = 0;
                                Taxam := excl;
                                TaxableAmount := Format(Taxam, 0, 1);
                            end;
                        end;
                    }
                    textelement(TaxAmount1)
                    {
                        NamespacePrefix = 'cbc';
                        XmlName = 'TaxAmount';
                        fieldattribute(currencyID; Invoice."Currency Code")
                        {

                        }
                        trigger OnBeforePassVariable()
                        var
                            incl: Decimal;
                            excl: Decimal;
                            Taxam: Decimal;
                        begin
                            incl := 0;
                            excl := 0;
                            SalesLine.SetRange("Document No.", Invoice."No.");
                            if SalesLine.FindSet() then begin
                                repeat
                                    incl := incl + SalesLine."Amount Including VAT";
                                    excl := excl + SalesLine."Line Amount";
                                until SalesLine.Next() = 0;
                                Taxam := incl - excl;
                                TaxAmount1 := Format(Taxam, 0, 1);
                            end;
                        end;
                    }

                    textelement(TaxCategory)
                    {
                        NamespacePrefix = 'cac';

                        textelement(ID2)
                        {
                            XmlName = 'ID';
                            NamespacePrefix = 'cbc';
                            // trigger OnBeforePassVariable()
                            // var
                            //     vatpos: Record "VAT Posting Setup";
                            // begin
                            //     vatpos.SetRange("VAT Bus. Posting Group", SalesLine."VAT Bus. Posting Group");
                            //     if vatpos.FindFirst() then begin
                            //         ID2 := vatpos."E-Inv VAT Category";
                            //     end;


                            // end;
                        }
                        textelement(Percent)
                        {
                            NamespacePrefix = 'cbc';

                            trigger OnBeforePassVariable()
                            var
                                incl: Decimal;

                            begin

                                SalesLine.SetRange("Document No.", Invoice."No.");
                                if SalesLine.FindFirst() then begin

                                    incl := SalesLine."VAT %";


                                    Percent := Format(incl);
                                end;
                            end;
                        }
                        textelement(TaxScheme3)
                        {
                            XmlName = 'TaxScheme';
                            NamespacePrefix = 'cac';
                            textelement(ID5)
                            {
                                XmlName = 'ID';
                                NamespacePrefix = 'cbc';
                                trigger OnBeforePassVariable()
                                begin
                                    ID5 := 'VAT';
                                end;
                            }
                        }

                    }


                }
                // tableelement(TaxSubtotal; "Sales Invoice Line")
                // {
                //     LinkTable = Invoice;
                //     LinkFields = "Document No." = field("No.");
                //     NamespacePrefix = 'cbc';
                //     // fieldelement(TaxAmount; Invoice.)


                //     textelement(test)
                //     {
                //         NamespacePrefix = 't';
                //     }
                //     fieldelement(TaxableAmount; TaxSubtotal."VAT Base Amount")
                //     {
                //         NamespacePrefix = 'cbc';
                //         fieldattribute(currencyID; Invoice."Currency Code")
                //         {

                //         }
                //     }

                //     textelement(TaxAmount1)
                //     {

                //         XmlName = 'TaxAmount';
                //         NamespacePrefix = 'cbc';

                //         fieldattribute(CurrencyID; Invoice."Currency Code")
                //         {

                //         }
                //         trigger OnBeforePassVariable()
                //         begin
                //             TaxAmount1 := Format(TaxSubtotal."Amount Including VAT" * TaxSubtotal."VAT Base Amount");
                //         end;

                //     }

                //     textelement(TaxCategory)
                //     {
                //         NamespacePrefix = 'cac';
                //         fieldelement(Percent; TaxSubtotal."VAT %")
                //         {
                //             NamespacePrefix = 'cbc';
                //         }
                //     }

                // }



            }

            textelement(LegalMonetaryTotal)
            {
                NamespacePrefix = 'cac';
                // LinkTable = Invoice;
                // LinkFields = "Document No." = field("No.");

                textelement(LineExtensionAmount)
                {
                    NamespacePrefix = 'cbc';
                    fieldattribute(currencyID; Invoice."Currency Code")
                    {

                    }
                    trigger OnBeforePassVariable()
                    var
                        int: Decimal;
                    begin
                        int := 0;
                        SalesLine.SetRange("Document No.", Invoice."No.");
                        if SalesLine.FindSet() then begin
                            repeat
                                int := int + SalesLine."Line Amount";

                            until SalesLine.Next() = 0;
                            LineExtensionAmount := Format(int, 0, 1);
                        end;
                    end;
                }

                textelement(TaxExclusiveAmount)
                {
                    NamespacePrefix = 'cbc';
                    fieldattribute(currencyID; Invoice."Currency Code")
                    {

                    }
                    trigger OnBeforePassVariable()
                    var
                        int: Decimal;
                    begin
                        int := 0;
                        SalesLine.SetRange("Document No.", Invoice."No.");
                        if SalesLine.FindSet() then begin
                            repeat
                                int := int + SalesLine."Line Amount";

                            until SalesLine.Next() = 0;
                            TaxExclusiveAmount := Format(int, 0, 1);
                        end;
                    end;
                }


                textelement(TaxInclusiveAmount)
                {
                    NamespacePrefix = 'cbc';
                    fieldattribute(currencyID; Invoice."Currency Code")
                    {

                    }
                    trigger OnBeforePassVariable()
                    var
                        int: Decimal;
                    begin
                        int := 0;
                        SalesLine.SetRange("Document No.", Invoice."No.");
                        if SalesLine.FindSet() then begin
                            repeat
                                int := int + SalesLine."Amount Including VAT";

                            until SalesLine.Next() = 0;
                            TaxInclusiveAmount := Format(int, 0, 1);
                        end;
                    end;
                }
                textelement(PayableAmount)
                {
                    NamespacePrefix = 'cbc';
                    fieldattribute(currencyID; Invoice."Currency Code")
                    {

                    }
                    trigger OnBeforePassVariable()
                    var
                        int: Decimal;
                    begin
                        int := 0;
                        SalesLine.SetRange("Document No.", Invoice."No.");
                        if SalesLine.FindSet() then begin
                            repeat
                                int := int + SalesLine."Amount Including VAT";

                            until SalesLine.Next() = 0;
                            PayableAmount := Format(int, 0, 1);
                        end;
                    end;
                }
            }

            tableelement(SalesLine; "Sales Invoice Line")
            {
                LinkTable = Invoice;
                LinkFields = "Document No." = field("No.");
                SourceTableView = SORTING("Document No.", "Line No.");
                XmlName = 'InvoiceLine';
                NamespacePrefix = 'cac';

                textelement(ID)
                {
                    NamespacePrefix = 'cbc';
                    trigger OnBeforePassVariable()
                    begin

                        ID := Format(SerialNo);
                    end;
                }

                fieldelement(InvoicedQuantity; SalesLine.Quantity)
                {
                    NamespacePrefix = 'cbc';
                    XmlName = 'InvoicedQuantity';

                    fieldattribute(unitCode; SalesLine."Unit of Measure Code")
                    {

                    }
                    trigger OnBeforePassField()
                    var
                        unitofmeasre: Record "Unit of Measure";
                    begin
                        unitofmeasre.SetRange("Code", SalesLine."Unit of Measure Code");
                        if unitofmeasre.FindFirst() then begin
                            SalesLine."Unit of Measure Code" := unitofmeasre."International Standard Code";
                        end;

                    end;

                }



                textelement(LineExtensionAmount1)
                {
                    NamespacePrefix = 'cbc';
                    XmlName = 'LineExtensionAmount';
                    fieldattribute(currencyID; Invoice."Currency Code")
                    {

                    }
                    trigger OnBeforePassVariable()
                    begin
                        LineExtensionAmount1 := Format(SalesLine.Amount, 0, 1);
                    end;

                }
                textelement(Item)
                {
                    NamespacePrefix = 'cac';
                    fieldelement(Description; SalesLine.Description)
                    {
                        NamespacePrefix = 'cbc';

                    }
                    fieldelement(Name; SalesLine.Description)
                    {
                        NamespacePrefix = 'cbc';
                    }
                    textelement(ClassifiedTaxCategory)
                    {
                        NamespacePrefix = 'cac';
                        textelement(ID1)
                        {
                            XmlName = 'ID';
                            NamespacePrefix = 'cbc';
                            // trigger OnBeforePassVariable()
                            // var
                            //     vatpos: Record "VAT Posting Setup";
                            // begin
                            //     vatpos.SetRange("VAT Bus. Posting Group", SalesLine."VAT Bus. Posting Group");
                            //     if vatpos.FindFirst() then begin
                            //         ID1 := vatpos."E-Inv VAT Category";
                            //     end;


                            // end;
                        }
                        fieldelement(Percent; SalesLine."VAT %")
                        {
                            NamespacePrefix = 'cbc';
                        }


                        textelement(TaxScheme4)
                        {
                            XmlName = 'TaxScheme';
                            NamespacePrefix = 'cac';
                            textelement(ID6)
                            {
                                NamespacePrefix = 'cbc';
                                XmlName = 'ID';
                                trigger OnBeforePassVariable()
                                begin
                                    ID6 := 'VAT';
                                end;
                            }
                        }
                    }
                }
                textelement(Price)
                {
                    NamespacePrefix = 'cac';
                    textelement(PriceAmount)
                    {
                        NamespacePrefix = 'cbc';
                        fieldattribute(currencyID; Invoice."Currency Code")
                        {

                        }
                        trigger OnBeforePassVariable()
                        begin
                            PriceAmount := Format(SalesLine."Unit Price", 0, 1);
                        end;
                    }
                }

                // textelement(testid)
                // {
                //     trigger OnBeforePassVariable()
                //     begin
                //         SalesLine.SetRange("Document No.", Invoice."No.");
                //         if SalesLine.FindSet() then begin

                //             SalesLine."Line No." := SalesLine."Line No.";
                //         end;
                //     end;
                // }


                // trigger OnAfterGetRecord()
                // var
                //     i: Integer;
                // begin
                //     i := 0;
                //     //SalesLine.Get();
                //     SalesLine.SetRange("Document No.", Invoice."No.");
                //     if SalesLine.FindSet()
                //     then
                //         repeat
                //             i := i + 1;
                //             testid := Format(i);
                //         until SalesLine.Next() = 0;
                // end;
                trigger OnAfterGetRecord()

                begin
                    Filename := Invoice."No.";
                    SerialNo := SerialNo + 1;
                end;
            }
        }

    }
    // }
    // requestpage
    // {
    //     SaveValues = false;
    //     layout
    //     {
    //         area(content)
    //         {
    //             // group(GroupName)
    //             // {
    //             //     field("No."; Invoice."No.")
    //             //     {
    //             //         ApplicationArea = Basic, Suite;
    //             //         Caption = 'No.';

    //             //         ToolTip = 'Specifies the posting date for the invoice(s) that the batch job creates. This field must be filled in.';
    //             //     }
    //             // }
    //         }
    //     }

    //     actions
    //     {
    //         area(processing)
    //         {

    //         }
    //     }
    // }
    var
        rep: Report 1306;
        xm: XmlPort "Export Contact";
        rec: Record 112;
        recor: Record 204;
        localTextConst: TextConst ENU = 'CONST';
        co: Codeunit 229;
        re: Report 296;
        f: Record 79;
        page: Page 133;
        ddv: Page 132;
        SerialNo: Integer;
        repjlk: Report 1306;
}
