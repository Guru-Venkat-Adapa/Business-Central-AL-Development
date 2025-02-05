tableextension 50113 SalesInHdr extends "Sales Invoice Header"
{
    fields
    {
        field(50001; "Tracking refrance No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }
}
