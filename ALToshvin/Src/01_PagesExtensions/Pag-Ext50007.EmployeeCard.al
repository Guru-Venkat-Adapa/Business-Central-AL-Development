pageextension 50007 EmployeeCard extends "Employee Card"
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

        addafter(General)
        {
            group("User Authentication")
            {
                Caption = 'User Authentication';
                Visible = false;
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Password; Rec.Password)
                {
                    ApplicationArea = all;
                    Editable = EditPermission;

                    trigger OnValidate()
                    var
                        Email: Codeunit "Email";
                        EmailMessage: Codeunit "Email Message";
                        BodyText: Text;
                        ToAddress: Text;
                    begin
                        if xRec.Password <> Rec.Password then begin
                            if not Confirm('Do you want to change the password?', true) then begin
                                Rec.Password := xRec.Password; // Revert the value
                                Rec."Original Password" := xRec.Password;
                                CurrPage.Update(false); // Refresh page without saving changes
                                exit;
                            end;

                            // Only update Original Password if new password is not blank
                            if Rec.Password <> '' then begin
                                Rec."Original Password" := Rec.Password;

                                ToAddress := Rec."Company E-Mail";
                                if ToAddress <> '' then begin
                                    BodyText :=
                                        'Dear ' + Rec."First Name" + ' ' + Rec."Last Name" + ',' + '<br/><br/>' +
                                        'We would like to inform you that your password has been successfully updated by the Admin.' + '<br/><br/>' +
                                        '<b>New Password:</b> ' + Rec.Password + '<br/><br/>' +
                                        'Best regards,' + '<br/>' +
                                        'Toshvin Analytical Pvt. Ltd.';

                                    EmailMessage.Create(ToAddress, 'Password Change Notification', BodyText, true);
                                    if Email.OpenInEditorModally(EmailMessage, Enum::"Email Scenario"::Default) = Enum::"Email Action"::Sent then
                                        Message('Email sent.');
                                end;
                            end else begin
                                // If password was cleared, don't update Original Password
                                Rec."Original Password" := Rec."Password"; // restore if needed
                            end;
                        end;
                    end;
                }
            }
        }


    }
    actions
    {
        addafter(PayEmployee)
        {
            action(DND)
            {
                ApplicationArea = All;
                Caption = 'DND';
                Promoted = true;
                Visible = false;

                trigger OnAction()
                var
                    UserAuthentication: Codeunit UserAuthentication;
                    Emp: Record Employee;
                begin
                    Emp.Reset();
                    if Emp.FindSet() then
                        repeat
                            Emp.Password := '';
                            Emp."Original Password" := '';
                            Emp.Modify();
                        until Emp.Next() = 0;
                    //UserAuthentication.CheckUserAuthentication('snambiar@toshvin.com', '12345');
                end;
            }
        }
    }


    trigger OnAfterGetRecord()
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then
            if UserSetup.Permission then
                EditPermission := true
            else
                EditPermission := false;
    end;

    var
        EditPermission: Boolean;
}
