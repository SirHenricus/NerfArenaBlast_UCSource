class NerfPDAScreenControls extends NerfWindow;

var int ButtonLeft[3], ButtonTop, ButtonWidth, ButtonHeight;
var int ScreenTop;

//
// Controls
//

// Controls Button
var NerfButtonControl GeneralButton;
var localized string GeneralButtonText;
var localized string GeneralButtonHelp;

// Movement Controls Button
var NerfButtonControl MovementButton;
var localized string MovementButtonText;
var localized string MovementButtonHelp;

// 'Other' Controls Button
var NerfButtonControl OtherButton;
var localized string OtherButtonText;
var localized string OtherButtonHelp;

//
// Screens
//
var NerfPDAScreenControlsGeneral GeneralControlsScreen;
var NerfPDAScreenControlsMovement MovementControlsScreen;
var NerfPDAScreenControlsOther OtherControlsScreen;


function Created() 
{
	local Color TextColor;

	Super.Created();

	TextColor.R = 255;
	TextColor.G = 255;
	TextColor.B = 255;

	if (NerfRootWindow(Root).bPDALowRes)
	{
		// low-res version
		ButtonLeft[0]	= 14;
		ButtonLeft[1]	= 74;
		ButtonLeft[2]	= 138;
		ButtonTop		= 10;
		ButtonWidth		= 54;
		ButtonHeight	= 16;
		ScreenTop		= 30;
	}
	else
	{
		// high-res version
		ButtonLeft[0]	= 24;
		ButtonLeft[1]	= 101;
		ButtonLeft[2]	= 178;
		ButtonTop		= 1;
		ButtonWidth		= 74;
		ButtonHeight	= 24;
		ScreenTop		= 30;
	}

	//
	// Create components.
	//
	GeneralButton = NerfButtonControl(CreateCONTROL(class'NerfButtonControl', ButtonLeft[0], ButtonTop, ButtonWidth, ButtonHeight));
	GeneralButton.UpTexture   = texture'Oval2';
	GeneralButton.OverTexture = texture'Oval2Over';
	GeneralButton.DownTexture = texture'Oval2Down';
	GeneralButton.bIgnoreLDoubleclick = True;
	GeneralButton.SetText(GeneralButtonText);
	GeneralButton.SetHelpText(GeneralButtonHelp);
	GeneralButton.SetFont(F_Normal);
	GeneralButton.SetTextColor(TextColor);
	GeneralButton.bStretched = True;

	MovementButton = NerfButtonControl(CreateCONTROL(class'NerfButtonControl', ButtonLeft[1], ButtonTop, ButtonWidth, ButtonHeight));
	MovementButton.UpTexture   = texture'Oval2';
	MovementButton.OverTexture = texture'Oval2Over';
	MovementButton.DownTexture = texture'Oval2Down';
	MovementButton.bIgnoreLDoubleclick = True;
	MovementButton.SetText(MovementButtonText);
	MovementButton.SetHelpText(MovementButtonHelp);
	MovementButton.SetFont(F_Normal);
	MovementButton.SetTextColor(TextColor);
	MovementButton.bStretched = True;

	OtherButton = NerfButtonControl(CreateCONTROL(class'NerfButtonControl', ButtonLeft[2], ButtonTop, ButtonWidth, ButtonHeight));
	OtherButton.UpTexture   = texture'Oval2';
	OtherButton.OverTexture = texture'Oval2Over';
	OtherButton.DownTexture = texture'Oval2Down';
	OtherButton.bIgnoreLDoubleclick = True;
	OtherButton.SetText(OtherButtonText);
	OtherButton.SetHelpText(OtherButtonHelp);
	OtherButton.SetFont(F_Normal);
	OtherButton.SetTextColor(TextColor);
	OtherButton.bStretched = True;
}

function ShowMovementScreen()
{
	NerfRootWindow(Root).PDAMainWindow().SetScreenTitle(NerfRootWindow(Root).PDAMainWindow().ControlsButtonText $ " - " $ MovementButtonText);

	if (GeneralControlsScreen != None)
		HideChildWindow(GeneralControlsScreen);
	if (OtherControlsScreen != None)
		HideChildWindow(OtherControlsScreen);

	GeneralButton.UpTexture = texture'Oval2';
	MovementButton.UpTexture = texture'Oval2Over';
	OtherButton.UpTexture = texture'Oval2';

	if (MovementControlsScreen == None)
		MovementControlsScreen = NerfPDAScreenControlsMovement(CreateWindow(class'NerfPDAScreenControlsMovement', 1, ScreenTop, WinWidth, WinHeight - 44, self));
	ShowChildWindow(MovementControlsScreen);
}

function ShowGeneralScreen()
{
	NerfRootWindow(Root).PDAMainWindow().SetScreenTitle(NerfRootWindow(Root).PDAMainWindow().ControlsButtonText $ " - " $ GeneralButtonText);

	if (MovementControlsScreen != None)
		HideChildWindow(MovementControlsScreen);
	if (OtherControlsScreen != None)
		HideChildWindow(OtherControlsScreen);

	GeneralButton.UpTexture = texture'Oval2Over';
	MovementButton.UpTexture = texture'Oval2';
	OtherButton.UpTexture = texture'Oval2';

	if (GeneralControlsScreen == None)
		GeneralControlsScreen = NerfPDAScreenControlsGeneral(CreateWindow(class'NerfPDAScreenControlsGeneral', 1, ScreenTop, WinWidth, WinHeight - 44, self));
	ShowChildWindow(GeneralControlsScreen);
}

function ShowOtherScreen()
{
	NerfRootWindow(Root).PDAMainWindow().SetScreenTitle(NerfRootWindow(Root).PDAMainWindow().MainScreenTitle $ " - " $ OtherButtonText);

	if (GeneralControlsScreen != None)
		HideChildWindow(GeneralControlsScreen);
	if (MovementControlsScreen != None)
		HideChildWindow(MovementControlsScreen);

	GeneralButton.UpTexture = texture'Oval2';
	MovementButton.UpTexture = texture'Oval2';
	OtherButton.UpTexture = texture'Oval2Over';

	if (OtherControlsScreen == None)
		OtherControlsScreen = NerfPDAScreenControlsOther(CreateWindow(class'NerfPDAScreenControlsOther', 1, ScreenTop, WinWidth, WinHeight - 44, self));
	ShowChildWindow(OtherControlsScreen);
}

function Notify(UWindowDialogControl C, byte E)
{

	Super.Notify(C, E);

	switch (E)
	{
	case DE_Click:
		switch (C)
		{
		case GeneralButton:
			ShowGeneralScreen();
			break;

		case MovementButton:
			ShowMovementScreen();
			break;

		case OtherButton:
			ShowOtherScreen();
			break;
		}
		break;
	}
}

defaultproperties
{
     GeneralButtonText=General
     GeneralButtonHelp=Adjust general control settings
     MovementButtonText=Movement
     MovementButtonHelp=Adjust movement control settings
     OtherButtonText=Other
     OtherButtonHelp=Adjust mouse and joystick control settings
}
