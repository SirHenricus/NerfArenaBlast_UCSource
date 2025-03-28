//=============================================================================
// LevelController: receives trigger message from the GameType as input, 
// then check the Player's ArenaAccessLevel to open arena doors.
//
// Created by Wezo
//=============================================================================
class LevelController extends Dispatcher;

//
// When LevelController is triggered...
//
function Trigger( actor Other, pawn EventInstigator )
{
	Instigator = EventInstigator;
	gotostate('ActiveEvent');
}

state ActiveEvent
{
Begin:
	disable('Trigger');
	for( i=0; i<(PlayerPawn(Instigator).ArenaAccessLevel+1); i++ )
	{
		if( OutEvents[i] != '' )
		{
			Sleep( OutDelays[i] );
			foreach AllActors( class 'Actor', Target, OutEvents[i] )
				Target.Trigger( Self, Instigator );
		}
	}
	enable('Trigger');
}

defaultproperties
{
}
