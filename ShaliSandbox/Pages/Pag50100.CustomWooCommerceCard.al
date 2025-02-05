page 50100 "Woo Commerce card"
{
    Caption = 'Woocommerce Connector Setup';
    SourceTable = "Custom Woo Commerce";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field(Code; Rec.Code)
                {
                }
                field("Woo Webstore URL"; Rec."Webstore URL")
                {
                }
                field("Woo Service URL"; Rec."Service URL")
                {
                }
                field("Woo Consumer Key"; Rec."Consumer Key")
                {
                }
                field("Woo Consumer Secret"; Rec."Consumer Secret")
                {
                }
                field("API Key as Query Param"; Rec."API Key as Query Param")
                {
                }
                group(SynchronizationJobs)
                {
                    Caption = 'Synchronization';

                    field("Woo Enabled"; Rec."Enabled")
                    {
                    }
                    field(ScheduledSynchJobsActive; ScheduledSynchJobsRunning)
                    {
                        Caption = 'Active Jobs';
                    }
                    field("No. of Minutes between Runs"; Rec."No. of Minutes between Runs")
                    {
                    }
                    field("Activity Log Retention Period"; Rec."Activity Log Retention Period")
                    {
                    }
                    field("Last Sales Order Date Created"; Rec."Last Sales Order Date Created")
                    {
                        ObsoleteState = Pending;
                        ObsoleteReason = 'Field is no longer in use. Replaced by Last Sales Order Date Modified';
                        ObsoleteTag = '21.4.0.0';
                        Caption = 'Last Sales Order Date Created';
                        Visible = false;
                    }
                    field("Last Sales Order Date Modified"; Rec."Last Sales Order Date Modified")
                    {
                        Caption = 'Last Sales Order Date Modified';
                    }
                    field("Webstore List Cache Time"; Rec."Webstore List Cache Time")
                    {
                    }
                }
                field(LearnMore; LearnMoreLbl)
                {
                }
            }
            group(Posting)
            {
                Caption = 'Posting';

                group(Customer)
                {
                    Caption = 'Customer';

                    field("Customer Template Code"; Rec."Customer Template Code")
                    {
                        Caption = 'Default Customer Template';
                    }
                    field("Default Customer No."; Rec."Default Customer No.")
                    {
                    }
                    field("Woo Default Guest Customer No."; Rec."Default Guest Customer No.")
                    {
                    }
                    field("Customer Role Filter"; Rec."Customer Role Filter")
                    {
                    }
                }
                group(Inventory)
                {
                    Caption = 'Inventory';

                    field("Item Template Code"; Rec."Item Template Code")
                    {
                        Caption = 'Default Item Template';
                    }
                    field("Woo Default Location Code"; Rec."Default Location Code")
                    {
                    }
                    field("Item Nos. Type"; Rec."Item Nos. Type")
                    {
                    }
                    group(ItemNos)
                    {
                        Visible = true;

                        field("Item Nos."; Rec."Item Nos.")
                        {
                        }
                    }
                    group(ItemDimensions)
                    {
                        field("Length Attribute Name"; Rec."Length Attribute Name")
                        {
                            ObsoleteState = Pending;
                            ObsoleteReason = 'Product dimensions are no longer used as attributes.';
                            ObsoleteTag = '21.4';
                            Visible = false;
                        }
                        field("Width Attribute Name"; Rec."Width Attribute Name")
                        {
                            ObsoleteState = Pending;
                            ObsoleteReason = 'Product dimensions are no longer used as attributes.';
                            ObsoleteTag = '21.4';
                            Visible = false;
                        }
                        field("Height Attribute Name"; Rec."Height Attribute Name")
                        {
                            ObsoleteState = Pending;
                            ObsoleteReason = 'Product dimensions are no longer used as attributes.';
                            ObsoleteTag = '21.4';
                            Visible = false;
                        }
                    }
                    group(ItemWeight)
                    {
                        Caption = 'Item Webstore Weight';

                        field("Webstore Weight"; Rec."Webstore Weight")
                        {
                            Caption = 'Webstore Weight';
                        }
                    }
                    field("Regular Price"; Rec."Regular Price")
                    {
                    }
                    group(CustomerPriceGroup)
                    {
                        Visible = true;

                        field("Customer Price Group"; Rec."Customer Price Group")
                        {
                        }
                    }
                    field("Marketing Text"; Rec."Marketing Text")
                    {
                    }
                }
                group(SalesOrder)
                {
                    Caption = 'Order';

                    field("Order Nos. Type"; Rec."Order Nos. Type")
                    {
                    }
                    group(OrderNos)
                    {
                        Visible = true;

                        field("Order Nos."; Rec."Order Nos.")
                        {
                        }
                    }
                    field("Sales Tax Account No."; Rec."Sales Tax Account No.")
                    {
                    }
                    field("Shipping Acount Type"; Rec."Shipping Acount Type")
                    {
                    }
                    field("Shipping Account No."; Rec."Shipping Account No.")
                    {
                    }
                    field("Default Document Date"; Rec."Default Document Date")
                    {
                    }
                    field("Default Posting Date"; Rec."Default Posting Date")
                    {
                    }
                    field("Complete Webstore Orders"; Rec."Complete Webstore Orders")
                    {
                        Caption = 'Complete Webstore Orders';
                    }
                    field("Webstore Status Filter"; Rec."Webstore Status Filter")
                    {
                        Caption = 'Webstore Status Filter';
                    }
                    field("Customer Note Sync"; Rec."Customer Note Sync")
                    {
                        Caption = 'Customer Note Sync';
                    }
                }
                group(Coupon)
                {
                    Caption = 'Coupon';

                    field("Coupon Nos."; Rec."Coupon Nos.")
                    {
                    }
                }
            }
            group(Syncronization)
            {
                Caption = 'Synchronization';

                group(PushToWebstore)
                {
                    Caption = 'Push Data to Webstore';

                    field("Push Webstore Items"; Rec."Push Webstore Items")
                    {
                        Caption = 'Items';
                    }
                    field("Push Webstore Item Categories"; Rec."Push Webstore Item Categories")
                    {
                        Caption = 'Item Categories';
                    }
                    field("Push Webstore Customers"; Rec."Push Webstore Customers")
                    {
                        Caption = 'Customers';
                    }
                    field("Push Webstore Coupons"; Rec."Push Webstore Coupons")
                    {
                        Caption = 'Coupons';
                    }
                }
                group(PullFromWebstore)
                {
                    Caption = 'Pull Data from Webstore';

                    field("Pull Webstore Items"; Rec."Pull Webstore Items")
                    {
                        Caption = 'Items';
                    }
                    field("Pull Webstore Item Categories"; Rec."Pull Webstore Item Categories")
                    {
                        Caption = 'Item Categories';
                    }
                    field("Web. Customer Sync."; Rec."Pull Webstore Customers")
                    {
                        Caption = 'Customers';
                    }
                    field("Pull Webstore Coupons"; Rec."Pull Webstore Coupons")
                    {
                        Caption = 'Coupons';
                    }
                    field("Pull Webstore Orders"; Rec."Pull Webstore Orders")
                    {
                        Caption = 'Orders';
                    }
                    field("Pull Webstore Return Orders"; Rec."Pull Webstore Return Orders")
                    {
                        Caption = 'Return Orders';
                    }
                }
                group("Synchronization Start Date")
                {
                    Caption = 'Pull Synchronization Start Date';

                    field("Woo Order Sync. Start Date"; Rec."Order Sync. Start Date")
                    {
                        Caption = 'Order';
                    }
                    field("Item Sync. Start Date"; Rec."Item Sync. Start Date")
                    {
                        Caption = 'Item';
                    }
                    field("Coupon Sync. Start Date"; Rec."Coupon Sync. Start Date")
                    {
                        Caption = 'Coupon';
                    }
                }
            }
            group(Status)
            {
                Caption = 'Status';

                fixed(Statistics)
                {
                    group(GroupData)
                    {
                        Caption = 'Data';

                        field("Woo Webstore Items"; Rec."Webstore Items")
                        {
                            Caption = 'Items';
                        }
                        field("Woo Webstore Customers"; Rec."Webstore Customers")
                        {
                            Caption = 'Customers';
                        }
                        field("Woo Webstore Coupons"; Rec."Webstore Coupons")
                        {
                            Caption = 'Coupons';
                        }
                        field("Woo Sales Orders - Synced"; Rec."Sales Orders - Synced")
                        {
                            Caption = 'Orders';
                        }
                        field("Woo Return Orders"; Rec."Return Orders")
                        {
                            Caption = 'Return Orders';
                        }
                    }
                    group(Logs)
                    {
                        Caption = 'Latest Logs';

                        field("Woo Item Sync. Logs"; Rec."Item Sync. Logs")
                        {
                            Caption = 'Items';
                        }
                        field("Woo Customer Sync. Logs"; Rec."Customer Sync. Logs")
                        {
                            Caption = 'Customers';
                        }
                        field("Woo Coupon Sync. Logs"; Rec."Coupon Sync. Logs")
                        {
                            Caption = 'Coupons';
                        }
                        field("Woo Order Sync. Logs"; Rec."Order Sync. Logs")
                        {
                            Caption = 'Orders';
                        }
                        field("Woo Return Order Sync. Logs"; Rec."Return Order Sync. Logs")
                        {
                            Caption = 'Return Orders';
                        }
                    }
                    group(Errors)
                    {
                        Caption = 'Latest Errors';

                        field("Woo Item Sync. Errors"; Rec."Item Sync. Errors")
                        {
                            Caption = 'Items';
                        }
                        field("Woo Customer Sync. Errors"; Rec."Customer Sync. Errors")
                        {
                            Caption = 'Customers';
                        }
                        field("Woo Coupon Sync. Errors"; Rec."Coupon Sync. Errors")
                        {
                            Caption = 'Coupons';
                        }
                        field("Woo Order Sync. Errors"; Rec."Order Sync. Errors")
                        {
                            Caption = 'Orders';
                        }
                        field("Woo Return Order Sync. Errors"; Rec."Return Order Sync. Errors")
                        {
                            Caption = 'Return Orders';
                        }
                    }
                    group(LastSyncTime)
                    {
                        Caption = 'Last Synced';

                        field("Woo Item Last Sync."; Rec."Item Last Synced")
                        {
                            Caption = 'Items';
                        }
                        field("Woo Customer Last Sync."; Rec."Customer Last Synced")
                        {
                            Caption = 'Customers';
                        }
                        field("Woo Coupon Last Sync."; Rec."Coupon Last Synced")
                        {
                            Caption = 'Coupons';
                        }
                        field("Woo Order Last Sync."; Rec."Order Last Synced")
                        {
                            Caption = 'Orders';
                        }
                        field("Woo Return Order Last Sync."; Rec."Return Order Last Synced")
                        {
                            Caption = 'Return Orders';
                        }
                    }
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Assisted Setup")
            {
                Visible = false;
                Caption = 'Add Store';
            }
            action(WooSynchronize)
            {
                Caption = 'Synchronize';
            }
            action(TestConnection)
            {
                Caption = 'Test Connection';
            }
            action(JobQueueEntry)
            {
                Caption = 'Job Queue Entry';
            }
            action(RescheduleJobQueueEntries)
            {
                Caption = 'Reschedule Job Queue Entries';
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
                Caption = 'Webstore Sales Orders';
            }
            action(WebstoreCouponList)
            {
                Caption = 'Webstore Coupon List';
            }
            action(OrderFeeLines)
            {
                Caption = 'Order Fee Lines';
            }
            action(CustomerPortal)
            {
                Caption = 'Customer Portal';
                Visible = true;
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
        area(Navigation)
        {
            action(WooActivityLog)
            {
                Caption = 'Activity Log';
            }
            action(WooSalesOrderLog)
            {
                Caption = 'Sales Order Log';
            }
            action(EncryptionManagement)
            {
                Caption = 'Encryption Management';
            }
        }
    }
    var
        ScheduledSynchJobsRunning: Text;
        ScheduledSynchJobsRunningStyleExpr: Text;
        ItemSynchJobsActivityLogErrorsStyleExpr: Text;
        CustomerSynchJobsActivityLogErrorsStyleExpr: Text;
        CouponSynchJobsActivityLogErrorsStyleExpr: Text;
        OrderSynchJobsActivityLogErrorsStyleExpr: Text;
        ReturnOrderSynchJobsActivityLogErrorsStyleExpr: Text;
        ItemSynchJobsActivitySuccessLogsStyleExpr: Text;
        CustomerSynchJobsActivitySuccessLogsStyleExpr: Text;
        CouponSynchJobsActivitySuccessLogsStyleExpr: Text;
        OrderSynchJobsActivitySuccessLogsStyleExpr: Text;
        ReturnOrderSynchJobsActivitySuccessLogsStyleExpr: Text;
        ReschedulePartialSynchJobsQst: Label '';
        RescheduleAllSynchJobsQst: Label '';
        SetupIsNotEnabledMsg: Label '';
        ReadyScheduledSynchJobsTok: Label '';
        AllScheduledJobsAreRunningMsg: Label '';
        LearnMoreLbl: Label '';
        ActiveJobs: Integer;
        TotalJobs: Integer;
        OrderNosVisibility: Boolean;
        ItemNosVisibility: Boolean;
        CustomerPortalVisibility: Boolean;
        CustomerPriceGroupVisibility: Boolean;
}