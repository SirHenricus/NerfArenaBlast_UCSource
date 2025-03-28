//=============================================================================
// DeathMatchGame.
//
// Intergrated by Wezo at 7-7-99
//=============================================================================
class DeathMatchGame extends NerfGameInfo;

var() globalconfig int	FragLimit; 
var() globalconfig int	TimeLimit; // time limit in minutes
var() globalconfig bool	bMultiPlayerBots;
var() globalconfig bool bChangeLevels;
var() globalconfig bool bHardCoreMode;
var() globalconfig bool bMegaSpeed;

var		bool	bDontRestart;
var		bool	bGameEnded;
var		bool	bAlreadyChanged;
var		int		RemainingTime;
var		bool	bRequireReady;
var		int		coolcount;
var		int		coolcounter;			// between end of play and start of victory podium
var		bool	bGameInProgress;        // false = run coolcounter prior to victory kickoff
var     bool    bGameIsAfoot;           // used by startgun to hold fire

// Bot related info
var   int			NumBots;
var	  int			RemainingBots;
var() globalconfig int	InitialBots;
var		NerfBotInfo		BotConfig;
var localized string GlobalNameChange;
var localized string NoNameChange;
var localized string TimeMessage[16];
var class<NerfBotInfo> BotConfigType;

var() globalconfig float AirControl; 

// DSL
function PreBeginPlay()
{
	Super.PreBeginPlay();
	AIType = AITYPE_PointMatch;
    bGameInProgress=true;
    bGameEnded=false;
    bGameIsAfoot=false;
}

function PostBeginPlay()
{
    local string CurrentURL;

	BotConfig = spawn(BotConfigType);
	RemainingTime = 60 * TimeLimit;
	if ( (Level.NetMode == NM_Standalone) || bMultiPlayerBots )
    {
        if ( InitialBots > 15 ) InitialBots = 15;   // safety
		RemainingBots = InitialBots;
        CurrentURL = Level.GetLocalURL();           // get name of this map
        if ( CurrentURL != "" )
        {
			CurrentURL = Mid( CurrentURL, InStr(CurrentURL,"PM-Amateur"));
            if ( CurrentURL != "" )
            {
                if ( RemainingBots > 4 )
                    RemainingBots = 4;
            }
        }
    }
	Super.PostBeginPlay();
}

function int GetIntOption( string Options, string ParseString, int CurrentValue)
{
	if ( !bTeamGame && (ParseString ~= "Team") )
		return 255;

	return Super.GetIntOption(Options, ParseString, CurrentValue);
}

function bool IsRelevant(actor Other) 
{
	if ( bMegaSpeed && Other.IsA('Pawn') && Pawn(Other).bIsPlayer )
	{
		Pawn(Other).GroundSpeed *= 1.5;
		Pawn(Other).WaterSpeed *= 1.5;
		Pawn(Other).AirSpeed *= 1.5;
		Pawn(Other).Acceleration *= 1.5;
	}
	return Super.IsRelevant(Other);
}

function LogGameParameters(StatLog StatLog)
{
	if (StatLog == None)
		return;
	
	Super.LogGameParameters(StatLog);

	StatLog.LogEventString(StatLog.GetTimeStamp()$Chr(9)$"game"$Chr(9)$"FragLimit"$Chr(9)$FragLimit);
	StatLog.LogEventString(StatLog.GetTimeStamp()$Chr(9)$"game"$Chr(9)$"TimeLimit"$Chr(9)$TimeLimit);
	StatLog.LogEventString(StatLog.GetTimeStamp()$Chr(9)$"game"$Chr(9)$"MultiPlayerBots"$Chr(9)$bMultiPlayerBots);
	StatLog.LogEventString(StatLog.GetTimeStamp()$Chr(9)$"game"$Chr(9)$"HardCore"$Chr(9)$bHardCoreMode);
	StatLog.LogEventString(StatLog.GetTimeStamp()$Chr(9)$"game"$Chr(9)$"MegaSpeed"$Chr(9)$bMegaSpeed);
}

function float PlayerJumpZScaling()
{
	if ( bHardCoreMode )
		return 1.1;
	else
		return 1.0;
}

//
// Set gameplay speed.
//
function SetGameSpeed( Float T )
{
	GameSpeed = FMax(T, 0.1);
	if ( bHardCoreMode )
		Level.TimeDilation = 1.1 * GameSpeed;
	else
		Level.TimeDilation = GameSpeed;
}

event InitGame( string Options, out string Error )
{
	local string InOpt;
	local Class<Mutator> M;

	Super.InitGame(Options, Error);

	SetGameSpeed(GameSpeed);
	FragLimit = GetIntOption( Options, "FragLimit", FragLimit );
   	TimeLimit = GetIntOption( Options, "TimeLimit", TimeLimit );

	InOpt = ParseOption( Options, "CoopWeaponMode");
	if ( InOpt != "" )
	{
		log("CoopWeaponMode "$bool(InOpt));
		bCoopWeaponMode = bool(InOpt);
	}

	if (Difficulty <= 1)
	{
		M = class<Mutator>(DynamicLoadObject("NerfI.SuitPowerPlusMutator", class'Class'));
		BaseMutator.AddMutator(Spawn(M));
	}
}

//------------------------------------------------------------------------------
// Game Querying.

function string GetRules()
{
	local string ResultSet;
	ResultSet = Super.GetRules();

	// Timelimit.
	ResultSet = "\\timelimit\\"$TimeLimit;
		
	// Fraglimit
	ResultSet = ResultSet$"\\fraglimit\\"$FragLimit;
		
	// Bots in Multiplay?
	if( bMultiplayerBots )
		Resultset = ResultSet$"\\MultiplayerBots\\"$true;
	else
		Resultset = ResultSet$"\\MultiplayerBots\\"$false;

	// Change levels?
	if( bChangeLevels )
		Resultset = ResultSet$"\\ChangeLevels\\"$true;
	else
		Resultset = ResultSet$"\\ChangeLevels\\"$false;

	return ResultSet;
}

function int ReduceDamage(int Damage, name DamageType, pawn injured, pawn instigatedBy)
{
	if (injured.Region.Zone.bNeutralZone)
		return 0;

	if ( instigatedBy == None)
		return Damage;

	if ( bHardCoreMode )
		Damage *= 1.5;

	//skill level modification
	if ( (instigatedBy.Skill < 1.5) && instigatedBy.IsA('NerfBots') && injured.IsA('PlayerPawn') )
		Damage = Damage * (0.7 + 0.15 * instigatedBy.skill);

	return (Damage * instigatedBy.DamageScaling);
}

function float PlaySpawnEffect(inventory Inv)
{
	spawn( class 'ReSpawn',,, Inv.Location );
	return 0.3;
}

function RestartGame()
{
	local string NextMap;
	local MapList myList;
	local string CurrentURL;
	local string LevelName;

	// multipurpose don't restart variable
	if ( bDontRestart )
		return;

	log("Restart Game");

	// these server travels should all be relative to the current URL
	if ( bChangeLevels && !bAlreadyChanged && (MapListType != None) )
	{
		// open a the nextmap actor for this game type and get the next map
		bAlreadyChanged = true;
		if (Level.NetMode == NM_StandAlone)
		{
			CurrentURL=Level.GetLocalURL();
			if (CurrentURL != "")
			{
				CurrentURL = Left( CurrentURL, InStr(CurrentURL,"?"));
				CurrentURL = Mid( CurrentURL, InStr(CurrentURL,"-")+1);
			}
			Level.Game=spawn(class'SinglePlayer');
			Level.ServerTravel("RR-"$CurrentURL$"?Game=NerfI.SinglePlayer", false);
			return;
		}
		else
		{
			myList = spawn(MapListType);
			NextMap = myList.GetNextMap();
//log( self$" checking map list for "$NextMap );
			myList.Destroy();
			if ( NextMap == "" )
				NextMap = GetMapName(MapPrefix, NextMap,1);
			if ( NextMap != "" )
			{
				log("Changing to "$NextMap);
				Level.ServerTravel(NextMap, false);
				return;
			}
		}
	}

	Level.ServerTravel("?Restart" , false);
}

event playerpawn Login
(
	string Portal,
	string Options,
	out string Error,
	class<playerpawn> SpawnClass
)
{
	local playerpawn NewPlayer;

	NewPlayer = Super.Login(Portal, Options, Error, SpawnClass );
	if ( NewPlayer != None )
	{
		ChangeTeam(newPlayer, newPlayer.PlayerReplicationInfo.TeamType);
		NewPlayer.AirControl = AirControl;
		if ( Left(NewPlayer.PlayerReplicationInfo.PlayerName, 6) == DefaultPlayerName )
			ChangeName( NewPlayer, (DefaultPlayerName$NumPlayers), false );
		NewPlayer.PlayerReplicationInfo.SkinIcon = NewPlayer.Face();
		NewPlayer.bAutoActivate = true;
	}

	return NewPlayer;
}

function bool AddBot()
{
	local NavigationPoint StartSpot;
	local Nerfbots NewBot;
	local int BotN;


//##nerf WES
//	Difficulty = BotConfig.Difficulty;
	BotN = BotConfig.ChooseBotInfo();

//	log(class$ " WES: AddBot "$BotN$" - Level of Difficulty" @Level.Game.Difficulty);
	
	// Find a start spot.
	StartSpot = FindPlayerStart(None, 255);
	if( StartSpot == None )
	{
		log("Could not find starting spot for Bot");
		return false;
	}

	// Try to spawn the player.
	NewBot = Spawn(BotConfig.GetBotClass(BotN),,,StartSpot.Location,StartSpot.Rotation);

	if ( NewBot == None )
		return false;

	if ( (bHumansOnly || Level.bHumansOnly) && !NewBot.bIsHuman )
	{
		NewBot.Destroy();
		log("Failed to spawn bot");
		return false;
	}

	StartSpot.PlayTeleportEffect(NewBot, true);

	// Init player's information.
	BotConfig.Individualize(NewBot, BotN, NumBots);
	NewBot.ViewRotation = StartSpot.Rotation;

	// broadcast a welcome message.
	BroadcastMessage( NewBot.PlayerReplicationInfo.PlayerName$EnteredMessage, true );

	AddDefaultInventory( NewBot );
	NumBots++;

    if ( bGameIsAfoot )     // don't wait if gun has gone off
        NewBot.bReadyToRun = true;

	NewBot.PlayerReplicationInfo.bIsABot = True;

	// Set the player's ID.
	NewBot.PlayerReplicationInfo.PlayerID = CurrentID++;

	// Log it.
	if (LocalLog != None)
		LocalLog.LogPlayerConnect(NewBot);
	if (WorldLog != None)
		WorldLog.LogPlayerConnect(NewBot);

	return true;
}

function EquipPlayer( pawn Player )
{
    local Weapon newWeapon;
    local class<Weapon> WeapClass;

    // Spawn default weapon.
    WeapClass = BaseMutator.MutatedDefaultWeapon();
    if( WeapClass==None || Player.FindInventoryType(WeapClass)!=None )
        return;

    newWeapon = Spawn(WeapClass);
    if( newWeapon != None )
    {
        newWeapon.Instigator = Player;
        newWeapon.BecomeItem();
        Player.AddInventory(newWeapon);
        newWeapon.BringUp();
        newWeapon.GiveAmmo(Player);
        newWeapon.SetSwitchPriority(Player);
        newWeapon.WeaponSet(Player);
    }
}


function Logout(pawn Exiting)
{
	Super.Logout(Exiting);
	if ( Exiting.IsA('NerfBots') )
		NumBots--;
}
	
function Timer()
{
	Super.Timer();

	if ( (RemainingBots > 0) && AddBot() )
		RemainingBots--;

	if ( !bGameInProgress && !bGameEnded )
    {
        coolcounter--;
        if ( coolcounter <= 0 )
        {
//log( self$" cool counted out" );
            bGameEnded = true;
            EndGame("fraglimit");			// trigger shameless victory display
			RemainingTime = 40;				// time to admire shameless victory display
        }
    }
	if ( bGameEnded )
	{
		RemainingTime--;
        if ( RemainingTime < -7 )
            RestartGame();
	}
	else if ( bGameInProgress && RemainingTime > 0 )
	{
		RemainingTime--;
		switch (RemainingTime)
		{
			case 300:
				BroadcastMessage(TimeMessage[0], True, 'CriticalEvent');
				break;
			case 240:
				BroadcastMessage(TimeMessage[1], True, 'CriticalEvent');
				break;
			case 180:
				BroadcastMessage(TimeMessage[2], True, 'CriticalEvent');
				break;
			case 120:
				BroadcastMessage(TimeMessage[3], True, 'CriticalEvent');
				break;
			case 60:
				BroadcastMessage(TimeMessage[4], True, 'CriticalEvent');
				break;
			case 30:
				BroadcastMessage(TimeMessage[5], True, 'CriticalEvent');
				break;
			case 10:
				BroadcastMessage(TimeMessage[6], True, 'CriticalEvent');
				break;
			case 5:
				BroadcastMessage(TimeMessage[7], True, 'CriticalEvent');
				break;
			case 4:
				BroadcastMessage(TimeMessage[8], True, 'CriticalEvent');
				break;
			case 3:
				BroadcastMessage(TimeMessage[9], True, 'CriticalEvent');
				break;
			case 2:
				BroadcastMessage(TimeMessage[10], True, 'CriticalEvent');
				break;
			case 1:
				BroadcastMessage(TimeMessage[11], True, 'CriticalEvent');
				break;
			case 0:
				BroadcastMessage(TimeMessage[12], True, 'CriticalEvent');
				break;
		}
		if ( RemainingTime <= 0 )
        {
            if ( Level.NetMode != NM_Standalone )
            {
                bGameEnded = true;
                EndGame("timelimit");
            }
            else
                CeasePlay();


/*
            else
            {
//log ( self$" time up -- checking for humans "$Level.PawnList );
                if ( Level.PawnList == None )
                    RemainingTime = 5.0;            // check again in 5 seconds
                else if ( !CheckForHumans() )
                    RemainingTime = 5.0;            // check again in 5 seconds
                else
        			EndGame("timelimit");
            }
*/
        }
	}
}


function bool CheckForHumans()
{
    local NerfIPlayer np;
    local bool bResult;

    bResult = false;            // assume none found
    foreach allactors( class 'NerfIPlayer', np )
    {
        bResult = true;
        break;
    }
    return bResult;
}


/* FindPlayerStart()
returns the 'best' player start for this player to start from.
Re-implement for each game type
*/
function NavigationPoint FindPlayerStart( Pawn Player, optional byte InTeam, optional string incomingName )
{
	local PlayerStart Dest, Candidate[4], Best;
	local float Score[4], BestScore, NextDist;
	local pawn OtherPlayer;
	local int i, num;
	local Teleporter Tel;
	local NavigationPoint N;

	if( incomingName!="" )
		foreach AllActors( class 'Teleporter', Tel )
			if( string(Tel.Tag)~=incomingName )
				return Tel;

	num = 0;
	//choose candidates	
	N = Level.NavigationPointList;
	While ( N != None )
	{
		if ( N.IsA('PlayerStart') && !N.Region.Zone.bWaterZone )
		{
			if (num<4)
				Candidate[num] = PlayerStart(N);
			else if (Rand(num) < 4)
				Candidate[Rand(4)] = PlayerStart(N);
			num++;
		}
		N = N.nextNavigationPoint;
	}

	if (num == 0 )
		foreach AllActors( class 'PlayerStart', Dest )
		{
			if (num<4)
				Candidate[num] = Dest;
			else if (Rand(num) < 4)
				Candidate[Rand(4)] = Dest;
			num++;
		}

	if (num>4) num = 4;
	else if (num == 0)
		return None;
		
	//assess candidates
	for (i=0;i<num;i++)
		Score[i] = 4000 * FRand(); //randomize
		
	for ( OtherPlayer=Level.PawnList; OtherPlayer!=None; OtherPlayer=OtherPlayer.NextPawn)	
		if ( OtherPlayer.bIsPlayer && (OtherPlayer.Health > 0) )
			for (i=0;i<num;i++)
				if ( OtherPlayer.Region.Zone == Candidate[i].Region.Zone )
				{
					NextDist = VSize(OtherPlayer.Location - Candidate[i].Location);
					if (NextDist < OtherPlayer.CollisionRadius + OtherPlayer.CollisionHeight)
						Score[i] -= 1000000.0;
					else if ( (NextDist < 2000) && OtherPlayer.LineOfSightTo(Candidate[i]) )
						Score[i] -= 10000.0;
				}
	
	BestScore = Score[0];
	Best = Candidate[0];
	for (i=1;i<num;i++)
		if (Score[i] > BestScore)
		{
			BestScore = Score[i];
			Best = Candidate[i];
		}

	return Best;
}

/* AcceptInventory()
Examine the passed player's inventory, and accept or discard each item
* AcceptInventory needs to gracefully handle the case of some inventory
being accepted but other inventory not being accepted (such as the default
weapon).  There are several things that can go wrong: A weapon's
AmmoType not being accepted but the weapon being accepted -- the weapon
should be killed off. Or the player's selected inventory item, active
weapon, etc. not being accepted, leaving the player weaponless or leaving
the HUD inventory rendering messed up (AcceptInventory should pick another
applicable weapon/item as current).
*/
function AcceptInventory(pawn PlayerPawn)
{
	//deathmatch accepts no inventory
	local inventory Inv;
	for( Inv=PlayerPawn.Inventory; Inv!=None; Inv=Inv.Inventory )
		Inv.Destroy();
	PlayerPawn.Weapon = None;
	PlayerPawn.SelectedItem = None;
	AddDefaultInventory( PlayerPawn );
}

function ChangeName( Pawn Other, coerce string S, bool bNameChange )
{
	local pawn APlayer;

	if ( S == "" )
		return;

	if (Other.PlayerReplicationInfo.PlayerName~=S)
		return;
	
	APlayer = Level.PawnList;
	
	While ( APlayer != None )
	{	
		if ( APlayer.bIsPlayer && (APlayer.PlayerReplicationInfo.PlayerName~=S) )
		{
			Other.ClientMessage(S$NoNameChange);
			return;
		}
		APlayer = APlayer.NextPawn;
	}

	if (bNameChange)
		BroadcastMessage(Other.PlayerReplicationInfo.PlayerName$GlobalNameChange$S, false);
			
	Other.PlayerReplicationInfo.PlayerName = S;
}

function bool ShouldRespawn(Actor Other)
{
	return ( (Inventory(Other) != None) && (Inventory(Other).ReSpawnTime!=0.0) );
}

function bool CanSpectate( pawn Viewer, actor ViewTarget )
{
	return ( (Level.NetMode == NM_Standalone) || (Spectator(Viewer) != None) );
}

// Monitor killed messages for fraglimit
function Killed(pawn killer, pawn Other, name damageType)
{
//log( Other$" killed by "$killer );
	Super.Killed(killer, Other, damageType);

	if ( Other.Spree > 4 )
		EndSpree(Killer, Other); 
	Other.Spree = 0;

	if ( (killer == None) || (Other == None) )
		return;

// DSL - NerfScoreBoard checks for Fraglimit because it is actually PointLimit
//	if ( !bTeamGame && (FragLimit > 0) && (killer.PlayerReplicationInfo.Score >= FragLimit) )
//		EndGame("fraglimit");

	if ( BotConfig.bAdjustSkill && (killer.IsA('PlayerPawn') || Other.IsA('PlayerPawn')) )
	{
		if ( killer.IsA('NerfBots') )
			NerfBots(killer).AdjustSkill(true);
		if ( Other.IsA('NerfBots') )
			NerfBots(Other).AdjustSkill(false);
	}
	if ( Other.bIsPlayer && (Killer != None) && Killer.bIsPlayer && (Killer != Other) 
		&& (!bTeamGame || (Other.PlayerReplicationInfo.Team != Killer.PlayerReplicationInfo.Team)) )
	{
		Killer.Spree++;
		if ( Killer.Spree > 4 )
			NotifySpree(Killer, Killer.Spree);
	} 
}	

function EndGame( string Reason )
{
	local actor A;
	local pawn aPawn;

	Super.EndGame(Reason);
	bGameEnded = true;
	aPawn = Level.PawnList;
	RemainingTime = -1; // use timer to force restart
}

function CeasePlay()
{
    local NerfBots      n;
//    local NerfIPlayer   p;

    foreach AllActors( class 'NerfBots', n )
    {
//log( self$" sending bot "$n$" to the showers" );
        n.GotoState('GameEnded');
    }

/*
    foreach AllActors( class 'NerfIPlayer', p )
    {
//log( self$" sending player "$p$" to the showers" );
        p.GotoState('Idle');
    }
*/

//log( self$" counter to "$coolcount );
    coolcounter = coolcount;
    bGameInProgress = false;
}


function NotifySpree(Pawn Other, int num)
{
	local Pawn P;

	if ( num == 5 )
		num = 0;
	else if ( num == 10 )
		num = 1;
	else if ( num == 15 )
		num = 2;
	else if ( num == 20 )
		num = 3;
	else if ( num == 25 )
		num = 4;
	else
		return;

	for ( P=Level.PawnList; P!=None; P=P.NextPawn )
		if ( P.IsA('NerfIPlayer') )
			P.ReceiveLocalizedMessage( class'KillingSpreeMessage', Num, Other.PlayerReplicationInfo );
}

function EndSpree(Pawn Killer, Pawn Other)
{
	local Pawn P;

	if ( !Other.bIsPlayer )
		return;
	for ( P=Level.PawnList; P!=None; P=P.NextPawn )
		if ( P.IsA('NerfIPlayer') )
		{
			if ( (Killer == None) || !Killer.bIsPlayer )
				NerfIPlayer(P).EndSpree(None, Other.PlayerReplicationInfo);
			else
				NerfIPlayer(P).EndSpree(Killer.PlayerReplicationInfo, Other.PlayerReplicationInfo);
		}
}

defaultproperties
{
     TimeLimit=10
     bChangeLevels=True
     bHardCoreMode=True
     coolcount=5
     InitialBots=5
     GlobalNameChange= changed name to 
     NoNameChange= is already in use
     TimeMessage(0)=5 minutes left in the game!
     TimeMessage(1)=4 minutes left in the game!
     TimeMessage(2)=3 minutes left in the game!
     TimeMessage(3)=2 minutes left in the game!
     TimeMessage(4)=1 minute left in the game!
     TimeMessage(5)=30 seconds left!
     TimeMessage(6)=10 seconds left!
     TimeMessage(7)=5 seconds and counting...
     TimeMessage(8)=4...
     TimeMessage(9)=3...
     TimeMessage(10)=2...
     TimeMessage(11)=1...
     TimeMessage(12)=Time's Up!
     BotConfigType=Class'NerfI.NerfBotInfo'
     AirControl=0.350000
     bNoMonsters=True
     bRestartLevel=False
     bPauseable=False
     bDeathMatch=True
     DefaultWeapon=Class'NerfI.SShot'
     ScoreBoardType=Class'NerfI.NerfScoreBoard'
     GameMenuType=Class'NerfI.NerfPMGameOptionsMenu'
     MapListType=Class'NerfI.PMmaplist'
     MapPrefix=PM
     BeaconName=pM
     GameName=Point Blast
     DeathMessageClass=Class'NerfI.DeathMessagePlus'
}
