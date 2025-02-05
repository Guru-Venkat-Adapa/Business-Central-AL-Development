page 50101 ClientIPPage

{

    pageType = card;
    ApplicationArea = All;
    Caption = 'Client IP';
    SourceTable = Customer;
    UsageCategory = Administration;

    layout

    {

        area(content)

        {

            group(Group)

            {


                // control(IPControl; MyControlAddIn)

                // {

                //     ApplicationArea = All;

                //     trigger OnControlAddInMessage(Message: Text; Value: Text)

                //     begin

                //         if Message = 'clientIp' then

                //             Message('Client IP: %1', Value);  // Display the client IP

                //     end;

                // }
                // usercontrol(MyControl_AddIn; MyControlAddIn)
                // {
                //     ApplicationArea = All;
                //     trigger IAmReady()
                //     begin
                //         CurrPage.MyControl_AddIn.getClientIP();
                //     end;

                // }

            }

        }

    }
    actions
    {
        // area(Processing)
        // {
        //     action(GetUserControl)
        //     {
        //         ApplicationArea=All;
        //         trigger OnAction()
        //         begin
        //         end;
        //     }
        // }
    }

    trigger OnOpenPage()

    var

    begin

    end;

}