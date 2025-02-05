controladdin "image import"
{
    MaximumHeight = 720;
    MinimumHeight = 400;
    MaximumWidth = 1920;
    MinimumWidth = 360;
    VerticalStretch = true;
    VerticalShrink = true;
    HorizontalStretch = true;
    HorizontalShrink = true;

    Scripts = 'UserControl/script.js';
    StyleSheets = 'UserControl/style.css';

    event Ready()
    procedure Initializeimage(html: Text)

    // event Sign(Signature: Text)
}