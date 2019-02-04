controladdin DemoD365BCAddin
{
    RequestedHeight = 300;
    MinimumHeight = 300;
    MaximumHeight = 300;
    RequestedWidth = 700;
    MinimumWidth = 250;
    MaximumWidth = 700;
    VerticalStretch = true;
    VerticalShrink = true;
    HorizontalStretch = true;
    HorizontalShrink = true;
    Scripts = 'Scripts/main.js';
    StyleSheets = 'CSS/stylesheet.css';
    StartupScript = 'Scripts/start.js';
    //RecreateScript = 'recreateScript.js';
    //RefreshScript = 'refreshScript.js';
    Images = 'Images/Avatar.png';

    event ControlReady()

    procedure HelloWorld()
}