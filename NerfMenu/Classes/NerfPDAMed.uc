//
//
//	NerfPDAMed
//
//	Resolution-dependant subclass of NerfPDA main menu
//  Medium (&High) resolution version.
//
//	All resolution-dependencies (control placement, painting, etc.) should go here
//
//
class NerfPDAMed extends NerfPDA
	config(user);

// Background
var texture Background[4];
var() string BackgroundName[4];


function Created()
{
	local Color MiscColor;

	Super.Created();

	//
	// Load the background.
	//
	Background[0] = Texture(DynamicLoadObject(BackgroundName[0], Class'Texture'));
	Background[1] = Texture(DynamicLoadObject(BackgroundName[1], Class'Texture'));
	Background[2] = Texture(DynamicLoadObject(BackgroundName[2], Class'Texture'));
	Background[3] = Texture(DynamicLoadObject(BackgroundName[3], Class'Texture'));


	//
	// Create components.
	//

	// status and help windows
	StatusWindow = NerfStatusWindow(CreateWindow(class'NerfStatusWindow', 155, 300, 305, 32));
	HelpWindow = NerfHelpWindow(CreateWindow(class'NerfHelpWindow', 155, 325, 305, 32));

	// Buttons
	StatsButton			= NerfButtonControl(CreateControl(class'NerfButtonControl', 45, 164, 55, 25));
	OptionsButton		= NerfButtonControl(CreateControl(class'NerfButtonControl', 35, 194, 65, 25));
	ControlsButton		= NerfButtonControl(CreateControl(class'NerfButtonControl', 30, 226, 72, 26));
	MultiPlayerButton	= NerfButtonControl(CreateControl(class'NerfButtonControl', 24, 257, 86, 26));
	PlayButton			= NerfButtonControl(CreateControl(class'NerfButtonControl', 42, 299, 128, 88));
	NewGameButton		= NerfButtonControl(CreateControl(class'NerfButtonControl', 461, 197, 32, 32));
	ExitEventButton		= NerfButtonControl(CreateControl(class'NerfButtonControl', 461, 238, 32, 32));
	QuitButton			= NerfButtonControl(CreateControl(class'NerfButtonControl', 461, 280, 32, 32));

	EnableButtons();

	ScreenTitleLabel = UWindowLabelControl(CreateControl(class'UWindowLabelControl', 205, 29, 180, 20));

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
			StatsButton.UpTexture = texture'Stats';
			OptionsButton.UpTexture = texture'OptionsOver';
			ControlsButton.UpTexture = texture'Controls';
			MultiPlayerButton.UpTexture   = texture'MultiPlayer';
			MultiPlayerButton.OverTexture = texture'MultiPlayerOver';
			MultiPlayerButton.DownTexture = texture'MultiPlayerDown';
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
			StatsButton.UpTexture = texture'Stats';
			OptionsButton.UpTexture = texture'Options';
			ControlsButton.UpTexture = texture'ControlsOver';
			MultiPlayerButton.UpTexture   = texture'MultiPlayer';
			MultiPlayerButton.OverTexture = texture'MultiPlayerOver';
			MultiPlayerButton.DownTexture = texture'MultiPlayerDown';
			MainScreenTitle = ControlsButtonText;
			MultiplayerScreenShown = False;
			ShowStatusWindow(False);
			break;

		case MultiPlayerButton:
			if (MultiPlayerScreenShown)
			{
				MultiplayerScreenShown = False;
				ShowStatusWindow(False);
				MultiPlayerButton.UpTexture   = texture'MultiPlayerOver';
				MultiPlayerButton.OverTexture = texture'MultiPlayerOver';
				MultiPlayerButton.DownTexture = texture'MultiPlayerOver';
				ShowCharInfo();		
			}
			else
			{
				HideChildWindow(MainScreen);
				HideChildWindow(ControlsScreen);
				HideChildWindow(OptionsScreen);
				ShowChildWindow(MultiPlayerScreen);
				MultiPlayerScreen.ShowJoinGameScreen();
				StatsButton.UpTexture = texture'Stats';
				OptionsButton.UpTexture = texture'Options';
				ControlsButton.UpTexture = texture'Controls';
				MultiPlayerButton.UpTexture   = texture'SinglePlayerOver';
				MultiPlayerButton.OverTexture = texture'SinglePlayerOver';
				MultiPlayerButton.DownTexture = texture'SinglePlayerOver';
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
//			log(class$ " WES: Notify NewPlayerProfile" @GetPlayerOwner());
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
	C.SetPos(0,255);
	C.DrawIcon(Background[2], 1.0);
	C.SetPos(255,255);
	C.DrawIcon(Background[3], 1.0);

	if (!ShowPic)
		return;

	// draw character picture
	C.bNoSmooth = True;
	C.Style = 2;								// ERenderStyle.STY_Masked;
	C.SetPos(14,19);
	C.DrawIcon(PDACharPic, 1.0);
}

function EnableButtons()
{
	StatsButton.UpTexture = texture'Stats';
	StatsButton.OverTexture = texture'StatsOver';
	StatsButton.DownTexture = texture'StatsDown';
	OptionsButton.UpTexture = texture'Options';
	OptionsButton.OverTexture = texture'OptionsOver';
	OptionsButton.DownTexture = texture'OptionsDown';
	ControlsButton.UpTexture = texture'Controls';
	ControlsButton.OverTexture = texture'ControlsOver';
	ControlsButton.DownTexture = texture'ControlsDown';
	MultiPlayerButton.UpTexture = texture'MultiPlayer';
	MultiPlayerButton.OverTexture = texture'MultiPlayerOver';
	MultiPlayerButton.DownTexture = texture'MultiPlayerDown';
	PlayButton.UpTexture = texture'Play';
	PlayButton.OverTexture = texture'PlayOver';
	PlayButton.DownTexture = texture'PlayDown';
	NewGameButton.UpTexture   = texture'NewGame';
	NewGameButton.OverTexture = texture'NewGameOver';
	NewGameButton.DownTexture = texture'NewGameDown';
	ExitEventButton.UpTexture   = texture'ExitEvent';
	ExitEventButton.OverTexture = texture'ExitEventOver';
	ExitEventButton.DownTexture = texture'ExitEventDown';
	QuitButton.UpTexture   = texture'Quit';
	QuitButton.OverTexture = texture'QuitOver';
	QuitButton.DownTexture = texture'QuitDown';
}

function DisableButtons()
{
	StatsButton.UpTexture = texture'StatsDisabled';
	StatsButton.OverTexture = texture'StatsDisabled';
	StatsButton.DownTexture = texture'StatsDisabled';
	OptionsButton.UpTexture = texture'OptionsDisabled';
	OptionsButton.OverTexture = texture'OptionsDisabled';
	OptionsButton.DownTexture = texture'OptionsDisabled';
	ControlsButton.UpTexture = texture'ControlsDisabled';
	ControlsButton.OverTexture = texture'ControlsDisabled';
	ControlsButton.DownTexture = texture'ControlsDisabled';
	MultiPlayerButton.UpTexture = texture'MultiPlayerDisabled';
	MultiPlayerButton.OverTexture = texture'MultiPlayerDisabled';
	MultiPlayerButton.DownTexture = texture'MultiPlayerDisabled';
	PlayButton.UpTexture = texture'PlayDisabled';
	PlayButton.OverTexture = texture'PlayDisabled';
	PlayButton.DownTexture = texture'PlayDisabled';
	NewGameButton.UpTexture   = texture'NewGameDisabled';
	NewGameButton.OverTexture = texture'NewGameDisabled';
	NewGameButton.DownTexture = texture'NewGameDisabled';
	ExitEventButton.UpTexture   = texture'ExitEventDisabled';
	ExitEventButton.OverTexture = texture'ExitEventDisabled';
	ExitEventButton.DownTexture = texture'ExitEventDisabled';
	QuitButton.UpTexture   = texture'QuitDisabled';
	QuitButton.OverTexture = texture'QuitDisabled';
	QuitButton.DownTexture = texture'QuitDisabled';
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
		ShowCharInfo();
		EnableButtons();
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
	StatsButton.UpTexture = texture'StatsOver';
	StatsButton.OverTexture = texture'StatsOver';
	StatsButton.DownTexture = texture'StatsOver';
	OptionsButton.UpTexture = texture'Options';
	ControlsButton.UpTexture = texture'Controls';
	MultiPlayerButton.UpTexture = texture'MultiPlayer';

	Super.ShowCharInfo();
}

function SetCharPicture(string PicName)
{
	local string PicClassName;

	PicClassName = "NerfRes.PDA_" $ PicName;
	PDACharPic = Texture(DynamicLoadObject(PicClassName, Class'Texture'));

	// precaution to avoid infinite accessed nones in log
	if (PDACharPic == None)
		ShowPic = False;
	else
		ShowPic = True;
}

defaultproperties
{
     BackgroundName(0)=NerfRes.MainBack11
     BackgroundName(1)=NerfRes.MainBack12
     BackgroundName(2)=NerfRes.MainBack21
     BackgroundName(3)=NerfRes.MainBack22
     PDAWidth=512
     PDAHeight=384
     ScreenLeft=150
     ScreenTop=60
     ScreenWidth=310
     ScreenHeight=275
}
