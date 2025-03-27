class NerfPDAScreenMultiPlayer extends NerfWindow;

var int ButtonLeft[3], ButtonTop, ButtonWidth, ButtonHeight;
var int ScreenTop;

//
// Controls
//

// Join Game Button
var NerfButtonControl JoinGameButton;
var localized string JoinGameButtonText;
var localized string JoinGameButtonHelp;

// Setup Server Button
var NerfButtonControl SetupServerButton;
var localized string SetupServerButtonText;
var localized string SetupServerButtonHelp;

// PlayerSetup Button
var NerfButtonControl MultiplayerSetupButton;
var localized string MultiplayerSetupButtonText;
var localized string MultiplayerSetupButtonHelp;

//
// Screens
//
var NerfPDAScreenJoinGame JoinGameScreen;
var NerfPDAScreenSetupServer SetupServerScreen;
var NerfPDAScreenMultiplayerSetup MultiplayerSetupScreen;


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
		ButtonLeft[1]	= 85;
		ButtonLeft[2]	= 155;
		ButtonTop		= 10;
		ButtonWidth		= 70;
		ButtonHeight	= 16;
		ScreenTop		= 30;
	}
	else
	{
		// high-res version
		ButtonLeft[0]	= 24;
		ButtonLeft[1]	= 24+77;
		ButtonLeft[2]	= 27+77*2;
		ButtonTop		= 1;
		ButtonWidth		= 74;
		ButtonHeight	= 24;
		ScreenTop		= 30;
	}

	//
	// Create components.
	//
	JoinGameButton = NerfButtonControl(CreateCONTROL(class'NerfButtonControl',  ButtonLeft[0], ButtonTop, ButtonWidth, ButtonHeight));
	JoinGameButton.UpTexture   = texture'Oval2';
	JoinGameButton.OverTexture = texture'Oval2Over';
	JoinGameButton.DownTexture = texture'Oval2Down';
	JoinGameButton.bIgnoreLDoubleclick = True;
	JoinGameButton.SetText(JoinGameButtonText);
	JoinGameButton.SetHelpText(JoinGameButtonHelp);
	JoinGameButton.SetFont(F_Normal);
	JoinGameButton.SetTextColor(TextColor);
	JoinGameButton.bStretched = True;

	SetupServerButton = NerfButtonControl(CreateCONTROL(class'NerfButtonControl',  ButtonLeft[1], ButtonTop, ButtonWidth, ButtonHeight));
	SetupServerButton.UpTexture   = texture'Oval2';
	SetupServerButton.OverTexture = texture'Oval2Over';
	SetupServerButton.DownTexture = texture'Oval2Down';
	SetupServerButton.bIgnoreLDoubleclick = True;
	SetupServerButton.SetText(SetupServerButtonText);
	SetupServerButton.SetHelpText(SetupServerButtonHelp);
	SetupServerButton.SetFont(F_Normal);
	SetupServerButton.SetTextColor(TextColor);
	SetupServerButton.bStretched = True;

	MultiplayerSetupButton = NerfButtonControl(CreateCONTROL(class'NerfButtonControl',  ButtonLeft[2], ButtonTop, ButtonWidth, ButtonHeight));
	MultiplayerSetupButton.UpTexture   = texture'Oval2';
	MultiplayerSetupButton.OverTexture = texture'Oval2Over';
	MultiplayerSetupButton.DownTexture = texture'Oval2Down';
	MultiplayerSetupButton.bIgnoreLDoubleclick = True;
	MultiplayerSetupButton.SetText(MultiplayerSetupButtonText);
	MultiplayerSetupButton.SetHelpText(MultiplayerSetupButtonHelp);
	MultiplayerSetupButton.SetFont(F_Normal);
	MultiplayerSetupButton.SetTextColor(TextColor);
	MultiplayerSetupButton.bStretched = True;

	//
	// create 'screens'
	//

	// NOTE: the screens are only created when requested since creation is so slow
}

function Notify(UWindowDialogControl C, byte E)
{

	Super.Notify(C, E);

	switch (E)
	{
	case DE_Click:
		switch (C)
		{
		case JoinGameButton:
			ShowJoinGameScreen();
			break;

		case SetupServerButton:
			ShowSetupServerScreen();
			break;

		case MultiplayerSetupButton:
			ShowMulitplayerSetupScreen();
			break;
		}
		break;
	}
}

function ShowJoinGameScreen()
{
	NerfRootWindow(Root).PDAMainWindow().SetScreenTitle(NerfRootWindow(Root).PDAMainWindow().MultiplayerButtonText $ " - " $ JoinGameButtonText);
	NerfRootWindow(Root).PDAMainWindow().ShowStatusWindow(True);

	if (SetupServerScreen != None)
		SetupServerScreen.Close();
	if (MultiplayerSetupScreen != None)
		MultiplayerSetupScreen.Close();

	JoinGameButton.UpTexture = texture'Oval2Over';
	SetupServerButton.UpTexture = texture'Oval2';
	MultiplayerSetupButton.UpTexture = texture'Oval2';

	if (JoinGameScreen == None)
		JoinGameScreen = NerfPDAScreenJoinGame(CreateWindow(class'NerfPDAScreenJoinGame', 1, 30, WinWidth, WinHeight - 44, self));
	ShowChildWindow(JoinGameScreen);
	JoinGameScreen.ShowBrowserWindow();
}

function ShowSetupServerScreen()
{
	NerfRootWindow(Root).PDAMainWindow().SetScreenTitle(NerfRootWindow(Root).PDAMainWindow().MultiplayerButtonText $ " - " $ SetupServerButtonText);
	NerfRootWindow(Root).PDAMainWindow().ShowStatusWindow(False);

	if (JoinGameScreen != None)
		JoinGameScreen.Close();
	if (MultiplayerSetupScreen != None)
		MultiplayerSetupScreen.Close();

	JoinGameButton.UpTexture = texture'Oval2';
	SetupServerButton.UpTexture = texture'Oval2Over';
	MultiplayerSetupButton.UpTexture = texture'Oval2';

	if (SetupServerScreen == None)
		SetupServerScreen = NerfPDAScreenSetupServer(CreateWindow(class'NerfPDAScreenSetupServer', 1, 30, WinWidth, WinHeight - 44, self));
	ShowChildWindow(SetupServerScreen);
}

function ShowMulitplayerSetupScreen()
{
	NerfRootWindow(Root).PDAMainWindow().SetScreenTitle(NerfRootWindow(Root).PDAMainWindow().MultiplayerButtonText $ " - " $ MultiplayerSetupButtonText);
	NerfRootWindow(Root).PDAMainWindow().ShowStatusWindow(False);

	if (JoinGameScreen != None)
		JoinGameScreen.Close();
	if (SetupServerScreen != None)
		SetupServerScreen.Close();

	JoinGameButton.UpTexture = texture'Oval2';
	SetupServerButton.UpTexture = texture'Oval2';
	MultiplayerSetupButton.UpTexture = texture'Oval2Over';

	if (MultiplayerSetupScreen == None)
		MultiplayerSetupScreen = NerfPDAScreenMultiplayerSetup(CreateWindow(class'NerfPDAScreenMultiplayerSetup', 1, 30, WinWidth, WinHeight - 44, self));
	ShowChildWindow(MultiplayerSetupScreen);
}

defaultproperties
{
     JoinGameButtonText=Find Games
     JoinGameButtonHelp=Join multiplayer game already in session
     SetupServerButtonText=Setup Server
     SetupServerButtonHelp=Start a new multiplayer game
     MultiplayerSetupButtonText=Setup Player
     MultiplayerSetupButtonHelp=Setup your character for multiplayer games
}
