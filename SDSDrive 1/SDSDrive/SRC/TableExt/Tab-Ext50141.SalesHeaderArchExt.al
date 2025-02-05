// tableextension 50160 "sales Header arc Ext" extends "Sales Header Archive"
// {
//     procedure SetWorkDescription(NewWorkDescription: Text)
//     var
//         OutStream: OutStream;
//     begin
//         Clear("Work Description");
//         "Work Description".CreateOutStream(OutStream, TEXTENCODING::UTF8);
//         OutStream.WriteText(NewWorkDescription);
//         Modify();
//     end;

//     procedure GetWorkDescription() WorkDescription: Text
//     var
//         TypeHelper: Codeunit "Type Helper";
//         InStream: InStream;
//     begin
//         CalcFields("Work Description");
//         "Work Description".CreateInStream(InStream, TEXTENCODING::UTF8);
//         exit(TypeHelper.TryReadAsTextWithSepAndFieldErrMsg(InStream, TypeHelper.LFSeparator(), FieldName("Work Description")));
//     end;

// }
