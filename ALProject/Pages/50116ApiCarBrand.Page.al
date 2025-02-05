page 50116 "Api Car Brand"
{
    PageType = API;
    Caption = 'Api Car Brand';
    APIPublisher = 'ShaligramInfotech';
    APIGroup = 'Guru';
    APIVersion = 'v1.0';

    EntityName = 'carBrand';
    EntityCaption = 'CarBrand';
    EntitySetName = 'carBrands';
    EntitySetCaption = 'CarBrands';

    SourceTable = "Car Brand";
    DelayedInsert = true;
    Extensible = false;
    ODataKeyFields = SystemId;

    layout
    {
        area(Content)
        {
            repeater(Control)
            {
                field(SystemId; Rec.SystemId)
                {
                    Caption = 'Id';
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    Caption = 'Name';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    Caption = 'Description';
                    ApplicationArea = All;
                }
                field(country; Rec.country)
                {
                    Caption = 'Country';
                    ApplicationArea = All;
                }
            }
            part(carmodels; "Api Car Model")
            {
                Caption = 'Car Models';
                EntityName = 'carModel';
                EntitySetName = 'carModels';
                SubPageLink = brandid = field(SystemId);
            }
        }
    }
}