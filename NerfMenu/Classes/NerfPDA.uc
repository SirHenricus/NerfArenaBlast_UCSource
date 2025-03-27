//
//
//	NerfPDA (Abstract base-class)
//
//	Resolution-independent main menu.
//
//	All menu functionality that is not dependant on resolution should go here
//
//
class NerfPDA extends NerfWindow
	config(user) abstract;

var() bool BackgroundSmooth;
var float FontHeight;
var int ScreenW, ScreenH;
var int PDAWidth, PDAHeight;

// player profile interface object
var string PlayerProfileClass;
var NerfPlayerProfile PlayerProfile;

var localized string LevelDescriptions[4];
var string ReadyRooms[8];

var sound ShowSound, HideSound;

// card info
var string CharName;
var int CharIndex;
var int CharLevel;
var string PlayerClass;
var byte Difficulty;
var string DifficultyDesc;
var string CharPicture;
var string Rank;
var int Events;
var string CharClass[4];
var string CharPicName[4];

var bool bMustTravel;
var class<GameInfo> GameClass;

var bool bDoTick;			// Hack flag
var bool bFirstRun;

// 'cards'
var NerfCardName NameCard;
var NerfCardChar CharacterCard;
var NerfCardLevel LevelCard;
var NerfCardProfile ProfileCard;

// Character picture
var texture PDACharPic;
var bool ShowPic;
var string PDACharName[4];


// Controls
var NerfButtonControl StatsButton;
var localized string StatsButtonText;
var localized string StatsButtonHelp;

var NerfButtonControl OptionsButton;
var localized string OptionsButtonText;
var localized string OptionsButtonHelp;

var NerfButtonControl ControlsButton;
var localized string ControlsButtonText;
var localized string ControlsButtonHelp;

var NerfButtonControl MultiPlayerButton;
var localized string MultiPlayerButtonText;
var localized string MultiPlayerButtonHelp;

var NerfButtonControl PlayButton;
var localized string PlayButtonText;
var localized string PlayButtonHelp;

var NerfButtonControl NewGameButton;
var localized string NewGameButtonText;
var localized string NewGameButtonHelp;

var NerfButtonControl ExitEventButton;
var localized string ExitEventButtonText;
var localized string ExitEventButtonHelp;

var NerfButtonControl QuitButton;
var localized string QuitButtonText;
var localized string QuitButtonHelp;


// Message boxes
var NerfQuitBox ConfirmExit;
var localized string ConfirmExitTitle;
var localized string ConfirmExitText;


// Misc windows
var	NerfHelpWindow HelpWindow;
var	NerfStatusWindow StatusWindow;
var UWindowLabelControl ScreenTitleLabel;

var string MainScreenTitle;
var localized string MainScreenTitleStats;
var localized string MainScreenTitleLevel;
var string ScreenTitleSave;
var bool MultiplayerScreenShown;
var() int ScreenLeft, ScreenTop, ScreenWidth, ScreenHeight;

// In-PDA screens
var NerfPDAScreenMain MainScreen;
var NerfPDAScreenOptions OptionsScreen;
var NerfPDAScreenControls ControlsScreen;
var NerfPDAScreenMultiPlayer MultiPlayerScreen;

var int	ixPreviousOwner;

function Created() 
{
	bDoTick = False;
	bMustTravel = False;
	Super.Created();

	// create the player profile interface
	PlayerProfile = New(None) class<NerfPlayerProfile>(DynamicLoadObject(PlayerProfileClass, class'Class'));
}

function AfterCreated()
{
	local Color MiscColor;
	local int CurrentProfile;

	StatsButton.bIgnoreLDoubleclick = True;
	StatsButton.SetHelpText(StatsButtonHelp);
	OptionsButton.bIgnoreLDoubleclick = True;
	OptionsButton.SetHelpText(OptionsButtonHelp);
	ControlsButton.bIgnoreLDoubleclick = True;
	ControlsButton.SetHelpText(ControlsButtonHelp);
	MultiPlayerButton.bIgnoreLDoubleclick = True;
	MultiPlayerButton.SetHelpText(MultiPlayerButtonHelp);
	PlayButton.bIgnoreLDoubleclick = True;
	NewGameButton.bIgnoreLDoubleclick = True;
	NewGameButton.SetHelpText(NewGameButtonHelp);
	ExitEventButton.bIgnoreLDoubleclick = True;
	ExitEventButton.SetHelpText(ExitEventButtonHelp);
	QuitButton.bIgnoreLDoubleclick = True;
	QuitButton.SetHelpText(QuitButtonHelp);
	MiscColor.R = 200;
	MiscColor.G = 200;
	MiscColor.B = 200;
	ScreenTitleLabel.SetTextColor(MiscColor);
	ScreenTitleLabel.SetText("");
	ScreenTitleLabel.SetFont(F_Bold);
/*
 *	In case we want to internationalize the buttons with text somehow
 *
	StatsButton.SetText(StatsButtonText);
	StatsButton.SetFont(F_Normal);
	StatsButton.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
	OptionsButton.SetText(OptionsButtonText);
	OptionsButton.SetFont(F_Normal);
	OptionsButton.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
	ControlsButton.SetText(ControlsButtonText);
	ControlsButton.SetFont(F_Normal);
	ControlsButton.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
	MultiPlayerButton.SetText(MultiPlayerButtonText);
	MultiPlayerButton.SetFont(F_Normal);
	MultiPlayerButton.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
	PlayButton.SetText(PlayButtonText);
	PlayButton.SetFont(F_Normal);
	PlayButton.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
	NewGameButton.SetText(NewGameButtonText);
	NewGameButton.SetFont(F_Normal);
	NewGameButton.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
	ExitEventButton.SetText(ExitEventButtonText);
	ExitEventButton.SetFont(F_Normal);
	ExitEventButton.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
	QuitButton.SetText(QuitButtonText);
	QuitButton.SetFont(F_Normal);
	QuitButton.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
 */

	//
	// Screens
	//
	OptionsScreen = NerfPDAScreenOptions(CreateWindow(class'NerfPDAScreenOptions', ScreenLeft, ScreenTop, ScreenWidth, ScreenHeight, self));
	HideChildWindow(OptionsScreen);

	ControlsScreen = NerfPDAScreenControls(CreateWindow(class'NerfPDAScreenControls', ScreenLeft, ScreenTop, ScreenWidth, ScreenHeight, self));
	HideChildWindow(ControlsScreen);

	MultiPlayerScreen = NerfPDAScreenMultiPlayer(CreateWindow(class'NerfPDAScreenMultiPlayer', ScreenLeft, ScreenTop, ScreenWidth, ScreenHeight, self));
	HideChildWindow(MultiPlayerScreen);

	MainScreen = NerfPDAScreenMain(CreateWindow(class'NerfPDAScreenMain', ScreenLeft, ScreenTop, ScreenWidth, ScreenHeight, self));
	HideChildWindow(MainScreen);

	// center mouse  FIXME: doesnt work right when starting in windowed mode
	Root.SetMousePos(NerfRootWindow(Root).ScreenWidth/2, NerfRootWindow(Root).ScreenHeight/2);

	MultiplayerScreenShown = False;
	bFirstRun = False;

	UpdateData();

//	CurrentProfile = int(GetConfigString("DefaultPlayer", "Profile", "user.ini"));
//	if (CurrentProfile == 0 || !PlayerProfile.LoadProfile(CurrentProfile))
//		bDoTick = True;		// can't create modal dialog in create, so do it on tick
//	else
//		SetCharInfo();

	if ( PlayerProfile.InfoClass ~= "NerfKids.Wes" )
		bDoTick = True;
	else
		SetCharInfo();
}

function Tick(float Delta)
{
	Super.Tick(Delta);

	// must do this modal window in tick since doing it in Create() is a bad thing...
	if (bDoTick)
	{
		bDoTick = False;
		bFirstRun = True;
//		log(class$ " WES: Tick NewPlayerProfile");
		NewPlayerProfile();				// intiate player setup
	}
}


function UpdateData()
{
// DSL - bring everything in from USER.INI
	PlayerProfile.ReadProfiles();
//log( "This report comes in PDA Creation after ReadProfiles" );
//	PlayerProfile.Report();

	PlayerProfile.SetTotalScore(GetPlayerOwner().TotalScore);
	PlayerProfile.SetAccessLevel(GetPlayerOwner().ArenaAccessLevel);

//log( "This report comes in PDA Creation after ReadPlayer Pawn" );
//	PlayerProfile.Report();

//	PlayerProfile.Profile[0].TotalScore = GetPlayerOwner().TotalScore;
//	PlayerProfile.Profile[0].ArenaAccessLevel = GetPlayerOwner().ArenaAccessLevel;

// DSL -- quick, copy current info before it rots
	PlayerProfile.StoreCurrentProfile();
//log( "This report comes in PDA Creation after StoreCurrent" );
//	PlayerProfile.Report();

// DSL -- copy from our I/O buffers into Dave's globals
	PlayerProfile.ReadProfileInfo();
//log( "This report comes in PDA Creation after UpdateInfo" );
//	PlayerProfile.Report();
}




function Notify(UWindowDialogControl C, byte E)
{
	if (!WindowEnabled)
		return;

	Super.Notify(C, E);
}

function Paint(Canvas C, float X, float Y)
{
	local float Junk;

	if (FontHeight == 0)
		TextSize(C, "TEST", Junk, FontHeight);
}

function SetPlayCredits(bool yn)
{
	SetConfigString("NerfI.NerfIPlayer", "bPlayCredits", yn, "user.ini");
}

//
// Card creation functions
// - to support dynamic loading of cards
//

function ShowNameCard()
{
	EnablePDA(False);

//	log(class$ " WES: PDA ShowNameCard initProfileInfo");
	PlayerProfile.InitProfileInfo();

	NameCard = NerfCardName(Root.CreateWindow(class'NerfCardName', 0, 0, 0, 0));
	ShowModal(NameCard);
}

function ShowCharacterCard()
{
	CharacterCard = NerfCardChar(Root.CreateWindow(class'NerfCardChar', 0, 0, 0, 0));
	ShowModal(CharacterCard);
}

function ShowLevelCard(optional bool DontShow)
{
	LevelCard = NerfCardLevel(Root.CreateWindow(class'NerfCardLevel', 0, 0, 0, 0));

	if (!DontShow)
		ShowModal(LevelCard);
}

function ShowProfileCard()
{
	EnablePDA(False);
//	PlayerProfile.SaveProfileInfo();		// i2d
	PlayerProfile.StoreCurrentProfile();
	ProfileCard = NerfCardProfile(Root.CreateWindow(class'NerfCardProfile', 0, 0, 0, 0));
	ShowModal(ProfileCard);
}

//
// Card callback interface
// - called by cards to notify us they've been closed
//
function SetPreviousOwner()
{
	ixPreviousOwner = PlayerProfile.CurrentProfile;
//log( "set Previous Owner to "$ixPreviousOwner );
}

function CardNameClosed()
{
	if (NameCard.bEscapeClose)
	{
		SetESCPlayerDefaults();
		EnablePDA(True);
	}
	else
	{		
//		PlayerProfile.SaveProfileInfo();		// i2d
		PlayerProfile.StoreCurrentProfile();
		ShowCharacterCard();
	}
}

function CardCharClosed()
{
//log( "CardCharClosed, ixp = "$ixPreviousOwner );
	if (CharacterCard.bEscapeClose)
	{
		SetESCPlayerDefaults();
		EnablePDA(True);
	}
	else
	{
//		PlayerProfile.SaveProfileInfo();		// i2d
		PlayerProfile.StoreCurrentProfile();
		ShowLevelCard();
//		ShowLevelCard(True); DSL
		LevelCard.SetCharPicIndex(CharacterCard.SelectedChar);
	
		ShowChildWindow(LevelCard);
	}
}

function CardLevelClosed()
{
//log( "CardLevelClosed ESC = "$LevelCard.bEscapeClose$", ixp = "$ixPreviousOwner );
	if (LevelCard.bEscapeClose)
	{
		SetESCPlayerDefaults();
		EnablePDA(True);
	}
	else
	{
//log( "CardLevelClosed non-esc for "$NameCard.GetName() );
		// set new player from info in cards
		bMustTravel = True;
		bFirstRun = False;

		PlayerProfile.InfoName = NameCard.GetName();
		PlayerProfile.InfoLevel = LevelCard.GetDifficulty();

		GetPlayerOwner().PlayerReplicationInfo.PlayerName = NameCard.GetName();
		PlayerClass = CharacterCard.GetClass();
		CharIndex = CharacterCard.SelectedChar;
		Difficulty = LevelCard.GetDifficulty();
		DifficultyDesc = LevelDescriptions[Difficulty];
		CharPicture = PDACharName[CharIndex];
		GetPlayerOwner().TotalScore = 0;
		GetPlayerOwner().PlayerReplicationInfo.Score = 0;
		Events = 0;
		GetPlayerOwner().ArenaAccessLevel = Events;
//		SetConfigString("DefaultPlayer", "Profile", PlayerProfile.CurrentProfile, "user.ini");
//		SetConfigString("DefaultPlayer", "Name", NameCard.GetName(), "user.ini");
//		SetConfigString("DefaultPlayer", "Class", CharacterCard.GetClass(), "user.ini");
//		SaveConfigs();
		PlayerProfile.SaveProfileInfo();
		PlayerProfile.StoreCurrentProfile();
		ShowCharInfo();
		EnablePDA(True);
	}
}

function CardProfileClosed()
{
	local int ThisPlayerProfile;

	EnablePDA(True);

//log( "CardProfileClosed ESC = "$ProfileCard.bEscapeClose$", ixp = "$ixPreviousOwner );
	ThisPlayerProfile = PlayerProfile.CurrentProfile;

	if (ProfileCard.bEscapeClose)
	{
		SetESCPlayerDefaults();
		ShowCharInfo();
	}
	else
	{
//		log(class$ " WES : PDA This PlayerProfile" @ThisPlayerProfile);
//		PlayerProfile.CurrentProfile = ThisPlayerProfile;
//		log(class$ " WES : PDA Read PlayerProfile");
//		PlayerProfile.ReadProfileInfo();
//		log(class$ " WES : PDA Set PlayerProfile" );
		PlayerProfile.ReadProfileInfo();
		SetCharInfo();
		bMustTravel = True;
		Play("", True);
	}
}

function NewPlayerProfile()
{
//	log(class$ " WES: PDA NewPlayerProfile" @GetPlayerOwner().TotalScore);

	PlayerProfile.SaveProfileInfo();
	PlayerProfile.StoreCurrentProfile();

	if (!bFirstRun)
		ShowProfileCard();

	else
		ShowNameCard();

//	if (PlayerProfile.FindFirstProfile() > 0)
//	else
//		ShowNameCard();
}

function SetESCPlayerDefaults()
{
	// set player profile to defaults when user ESC's out of firstrun cards
	
	if (!bFirstRun)
	{
//log( " SetESC restoring "$ixPreviousOwner );
		if ( ixPreviousOwner < 1 || ixPreviousOwner > 4 )
			ixPreviousOwner = 1;
		PlayerProfile.ReadProfile(ixPreviousOwner);
		PlayerProfile.ReadProfileInfo();
		return;
	}

	PlayerProfile.ReadProfile(1);				// set up Ted as default
	bMustTravel = True;
	PlayerClass = CharClass[0];
	GetPlayerOwner().PlayerReplicationInfo.PlayerName = "Player";
	Difficulty = 1;
	DifficultyDesc = LevelDescriptions[Difficulty];
	CharIndex = 0;
	CharPicture = PDACharName[0];
	GetPlayerOwner().TotalScore = 0;
	GetPlayerOwner().PlayerReplicationInfo.Score = 0;
	Events = 0;
//	SetConfigString("DefaultPlayer", "Profile", "0", "user.ini");
//	SetConfigString("DefaultPlayer", "Name", GetPlayerOwner().PlayerReplicationInfo.PlayerName, "user.ini");
//	SetConfigString("DefaultPlayer", "Class", PlayerClass, "user.ini");
//	SaveConfigs();
	PlayerProfile.SaveProfiles();
	ShowCharInfo();	
}

// set player info from profile
function SetCharInfo()
{
	local int i;
		
//	log(class$ " WES: PDA SetCharInfo" @PlayerProfile.InfoClass);
	PlayerClass = PlayerProfile.InfoClass;
	GetPlayerOwner().PlayerReplicationInfo.PlayerName = PlayerProfile.InfoName;
	Difficulty = PlayerProfile.InfoLevel;
	DifficultyDesc = LevelDescriptions[Difficulty];
	CharIndex = ClassToIndex(PlayerProfile.InfoClass);
	CharPicture = PDACharName[CharIndex];
	GetPlayerOwner().TotalScore = PlayerProfile.InfoPoints;
//	GetPlayerOwner().PlayerReplicationInfo.Score = 0;
//	Events = PlayerProfile.InfoEvents;
//	GetPlayerOwner().ArenaAccessLevel = Events;
//	SetConfigString("DefaultPlayer", "Profile", PlayerProfile.CurrentProfile, "user.ini");
//	SetConfigString("DefaultPlayer", "Name", PlayerProfile.InfoName, "user.ini");
//	SetConfigString("DefaultPlayer", "Class", PlayerProfile.InfoClass, "user.ini");

//	SaveConfigs();
	ShowCharInfo();	
}


// update Character info in the PDA
function ShowCharInfo()
{
	local int CompletedEvents;

	// show appropriate screen only
	HideChildWindow(OptionsScreen);
	HideChildWindow(ControlsScreen);
	HideChildWindow(MultiPlayerScreen);
	MultiPlayerScreenShown = False;
	ShowStatusWindow(False);
	ShowChildWindow(MainScreen);

	//  PDA Picture
	SetCharPicture(CharPicture);

	//  Character Name
	SetScreenTitle(GetPlayerOwner().PlayerReplicationInfo.PlayerName $ MainScreenTitleStats);

	// update the main character info screen
//	MainScreen.ShowCharInfo(GetPlayerOwner().PlayerReplicationInfo.PlayerName, MainScreenTitleLevel $ " " $ Rank,
//		GetPlayerOwner().TotalScore, DifficultyDesc, Events);

	CompletedEvents = PlayerProfile.GetCompletions();

//log( "ESC - PPIN = "$PlayerProfile.InfoName$" and PRI is "$GetPlayerOwner().PlayerReplicationInfo.PlayerName );
//log( "ESC - also P[0].Name = "$PlayerProfile.GetName() );
	MainScreen.ShowCharInfo(PlayerProfile.InfoName, MainScreenTitleLevel $ " " $ Rank,
		PlayerProfile.InfoPoints, DifficultyDesc, CompletedEvents);
}

function Play(optional string StartMap, optional bool bNoClose)
{
	local string URL;
	local GameInfo NewGame;
	local string GameType;
	local string Map;
	local bool bStandAlone;

//	SaveConfig();
//log( "Play Button - before save profinfo" );
//	PlayerProfile.Report();
	PlayerProfile.SaveProfileInfo();	// from Dave's InfoStuff to our array
	PlayerProfile.SaveProfiles();		// from our array to USER.INI
	GetPlayerOwner().TotalScore = PlayerProfile.GetTotalScore();
	GetPlayerOwner().ArenaAccessLevel = PlayerProfile.GetAccessLevel();

//log( "Play Button - after save profiles" );
//	PlayerProfile.Report();

	if (MultiPlayerScreen.WindowIsVisible())
	{
		if (MultiPlayerScreen.SetupServerScreen != None && MultiPlayerScreen.SetupServerScreen.WindowIsVisible())
		{
			log("Starting Multiplayer Server");
			MultiPlayerScreen.SetupServerScreen.StartServer();
		}
		if (MultiPlayerScreen.JoinGameScreen != None && MultiPlayerScreen.JoinGameScreen.WindowIsVisible())
		{
			log("Joining a Network Game");
			MultiPlayerScreen.JoinGameScreen.JoinGame();
		}
		return;
	}

	if (!bNoClose)
		Root.Close();

	if (StartMap == "")
	{
		log("Returning to existing single-player game");
		return;
	}

	log("Starting a Singleplayer Game");

	if (!bMustTravel)
		return;

	bMustTravel = False;
	StartMap = ReadyRooms[GetPlayerOwner().ArenaAccessLevel]
		$ "?Class=" $ PlayerClass
		$ "?Difficulty=" $ Difficulty
		$ "?Name="  $ GetPlayerOwner().PlayerReplicationInfo.PlayerName
		$ "?Team="  $ GetPlayerOwner().PlayerReplicationInfo.Team
		$ "?Rate="  $ GetPlayerOwner().Player.CurrentNetSpeed;

	GetPlayerOwner().ClientTravel(StartMap, TRAVEL_Absolute, false);
}

function ExitGame()
{
	local NerfQuitBox W;
	local UWindowFramedWindow F;
	
//log( "Exit Game Button - before save profinfo" );
//	PlayerProfile.Report();
	PlayerProfile.SaveProfileInfo();	// from Dave's InfoStuff to our array
	PlayerProfile.SaveProfiles();		// from our array to USER.INI
//log( "Exit Game Button - after save profiles" );
//	PlayerProfile.Report();

	ConfirmExit = NerfQuitBox(Root.CreateWindow(class'NerfQuitBox', 100, 100, 100, 100, Self));
	ConfirmExit.SetupMessageBox(ConfirmExitTitle, ConfirmExitText, MB_YesNo, MR_No);
	F = UWindowFramedWindow(GetParent(class'UWindowFramedWindow'));

	if (F != None)
		F.ShowModal(ConfirmExit);
	else
		Root.ShowModal(ConfirmExit);
}

function NerfMessageBoxDone(NerfMessageBox W, MessageBoxResult Result)
{
	if (W == ConfirmExit)
	{
		SetPlayCredits(ConfirmExit.bPlayCredits);
		ConfirmExit = None;
		if (Result == MR_Yes)
		{
			NerfRootWindow(Root).DoQuitGame();
			GetPlayerOwner().ConsoleCommand("Exit");
		}
	}
}

function ShowStatusWindow(bool yn)
{
	if (StatusWindow != None)
		if (yn)
			ShowChildWindow(StatusWindow);
		else
			HideChildWindow(StatusWindow);
}

function SetScreenTitle(String S)
{
	ScreenTitleLabel.SetText(S);
}

function Display(bool bShow)
{
	if (bShow)
	{
		UpdateData();
		GetPlayerOwner().PlaySound(ShowSound, SLOT_Interface);

		if (NameCard != None)		HideChildWindow(NameCard);
		if (CharacterCard != None)	HideChildWindow(CharacterCard);
		if (LevelCard != None)		HideChildWindow(LevelCard);
		if (ProfileCard != None)	HideChildWindow(ProfileCard);

		EnablePDA(True);

		ShowCharInfo();
	}
	else
	{
		GetPlayerOwner().PlaySound(HideSound, SLOT_Interface);
		if (bMustTravel)
			Play(ReadyRooms[GetPlayerOwner().ArenaAccessLevel]);
	}
}

function bool EnablePDA(bool bEnable)
{
	if (bEnable == WindowEnabled)
		return False;				// no change

	WindowEnabled = bEnable;			// Disable PDA window notify

	return True;
}

function int ClassToIndex(string ClassString)
{
	local int i;

	for (i = 0; i < ArrayCount(CharClass); i++)
		if (CharClass[i] == ClassString)
			return i;

	return 0;				// not found
}

function string ClassToPic(string ClassString)
{
	local int i;

	for (i = 0; i < ArrayCount(CharClass); i++)
		if (CharClass[i] == ClassString)
			return CharPicName[i];
	
	return string(None);	// not found
}

function ResolutionChanged(float W, float H)
{
	Super.ResolutionChanged(W, H);

	if (OptionsScreen != None)
		OptionsScreen.ResolutionChanged(W,H);
}

function CenterWindow()
{
	ParentWindow.WinLeft = (NerfRootWindow(Root).ScreenWidth - PDAWidth) / 2;
	ParentWindow.WinTop = (NerfRootWindow(Root).ScreenHeight - PDAHeight) / 2;
}

function SetCharPicture(string PicName)
{
	// implemented in subclass
}

defaultproperties
{
     PlayerProfileClass=NerfMenu.NerfPlayerProfile
     LevelDescriptions(0)=Nerf Junior
     LevelDescriptions(1)=Amateur Pro
     LevelDescriptions(2)=Super Nerf Pro
     LevelDescriptions(3)=Mega Nerf
     ReadyRooms(0)=RR-Amateur
     ReadyRooms(1)=RR-Sequoia
     ReadyRooms(2)=RR-Orbital
     ReadyRooms(3)=RR-Barracuda
     ReadyRooms(4)=RR-Asteroid
     ReadyRooms(5)=RR-Sky
     ReadyRooms(6)=RR-Luna
     ReadyRooms(7)=RR-Champion
     ShowSound=Sound'NerfRes.PDAUp'
     HideSound=Sound'NerfRes.PDADown'
     Difficulty=255
     CharClass(0)=NerfKids.Ted
     CharClass(1)=NerfKids.Jami
     CharClass(2)=NerfKids.Ryan
     CharClass(3)=NerfKids.Sarge
     CharPicName(0)=NerfRes.CardTed
     CharPicName(1)=NerfRes.CardJami
     CharPicName(2)=NerfRes.CardRyan
     CharPicName(3)=NerfRes.CardSarge
     PDACharName(0)=Ted
     PDACharName(1)=Jami
     PDACharName(2)=Ryan
     PDACharName(3)=Sarge
     StatsButtonText=Stats
     StatsButtonHelp=Display player statistics
     OptionsButtonText=Options
     OptionsButtonHelp=Set up user options
     ControlsButtonText=Controls
     ControlsButtonHelp=Adjusts keyboard/mouse controls
     MultiPlayerButtonText=Multiplayer
     MultiPlayerButtonHelp=Setup/Start/Join multiplayer game
     PlayButtonText=Play
     NewGameButtonText=New Game
     NewGameButtonHelp=Start a new game
     ExitEventButtonText=Exit Event
     ExitEventButtonHelp=Quit this Nerf event
     QuitButtonText=Quit
     QuitButtonHelp=Exit to windows
     ConfirmExitTitle=Confirm Exit
     ConfirmExitText=Are you sure you want to quit?
     MainScreenTitleStats='s Stats
     MainScreenTitleLevel=Level
}
