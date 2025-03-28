//=============================================================================
// TargetMover.	- by Wezo
// 
// Charateristic:	Target Mover which generate points if the players or bots hit
//					it.When the last keyframe position is reached, this mover 
//					interpolates to the first keyframe (directly, not through the
//					intermediate frames).
// 
// Usage		:	1) Put Points for the target and assign a texture for it in 
//					the mover properties.
//					2) Set instantTrigger to False if you want to trigger event at
//					the last keyframe. It's set as true as default.
//					3) Set the Mover to TriggerOpenTimed.
//=================================================================================
class TargetMover extends Mover;

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

//	log (class$ " WES: Taking Damage " $instigatedBy);

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

	
	self.Trigger(self, instigatedBy);
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
     bDamageTriggered=True
}
