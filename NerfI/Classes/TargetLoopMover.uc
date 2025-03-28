//=============================================================================
// TargetLoopMover.	- by Wezo
// 
// Charateristic:	Target Mover which generate points if the players or bots hit
//					it.When the last keyframe position is reached, this mover 
//					interpolates to the first keyframe (directly, not through the
//					intermediate frames), and repeats the movement forever.
// 
// Usage		:	1) Set TriggerToLoop = False, so that the Mover will loop forever
//					once the trigger event is sent.
//					2) Set TriggerToLoop = True, so that the Mover will only loop if 
//					the corespondent trigger is being trigger.
//					3) Set AutoLoop = True, so that the Mover will loop once the level
//					start.
//					4) Put Points for the target and assign a texture for it in 
//					the mover properties.
//=================================================================================
class TargetLoopMover extends LoopMover;

var () int Points;
var () texture PointTexture;
var () bool instantTrigger;

// When damaged
function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, 
						Vector momentum, name damageType)
{
	local vector SLoc;
	local HitPoint bonus;
	local actor A;

	instigatedBy.PlayerReplicationInfo.score += Points;
	SLoc = Location;
	SLoc.Z += 50;
		
	bonus = spawn(class 'HitPoint',instigatedBy,'', SLoc);
	if (bonus != None)
	{
		bonus.texture = PointTexture;
		bonus.gotostate('Flowing');
	}

	if ( instantTrigger )
	{
		if( Event != '' )
			foreach AllActors( class 'Actor', A, Event )
				A.Trigger( Self, Instigator );
	}
}

// Handle when the mover finishes opening.
function FinishedOpening()
{
	local actor A;

	// Update sound effects.
	PlaySound( OpenedSound, SLOT_None );
	
	// Trigger any chained movers.
	if ( !instantTrigger )
	{
		if( Event != '' )
			foreach AllActors( class 'Actor', A, Event )
				A.Trigger( Self, Instigator );
	}

	FinishNotify();
}

defaultproperties
{
     instantTrigger=True
}
