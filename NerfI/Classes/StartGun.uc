//=============================================================================
// StartGun
//
// after timer countdown,
// notifies RaceStart points to let their bots go
//
// Integrated by Wezo
//=============================================================================
//##nerf WES FIXME
// Might now even need this class cause UT has build in start delay.
class StartGun extends Triggers;

#exec Texture Import File=g:\NerfRes\nerfmesh\Textures\clock.pcx Name=S_Clock Mips=Off Flags=2
#exec Audio Import File="g:\NerfRes\scrptsnd\specialfx\buzzer.wav" NAME="Bzzzt"

var()   sound       Announcement;
var()   sound       Buzzer;
var()   float       VODelay;        // how long to wait before announcement
var()   float       BuzzDelay;      // how long to wait before buzzer
var     bool        bSFlag;
var     bool        bMPFlag;         // true = multiplayer
var     NerfBots    Racer;  
var     PlayerPawn  NrfPlyr;
var     int         DownCounter;
var     string      HoldHorsesMsg;

function PreBeginPlay()
{
    if ( Level.NetMode != NM_Standalone )
    {
        DownCounter = 25;
        bMPFlag = true;
    }
    else
    {
        DownCounter = 0;
        bMPFlag = false;
    }
    Super.PreBeginPlay();
}

//
// as game starts up, play opening announcement
// and start downcount clock
//
function PostBeginPlay()
{

    bSFlag = False;             // play announcement first
    if ( bMPFlag )              // multiplayer? 
    {
        SetTimer( 1.0, false );
    }
    else
       SetTimer( VODelay, false );          // single player
/* DSL -- this is apparently too early to take effect on player
 *     -- so it has been moved to function Timer, below
 *  foreach AllActors ( class 'PlayerPawn', NrfPlyr )
 *      NrfPlyr.GroundSpeed = 0.0;
 */
    Super.PostBeginPlay();
}

//
// at end of countdown, play buzzer sound
// and turn player loose
//
function Timer()
{
    if ( bMPFlag && (DownCounter > 0) )
    {
        if ( DownCounter == 1 )
            HoldHorsesMsg = DownCounter$" second to game start...";
        else
            HoldHorsesMsg = DownCounter$" seconds to game start...";
        BroadcastMessage( HoldHorsesMsg, true, 'CriticalEvent' );
        DownCounter--;
        SetTimer( 1.0, false );
    }
    else
    {
        if ( !bSFlag )
        {
            foreach AllActors ( class 'PlayerPawn', NrfPlyr )
            {
                NrfPlyr.GroundSpeed = -1.0;
                NrfPlyr.AirControl = 0.0;
                NrfPlyr.PlaySound(Announcement, SLOT_Interface,16,true,1000000);
            }
            SetTimer( BuzzDelay, false );
            bSFlag = True;      // next time play buzzer
        }
        else
        {
            DeathMatchGame(Level.Game).bGameIsAfoot = true;
            foreach AllActors( class 'NerfBots', Racer )
            {
                Racer.bReadyToRun = True;
                Level.Game.EquipPlayer( Racer );
            }
            foreach AllActors( class 'PlayerPawn', NrfPlyr )
            {
                NrfPlyr.GroundSpeed = NrfPlyr.Default.GroundSpeed;
                NrfPlyr.AirControl = NrfPlyr.Default.AirControl;
                Level.Game.EquipPlayer( NrfPlyr );
                NrfPlyr.PlaySound(Buzzer, SLOT_Interact,16,true,1000000);
            }
        }
    }
}

defaultproperties
{
     Buzzer=Sound'NerfI.Bzzzt'
     VODelay=1.000000
     BuzzDelay=16.500000
     Texture=Texture'NerfI.S_Clock'
}
