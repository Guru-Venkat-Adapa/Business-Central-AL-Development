codeunit 50102 "Purchase Chart"
{
    procedure getUserIdforperioditem(): Text
    var
        user: Record "Item Chart";
    begin
        user.SetRange("User ID", Database.UserId);
        user.SetRange("Company Name", Database.CompanyName);
        if not user.FindSet() then begin
            user.Init();
            user."User ID" := Format(Database.UserId);
            user."Company Name" := Format(Database.CompanyName);
            user."Chart Type" := user."Chart Type"::Column;
            user.Insert(true);
            exit(User."User ID");
        end else
            exit(user."User ID");
    end;

    procedure getUserIdforperiodsales(): Text
    var
        user: Record "Item Chart";
    begin
        user.SetRange("User ID", Database.UserId);
        user.SetRange("Company Name", Database.CompanyName);
        if not user.FindSet() then begin
            user.Init();
            user."User ID" := Format(Database.UserId);
            user."Company Name" := Format(Database.CompanyName);
            user."Chart Type" := user."Chart Type"::Column;
            user.Insert(true);
            exit(User."User ID");
        end else
            exit(user."User ID");
    end;
}