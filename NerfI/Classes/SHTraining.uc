//=============================================================================
// SHTraining.
//=============================================================================
class SHTraining expands ScavengerHuntGame;

var PlayerPawn NewPlayer;
var Sound lastSound;
var bool bLInit;
var name EndDispatcherTag;
var Dispatcher DispEnd;
var ESoundSlot MySlot;

function PreBeginPlay()
{
    Level.DefaultGameType=class'NerfI.ScavengerHuntGame';
    bLInit = false;
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

    foreach AllActors( class'Dispatcher', DispEnd, EndDispatcherTag )
        break;
//    if ( DispEnd == None )
//       log( " TR - No Ending Dispatcher!" );
//    else
//       log( " TR - ending Dispatcher is "$DispEnd );

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
	SetTimer(1.00,true);
	return NewPlayer;
}

/*
function GITimerFunc()
{
    SentText = 0;
}

function PMTimerFunc()
{
    if ( (RemainingBots > 0) && AddBot() )
        RemainingBots--;
// remainder of PMTimer deals with countdown timer
}
*/

function SHTimerFunc()
{
    local SHBallpick b;
    local SHBallproj p;
    local int LevelBallSlot[8], i;
    local int TrackTime;

//    TrackTime = Level.TimeSeconds%30;
    TrackTime = Level.TimeSeconds%10;
    if (TrackTime == 1)
    {
        foreach AllActors ( class 'Shballpick', b)
        {
            if (LevelBallSlot[b.Sequence] == 0)
                LevelBallSlot[b.Sequence] = 1;
        }
        foreach AllActors ( class 'SHBallproj', p)
        {
            if (LevelBallSlot[p.slot] == 0)
                LevelBallSlot[p.slot] = 1;

        }

        for ( i=1; i<7; i++)		// don't spawn gold ball in training
        {
            if (LevelBallSlot[i] == 0)
                RespawnColorBall(i);
        }

    }
/*
    if ( TimeLimit > 0 )
    {
        RemainingTime--;
        if ( bGameEnded )
        {
            if ( RemainingTime < -7 )
                RestartGame();
        }
        else if ( RemainingTime <= 0 )
            EndGame("timelimit");
    }
*/
}

function Timer()
{
    local Lesson L;
    local int   total, ix;

// if lessons have not been started, start 'em
    if ( !bLInit )
    {
        foreach AllActors( class'Lesson', L )
        {
            if ( L.LessonType == LESSON_First )
            {
                L.RunLesson();
                break;
            }            
        }
        bLInit = true;
    }
    else            // do game stuff
    {               // in place of Super.Timer();
    
        SentText = 0;   // GITimer super.super.super.super
//        NGITimerFunc(); // super.super.super    ( none as of 8/3/99 )
//        PMTimerFunc();  // super.super            AddBot() and timer countdown
        SHTimerFunc();  // super                    ball gen maintenance
    }

// count number of balls deposited by student
    total = 0;
    if ( NewPlayer != None )
    {
        for (ix = 0; ix < 7; ix++)
        {
            if (NewPlayer.HasDepositedBall(ix))
                total++;
        }
    }
    if ( total > 2 )        // game over
    {
        BroadcastMessage( "You did it!" );
        if ( DispEnd != None )
        {
//log ( "TR - triggering "$DispEnd );
            DispEnd.Trigger( None, NewPlayer );
        }
		Disable( 'Timer' );
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
     EndDispatcherTag=EndDispatcher
     MySlot=SLOT_Interface
     GameMenuType=Class'NerfI.NerfGameOptionsMenu'
}
