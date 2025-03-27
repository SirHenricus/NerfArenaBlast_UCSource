//
// Utility class to find/read/write player profiles
//
class NerfPlayerProfile extends Object;

// USER.INI file carries six profiles:
//		Current, which is a copy of one of the following five --
//		Ted, Jami, Ryan, Sarge ( all Twisters ) and Wes ( Multiplayer )
//
//
// 1) when PDA is created, it reads all six profiles from USER.INI into memory
//	  and copies PRF_Current to the appropriate PRF_xxx ( in memory )
// 2) user plays with PDA for a while --
//		2a) IF user chooses a Twister card, the appropriate PRF_xxx is copied to PRF_Current
// 3) when PDA is dismissed:
//		3a) by PLAY button -- PRF_Current is again copied to the appropriate PRF_xxx
//			and all six profiles are written to USER.INI
//		3b) by ESC key -- nothing
//
//
// this enum is here for reference only -- in the code we use
// integers 0 through 5 to sidestep casting problems
enum EProfileIndex
{
	PRF_Current,
	PRF_Ted,
	PRF_Jami,
	PRF_Ryan,
	PRF_Sarge,
	PRF_Wes
};

// a complete profile has a top and a bottom
struct OneProfile
{
	var	string			Name;		// as entered by user when signing up, default is "Player"
	var string			Class;		// as chosen by user from cards, default is "NerfKids.Wes"
	var string			LocalMap;	// visitor from NERF.INI, default is "RR-Amateur.nrf"
	var byte			Difficulty;	// as set by user, default is 1
	var byte			Team;		// as set by user, default is 255 (no team)
	var int				Index;		// PRF_Ted through PRF_Wes, default is PRF_Wes
	var string         LevelRank[28];
	var byte           LevelClear[28];
	var float          LevelHighScore[28];
	var float          TotalScore;
	var byte           ArenaAccessLevel;
	var int			   LastGameType;
};


// our variables to hold all the above
var OneProfile	Profile[6];


// profile index info
var int CurrentProfile;
// profile detail info
var string InfoClass;
var string InfoName;
var int InfoPoints;
var int InfoLevel;
var string InfoRank[28];
var int InfoEvents;
var float InfoHighScores[28];
var byte InfoClears[28];
var string ReadyRooms[8];		// copied from NerfPDA.uc - don't yet know
								// how to make them visible here
// copy PRF_Current to appropriate PRF_xxx
// to be called when PDA comes up and again when PDA is dismissed by Play button
// prior to saving all profiles to USER.INI
function StoreCurrentProfile()
{
	log(class$ "WES: StoreCurrentProfile" @Profile[0].Index$" who is "$Profile[0].Name );
	Profile[Profile[0].Index] = Profile[0];
//	log(class$ "WES: StoreCurrentProfile" @Profile[5].Name);
	CurrentProfile =  Profile[0].Index;
}

// copy appropriate PRF_xxx to PRF_Current
// to be called when user changes player cards
function ReadProfile( int ix )
{
	Profile[0] = Profile[ix];
//	log(class$ "WES: ReadProfile index b" @Profile[0].index);
	CurrentProfile =  ix;
}

// copy all six profiles to USER.INI
// to be called when PDA is dismissed by Play button
// PRF_Current is saved in two parts:
//		Top goes into [DefaultPlayer]
//		Bottom goes into [Engine.PlayerPawn]
// PRF_xxx's are saved as single entities

function SaveProfiles()
{
	local int i;

//	log(class$ " WES: PlayerProfile SaveProfiles() got call");
	Profile[0].LocalMap = ReadyRooms[Profile[0].ArenaAccessLevel]$".nrf";

// first save Top of PRF_Current to [DefaultPlayer]
	SetConfigString("DefaultPlayer", "Name",		Profile[0].Name,		"user.ini");
	SetConfigString("DefaultPlayer", "Class",		Profile[0].Class,		"user.ini");
	SetConfigString("DefaultPlayer", "Difficulty",	Profile[0].Difficulty,	"user.ini");
	SetConfigString("DefaultPlayer", "Team",		Profile[0].Team,		"user.ini");
	SetConfigString("DefaultPlayer", "Index",		Profile[0].Index,		"user.ini");
	SetConfigString("URL",			 "LocalMap",	Profile[0].LocalMap,	"nerf.ini");	// note redirection

// next save Bottom of PRF_Current to [Engine.PlayerPawn]
	SetConfigString("Engine.PlayerPawn", "TotalScore",			Profile[0].TotalScore,          "user.ini");
	SetConfigString("Engine.PlayerPawn", "ArenaAccessLevel",	Profile[0].ArenaAccessLevel,    "user.ini");
	SetConfigString("Engine.PlayerPawn", "LastGameType",		Profile[0].LastGameType,        "user.ini");

	for( i=0; i<28; i++ )
        SetConfigString("Engine.PlayerPawn", "LevelHighScore["$i$"]", Profile[0].LevelHighScore[i], "user.ini");
	for( i=0; i<28; i++ )
        SetConfigString("Engine.PlayerPawn", "LevelRank["$i$"]",	  Profile[0].LevelRank[i],      "user.ini");
	for( i=0; i<28; i++ )
        SetConfigString("Engine.PlayerPawn", "LevelClear["$i$"]",	  Profile[0].LevelClear[i],     "user.ini");

// finally save top and bottom of all PRF_xxx's

//	log(class$ " WES: Report Before StoreCurrentProfile");
//	Report();
	StoreCurrentProfile();
//	log(class$ " WES: Report After StoreCurrentProfile");
//	Report();

	for( i=1; i<6; i++ )
		SaveOneProfile(i);			
}

function SaveOneProfile( int ix )
{
	local int i;

	Profile[i].LocalMap = ReadyRooms[Profile[i].ArenaAccessLevel]$".nrf";
	SetConfigString("Card"$ix, "Name",				 Profile[ix].Name,					 "user.ini"); 
	SetConfigString("Card"$ix, "Class",				 Profile[ix].Class,					 "user.ini"); 
	SetConfigString("Card"$ix, "Difficulty",		 Profile[ix].Difficulty,			 "user.ini"); 
	SetConfigString("Card"$ix, "Team",				 Profile[ix].Team,					 "user.ini"); 
	SetConfigString("Card"$ix, "Index",				 Profile[ix].Index,					 "user.ini"); 
	SetConfigString("Card"$ix, "LocalMap",			 Profile[ix].LocalMap,				 "user.ini");	// note nonredirection

	SetConfigString("Card"$ix, "TotalScore",		 Profile[ix].TotalScore,          "user.ini");
	SetConfigString("Card"$ix, "LastGameType",		 Profile[ix].LastGameType,        "user.ini");
	SetConfigString("Card"$ix, "ArenaAccessLevel",	 Profile[ix].ArenaAccessLevel,    "user.ini");

	for( i=0; i<28; i++ )
        SetConfigString("Card"$ix, "LevelHighScore["$i$"]", Profile[ix].LevelHighScore[i],  "user.ini");
	for( i=0; i<28; i++ )
        SetConfigString("Card"$ix, "LevelRank["$i$"]",	    Profile[ix].LevelRank[i],       "user.ini");
	for( i=0; i<28; i++ )
        SetConfigString("Card"$ix, "LevelClear["$i$"]",	    Profile[ix].LevelClear[i],      "user.ini");
}

// and now the inverse
// read all six profiles from USER.INI
// to be called when PDA first comes up
// PRF_Current is read in two parts:
//		Top from [DefaultPlayer]
//		Bottom from [Engine.PlayerPawn]
// PRF_xxx's are read as single entities

function ReadProfiles()
{
	local int i;

// first read Top of PRF_Current from [DefaultPlayer]
	Profile[0].Name		  =	     GetConfigString("DefaultPlayer", "Name",	    "user.ini");
	Profile[0].Class	  =	     GetConfigString("DefaultPlayer", "Class",	    "user.ini");
	Profile[0].Difficulty =	byte(GetConfigString("DefaultPlayer", "Difficulty", "user.ini"));
	Profile[0].Team		  =	byte(GetConfigString("DefaultPlayer", "Team",	    "user.ini"));
	Profile[0].Index	  =	 int(GetConfigString("DefaultPlayer", "Index",	    "user.ini"));
	Profile[0].LocalMap   =	     GetConfigString("URL",			  "LocalMap",   "nerf.ini");	// note redirection
// next read Bottom of PRF_Current from [Engine.PlayerPawn]

	Profile[0].TotalScore          =	float(GetConfigString("Engine.PlayerPawn", "TotalScore",		"user.ini"));
	Profile[0].LastGameType        =	  int(GetConfigString("Engine.PlayerPawn", "LastGameType",		"user.ini"));
	Profile[0].ArenaAccessLevel    =	 byte(GetConfigString("Engine.PlayerPawn", "ArenaAccessLevel",	"user.ini"));

	for( i=0; i<28; i++ )
		Profile[0].LevelHighScore[i] = float(GetConfigString("Engine.PlayerPawn", "LevelHighScore["$i$"]", "user.ini"));
	for( i=0; i<28; i++ )
        Profile[0].LevelRank[i]		=       GetConfigString("Engine.PlayerPawn", "LevelRank["$i$"]",	  "user.ini");
	for( i=0; i<28; i++ )
        Profile[0].LevelClear[i]		=  byte(GetConfigString("Engine.PlayerPawn", "LevelClear["$i$"]",	  "user.ini"));

// finally read top and bottom of all PRF_xxx's
	for( i=1; i<6; i++ )
		ReadOneProfile(i);			
}

function ReadOneProfile( int ix )
{
	local int i;

	Profile[ix].Name				   =	   GetConfigString("Card"$ix, "Name",				 "user.ini"); 
	Profile[ix].Class				   =	   GetConfigString("Card"$ix, "Class",				 "user.ini"); 
	Profile[ix].Difficulty			   =  byte(GetConfigString("Card"$ix, "Difficulty",		     "user.ini")); 
	Profile[ix].Team				   =  byte(GetConfigString("Card"$ix, "Team",				 "user.ini")); 
	Profile[ix].Index				   =   int(GetConfigString("Card"$ix, "Index",				 "user.ini")); 
	Profile[ix].LocalMap			   =	   GetConfigString("Card"$ix, "LocalMap",			 "user.ini");	// note nonredirection

	Profile[ix].TotalScore          = float(GetConfigString("Card"$ix, "TotalScore",			 "user.ini"));
	Profile[ix].LastGameType        =   int(GetConfigString("Card"$ix, "LastGameType",		 "user.ini"));
	Profile[ix].ArenaAccessLevel    =  byte(GetConfigString("Card"$ix, "ArenaAccessLevel",	 "user.ini"));

	for( i=0; i<28; i++ )
		Profile[ix].LevelHighScore[i] = float(GetConfigString("Card"$ix, "LevelHighScore["$i$"]",  "user.ini"));
	for( i=0; i<28; i++ )
		Profile[ix].LevelRank[i]      =       GetConfigString("Card"$ix, "LevelRank["$i$"]",	      "user.ini");
	for( i=0; i<28; i++ )
		Profile[ix].LevelClear[i]     =  byte(GetConfigString("Card"$ix, "LevelClear["$i$"]",	  "user.ini"));
}

function SetTotalScore(float score )
{
	Profile[0].TotalScore = score;
}
function SetAccessLevel( byte level )
{
	Profile[0].ArenaAccessLevel = level;
}
function float GetTotalScore()
{
	return Profile[0].TotalScore;
}
function byte GetAccessLevel()
{
	return Profile[0].ArenaAccessLevel;
}
function int GetCompletions()
{
	local int trips;
	local int i;

	trips = 0;
	for ( i=0; i<28; i++ )
	{
		if ( Profile[0].LevelClear[i] > 0 )
			trips++;
	}

	return trips;
}
function string GetName()
{
	return Profile[0].Name;
}




/*
// memory scanner
function Report()
{
	local int ix;

	log( "---------------------------------------" );
	log( "InfoSection:" );
	log( "      InfoName = "$InfoName );
	log( "     InfoClass = "$InfoClass );
	log( "    InfoPoints = "$InfoPoints );
	log( "     InfoLevel = "$InfoLevel );
	log( "    InfoEvents = "$InfoEvents );
	log( "CurrentProfile = "$CurrentProfile );

	for ( ix = 0; ix<6; ix++ )
	{
		log( "---------------------------------------" );
		log( "Profile["$ix$"]" );
		log( "          Name = "$Profile[ix].Name );		
		log( "         Class = "$Profile[ix].Class );		
		log( "    TotalScore = "$Profile[ix].TotalScore );		
		log( "    Difficulty = "$Profile[ix].Difficulty );		
		log( "   ArenaAccess = "$Profile[ix].ArenaAccessLevel );		
		log( "         Index = "$Profile[ix].Index );		
	}
	log( "---------------------------------------" );
}
*/
//
//
// read profile info from current slot into our class data
//
function ReadProfileInfo()
{
	local int i;

	InfoClass	=     Profile[0].Class;
	InfoName	=     Profile[0].Name;
	InfoPoints	= int(Profile[0].TotalScore);
	InfoLevel	= int(Profile[0].Difficulty);
	InfoEvents	= int(Profile[0].ArenaAccessLevel);

	for (i = 0; i < 28; i++)
	{
		InfoHighScores[i]	= Profile[0].LevelHighScore[i];
		InfoClears[i]		= Profile[0].LevelClear[i];
		InfoRank[i]			= Profile[0].LevelRank[i];
	}

	// sanity checks
	if (InfoName == "")
		InfoName = "Player";
	if (InfoLevel < 0 || InfoLevel > 3)
		InfoLevel = 1;

	CurrentProfile = Profile[0].Index;
}

//
// write current profile info into given clot
// copy back stats in case they were cleared by
// "start a new game" or some such
function SaveProfileInfo()
{
	local int i;

	Profile[0].Name				= InfoName;
	Profile[0].Class			= InfoClass;	
	Profile[0].TotalScore	    = InfoPoints;	
	Profile[0].Difficulty		= InfoLevel;
	Profile[0].ArenaAccessLevel = InfoEvents;	
	for (i = 0; i < 28; i++)
	{
		Profile[0].LevelHighScore[i] = InfoHighScores[i];
		Profile[0].LevelClear[i]	 = InfoClears[i];	
		Profile[0].LevelRank[i]		 = InfoRank[i];
	}
	Profile[0].Index = CurrentProfile;
}


function InitProfileInfo()
{
	local int i;

//	log(class$ " WES: PlayerProfile Init");
	CurrentProfile	= 0;
	InfoClass		= "";
	InfoName		= "";
	InfoPoints		= 0;
	InfoLevel		= 1;
	InfoEvents		= 0;

	for (i = 0; i < 28; i++)
	{
		InfoHighScores[i]	= 0.0;
		InfoClears[i]		= 0;
	}
}

function ResetPlayerProfile()
{
	local int i;

	InfoPoints = 0;
	InfoLevel = 1;
	InfoEvents = 0;

	for ( i=0; i < 28; i++ )
	{
		InfoHighScores[i]	= 0.0;
		InfoClears[i]		= 0;
		InfoRank[i]			= "";
	}
	SaveProfileInfo();
	StoreCurrentProfile();
}

//
// delete a given profile
//
function DeleteProfile(int cp)
{
	local int i;

//	log(class$ " WES: PlayerProfile Delete");
	InfoName		= "Player";
	InfoPoints		= 0;
	InfoLevel		= 1;
	InfoEvents		= 0;

	for (i = 0; i < 28; i++)
	{
		InfoHighScores[i]	= 0.0;
		InfoClears[i]		= 0;
		InfoRank[i]			= "";
	}
	SaveProfileInfo();
	StoreCurrentProfile();
}

/*
//
// check to see if a given profile 'slot' exists
//
function bool ProfileExists(int P)
{
	// profile must have a class to 'exist'
	return (GetConfigString("PlayerProfile" $ P, "Class", "user.ini") != "");
}

//
// scan profile 'slots' for first with a filled profile
//

function int FindFirstProfile()
{
	local int i;

	for (i = 1; i <= MaxProfiles; i++)
	{
		if (ProfileExists(i))
			break;
	}
	if (i > MaxProfiles)
	{
		log("No player profiles found");
		return 0;
	}
	else
	{
		CurrentProfile = i;
		ReadProfileInfo();
		return i;
	}
}
*/
//
// find next profile 'slot' with information
//
function int FindNextProfile()
{

	CurrentProfile++;
	if ( CurrentProfile > 4 )
		CurrentProfile = 1;
	ReadProfile( CurrentProfile );
	ReadProfileInfo();
}

//
// find previous profile 'slot' with information
//
function int FindPrevProfile()
{
	CurrentProfile--;
	if ( CurrentProfile < 1 )
		CurrentProfile = 4;
	ReadProfile( CurrentProfile );
	ReadProfileInfo();
}

defaultproperties
{
     ReadyRooms(0)=RR-Amateur
     ReadyRooms(1)=RR-Sequoia
     ReadyRooms(2)=RR-Orbital
     ReadyRooms(3)=RR-Barracuda
     ReadyRooms(4)=RR-Asteroid
     ReadyRooms(5)=RR-Sky
     ReadyRooms(6)=RR-Luna
     ReadyRooms(7)=RR-Champion
}
