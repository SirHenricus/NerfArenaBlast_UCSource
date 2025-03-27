class NerfPDAScreenSetupServer extends NerfWindow;

var bool Initialized;
var bool Changed;
var Class IpServerClass;

// Event
var config string GameType;
var class<GameInfo> GameClass;
var string Games[16];
var int MaxGames;
var NerfSelectorControl EventSelector;
var localized string EventText;
var localized string EventHelp;

// Arena
var config string Map;
var NerfSelectorControl ArenaSelector;
var localized string ArenaText;
var localized string ArenaHelp;

// Weapon Pak
var config string WeaponPak;
var NerfSelectorControl WeaponPakSelector;
var localized string WeaponPakText;
var localized string WeaponPakHelp;
var config string WeaponPakClass[10];
var localized string WeaponPakNames[10];

// Point Limit
var config int PointLimit;
var NerfEditControl PointLimitEdit;
var localized string PointLimitText;
var localized string PointLimitHelp;

// Time Limit
var config int TimeLimit;
var NerfEditControl TimeLimitEdit;
var localized string TimeLimitText;
var localized string TimeLimitHelp;

// Max Players
var config int MaxPlayers;
var NerfEditControl MaxPlayersEdit;
var localized string MaxPlayersText;
var localized string MaxPlayersHelp;

// Server Name
var config string ServerName;
var NerfEditControl ServerNameEdit;
var localized string ServerNameText;
var localized string ServerNameHelp;

// Publish Server
var config bool PublishServer;
var UWindowLabelControl PublishServerLabel;
var localized string PublishServerText;

var NerfButtonControl PublishServerOnButton;
var localized string PublishServerOnText;
var localized string PublishServerOnHelp;

var NerfButtonControl PublishServerOffButton;
var localized string PublishServerOffText;
var localized string PublishServerOffHelp;

//// Team Play
//var config bool TeamPlay;
//var UWindowLabelControl TeamPlayLabel;
//var localized string TeamPlayText;
//
//var NerfButtonControl TeamPlayOnButton;
//var localized string TeamPlayOnText;
//var localized string TeamPlayOnHelp;
//
//var NerfButtonControl TeamPlayOffButton;
//var localized string TeamPlayOffText;
//var localized string TeamPlayOffHelp;

// Weapon Stay
var config bool WeaponStay;
var UWindowLabelControl WeaponStayLabel;
var localized string WeaponStayText;

var NerfButtonControl WeaponStayOnButton;
var localized string WeaponStayOnText;
var localized string WeaponStayOnHelp;

var NerfButtonControl WeaponStayOffButton;
var localized string WeaponStayOffText;
var localized string WeaponStayOffHelp;

// Dedicated Server
var config bool DedicatedServer;
var UWindowLabelControl DedicatedServerLabel;
var localized string DedicatedServerText;

var NerfButtonControl DedicatedServerOnButton;
var localized string DedicatedServerOnText;
var localized string DedicatedServerOnHelp;

var NerfButtonControl DedicatedServerOffButton;
var localized string DedicatedServerOffText;
var localized string DedicatedServerOffHelp;

function StartServer()
{
	local string URL;
	local GameInfo NewGame;
	local byte Difficulty;

	GameClass = class<GameInfo>(DynamicLoadObject(GameType, class'Class'));

	NewGame = GetPlayerOwner().Spawn(GameClass);
	NewGame.ResetGame();
	DeathMatchGame(NewGame).Default.FragLimit = PointLimit;
	DeathMatchGame(NewGame).Default.TimeLimit = TimeLimit;
	DeathMatchGame(NewGame).Default.MaxPlayers = MaxPlayers;
	DeathMatchGame(NewGame).Default.bCoopWeaponMode	= WeaponStay;
	// FIXME: TODO: implement team play
	Difficulty = -1;		// FIXME
	NewGame.Destroy();

	URL = Map $ "?Game=" $ GameType;
	if ((Difficulty < 0) || (Difficulty > 3))
	Difficulty = 1;
	URL = URL $ "?Difficulty=" $ Difficulty;
	if (GetPlayerOwner().Level.Game != None)
		URL = URL $ "?GameSpeed=" $ GetPlayerOwner().Level.Game.GameSpeed;
	if (!DedicatedServer)
	URL = URL $ "?Listen";
	log("URL: '" $ URL $ "'");

//	GetPlayerOwner().PlayEnterSound();
	Root.Close();

	if (DedicatedServer)
	{
		log("Starting a Dedicated Server");
		
		GetPlayerOwner().ConsoleCommand("RELAUNCH " $ URL $ " -server log=" $ GameClass.Default.ServerLogName);
	}
	else
	{
		log("Starting a Multiplayer Server");

		GetPlayerOwner().ClientTravel(URL, TRAVEL_Absolute, false);
	}
}

function Created()
{
	local int ControlWidth, ControlLeft;
	local int ControlTop;

	// Event
	local int i, j, Selection, Pos;
	local class<GameInfo> TempClass;
	local string TempGame;
	local string NextGame;
	local string TempGames[64];
	local bool bFoundSavedGameClass;

	Initialized = False;

	// Force IPServer to load
	IPServerClass = Class(DynamicLoadObject("IpServer.UdpServerUplink", class'Class'));

	Super.Created();

	ControlWidth = WinWidth - 20;
	ControlLeft = 10;
	ControlTop = 10;

	//
	// Create components.
	//

	// Event (GameType)
	EventSelector = NerfSelectorControl(CreateControl(class'NerfSelectorControl', ControlLeft, ControlTop, ControlWidth, 1));
	EventSelector.SetText(EventText);
	EventSelector.SetHelpText(EventHelp);
	EventSelector.SetFont(F_Normal);
	EventSelector.SetEditable(False);
	EventSelector.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);

	// Compile a list of all event types (gametypes)
	i = 0;
	NextGame = GetPlayerOwner().GetNextInt("GameInfo", 0); 
	while (NextGame != "")
	{
		Pos = InStr(NextGame, ".");
		if (Left(NextGame, Pos) ~= "NerfI")
			TempGames[i] = NextGame;
		i++;
		if(i == 64)
		{
			Log("More than 64 gameinfos listed in int files");
			break;
		}
		NextGame = GetPlayerOwner().GetNextInt("GameInfo", i);
	}

	// Fill the control with events (gametypes)
	for (i = 0; i < 64; i++)
	{
		if (TempGames[i] != "")
		{
			Games[MaxGames] = TempGames[i];
			if ( !bFoundSavedGameClass && (Games[MaxGames] ~= GameType) )
			{
				bFoundSavedGameClass = true;
				Selection = MaxGames;
			}
			TempClass = Class<GameInfo>(DynamicLoadObject(Games[MaxGames], class'Class'));
			EventSelector.AddItem(TempClass.Default.GameName);
			MaxGames++;
		}
	}
	EventSelector.SetSelectedIndex(Selection);	
	GameType = Games[Selection];
	GameClass = Class<GameInfo>(DynamicLoadObject(GameType, class'Class'));
	ControlTop += 20;

	// Arena
	ArenaSelector = NerfSelectorControl(CreateControl(class'NerfSelectorControl', ControlLeft, ControlTop, ControlWidth, 1));
	ArenaSelector.SetText(ArenaText);
	ArenaSelector.SetHelpText(ArenaHelp);
	ArenaSelector.SetFont(F_Normal);
	ArenaSelector.SetEditable(False);
	ArenaSelector.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
	IterateMaps(Map);
	ControlTop += 20;

//	// Weapon Pak
//	WeaponPakSelector = NerfSelectorControl(CreateControl(class'NerfSelectorControl', ControlLeft, ControlTop, ControlWidth, 1));
//	WeaponPakSelector.SetText(WeaponPakText);
//	WeaponPakSelector.SetHelpText(WeaponPakHelp);
//	WeaponPakSelector.SetFont(F_Normal);
//	WeaponPakSelector.SetEditable(False);
//	WeaponPakSelector.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
//	for (i = 0; i < 10; i++)
//	{
//		if (WeaponPakNames[i] == "")
//			break;
//
//		WeaponPakSelector.AddItem(WeaponPakNames[i], WeaponPakClass[i]);
//	}
//	WeaponPakSelector.SetSelectedIndex(Max(WeaponPakSelector.FindItemIndex2(WeaponPak),0));	
//	ControlTop += 20;

	// Point Limit
	PointLimitEdit = NerfEditControl(CreateControl(class'NerfEditControl', ControlLeft, ControlTop, ControlWidth, 1));
	PointLimitEdit.SetText(PointLimitText);
	PointLimitEdit.SetHelpText(PointLimitHelp);
	PointLimitEdit.SetFont(F_Normal);
	PointLimitEdit.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
	PointLimitEdit.SetNumericOnly(True);
	PointLimitEdit.SetMaxLength(5);
	PointLimitEdit.SetValue(string(PointLimit));
	ControlTop += 20;

	// Time Limit
	TimeLimitEdit = NerfEditControl(CreateControl(class'NerfEditControl', ControlLeft, ControlTop, ControlWidth, 1));
	TimeLimitEdit.SetText(TimeLimitText);
	TimeLimitEdit.SetHelpText(TimeLimitHelp);
	TimeLimitEdit.SetFont(F_Normal);
	TimeLimitEdit.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
	TimeLimitEdit.SetNumericOnly(True);
	TimeLimitEdit.SetMaxLength(3);
	TimeLimitEdit.SetValue(string(TimeLimit));
	ControlTop += 20;

	// Max Players
	MaxPlayersEdit = NerfEditControl(CreateControl(class'NerfEditControl', ControlLeft, ControlTop, ControlWidth, 1));
	MaxPlayersEdit.SetText(MaxPlayersText);
	MaxPlayersEdit.SetHelpText(MaxPlayersHelp);
	MaxPlayersEdit.SetFont(F_Normal);
	MaxPlayersEdit.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
	MaxPlayersEdit.SetNumericOnly(True);
	MaxPlayersEdit.SetMaxLength(2);
	MaxPlayersEdit.SetDelayedNotify(True);
	MaxPlayersEdit.SetValue(string(MaxPlayers));
	ControlTop += 20;

	// Server Name
	ServerNameEdit = NerfEditControl(CreateControl(class'NerfEditControl', ControlLeft, ControlTop, ControlWidth, 1));
	ServerNameEdit.SetText(ServerNameText);
	ServerNameEdit.SetHelpText(ServerNameHelp);
	ServerNameEdit.SetFont(F_Normal);
	ServerNameEdit.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
	ServerNameEdit.SetNumericOnly(False);
	ServerNameEdit.SetMaxLength(40);
	ServerNameEdit.SetDelayedNotify(True);
	ServerName = GetPlayerOwner().GameReplicationInfo.ServerName;
	ServerNameEdit.SetValue(ServerName);
	ControlTop += 20;

	//
	// Publish Server on Master Server (i.e. GameSpy, etc.)
	//
	// label
	PublishServerLabel = UWindowLabelControl(CreateControl(class'UWindowLabelControl', ControlLeft, ControlTop + 5, ControlWidth/2, 20));
	PublishServerLabel.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
	PublishServerLabel.SetText(PublishServerText);
	PublishServerLabel.SetFont(F_Normal);

	// Publish Server ON button
	PublishServerOnButton = NerfButtonControl(CreateCONTROL(class'NerfButtonControl', WinWidth - 155, ControlTop, 71, 20));
	PublishServerOnButton.bIgnoreLDoubleclick = True;
	PublishServerOnButton.SetText(PublishServerOnText);
	PublishServerOnButton.SetHelpText(PublishServerOnHelp);
	PublishServerOnButton.SetFont(F_Normal);
	PublishServerOnButton.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);

	// Publish Server OFF button
	PublishServerOffButton = NerfButtonControl(CreateCONTROL(class'NerfButtonControl', WinWidth - 80, ControlTop, 71, 20));
	PublishServerOffButton.bIgnoreLDoubleclick = True;
	PublishServerOffButton.SetText(PublishServerOffText);
	PublishServerOffButton.SetHelpText(PublishServerOffHelp);
	PublishServerOffButton.SetFont(F_Normal);
	PublishServerOffButton.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
	SetPublishServer(GetPlayerOwner().ConsoleCommand("get IpServer.UdpServerUplink DoUplink") ~= "True");
	ControlTop += 25;

	//
	// Team Play
	//
	// label
//	TeamPlayLabel = UWindowLabelControl(CreateControl(class'UWindowLabelControl', ControlLeft, ControlTop + 5, ControlWidth/2, 20));
//	TeamPlayLabel.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
//	TeamPlayLabel.SetText(TeamPlayText);
//	TeamPlayLabel.SetFont(F_Normal);
//
//	// Team Play ON button
//	TeamPlayOnButton = NerfButtonControl(CreateCONTROL(class'NerfButtonControl', WinWidth - 155, ControlTop, 71, 20));
//	TeamPlayOnButton.bIgnoreLDoubleclick = True;
//	TeamPlayOnButton.SetText(TeamPlayOnText);
//	TeamPlayOnButton.SetHelpText(TeamPlayOnHelp);
//	TeamPlayOnButton.SetFont(F_Normal);
//	TeamPlayOnButton.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
//
//	// Team Play OFF button
//	TeamPlayOffButton = NerfButtonControl(CreateCONTROL(class'NerfButtonControl', WinWidth - 80, ControlTop, 71, 20));
//	TeamPlayOffButton.bIgnoreLDoubleclick = True;
//	TeamPlayOffButton.SetText(TeamPlayOffText);
//	TeamPlayOffButton.SetHelpText(TeamPlayOffHelp);
//	TeamPlayOffButton.SetFont(F_Normal);
//	TeamPlayOffButton.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
//	SetTeamPlay(TeamPlay);
//	ControlTop += 25;

	//
	// Weapons Stay
	//
	// label
	WeaponStayLabel = UWindowLabelControl(CreateControl(class'UWindowLabelControl', ControlLeft, ControlTop + 5, ControlWidth/2, 20));
	WeaponStayLabel.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
	WeaponStayLabel.SetText(WeaponStayText);
	WeaponStayLabel.SetFont(F_Normal);

	// Weapons Stay ON button
	WeaponStayOnButton = NerfButtonControl(CreateCONTROL(class'NerfButtonControl', WinWidth - 155, ControlTop, 71, 20));
	WeaponStayOnButton.bIgnoreLDoubleclick = True;
	WeaponStayOnButton.SetText(WeaponStayOnText);
	WeaponStayOnButton.SetHelpText(WeaponStayOnHelp);
	WeaponStayOnButton.SetFont(F_Normal);
	WeaponStayOnButton.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);

	// Weapons Stay OFF button
	WeaponStayOffButton = NerfButtonControl(CreateCONTROL(class'NerfButtonControl', WinWidth - 80, ControlTop, 71, 20));
	WeaponStayOffButton.bIgnoreLDoubleclick = True;
	WeaponStayOffButton.SetText(WeaponStayOffText);
	WeaponStayOffButton.SetHelpText(WeaponStayOffHelp);
	WeaponStayOffButton.SetFont(F_Normal);
	WeaponStayOffButton.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
	SetWeaponStay(WeaponStay);
	ControlTop += 25;

	//
	// Dedicated Server
	//
	// label
	DedicatedServerLabel = UWindowLabelControl(CreateControl(class'UWindowLabelControl', ControlLeft, ControlTop + 5, ControlWidth/2, 20));
	DedicatedServerLabel.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
	DedicatedServerLabel.SetText(DedicatedServerText);
	DedicatedServerLabel.SetFont(F_Normal);

	// Dedicated Server ON button
	DedicatedServerOnButton = NerfButtonControl(CreateCONTROL(class'NerfButtonControl', WinWidth - 155, ControlTop, 71, 20));
	DedicatedServerOnButton.bIgnoreLDoubleclick = True;
	DedicatedServerOnButton.SetText(DedicatedServerOnText);
	DedicatedServerOnButton.SetHelpText(DedicatedServerOnHelp);
	DedicatedServerOnButton.SetFont(F_Normal);
	DedicatedServerOnButton.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);

	// Dedicated Server OFF button
	DedicatedServerOffButton = NerfButtonControl(CreateCONTROL(class'NerfButtonControl', WinWidth - 80, ControlTop, 71, 20));
	DedicatedServerOffButton.bIgnoreLDoubleclick = True;
	DedicatedServerOffButton.SetText(DedicatedServerOffText);
	DedicatedServerOffButton.SetHelpText(DedicatedServerOffHelp);
	DedicatedServerOffButton.SetFont(F_Normal);
	DedicatedServerOffButton.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
	SetDedicatedServer(DedicatedServer);
	ControlTop += 25;

	Initialized = True;
}

function IterateMaps(string DefaultMap)
{
	local string FirstMap, NextMap, TestMap;
	local int Selected;
	local string MapName;
//##nerf WES 
// Prefix of the Map
	local string PrefixString;
	local int Marker;

	FirstMap = GetPlayerOwner().GetMapName(GameClass.Default.MapPrefix, "", 0);

	ArenaSelector.Clear();
	NextMap = FirstMap;

	while (!(FirstMap ~= TestMap))
	{
		// Make map name more 'friendly'
		MapName = Left(NextMap, Len(NextMap) - 4);				// strip file extension
		Marker = Instr(MapName, " ");

//##nerf WES 
// Checking the last charactor of the prefixstring.
		PrefixString = Left( MapName, InStr(MapName,"-"));
		PrefixString = Right(PrefixString, 1);

		// strip prefix
		if (Marker < 0)
			Marker = Instr(MapName, "-");
		if (Marker > -1)
			MapName = Right(MapName, Len(MapName) - Marker - 1);

//		MapName = Right(MapName, Len(MapName) - 2);				// strip prefix
//		if (Left(MapName, 1) == "-" || Left(MapName, 1) == " ")
//			MapName = Right(MapName, Len(MapName) - 1);			// strip hyphen or space

//##nerf WES 
// Putting extra string at the end of the map name.
		switch(PrefixString)
		{
			case "X":
			case "x":	MapName=MapName$"-Bonus";
						break;
			case "1":	MapName=MapName$"-Bonus I";
						break;
			case "2":	MapName=MapName$"-Bonus II";
						break;
			case "3":	MapName=MapName$"-Bonus III";
						break;
			case "4":	MapName=MapName$"-Bonus IV";
						break;
			case "5":	MapName=MapName$"-Bonus V";
						break;
			case "6":	MapName=MapName$"-Bonus VI";
						break;
			case "7":	MapName=MapName$"-Bonus VII";
						break;
			case "8":	MapName=MapName$"-Bonus VIII";
						break;
			case "9":	MapName=MapName$"-Bonus IX";
						break;
			case "0":	MapName=MapName$"-Bonus X";
						break;
			default	:	break;
		}

		// Add the map.

//##nerf WES 
// Checking Tutorial Levels.
		if (!(MapName ~= "Tut"))
			ArenaSelector.AddItem(MapName, NextMap);

		// Get the next map.
		NextMap = GetPlayerOwner().GetMapName(GameClass.Default.MapPrefix, NextMap, 1);

		// Text to see if this is the last.
		TestMap = NextMap;
	}
	ArenaSelector.Sort();

	ArenaSelector.SetSelectedIndex(Max(ArenaSelector.FindItemIndex2(DefaultMap, True), 0));	
}

function Notify(UWindowDialogControl C, byte E)
{
	Super.Notify(C, E);

	Changed = False;

	switch (E)
	{
	case DE_Change:
		switch(C)
		{
		case EventSelector:
			GameChanged();
			Changed = True;
			break;

		case ArenaSelector:
			MapChanged();
			Changed = True;
			break;

//		case WeaponPakSelector:
//			WeaponPak = WeaponPakSelector.GetValue2();
//			// FIXME: currently does nothing
//			Changed = True;
//			break;

		case PointLimitEdit:
			PointLimit = int(PointLimitEdit.GetValue());
			Changed = True;
			break;

		case TimeLimitEdit:
			TimeLimit = int(TimeLimitEdit.GetValue());
			Changed = True;
			break;

		case MaxPlayersEdit:
			MaxPlayers = int(MaxPlayersEdit.GetValue());
			Changed = True;
			break;

		case ServerNameEdit:
			ServerName = ServerNameEdit.GetValue();
			GetPlayerOwner().GameReplicationInfo.ServerName = ServerName;
			class'GameReplicationInfo'.Default.ServerName = ServerName;
			class'GameReplicationInfo'.Static.StaticSaveConfig();
			Changed = True;
			break;
		}
		break;

	case DE_Click:
		switch (C)
		{
		case PublishServerOnButton:
			SetPublishServer(True);
			Changed = True;
			break;

		case PublishServerOffButton:
			SetPublishServer(False);
			Changed = True;
			break;

//		case TeamPlayOnButton:
//			SetTeamPlay(True);
//			Changed = True;
//			break;
//
//		case TeamPlayOffButton:
//			SetTeamPlay(False);
//			Changed = True;
//			break;
//
		case WeaponStayOnButton:
			SetWeaponStay(True);
			break;

		case WeaponStayOffButton:
			SetWeaponStay(False);
			break;

		case DedicatedServerOnButton:
			SetDedicatedServer(True);
			break;

		case DedicatedServerOffButton:
			SetDedicatedServer(False);
			break;
		}
		break;
	}
	if (Initialized && Changed)
	{
		SaveConfig();
	}
}

//
// Message handlers
//

//function SetTeamPlay(bool yn)
//{
//	TeamPlay = yn;
//	if (yn)
//	{
//		ButtonDown(TeamPlayOnButton);
//		ButtonUp(TeamPlayOffButton);
//	}
//	else
//	{
//		ButtonDown(TeamPlayOffButton);
//		ButtonUp(TeamPlayOnButton);
//	}
//}

function SetWeaponStay(bool yn)
{
	if (Initialized && yn == WeaponStay)
		return;

	if (yn)
	{
		ButtonDown(WeaponStayOnButton);
		ButtonUp(WeaponStayOffButton);
	}
	else
	{
		ButtonDown(WeaponStayOffButton);
		ButtonUp(WeaponStayOnButton);
	}

	WeaponStay = yn;
	if (Initialized)
		Changed = True;
}

function SetPublishServer(bool yn)
{
	if (Initialized && yn == PublishServer)
		return;

	if (yn)
	{
		// TODO: add hacker warning here...
		ButtonDown(PublishServerOnButton);
		ButtonUp(PublishServerOffButton);
		GetPlayerOwner().ConsoleCommand("set IpServer.UdpServerUplink DoUplink True");
	}
	else
	{
		ButtonDown(PublishServerOffButton);
		ButtonUp(PublishServerOnButton);
		GetPlayerOwner().ConsoleCommand("set IpServer.UdpServerUplink DoUplink False");
	}

	PublishServer = yn;
	if (Initialized)
	{
		class'UdpServerUplink'.Static.StaticSaveConfig();
		Changed = True;
	}
}

function SetDedicatedServer(bool yn)
{
	if (Initialized && yn == DedicatedServer)
		return;

	if (yn)
	{
		ButtonDown(DedicatedServerOnButton);
		ButtonUp(DedicatedServerOffButton);
	}
	else
	{
		ButtonDown(DedicatedServerOffButton);
		ButtonUp(DedicatedServerOnButton);
	}

	DedicatedServer = yn;
	if (Initialized)
		Changed = True;
}

function GameChanged()
{
	local int CurrentGame, i;

	if (!Initialized)
		return;

	if(GameClass != None)
		GameClass.static.StaticSaveConfig();

	CurrentGame = EventSelector.GetSelectedIndex();

	GameType = Games[CurrentGame];
	GameClass = Class<GameInfo>(DynamicLoadObject(GameType, class'Class'));

	if (GameClass == None)
	{
		MaxGames--;
		if ( MaxGames > CurrentGame )
		{
			for ( i=CurrentGame; i<MaxGames; i++ )
				Games[i] = Games[i+1];
		}
		else if ( CurrentGame > 0 )
			CurrentGame--;
		EventSelector.SetSelectedIndex(CurrentGame);
		return;
	}
	if (ArenaSelector != None)
		IterateMaps(Map);
}

function MapChanged()
{
	if (!Initialized)
		return;

	Map = ArenaSelector.GetValue2();
//	ScreenshotWindow.SetMap(BotmatchParent.Map);
}

defaultproperties
{
     GameType=NerfI.DeathMatchGame
     EventText=Select Event
     EventHelp=Select an event to play
     Map=PM-Amateur.nrf
     ArenaText=Select Arena
     ArenaHelp=Select a map to play in
     WeaponPak=NerfWeapon.WeaponPak
     WeaponPakText=Select Weapon Pak
     WeaponPakHelp=Pick a weapon pack add-on to use
     WeaponPakClass(0)=NerfWeapon.WeaponPak
     WeaponPakNames(0)=Default
     PointLimit=6000
     PointLimitText=Point Limit
     PointLimitHelp=The game will end if a player achieves this many points. A value of 0 sets no point limit.
     TimeLimit=15
     TimeLimitText=Time Limit
     TimeLimitHelp=The game will end if after this many minutes. A value of 0 sets no time limit.
     MaxPlayers=16
     MaxPlayersText=Max Players
     MaxPlayersHelp=Maximum number of human players and spectators allowed to connect to the game.
     ServerNameText=Server Name
     ServerNameHelp=Name of server that will be listed on other players game browsers.
     PublishServerText=Publish Server
     PublishServerOnText=PUBLIC
     PublishServerOnHelp=List this server on the internet for others to join.  WARNING: this will expose your machine to hackers - USE AT YOUR OWN RISK!!!
     PublishServerOffText=PRIVATE
     PublishServerOffHelp=This machine will only be visible to the LAN game browser.  Other players can still connect if they know your IP address.
     WeaponStay=True
     WeaponStayText=Blasters Stay
     WeaponStayOnText=STAY
     WeaponStayOnHelp=Picked up Blasters instantly respawn
     WeaponStayOffText=NORMAL
     WeaponStayOffHelp=Picked up Blasters respawn normally
     DedicatedServerText=Dedicated Server
     DedicatedServerOnText=DEDICATED
     DedicatedServerOnHelp=Run game as dedicated server.  NOTE: THE GAME WILL DISSAPPEAR AND ONLY SHOW UP AS A TRAY ICON!!!
     DedicatedServerOffText=PARTICIPATE
     DedicatedServerOffHelp=This machine participates in multiplayer games
}
