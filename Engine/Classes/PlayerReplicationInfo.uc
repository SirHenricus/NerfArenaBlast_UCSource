//=============================================================================
// PlayerReplicationInfo.
//=============================================================================
class PlayerReplicationInfo expands ReplicationInfo
	native nativereplication;

var string				PlayerName;		// Player name, or blank if none.
var string				OldName;		// Temporary value.
var int					PlayerID;		// Unique id number.
var string				TeamName;		// Team name, or blank if none.
var byte				Team;			// Player Team, 255 = None for player.
var int					TeamID;			// Player position in team.
var float				Score;			// Player's current score.
var float				Deaths;			// Number of player's deaths.
var float				Spree;			// Player is on a killing spree.

var class<VoicePack>	VoiceType;

//##nerf WES FIXME
// Taking it out since we never use it.
//var Decoration			HasFlag;

var int					Ping;
var bool				bIsFemale;
var	bool				bIsABot;
var bool				bFeigningDeath;
var bool				bIsSpectator;
var bool				bWaitingPlayer;
var bool				bAdmin;
//##nerf WES FIXME
// Don't need TalkTexture since we are not displaying their face.
//var Texture				TalkTexture;
var ZoneInfo			PlayerZone;
var LocationID			PlayerLocation;
var name				SuicideType;
var int					Rank;
var int					Lead;
var bool				bDead;

// Nerf expansion slot
var texture				SkinIcon;		// player's icon in the HUD
var ETeamType			TeamType;		// twister, tycoon, whatever
var EBotIndex			BotIndex;		// one of ours, 0-32

var	EVType				VType;			// for voice source construction


replication
{
	// Things the server should send to the client.
	reliable if ( Role == ROLE_Authority )
		PlayerName, OldName, PlayerID, TeamName, Team, TeamID, Score, Deaths, Spree, VoiceType,
		//HasFlag, 
		Ping, bIsFemale, bIsABot, bFeigningDeath, bIsSpectator, bWaitingPlayer,
		bAdmin, 
//##nerf WES 
// Don't need TalkTexture since we are not displaying their face.
		//TalkTexture,
		PlayerZone, PlayerLocation, SuicideType, Rank, Lead, bDead,
		SkinIcon, TeamType, BotIndex, VType;
}

function PostBeginPlay()
{
	Timer();
	SetTimer(2.0, true);
	bIsFemale = Pawn(Owner).bIsFemale;
}
 					
function Timer()
{
	local float MinDist, Dist;
	local LocationID L;

	MinDist = 1000000;
	PlayerLocation = None;
	if ( PlayerZone != None )
		for ( L=PlayerZone.LocationID; L!=None; L=L.NextLocation )
		{
			Dist = VSize(Owner.Location - L.Location);
			if ( (Dist < L.Radius) && (Dist < MinDist) )
			{
				PlayerLocation = L;
				MinDist = Dist;
			}
		}

	if (PlayerPawn(Owner) != None)
		Ping = int(PlayerPawn(Owner).ConsoleCommand("GETPING"));
}

defaultproperties
{
     Team=255
     NetUpdateFrequency=4.000000
}
