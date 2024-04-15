// table 50114 "State2"
// {
//     DataClassification = ToBeClassified;

//     fields
//     {
//         field(1; SlNo; Integer)
//         {
//             DataClassification = CustomerContent;
//             Caption = 'Sl No.';
//         }
//         field(2; Stateid; Integer)
//         {
//             DataClassification = CustomerContent;
//             Caption = 'State Id';
//         }
//         field(3; StateName; Text[100])
//         {
//             DataClassification = CustomerContent;
//             Caption = 'State Name';
//         }
//         field(4; CountryId; Integer)
//         {
//             DataClassification = CustomerContent;
//             Caption = 'Country Name';
//             TableRelation = Country;
//         }
//     }

//     keys
//     {
//         key(Key1; Stateid)
//         {
//             Clustered = true;
//         }
//     }
// }