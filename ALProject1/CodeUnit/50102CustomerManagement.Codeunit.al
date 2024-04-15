codeunit 50102 "Customer Management"
{
    trigger OnRun()
    begin

    end;
    procedure DefaultCategory(CustomerCode: Code[20])
    begin
        Customer.Get(CustomerCode);
        CustomerCategory.SetRange(Default, true);
        if CustomerCategory.FindFirst() then begin
            Customer."Customer Category SDM" := CustomerCategory.No;
            Customer.Modify();
        end;
    end;
    procedure DefaultCategory()
    // var
    // Customer :Record Customer;
    // CustomerCategory:Record "Customer Category";
    begin
        CustomerCategory.SetRange(Default, true);
        if CustomerCategory.FindFirst() then begin
            if Customer.FindSet() then
                repeat
                    Customer."Customer Category SDM" := CustomerCategory.No;
                    Customer.Modify();
                until Customer.Next() = 0;
        end;
    end;
    procedure CreateDefaultCategory()
    begin
        CustomerCategory.No := 'DEFAULT';
        CustomerCategory.Description := 'Default Customer Category';
        CustomerCategory.Default := true;
        if CustomerCategory.Insert then;
    end;
    procedure GetTotalCustomerWithoutCategory(): Integer
    begin
        Customer.SetRange("Customer Category SDM", '');
        exit(Customer.Count());
    end;

    var
        Customer: Record Customer;
        CustomerCategory: Record "Customer Category";
}
