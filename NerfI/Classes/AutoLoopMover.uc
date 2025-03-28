//=============================================================================
// AutoLoopMover.	- by Wezo
// 
// Charateristic:	Loop Mover trigger by level start. When the last keyframe 
//					position is reached, this mover interpolates to the first 
//					keyframe (directly, not through the intermediate frames),
//					and repeats the movement forever.
//=================================================================================
class AutoLoopMover extends LoopMover;

function BeginPlay() 
{
	Super.BeginPlay();
	Gotostate('LoopMove');
}

state() LoopMove
{
Begin:
	NextKeyNum = KeyNum + 1;
	if( NextKeyNum >= NumKeys ) NextKeyNum = 0;
	DoOpen();
	FinishInterpolation();
	FinishedOpening();

	// Loop forever
	GotoState( 'LoopMove', 'Begin' );
}

defaultproperties
{
}
