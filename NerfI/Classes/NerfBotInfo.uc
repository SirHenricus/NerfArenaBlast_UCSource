//=============================================================================
// NerfBotInfo.
//
// Integrated by Wezo
//=============================================================================
class NerfBotInfo extends Info;

var() config bool	bAdjustSkill;
var() config bool	bRandomOrder;
var   config byte	Difficulty;

var() config string BotNames[32];		// FIXME this needs to be localized
var() config int BotTeams[32];
var() config float BotSkills[32];
var() config float BotAccuracy[32];
var() config float CombatStyle[32]; 
var() config float Alertness[32];
var() config float Camping[32];
var() config class<Weapon> FavoriteWeapon[32];
var	  byte ConfigUsed[32];
var() config string BotClasses[32];
var() config string BotSkins[32];
var string AvailableClasses[32], AvailableDescriptions[32], NextBotClass;
var int NumClasses;

//##nerf WES FIXME
// Might have a better way to load bot classes since we have string manipulation now.
var string WarClasses[32];
var string RaceClasses[32];
var string HuntClasses[32];
var int classcount;

var int RandomTeamArray[7];
var int ixStep;
var bool bUseGators;

function PreBeginPlay()
{
	//DON'T Call parent prebeginplay
    classcount = 32;
    bUseGators = false;
/*
//
// DSL: intializing these here because on account of the fact
// that defaultproperties seems to have a bytecount limit
//
	BotClasses[0]="WarBots.WBTed";
	BotClasses[1]="WarBots.WBJami";
	BotClasses[2]="WarBots.WBRyan";
	BotClasses[3]="WarBots.WBSarge";
	BotClasses[4]="WarBots.WBHope";
	BotClasses[5]="WarBots.WBTodd";
	BotClasses[6]="WarBots.WBWilliam";
	BotClasses[7]="WarBots.WBJustin";
	BotClasses[8]="WarBots.WBJudge";
	BotClasses[9]="WarBots.WBOMalley";
	BotClasses[10]="WarBots.WBRiles";
	BotClasses[11]="WarBots.WBSam";
	BotClasses[12]="WarBots.WBLittleTree";
	BotClasses[13]="WarBots.WBWaterSpirit";
	BotClasses[14]="WarBots.WBGranite";
	BotClasses[15]="WarBots.WBRabbit";
	BotClasses[16]="WarBots.WBJamie";
	BotClasses[17]="WarBots.WBPhoebe";
	BotClasses[18]="WarBots.WBBrin";
	BotClasses[19]="WarBots.WBCallie";
	BotClasses[20]="WarBots.WBJonas";
	BotClasses[21]="WarBots.WBTroy";
	BotClasses[22]="WarBots.WBRoger";
	BotClasses[23]="WarBots.WBLori";
	BotClasses[24]="WarBots.WBNewton";
	BotClasses[25]="WarBots.WBFrazier";
	BotClasses[26]="WarBots.WBMary";
	BotClasses[27]="WarBots.WBGeorgie";
	BotClasses[28]="WarBots.WBJane";
	BotClasses[29]="WarBots.WBWes";
	BotClasses[30]="WarBots.WBVince";
	BotClasses[31]="WarBots.WBSharon";

	WarClasses[0]="WarBots.WBTed";
	WarClasses[1]="WarBots.WBJami";
	WarClasses[2]="WarBots.WBRyan";
	WarClasses[3]="WarBots.WBSarge";
	WarClasses[4]="WarBots.WBHope";
	WarClasses[5]="WarBots.WBTodd";
	WarClasses[6]="WarBots.WBWilliam";
	WarClasses[7]="WarBots.WBJustin";
	WarClasses[8]="WarBots.WBJudge";
	WarClasses[9]="WarBots.WBOMalley";
	WarClasses[10]="WarBots.WBRiles";
	WarClasses[11]="WarBots.WBSam";
	WarClasses[12]="WarBots.WBLittleTree";
	WarClasses[13]="WarBots.WBWaterSpirit";
	WarClasses[14]="WarBots.WBGranite";
	WarClasses[15]="WarBots.WBRabbit";
	WarClasses[16]="WarBots.WBJamie";
	WarClasses[17]="WarBots.WBPhoebe";
	WarClasses[18]="WarBots.WBBrin";
	WarClasses[19]="WarBots.WBCallie";
	WarClasses[20]="WarBots.WBJonas";
	WarClasses[21]="WarBots.WBTroy";
	WarClasses[22]="WarBots.WBRoger";
	WarClasses[23]="WarBots.WBLori";
	WarClasses[24]="WarBots.WBNewton";
	WarClasses[25]="WarBots.WBFrazier";
	WarClasses[26]="WarBots.WBMary";
	WarClasses[27]="WarBots.WBGeorgie";
	WarClasses[28]="WarBots.WBJane";
	WarClasses[29]="WarBots.WBWes";
	WarClasses[30]="WarBots.WBVince";
	WarClasses[31]="WarBots.WBSharon";

	RaceClasses[0]="RaceBots.RBTed";
	RaceClasses[1]="RaceBots.RBJami";
	RaceClasses[2]="RaceBots.RBRyan";
	RaceClasses[3]="RaceBots.RBSarge";
	RaceClasses[4]="RaceBots.RBHope";
	RaceClasses[5]="RaceBots.RBTodd";
	RaceClasses[6]="RaceBots.RBWilliam";
	RaceClasses[7]="RaceBots.RBJustin";
	RaceClasses[8]="RaceBots.RBJudge";
	RaceClasses[9]="RaceBots.RBOMalley";
	RaceClasses[10]="RaceBots.RBRiles";
	RaceClasses[11]="RaceBots.RBSam";
	RaceClasses[12]="RaceBots.RBLittleTree";
	RaceClasses[13]="RaceBots.RBWaterSpirit";
	RaceClasses[14]="RaceBots.RBGranite";
	RaceClasses[15]="RaceBots.RBRabbit";
	RaceClasses[16]="RaceBots.RBJamie";
	RaceClasses[17]="RaceBots.RBPhoebe";
	RaceClasses[18]="RaceBots.RBBrin";
	RaceClasses[19]="RaceBots.RBCallie";
	RaceClasses[20]="RaceBots.RBJonas";
	RaceClasses[21]="RaceBots.RBTroy";
	RaceClasses[22]="RaceBots.RBRoger";
	RaceClasses[23]="RaceBots.RBLori";
	RaceClasses[24]="RaceBots.RBNewton";
	RaceClasses[25]="RaceBots.RBFrazier";
	RaceClasses[26]="RaceBots.RBMary";
	RaceClasses[27]="RaceBots.RBGeorgie";
	RaceClasses[28]="RaceBots.RBJane";
	RaceClasses[29]="RaceBots.RBWes";
	RaceClasses[30]="RaceBots.RBVince";
	RaceClasses[31]="RaceBots.RBSharon";

	HuntClasses[0]="HuntBots.HBTed";
	HuntClasses[1]="HuntBots.HBJami";
	HuntClasses[2]="HuntBots.HBRyan";
	HuntClasses[3]="HuntBots.HBSarge";
	HuntClasses[4]="HuntBots.HBHope";
	HuntClasses[5]="HuntBots.HBTodd";
	HuntClasses[6]="HuntBots.HBWilliam";
	HuntClasses[7]="HuntBots.HBJustin";
	HuntClasses[8]="HuntBots.HBJudge";
	HuntClasses[9]="HuntBots.HBOMalley";
	HuntClasses[10]="HuntBots.HBRiles";
	HuntClasses[11]="HuntBots.HBSam";
	HuntClasses[12]="HuntBots.HBLittleTree";
	HuntClasses[13]="HuntBots.HBWaterSpirit";
	HuntClasses[14]="HuntBots.HBGranite";
	HuntClasses[15]="HuntBots.HBRabbit";
	HuntClasses[16]="HuntBots.HBJamie";
	HuntClasses[17]="HuntBots.HBPhoebe";
	HuntClasses[18]="HuntBots.HBBrin";
	HuntClasses[19]="HuntBots.HBCallie";
	HuntClasses[20]="HuntBots.HBJonas";
	HuntClasses[21]="HuntBots.HBTroy";
	HuntClasses[22]="HuntBots.HBRoger";
	HuntClasses[23]="HuntBots.HBLori";
	HuntClasses[24]="HuntBots.HBNewton";
	HuntClasses[25]="HuntBots.HBFrazier";
	HuntClasses[26]="HuntBots.HBMary";
	HuntClasses[27]="HuntBots.HBGeorgie";
	HuntClasses[28]="HuntBots.HBJane";
	HuntClasses[29]="HuntBots.HBWes";
	HuntClasses[30]="HuntBots.HBVince";
	HuntClasses[31]="HuntBots.HBSharon";
*/
}

function SetAI( EAIGameType n )
{
    local int i;

    if ( n == AITYPE_ArenaRace )
    {
        for ( i = 0; i < classcount; i++ )
            BotClasses[i] = RaceClasses[i];
    }
    else if ( n == AITYPE_ScavengerHunt )
    {
        for ( i = 0; i < classcount; i++ )
            BotClasses[i] = HuntClasses[i];
    }
    else
    {
        for ( i = 0; i < classcount; i++ )
            BotClasses[i] = WarClasses[i];
    }
}

function PostBeginPlay()
{

	local string NextBotClass, NextBotDesc;
	local int i;
    local int ixSeed;
    local int ixSkip;

//##nerf WES FIXME
// DSL's valuables.
	local string BotIlk;
    local string PullString;
    local int ixBot;       
    local EAIGameType   gt;

    local string botstr;
    local int j;
    local int rseed[6];
    local string CurrentURL;

//log( "NBI -- PostBegin" );


	Super.PostBeginPlay();

    NumClasses = 0;
    ixBot = Level.BotTeam*4;

//##nerf WES FIXME
// Using Don's fixed array to load bots. Need to be fixed. 
/*
	GetNextIntDesc("NerfBots", 0, NextBotClass, NextBotDesc); 
	while ( (NextBotClass != "") && (NumClasses < 32) )
	{
		AvailableClasses[NumClasses] = NextBotClass;
		AvailableDescriptions[NumClasses] = NextBotDesc;
		NumClasses++;
		GetNextIntDesc("NerfBots", NumClasses, NextBotClass, NextBotDesc); 
	}
*/

// make only appropriate bots available
    if ( Level.Game.IsA('ArenaRaceGame') )
    {
        PullString = "Race";            // next group are fleet of foot
        gt = AITYPE_ArenaRace;
    }
    else if (Level.Game.IsA('ScavengerHuntGame') || Level.Game.IsA('TeamScavengerHuntGame'))
    {
        PullString = "Hunt";            // finally come the sharp-eyed
        gt = AITYPE_ScavengerHunt;
    }
    else if (Level.Game.IsA('LabRatGame'))
    {
        PullString = "Lab";
        gt = AITYPE_LabRat;
    }
    else
    {
        PullString = "War";            // default = warbot classes
        gt = AITYPE_PointMatch;
    }
    SetAI( gt );

//    log( "NBI -- PullString = "$PullString );
//    log( "NBI -- game is "$Level.Game );
//    log( "NBI -- beacon is "$Level.Game.BeaconName );

    for ( i=0; i<classcount; i++ )
    {
        switch( gt )
        {
            case AITYPE_ArenaRace:
                AvailableClasses[i] = RaceClasses[i];
                break;
            case AITYPE_ScavengerHunt:
                AvailableClasses[i] = HuntClasses[i];
                break;
            default:
                AvailableClasses[i] = WarClasses[i];
                break;
        }
    }

//
//    BotIlk = "NerfBots";
//
//	NextBotClass = GetNextInt(BotIlk, ixBot); 
//	while ( (NextBotClass != "") && (ixBot < 32) )
//	while ( (NextBotClass != "") && (ixBot < (Level.BotTeam*4)+4) )
//	{
//        if ( InStr( NextBotClass, PullString ) >= 0 )
//        {
//            log( "   found "$NextBotClass );
//    		AvailableClasses[NumClasses] = NextBotClass;
//    		NumClasses++;
//        }
//        else log( "  ignoring "$NextBotClass );
//        ixBot++;
//		NextBotClass = GetNextInt( BotIlk, ixBot); 
/*
    	AvailableClasses[NumClasses] = NextBotClass;
    	NumClasses++;
		NextBotClass = GetNextInt( BotIlk, NumClasses); 
*/
//	}
//    log( "NBI -- found NumClasses "$NumClasses );
//
// generate a random array of 5 indexes (to teams, from which to choose bots)

//    for ( j = 0; j < 21; j++ )        // iteration used for testing only
//    {
        for ( i=0; i < 6; i++ )
            rseed[i] = 0;

        for ( i = 0; i < 6; i++ )
        {
            ixSeed = RandRange(0,5.99);
            if ( rseed[ixSeed] == 0 )
            {
                RandomTeamArray[i] = ixSeed;
                rseed[ixSeed] = 1;
            }
            else
            {
                while ( rseed[ixSeed] == 1 )
                {
                    ixSeed++;
                    if ( ixSeed > 5 )
                        ixSeed = 0;
                }
                RandomTeamArray[i] = ixSeed;
                rseed[ixSeed] = 1;
            }
        }


//        botstr = " "$RandomTeamArray[0];
//        botstr = botstr$" "$RandomTeamArray[1];
//        botstr = botstr$" "$RandomTeamArray[2];
//        botstr = botstr$" "$RandomTeamArray[3];
//        botstr = botstr$" "$RandomTeamArray[4];
//        botstr = botstr$" "$RandomTeamArray[5];
//        log( "NBI RTA = "$botstr );
//    }                                 // iteration used for testing only
    ixStep = 0;

    if ( Level.NetMode == NM_Standalone )
    {
        CurrentURL = Level.GetLocalURL();           // get name of this ma
//log( "NBI CurrentURL is "$CurrentURL );
        if ( CurrentURL != "" )
        {
            CurrentURL = Mid( CurrentURL, InStr(CurrentURL, "PM-Amateur"));
            if ( CurrentURL != "" )
            {
                bUseGators = true;
                DeathMatchGame(Level.Game).RemainingBots = 4;
//log( self$" NBI - bUseGators = "$bUseGators$" and curl = "$CurrentURL );
            }
        }
    }
}

function String GetAvailableClasses(int n)
{
	return AvailableClasses[n];
}

function int ChooseBotInfo()
{
	local int n, base, cap, wrap;

    if ( bUseGators )
        n = 28;                         // base of gators
    else
    {
        n = RandomTeamArray[ixStep];
        n++;                            // don't choose a Twister
        n *= 4;                         // base of this team
    }

//log ( "NBI baseN = "$n );
    base = n;
    cap = n + 4;
    n += RandRange(0,3.99);
    wrap = 0;
    while ( (ConfigUsed[n] != 0) && (wrap < 4) ) // get an unused member of this team
    {
        wrap++;
        n++;
        if ( n >= cap ) n = base;
    }
// if all four team members already used, we'll get somebody named "BotN" 
//log ( "NBI finalN = "$n );
    ixStep++;
    if ( ixStep > 5 ) ixStep = 0;
/*

	if ( bRandomOrder )
		n = Rand(16);
	else 
//##nerf WES FIXME
// DSL MOD from the original unreal code
//		n = 0;
		n = Level.BotTeam*4;

	start = n;
	while ( (n < 32) && (ConfigUsed[n] == 1) )               
		n++;

	if ( (n == 32) && bRandomOrder )
	{
		n = 0;
		while ( (n < start) && (ConfigUsed[n] == 1) )
			n++;
	}

	if ( n > 31 )
		n = 31;
*/

	return n;
}

function class<Nerfbots> GetBotClass(int n)
{
	return class<Nerfbots>( DynamicLoadObject(GetBotClassName(n), class'Class') );
}

function Individualize(Nerfbots NewBot, int n, int NumBots)
{
	local texture NewSkin;

	// Set bot's skin
//##nerf WES FIXME
// Doing it as the DSL way. Not the unreal way
//  By passing the BotSkins[n] in the ini file right now cause it doesn't do anything 
//  until DON makes a link between the Bot config menu and his bot list.
/*
	if ( (n >= 0) && (n < 32) && (BotSkins[n] != "") && (BotSkins[n] != "None") )
	{
		NewSkin = texture(DynamicLoadObject(BotSkins[n], class'Texture'));
		if ( NewSkin != None )
			NewBot.Skin = NewSkin;
	}
*/

	if ( (n >= 0) && (n < 32))
	{
// Getting the Icons for the Bots
		NewBot.PlayerReplicationInfo.SkinIcon = NewBot.Face();
	}

	// Set bot's name.
	if ( (BotNames[n] == "") || (ConfigUsed[n] == 1) )
		BotNames[n] = "Bot";

	Level.Game.ChangeName( NewBot, BotNames[n], false );
	if ( BotNames[n] != NewBot.PlayerReplicationInfo.PlayerName )
		Level.Game.ChangeName( NewBot, ("Bot"$NumBots), false);

	ConfigUsed[n] = 1;

	// adjust bot skill
//	log(class$ " WES: Game Difficulty" @Level.Game.Difficulty);
	if (Level.Game.Difficulty == 0)
	{
		NewBot.CombatStyle -=1;
		NewBot.Alertness -=1;
		NewBot.Accuracy +=0.6;
		NewBot.GroundSpeed*=0.7;
	}
	else if (Level.Game.Difficulty == 1)
	{
		NewBot.CombatStyle -=0.75;
		NewBot.Alertness -=0.75;
		NewBot.Accuracy +=0.5;
		NewBot.GroundSpeed*=0.85;
	}

	NewBot.Skill = FClamp(NewBot.Skill + BotSkills[n], 0, 3);
	NewBot.ReSetSkill();
}

function SetBotClass(String ClassName, int n)
{
	BotClasses[n] = ClassName;
}

function SetBotName( coerce string NewName, int n )
{
	BotNames[n] = NewName;
}

function String GetBotName(int n)
{
	return BotNames[n];
}

function int GetBotTeam(int num)
{
	return BotTeams[Num];
}

function SetBotTeam(int NewTeam, int n)
{
	BotTeams[n] = NewTeam;
}

function int GetBotIndex( coerce string BotName )
{
	local int i;
	local bool found;

	found = false;
	for (i=0; i<ArrayCount(BotNames)-1; i++)
		if (BotNames[i] == BotName)
		{
			found = true;
			break;
		}

	if (!found)
		i = -1;

	return i;
}

function string GetBotSkin( int num )
{
	return BotSkins[Num];
}

function SetBotSkin( coerce string NewSkin, int n )
{
	BotSkins[n] = NewSkin;
}

function String GetBotClassName(int n)
{
	if ( (n < 0) || (n > 31) )
		return AvailableClasses[Rand(NumClasses)];

	if ( BotClasses[n] == "" )
		BotClasses[n] = AvailableClasses[Rand(NumClasses)];

	return BotClasses[n];
}

defaultproperties
{
     Difficulty=1
     BotNames(0)=Ted
     BotNames(1)=Jami
     BotNames(2)=Ryan
     BotNames(3)=Sarge
     BotNames(4)=Hope
     BotNames(5)=Todd
     BotNames(6)=William
     BotNames(7)=Justin
     BotNames(8)=Judge
     BotNames(9)=OMalley
     BotNames(10)=Riles
     BotNames(11)=Sam
     BotNames(12)=Little Tree
     BotNames(13)=Water Spirit
     BotNames(14)=Granite
     BotNames(15)=Rabbit
     BotNames(16)=Jamie
     BotNames(17)=Phoebe
     BotNames(18)=Brin
     BotNames(19)=Callie
     BotNames(20)=Jonas
     BotNames(21)=Troy
     BotNames(22)=Roger
     BotNames(23)=Lori
     BotNames(24)=Newton
     BotNames(25)=Frazier
     BotNames(26)=Mary
     BotNames(27)=Georgie
     BotNames(28)=Jane
     BotNames(29)=Wes
     BotNames(30)=Vince
     BotNames(31)=Sharon
     BotTeams(4)=1
     BotTeams(5)=1
     BotTeams(6)=1
     BotTeams(7)=1
     BotTeams(8)=2
     BotTeams(9)=2
     BotTeams(10)=2
     BotTeams(11)=2
     BotTeams(12)=3
     BotTeams(13)=3
     BotTeams(14)=3
     BotTeams(15)=3
     BotTeams(16)=4
     BotTeams(17)=4
     BotTeams(18)=4
     BotTeams(19)=4
     BotTeams(20)=5
     BotTeams(21)=5
     BotTeams(22)=5
     BotTeams(23)=5
     BotTeams(24)=6
     BotTeams(25)=6
     BotTeams(26)=6
     BotTeams(27)=6
     BotTeams(28)=7
     BotTeams(29)=7
     BotTeams(30)=7
     BotTeams(31)=7
     BotClasses(0)=WarBots.WBTed
     BotClasses(1)=WarBots.WBJami
     BotClasses(2)=WarBots.WBRyan
     BotClasses(3)=WarBots.WBSarge
     BotClasses(4)=WarBots.WBHope
     BotClasses(5)=WarBots.WBTodd
     BotClasses(6)=WarBots.WBWilliam
     BotClasses(7)=WarBots.WBJustin
     BotClasses(8)=WarBots.WBJudge
     BotClasses(9)=WarBots.WBOMalley
     BotClasses(10)=WarBots.WBRiles
     BotClasses(11)=WarBots.WBSam
     BotClasses(12)=WarBots.WBLittleTree
     BotClasses(13)=WarBots.WBWaterSpirit
     BotClasses(14)=WarBots.WBGranite
     BotClasses(15)=WarBots.WBRabbit
     BotClasses(16)=WarBots.WBJamie
     BotClasses(17)=WarBots.WBPhoebe
     BotClasses(18)=WarBots.WBBrin
     BotClasses(19)=WarBots.WBCallie
     BotClasses(20)=WarBots.WBJonas
     BotClasses(21)=WarBots.WBTroy
     BotClasses(22)=WarBots.WBRoger
     BotClasses(23)=WarBots.WBLori
     BotClasses(24)=WarBots.WBNewton
     BotClasses(25)=WarBots.WBFrazier
     BotClasses(26)=WarBots.WBMary
     BotClasses(27)=WarBots.WBGeorgie
     BotClasses(28)=WarBots.WBJane
     BotClasses(29)=WarBots.WBWes
     BotClasses(30)=WarBots.WBVince
     BotClasses(31)=WarBots.WBSharon
     WarClasses(0)=WarBots.WBTed
     WarClasses(1)=WarBots.WBJami
     WarClasses(2)=WarBots.WBRyan
     WarClasses(3)=WarBots.WBSarge
     WarClasses(4)=WarBots.WBHope
     WarClasses(5)=WarBots.WBTodd
     WarClasses(6)=WarBots.WBWilliam
     WarClasses(7)=WarBots.WBJustin
     WarClasses(8)=WarBots.WBJudge
     WarClasses(9)=WarBots.WBOMalley
     WarClasses(10)=WarBots.WBRiles
     WarClasses(11)=WarBots.WBSam
     WarClasses(12)=WarBots.WBLittleTree
     WarClasses(13)=WarBots.WBWaterSpirit
     WarClasses(14)=WarBots.WBGranite
     WarClasses(15)=WarBots.WBRabbit
     WarClasses(16)=WarBots.WBJamie
     WarClasses(17)=WarBots.WBPhoebe
     WarClasses(18)=WarBots.WBBrin
     WarClasses(19)=WarBots.WBCallie
     WarClasses(20)=WarBots.WBJonas
     WarClasses(21)=WarBots.WBTroy
     WarClasses(22)=WarBots.WBRoger
     WarClasses(23)=WarBots.WBLori
     WarClasses(24)=WarBots.WBNewton
     WarClasses(25)=WarBots.WBFrazier
     WarClasses(26)=WarBots.WBMary
     WarClasses(27)=WarBots.WBGeorgie
     WarClasses(28)=WarBots.WBJane
     WarClasses(29)=WarBots.WBWes
     WarClasses(30)=WarBots.WBVince
     WarClasses(31)=WarBots.WBSharon
     RaceClasses(0)=RaceBots.RBTed
     RaceClasses(1)=RaceBots.RBJami
     RaceClasses(2)=RaceBots.RBRyan
     RaceClasses(3)=RaceBots.RBSarge
     RaceClasses(4)=RaceBots.RBHope
     RaceClasses(5)=RaceBots.RBTodd
     RaceClasses(6)=RaceBots.RBWilliam
     RaceClasses(7)=RaceBots.RBJustin
     RaceClasses(8)=RaceBots.RBJudge
     RaceClasses(9)=RaceBots.RBOMalley
     RaceClasses(10)=RaceBots.RBRiles
     RaceClasses(11)=RaceBots.RBSam
     RaceClasses(12)=RaceBots.RBLittleTree
     RaceClasses(13)=RaceBots.RBWaterSpirit
     RaceClasses(14)=RaceBots.RBGranite
     RaceClasses(15)=RaceBots.RBRabbit
     RaceClasses(16)=RaceBots.RBJamie
     RaceClasses(17)=RaceBots.RBPhoebe
     RaceClasses(18)=RaceBots.RBBrin
     RaceClasses(19)=RaceBots.RBCallie
     RaceClasses(20)=RaceBots.RBJonas
     RaceClasses(21)=RaceBots.RBTroy
     RaceClasses(22)=RaceBots.RBRoger
     RaceClasses(23)=RaceBots.RBLori
     RaceClasses(24)=RaceBots.RBNewton
     RaceClasses(25)=RaceBots.RBFrazier
     RaceClasses(26)=RaceBots.RBMary
     RaceClasses(27)=RaceBots.RBGeorgie
     RaceClasses(28)=RaceBots.RBJane
     RaceClasses(29)=RaceBots.RBWes
     RaceClasses(30)=RaceBots.RBVince
     RaceClasses(31)=RaceBots.RBSharon
     HuntClasses(0)=HuntBots.HBTed
     HuntClasses(1)=HuntBots.HBJami
     HuntClasses(2)=HuntBots.HBRyan
     HuntClasses(3)=HuntBots.HBSarge
     HuntClasses(4)=HuntBots.HBHope
     HuntClasses(5)=HuntBots.HBTodd
     HuntClasses(6)=HuntBots.HBWilliam
     HuntClasses(7)=HuntBots.HBJustin
     HuntClasses(8)=HuntBots.HBJudge
     HuntClasses(9)=HuntBots.HBOMalley
     HuntClasses(10)=HuntBots.HBRiles
     HuntClasses(11)=HuntBots.HBSam
     HuntClasses(12)=HuntBots.HBLittleTree
     HuntClasses(13)=HuntBots.HBWaterSpirit
     HuntClasses(14)=HuntBots.HBGranite
     HuntClasses(15)=HuntBots.HBRabbit
     HuntClasses(16)=HuntBots.HBJamie
     HuntClasses(17)=HuntBots.HBPhoebe
     HuntClasses(18)=HuntBots.HBBrin
     HuntClasses(19)=HuntBots.HBCallie
     HuntClasses(20)=HuntBots.HBJonas
     HuntClasses(21)=HuntBots.HBTroy
     HuntClasses(22)=HuntBots.HBRoger
     HuntClasses(23)=HuntBots.HBLori
     HuntClasses(24)=HuntBots.HBNewton
     HuntClasses(25)=HuntBots.HBFrazier
     HuntClasses(26)=HuntBots.HBMary
     HuntClasses(27)=HuntBots.HBGeorgie
     HuntClasses(28)=HuntBots.HBJane
     HuntClasses(29)=HuntBots.HBWes
     HuntClasses(30)=HuntBots.HBVince
     HuntClasses(31)=HuntBots.HBSharon
}
