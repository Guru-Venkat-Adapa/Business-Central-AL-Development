namespace Toshvin.Toshvin;
using Microsoft.HumanResources.Employee;

codeunit 50003 UserAuthentication
{
    SingleInstance = true;

    var
        NoSeriesCode: Code[20];

    procedure SetNoSeries(NewNoSeries: Code[20])
    begin
        NoSeriesCode := NewNoSeries;
    end;

    procedure GetNoSeries(): Code[20]
    begin
        exit(NoSeriesCode);
    end;

    procedure ClearBuffer()
    begin
        Clear(NoSeriesCode);
    end;


    // procedure CheckUserAuthentication(userName: Text[30]; password: Text[30]): Text
    // var
    //     Employee: Record Employee;
    //     EmployeeJson: JsonObject;
    //     ResponseJson: JsonObject;
    //     Result: Text;
    //     EmpJsonText: Text;
    //     Manager: Boolean;
    //     Dimension: Codeunit "Smart Search API";
    // //DimValue: Record "Dimension Value";
    // begin
    //     if userName = '' then
    //         Error('Username must not be blank.');

    //     if password = '' then
    //         Error('Password must not be blank.');

    //     Employee.Reset();
    //     Employee.SetRange("User ID", userName);
    //     if not Employee.FindFirst() then
    //         Error('Username Invalid.');

    //     // Employee.Reset();
    //     // Employee.SetRange(Password, password);
    //     // if not Employee.FindFirst() then
    //     //     Error('Invalid password.');

    //     if Employee."Password" <> password then
    //         Error('Invalid password.');

    //     if Employee."Approver Manager" then begin
    //         // Build employee JSON
    //         EmployeeJson.Add('EmpId', Employee."No.");
    //         EmployeeJson.Add('EmpName', Employee."First Name" + ' ' + Employee."Last Name");
    //         EmployeeJson.Add('EmpDesignation', Employee."Job Title");
    //         EmployeeJson.Add('ApproverManager', True);
    //         EmployeeJson.Add('department', Dimension.GetEmployeeDepartmentDimesion(Employee."Global Dimension 1 Code"));
    //         EmployeeJson.Add('region', Dimension.GetEmployeeRegionDimesion(Employee."Global Dimension 2 Code"));
    //         // DimValue.Reset();
    //         // DimValue.SetRange("Dimension Code", 'DEPARTMENT');
    //         // DimValue.SetRange(Code, Employee."Global Dimension 1 Code");
    //         // if DimValue.FindFirst() then
    //         //     EmployeeJson.Add('department', DimValue.Name);

    //         // DimValue.Reset();
    //         // DimValue.SetRange("Dimension Code", 'REGION');
    //         // DimValue.SetRange(Code, Employee."Global Dimension 2 Code");
    //         // if DimValue.FindFirst() then
    //         //     EmployeeJson.Add('region', DimValue.Name);

    //     end else begin
    //         // Build employee JSON
    //         EmployeeJson.Add('EmpId', Employee."No.");
    //         EmployeeJson.Add('EmpName', Employee."First Name" + ' ' + Employee."Last Name");
    //         EmployeeJson.Add('EmpDesignation', Employee."Job Title");
    //         EmployeeJson.Add('ApproverManager', false);
    //         EmployeeJson.Add('department', Dimension.GetEmployeeDepartmentDimesion(Employee."Global Dimension 1 Code"));
    //         EmployeeJson.Add('region', Dimension.GetEmployeeRegionDimesion(Employee."Global Dimension 2 Code"));
    //     end;
    //     // Build final response
    //     ResponseJson.Add('value', 'Authentication successful.');
    //     ResponseJson.Add('user', EmployeeJson);

    //     ResponseJson.WriteTo(Result);
    //     exit(Result);
    // end;

}
