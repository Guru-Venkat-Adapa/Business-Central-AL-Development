pageextension 50050 "Business Mang Role Center Ext" extends "Business Manager Role Center"
{
    layout
    {
        modify("Intercompany Activities")
        {
            Visible = false;
        }
        modify(Control46)
        {
            Visible = false;
        }

#if SHOPIFY
modify(ShpfyActivities)
{
    Visible = false;
}
#endif

    }
}
