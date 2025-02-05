codeunit 50105 "Upgrade Codeunit"
{
    Subtype=Upgrade;
    trigger OnUpgradePerCompany()
    var
    customercategory:Record "Customer Category";
    module :ModuleInfo;
    begin
        NavApp.GetCurrentModuleInfo(module);
        if module.DataVersion.Major=1 then begin
            if customercategory.Get('WARNING') then begin
                customercategory.Rename('BAD');
                customercategory.Description:='Bad Customer';
                customercategory.Modify();
            end;
        end;
    end;
}