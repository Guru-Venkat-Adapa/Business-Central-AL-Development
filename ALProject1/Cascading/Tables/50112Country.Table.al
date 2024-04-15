// table 50112 Country
// {
//     DataClassification = ToBeClassified;
//     Caption='Country';
//     fields
//     {
//         field(1;"Sl No.";Integer)
//         {
//             DataClassification=CustomerContent;
//             Caption='Sl No.';
//         }
//         field(2;"Country Id"; Integer)
//         {
//             DataClassification = CustomerContent;
//             Caption='Country Id';
//         }
//         field(3;CountryName;Text[100])
//         {
//             DataClassification=CustomerContent;
//             Caption='Country Name';
//         }
//     }

//     keys
//     {
//         key(Key1; "Country Id")
//         {
//             Clustered = true;
//         }
//     }
// }