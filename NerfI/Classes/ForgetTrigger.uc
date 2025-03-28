//=============================================================================
// ForgetTrigger.
// Players hitting this trigger will Forget up towards the current running 
// direction
//
//=============================================================================
class ForgetTrigger expands Triggers;

var NerfBots Pending;
var()       name        MoverTag;			// if to be associated with a mover
var         mover       MyMover;

function PostBeginPlay()
{
	if ( MoverTag != '' )
    {
		ForEach AllActors(class'Mover', MyMover, MoverTag )
		{
			SetBase(MyMover);
			break;
		}

    }
	Super.PostBeginPlay();
}

function Timer()
{
//log( "Telling "$Pending$" to forget it" );

//##nerf WES
// There's no such thing as NerfBot.PickDestination cause PickDestination
// is not a global function in NerfBots. It's a function inside a state.
    if ( Pending != None )
        Pending.GotoState( 'Wandering' );
}

function Touch( actor Other )
{
	if ( Other.IsA('NerfBots') )
	{
		Pending = NerfBots(Other);
		SetTimer(0.01, false);
	}
}

defaultproperties
{
}
