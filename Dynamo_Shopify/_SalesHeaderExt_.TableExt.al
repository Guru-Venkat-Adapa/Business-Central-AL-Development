tableextension 50102 "SalesHeaderExt" extends "Sales Header"
{
    fields
    {
        // Add changes to table fields here
        field(50101; "Sent Order Confirmation"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50102; "Tracking reference No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50103; "Delivery Status Send"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50104; "Tacking Type";Enum "Tracking Type")
        {
            DataClassification = ToBeClassified;
        }
        field(50105; "Order Margin"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50106; "Customer Type"; Option)
        {
            OptionMembers = Clear, "Personal In-Store", Wholsale, "Personal Online", "Commercial In-Store", "Commercial Online";
            DataClassification = ToBeClassified;
        }
        field(50107; "Referral Source"; Option)
        {
            OptionMembers = Clear, "Need To Ask", "Afterpay Referral", Amazon, "Cart Abandonment", Catch, "Commercial Prospecting", "Cross fit Games Stand", "Deal/Coupon Website", "Dynamo+", Ebay, "Email Marketing", Facebook, "FB Marketplace", "Friend Of a Friend", "Google Ads", "Google Organic (Not Paid Ads)", Gumtree, Humm, Instagram, "Kogan Marketplace", "My Deal", "MyPThub App", Other, "Reeplex.com.au", "Referred by Friend", "Return Customer", Shopify, "Shopify Shop App", Snapchat, Tiktok, "Walk In From Sign", "Yopto Product Review", Youtube, Azpmoney;
            DataClassification = ToBeClassified;
        }
        field(50108; Stages; Option)
        {
            OptionMembers = "New-need processing", "Awaiting Payment", "Pending FraudLabs approvals", "Needs Third Party Shipping", "Third party Shipping Awaiting Pick Up", "On local delivery-Need to inform customer", "On local delivery-customer informed READY", "Prapare Pick Ups", "Needs Pickup", "Warranty - Parts and Servicing", "Waiting for Stock", "Local Installation - TIME REQUIRED", "Local Installation - TIME SET", "Commercial Installation - TIME REQUIRED", "Commercial Installation - TIME SET", "On Hold", "READ Internal Comments Multiple actions", "Dispatched", "Pre-orders", "Pre-orders-Awaiting Payment", "Release To Pick-WMS", "Ready To Pack-WMS", "Partially Picked";
            DataClassification = ToBeClassified;
        }
        field(50109; "Payment Received %"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }
}
