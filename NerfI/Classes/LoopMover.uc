//=============================================================================
// LoopMover.
//
// Usage		:	1) Set TriggerToLoop = False, so that the Mover will loop forever
//					once the trigger event is sent.
//					2) Set TriggerToLoop = True, so that the Mover will only loop if 
//					the corespondent trigger is being trigger.
//					3) Set AutoLoop = True, so that the Mover will loop once the level
//					start.
// Integrated by Wezo 7-7-99
//=============================================================================
class LoopMover extends Mover;

// When the last keyframe position is reached, this mover 
// interpolates to the first keyframe (directly, not through
// the intermediate frames), and repeats the movement forever.

var int NextKeyNum;
var () bool TriggerToLoop;
var () bool AutoLoop;

function BeginPlay() 
{
	KeyNum = 0;
	Super.BeginPlay();
	if (AutoLoop)
		Gotostate('LoopMove', 'AutoLooping');
}


function DoOpen() 
{
	// Move to the next keyframe.
	//
	bOpening = true;
	bDelaying = false;
	InterpolateTo( NextKeyNum, MoveTime );
	PlaySound( OpeningSound );
	AmbientSound = MoveAmbientSound;
}

state() LoopMove
{
	function Trigger( actor Other, pawn EventInstigator )
	{
		SavedTrigger = Other;
		Instigator = EventInstigator;
		SavedTrigger.BeginEvent();
		GotoState( 'LoopMove', 'Open' );
	}

	function UnTrigger( actor Other, pawn EventInstigator )
	{
		Enable( 'Trigger' );
		SavedTrigger = Other;
		Instigator = EventInstigator;
		GotoState( 'LoopMove', 'InactiveState' );
	}
		
	function InterpolateEnd(actor Other) 
	{	
	}

	function BeginState()
	{
		bOpening = false;
	}

Open:
	Disable ('Trigger');
	if (!TriggerToLoop)
		Disable('UnTrigger');
	NextKeyNum = KeyNum + 1;
	if( NextKeyNum >= NumKeys ) NextKeyNum = 0;
	DoOpen();
	FinishInterpolation();
	FinishedOpening();

	// Loop forever
	GotoState( 'LoopMove', 'Open' );
InactiveState:
	FinishInterpolation();
	FinishedOpening();
	Stop;

	// Auto Looping
AutoLooping:
	NextKeyNum = KeyNum + 1;
	if( NextKeyNum >= NumKeys ) NextKeyNum = 0;
	DoOpen();
	FinishInterpolation();
	FinishedOpening();

	// Loop forever
	GotoState( 'LoopMove', 'AutoLooping' );
	
}

defaultproperties
{
}
