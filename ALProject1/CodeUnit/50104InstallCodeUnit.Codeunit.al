codeunit 50104 "Installation Codeunit"
{
    Subtype = Install;
    trigger OnInstallAppPerCompany()
    var
        archeviedVersion: Text;
        customercategory: Record "Customer Category";
    begin
        archeviedVersion := NavApp.GetArchiveVersion();
        if archeviedVersion = '1.0.0.0' then begin
            NavApp.RestoreArchiveData(Database::"Customer Category");
            NavApp.RestoreArchiveData(Database::Customer);
            NavApp.DeleteArchiveData(Database::"Customer Category");
            NavApp.DeleteArchiveData(Database::Customer);
        end;
        if customercategory.IsEmpty() then
        InsertDefaultCustomerCategory();
    end;
    procedure InsertDefaultCustomerCategory()
    begin
        InsertCustomerCategory('TOP','Top Customer');
        InsertCustomerCategory('MEDIUM','Standard Customer');
        InsertCustomerCategory('BAD','Bad Customer');
    end;
    procedure InsertCustomerCategory(id:Code[20];description :Text[200])
    var
    customercategory:Record "Customer Category";
    begin
        customercategory.Init();
        customercategory.No:=id;
        customercategory.Description:=description;
        customercategory.Insert();
    end;

    var 
    // data:Report "Customer - Top 10 List";
}