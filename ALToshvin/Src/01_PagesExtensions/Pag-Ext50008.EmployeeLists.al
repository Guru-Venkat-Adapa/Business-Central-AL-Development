pageextension 50008 EmployeeLists extends "Employee List"
{
    layout
    {
        addafter("No.")
        {
            field("CRM Employee ID"; Rec."CRM Employee ID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the CRM Employee ID field.';
            }
        }
    }
    actions
    {
        addafter("Sent Emails")
        {
            action(CopyCRMEmployeeID)
            {
                ApplicationArea = All;
                Caption = 'DND';
                Image = Copy;
                ToolTip = 'DND';
                Promoted = true;

                trigger OnAction()
                var
                    Emp: Record Employee;
                    FirstLetter: Text[1];
                    NewPassword: Text;
                begin
                    if not Confirm('This will update passwords for all employees. Do you want to continue?') then
                        exit;
                    Emp.Reset();
                    if Emp.FindSet() then
                        repeat
                            Emp."User ID" := Emp."Company E-Mail";
                            if (Emp."First Name" <> '') and (Emp."Last Name" <> '') then begin
                                FirstLetter := LowerCase(CopyStr(Emp."First Name", 1, 1));
                                NewPassword := FirstLetter + LowerCase(Emp."Last Name") + '@123';
                                Emp.Password := NewPassword;
                                Emp."Original Password" := NewPassword;
                                Emp.Modify(false);
                            end;
                        until Emp.Next() = 0;
                    Message('Passwords updated for all employees.');
                end;
            }
        }
    }
}
