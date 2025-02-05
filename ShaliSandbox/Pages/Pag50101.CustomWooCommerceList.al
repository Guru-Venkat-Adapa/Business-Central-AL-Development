page 50101 "Woo Commerce List"
{
    Caption = 'Woo Commerece List';
    SourceTable = "Custom Woo Commerce";
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = "Woo Commerce card";
    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field(Code; Rec.Code)
                {
                }
                field("Woo Webstore URL"; Rec."Webstore URL")
                {
                }
                field("Woo Enabled"; Rec."Enabled")
                {
                }
                field("Woo Default Location Code"; Rec."Default Location Code")
                {
                    Visible = false;
                }
                field("Item Template Code"; Rec."Item Template Code")
                {
                    Caption = 'Default Item Template';
                    Visible = false;
                }
                field("Customer Template Code"; Rec."Customer Template Code")
                {
                    Caption = 'Default Customer Template';
                    Visible = false;
                }
                field("Last Sales Order Date Created"; Rec."Last Sales Order Date Created")
                {
                    ObsoleteState = Pending;
                    ObsoleteReason = 'Field no longer used. Replaced by Last Sales Order Date Modified';
                    ObsoleteTag = '21.4.0.0';
                    Visible = false;
                }
                field("Last Sales Order Date Modified"; Rec."Last Sales Order Date Modified")
                {
                    Visible = false;
                }
                field("Push Webstore Items"; Rec."Push Webstore Items")
                {
                    Caption = 'Items';
                    Visible = false;
                }
                field("Pull Webstore Items"; Rec."Pull Webstore Items")
                {
                    Caption = 'Items';
                    Visible = false;
                }
                field("Push Webstore Item Categories"; Rec."Push Webstore Item Categories")
                {
                    Caption = 'Item Categories';
                    Visible = false;
                }
                field("Pull Webstore Item Categories"; Rec."Pull Webstore Item Categories")
                {
                    Caption = 'Item Categories';
                    Visible = false;
                }
                field("Push Webstore Customers"; Rec."Push Webstore Customers")
                {
                    Caption = 'Customers';
                    Visible = false;
                }
                field("Web. Customer Sync."; Rec."Pull Webstore Customers")
                {
                    Caption = 'Customers';
                    Visible = false;
                }
                field("Pull Webstore Orders"; Rec."Pull Webstore Orders")
                {
                    Caption = 'Orders';
                    Visible = false;
                }
            }
        }
        area(FactBoxes)
        {
            part("Synchronization Jobs"; "Woo Synch. Logs FactBox")
            {
            }
            part("Webstore Details"; "Woo Web. Con. Details FactBox")
            {
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Assisted Setup")
            {
                Caption = 'Add Store';
            }
            action(TestConnection)
            {
                Caption = 'Test Connection';
            }
            action(WooSynchronize)
            {
                Caption = 'Synchronize';
            }
            action(JobQueueEntry)
            {
                Caption = 'Job Queue Entry';
            }
            action(RescheduleJobQueueEntries)
            {
                Caption = 'Reschedule Job Queue Entries';
            }
            action(WooActivityLog)
            {
                Caption = 'Activity Log';
            }
            action(WooSalesOrderLog)
            {
                Caption = 'Sales Order Log';
            }
            action(WebstoreItemMapping)
            {
                Caption = 'Webstore Item Mapping';
            }
            action(WebstoreCustomerMapping)
            {
                Caption = 'Webstore Customer Mapping';
            }
            action(WebstoreItemCategoryMapping)
            {
                Caption = 'Webstore Item Category Mapping';
            }
            action(WebstoreItemAttribureMapping)
            {
                Caption = 'Webstore Item Attribute Mapping';
            }
            action(WebstoreSalesOrders)
            {
                Caption = 'Webstore Sales Order List';
            }
            action(DefaultCountryRegionSettings)
            {
                Caption = 'Default Country/Region Settings';
            }
            action(OrderPayment)
            {
                Caption = 'Webstore Payment Methods';
            }
        }
    }

    var
        demo: Page 70178836;
        demo1: Page 70178837;
        demo2: Record 70178832;
}