//=============================================================================
// ARTraining.
//=============================================================================
class ARTraining expands ArenaRaceGame;

var PlayerPawn NewPlayer;
var Sound lastSound;
var ESoundSlot MySlot;

function PreBeginPlay()
{
    Level.DefaultGameType=class'NerfI.ArenaRaceGame';
    Super.PreBeginPlay();
}

function PostBeginPlay()
{
    Super.PostBeginPlay();
    bGameIsAfoot = true;            // allow SShot to come up right away
}


function BeginPlay()
{
    local Trigger t;

    foreach AllActors( class'Trigger', t )
    {
		if ( t.bGameRelevant == false )
		{
//log( "TR - turning off "$t );        
	        t.bInitiallyActive = false;
		}
    }

    Super.BeginPlay();
}


event playerpawn Login
(
	string Portal,
	string Options,
	out string Error,
	class<playerpawn> SpawnClass
)
{
//log( "TR - player login" );
	NewPlayer = Super.Login(Portal, Options, Error, SpawnClass);	
	SetTimer(1.00,False);
	return NewPlayer;
}

function Timer()
{
    local Lesson L;

    foreach AllActors( class'Lesson', L )
    {
        if ( L.LessonType == LESSON_First )
        {
            L.RunLesson();
            break;
        }            
    }
}

// DSL
// by routing tutorial lesson wave files through here, each
// succeeding one can interrupt the one before it.
// Note: may need var lastSound as ref
function GamePlaySound( sound S )
{

//    PlaySound(S, SLOT_Misc, 1, false, 4096 );

    if ( lastSound != None )
        NewPlayer.PlaySound(lastSound, MySlot, 0, false, 0);
    NewPlayer.PlaySound(S, MySlot, 1, false, 4096);
    lastSound = S;
}

/*
intrinsic(264) final function PlaySound
(
	sound				Sound,
	optional ESoundSlot Slot,
	optional float		Volume,
	optional bool		bNoOverride,
	optional float		Radius,
	optional float		Pitch
);

     SLOT_None,
     SLOT_Misc,
     SLOT_Pain,
     SLOT_Interact,
     SLOT_Ambient,
     SLOT_Talk,
     SLOT_Interface,

*/


// respawn at nearest respawn point or playerstart if rs not found
function bool RestartPlayer( pawn aPlayer )	
{
    local NavigationPoint mySpot;
    local ReSpawnPoint startSpot, testSpot;
	local bool foundStart;
    local float dist_best, dist_curr;


	if( bRestartLevel && Level.NetMode!=NM_DedicatedServer && Level.NetMode!=NM_ListenServer )
		return true;

    dist_best = 100000.00;

// find closest respawn point
    foreach AllActors( class'ReSpawnPoint', testSpot )    
    {
        dist_curr = VSize( aPlayer.Location-testSpot.Location );
        if ( dist_curr < dist_best )
        {
            startSpot = testSpot;
            dist_best = dist_curr;
        }
    }

    mySpot = startSpot;

    if ( mySpot == None )
        mySpot = FindPlayerStart(aPlayer, aPlayer.PlayerReplicationInfo.Team);

    if( mySpot == None )
         return false;

	foundStart = aPlayer.SetLocation(mySpot.Location);

//    log( aPlayer$" has spawnspot of "$aPlayer.SpawnSpot$" and fs of "$foundStart );
	if( foundStart )
	{
		mySpot.PlayTeleportEffect(aPlayer, true);
		aPlayer.SetRotation(mySpot.Rotation);
		aPlayer.ViewRotation = aPlayer.Rotation;
		aPlayer.Acceleration = vect(0,0,0);
		aPlayer.Velocity = vect(0,0,0);
		aPlayer.Health = aPlayer.Default.Health;
		aPlayer.SetCollision( true, true, true );
		aPlayer.ClientSetRotation( mySpot.Rotation );
		aPlayer.bHidden = false;

		aPlayer.SoundDampening = aPlayer.Default.SoundDampening;
// recover from our suitdeath routine
        aPlayer.Style = aPlayer.Default.Style;
        aPlayer.bBlockActors = aPlayer.Default.bBlockActors;
		AddDefaultInventory(aPlayer);
	}
	return foundStart;
}

defaultproperties
{
     MySlot=SLOT_Interface
     GameMenuType=Class'NerfI.NerfGameOptionsMenu'
}
