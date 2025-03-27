//
//
//	NerfPDALow
//
//	Resolution-dependant subclass of NerfPDA main menu
//  Low resolution version.
//
//	All resolution-dependencies (control placement, painting, etc.) should go here
//
//
class NerfPDALow extends NerfPDA
	config;

// Background
var texture Background[2];
var() string BackgroundName[2];


function Created()
{
	Super.Created();

	//
	// Load the background.
	//
	Background[0] = Texture(DynamicLoadObject(BackgroundName[0], Class'Texture'));
	Background[1] = Texture(DynamicLoadObject(BackgroundName[1], Class'Texture'));

	//
	// Create components.
	//

	// status and help windows
	StatusWindow = NerfStatusWindow(CreateWindow(class'NerfStatusWindow', ScreenLeft, ScreenHeight-30, ScreenWidth, 24));
	HelpWindow = NerfHelpWindow(CreateWindow(class'NerfHelpWindow', ScreenLeft, ScreenHeight-17, ScreenWidth, 24));
//	StatusWindow = NerfStatusWindow(Root.CreateWindow(class'NerfStatusWindow', ScreenLeft, NerfRootWindow(Root).ScreenHeight-40, ScreenWidth, 24));
//	HelpWindow = NerfHelpWindow(Root.CreateWindow(class'NerfHelpWindow', ScreenLeft, NerfRootWindow(Root).ScreenHeight-24, ScreenWidth, 24));


	// Buttons
	StatsButton			= NerfButtonControl(CreateControl(class'NerfButtonControl', 0, 63, 51, 17));
	OptionsButton		= NerfButtonControl(CreateControl(class'NerfButtonControl', 0, 81, 51, 17));
	ControlsButton		= NerfButtonControl(CreateControl(class'NerfButtonControl', 0, 98, 51, 17));
	MultiPlayerButton	= NerfButtonControl(CreateControl(class'NerfButtonControl', 0, 116, 51, 17));
	PlayButton			= NerfButtonControl(CreateControl(class'NerfButtonControl', 0, 189, 55, 51));
	NewGameButton		= NerfButtonControl(CreateControl(class'NerfButtonControl', 0, 136, 51, 17));
	ExitEventButton		= NerfButtonControl(CreateControl(class'NerfButtonControl', 0, 155, 51, 17));
	QuitButton			= NerfButtonControl(CreateControl(class'NerfButtonControl', 0, 171, 51, 17));

	EnableButtons();

	// Screen Title
	ScreenTitleLabel = UWindowLabelControl(CreateControl(class'UWindowLabelControl', ScreenLeft+50, 0, 180, 20));

	ScreenLeft = ScreenLeft - WinLeft;

	AfterCreated();
}

function Notify(UWindowDialogControl C, byte E)
{
	Super.Notify(C, E);

	switch (E)
	{
	case DE_Click:
		switch (C)
		{
		case StatsButton:
			ShowCharInfo();
			break;
					
		case OptionsButton:
			HideChildWindow(MainScreen);
			HideChildWindow(ControlsScreen);
			HideChildWindow(MultiPlayerScreen);
			ShowChildWindow(OptionsScreen);
			OptionsScreen.ShowGeneralScreen();
			StatsButton.UpTexture = texture'LOW_Stats';
			OptionsButton.UpTexture = texture'LOW_OptionsOver';
			ControlsButton.UpTexture = texture'LOW_Controls';
			MultiPlayerButton.UpTexture   = texture'LOW_MultiPlayer';
			MultiPlayerButton.OverTexture = texture'LOW_MultiPlayerOver';
			MultiPlayerButton.DownTexture = texture'LOW_MultiPlayerDown';
			MainScreenTitle = OptionsButtonText;
			MultiplayerScreenShown = False;
			ShowStatusWindow(False);
			break;

		case ControlsButton:
			HideChildWindow(MainScreen);
			HideChildWindow(OptionsScreen);
			HideChildWindow(MultiPlayerScreen);
			ShowChildWindow(ControlsScreen);
			ControlsScreen.ShowGeneralScreen();
			StatsButton.UpTexture = texture'LOW_Stats';
			OptionsButton.UpTexture = texture'LOW_Options';
			ControlsButton.UpTexture = texture'LOW_ControlsOver';
			MultiPlayerButton.UpTexture   = texture'LOW_MultiPlayer';
			MultiPlayerButton.OverTexture = texture'LOW_MultiPlayerOver';
			MultiPlayerButton.DownTexture = texture'LOW_MultiPlayerDown';
			MainScreenTitle = ControlsButtonText;
			MultiplayerScreenShown = False;
			ShowStatusWindow(False);
			break;

		case MultiPlayerButton:
			if (MultiPlayerScreenShown)
			{
				MultiplayerScreenShown = False;
				ShowStatusWindow(False);
				MultiPlayerButton.UpTexture   = texture'LOW_MultiPlayerOver';
				MultiPlayerButton.OverTexture = texture'LOW_MultiPlayerOver';
				MultiPlayerButton.DownTexture = texture'LOW_MultiPlayerOver';
				ShowCharInfo();		
			}
			else
			{
				HideChildWindow(MainScreen);
				HideChildWindow(ControlsScreen);
				HideChildWindow(OptionsScreen);
				ShowChildWindow(MultiPlayerScreen);
				MultiPlayerScreen.ShowJoinGameScreen();
				StatsButton.UpTexture = texture'LOW_Stats';
				OptionsButton.UpTexture = texture'LOW_Options';
				ControlsButton.UpTexture = texture'LOW_Controls';
				MultiPlayerButton.UpTexture   = texture'LOW_SinglePlayerOver';
				MultiPlayerButton.OverTexture = texture'LOW_SinglePlayerOver';
				MultiPlayerButton.DownTexture = texture'LOW_SinglePlayerOver';
				MainScreenTitle = MultiPlayerButtonText;
				MultiplayerScreenShown = True;
				ShowStatusWindow(True);
			}
			break;

		case ExitEventButton:
			bMustTravel = True;
			Play(ReadyRooms[GetPlayerOwner().ArenaAccessLevel]);		// go to last readyroom
			break;

		case PlayButton:
			Play();
			break;

		case NewGameButton:
			SetPreviousOwner();
			NewPlayerProfile();
			break;

		case QuitButton:
			ExitGame();
			break;
		}
		break;
	}
}

function Paint(Canvas C, float X, float Y)
{
	Super.Paint(C, X, Y);

	// draw background tiled
	C.bNoSmooth = !BackgroundSmooth;			// note: false causes tiling artifacts (gaps)
	C.Style = 2;								// ERenderStyle.STY_Masked;

	C.SetPos(0,0);
	C.DrawIcon(Background[0], 1.0);
	C.SetPos(255,0);
	C.DrawIcon(Background[1], 1.0);

	if (!ShowPic)
		return;

	// draw character picture
	C.bNoSmooth = True;
	C.Style = 2;								// ERenderStyle.STY_Masked;
	C.SetPos(0,0);
	C.DrawIcon(PDACharPic, 1.0);
}

function EnableButtons()
{
	StatsButton.UpTexture = texture'LOW_Stats';
	StatsButton.OverTexture = texture'LOW_StatsOver';
	StatsButton.DownTexture = texture'LOW_StatsDown';
	OptionsButton.UpTexture = texture'LOW_Options';
	OptionsButton.OverTexture = texture'LOW_OptionsOver';
	OptionsButton.DownTexture = texture'LOW_OptionsDown';
	ControlsButton.UpTexture = texture'LOW_Controls';
	ControlsButton.OverTexture = texture'LOW_ControlsOver';
	ControlsButton.DownTexture = texture'LOW_ControlsDown';
	MultiPlayerButton.UpTexture = texture'LOW_MultiPlayer';
	MultiPlayerButton.OverTexture = texture'LOW_MultiPlayerOver';
	MultiPlayerButton.DownTexture = texture'LOW_MultiPlayerDown';
	PlayButton.UpTexture = texture'LOW_Play';
	PlayButton.OverTexture = texture'LOW_PlayOver';
	PlayButton.DownTexture = texture'LOW_PlayDown';
	NewGameButton.UpTexture   = texture'LOW_NewGame';
	NewGameButton.OverTexture = texture'LOW_NewGameOver';
	NewGameButton.DownTexture = texture'LOW_NewGameDown';
	ExitEventButton.UpTexture   = texture'LOW_ExitEvent';
	ExitEventButton.OverTexture = texture'LOW_ExitEventOver';
	ExitEventButton.DownTexture = texture'LOW_ExitEventDown';
	QuitButton.UpTexture   = texture'LOW_Quit';
	QuitButton.OverTexture = texture'LOW_QuitOver';
	QuitButton.DownTexture = texture'LOW_QuitDown';
}

function DisableButtons()
{
	StatsButton.UpTexture = texture'LOW_StatsDisabled';
	StatsButton.OverTexture = texture'LOW_StatsDisabled';
	StatsButton.DownTexture = texture'LOW_StatsDisabled';
	OptionsButton.UpTexture = texture'LOW_OptionsDisabled';
	OptionsButton.OverTexture = texture'LOW_OptionsDisabled';
	OptionsButton.DownTexture = texture'LOW_OptionsDisabled';
	ControlsButton.UpTexture = texture'LOW_ControlsDisabled';
	ControlsButton.OverTexture = texture'LOW_ControlsDisabled';
	ControlsButton.DownTexture = texture'LOW_ControlsDisabled';
	MultiPlayerButton.UpTexture = texture'LOW_MultiPlayerDisabled';
	MultiPlayerButton.OverTexture = texture'LOW_MultiPlayerDisabled';
	MultiPlayerButton.DownTexture = texture'LOW_MultiPlayerDisabled';
	PlayButton.UpTexture = texture'LOW_PlayDisabled';
	PlayButton.OverTexture = texture'LOW_PlayDisabled';
	PlayButton.DownTexture = texture'LOW_PlayDisabled';
	NewGameButton.UpTexture   = texture'LOW_NewGameDisabled';
	NewGameButton.OverTexture = texture'LOW_NewGameDisabled';
	NewGameButton.DownTexture = texture'LOW_NewGameDisabled';
	ExitEventButton.UpTexture   = texture'LOW_ExitEventDisabled';
	ExitEventButton.OverTexture = texture'LOW_ExitEventDisabled';
	ExitEventButton.DownTexture = texture'LOW_ExitEventDisabled';
	QuitButton.UpTexture   = texture'LOW_QuitDisabled';
	QuitButton.OverTexture = texture'LOW_QuitDisabled';
	QuitButton.DownTexture = texture'LOW_QuitDisabled';
}

function bool EnablePDA(bool bEnable)
{
	if (!Super.EnablePDA(bEnable))
		return False;

	// we're being enabled/disabled
	if (bEnable)
	{
		// enable
		ShowPic = True;
		SetScreenTitle(ScreenTitleSave);
		EnableButtons();
		ShowCharInfo();
	}
	else
	{
		// disable
		ShowPic = False;
		ScreenTitleSave = ScreenTitleLabel.Text;
		SetScreenTitle("");
		DisableButtons();
		HideChildWindow(MainScreen);
		HideChildWindow(ControlsScreen);
		HideChildWindow(MultiPlayerScreen);
		HideChildWindow(OptionsScreen);
	}

	return true;
}

function ShowCharInfo()
{
	// Sync buttons to screen
	StatsButton.UpTexture = texture'LOW_StatsOver';
	StatsButton.OverTexture = texture'LOW_StatsOver';
	StatsButton.DownTexture = texture'LOW_StatsOver';
	OptionsButton.UpTexture = texture'LOW_Options';
	ControlsButton.UpTexture = texture'LOW_Controls';
	MultiPlayerButton.UpTexture = texture'LOW_MultiPlayer';

	Super.ShowCharInfo();
}

function SetCharPicture(string PicName)
{
	local string PicClassName;

	PicClassName = "NerfRes.PDA_LOW_" $ PicName;
	PDACharPic = Texture(DynamicLoadObject(PicClassName, Class'Texture'));

	// precaution to avoid infinite accessed nones in log
	if (PDACharPic == None)
		ShowPic = False;
	else
		ShowPic = True;
}

defaultproperties
{
     BackgroundName(0)=NerfRes.LOW_MainBack11
     BackgroundName(1)=NerfRes.LOW_MainBack12
     PDAWidth=320
     PDAHeight=240
     ScreenLeft=63
     ScreenWidth=250
     ScreenHeight=240
}
