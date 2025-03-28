//=============================================================================
// TarPointTrigger.
//=============================================================================

////////////////////////////////////////////////////////////////////////////////
// This is an invisible Trigger that triggers a 200 pts score which flow in the 
// air. This Trigger could also link to the other trigger or mover to trigger an
// event or activate a mover.
// 
// TarPoint Trigger is just like the regular trigger except it generate point
// display. You could also place the trigger on a Mover which is moving constantly
//
// General Usage:
//		1. Set the TriggerType of the TarPointTrigger to TT_ClassProximity from 
//         the Editor Property menu.
//		2. Set the ClassProximityType of the TarPointTrigger to Class'Engine.Projectile'
//
//	The above Property should be set as default.
//
// Trigger with Physics:
//		1. Set Physics to PHYS_falling in the Property Menu.
//		2. Set bFixedRotationDir to TRUE.
//		3. Set bCollideWorld to TRUE.
//
// The about Property of Tigger with Physics is NOT set as default.
//
// P.S. Properties setting for Trigger with Physics apply to regular trigger too.
////////////////////////////////////////////////////////////////////////////////

class TarPointTrigger extends Trigger;

var() int Point;

function Touch( actor Other )
{
	local vector SLoc;
	local HitPoint bonus;

	local actor A;
	
	if( IsRelevant( Other ) )
	{
//		log(class$ " Other is relevant ");
		if ( ReTriggerDelay > 0 )
		{
			if ( Level.TimeSeconds - TriggerTime < ReTriggerDelay )
				return;
			TriggerTime = Level.TimeSeconds;
		}
		// Broadcast the Trigger message to all matching actors.
		if( Event != '' )
			foreach AllActors( class 'Actor', A, Event )
				A.Trigger( Other, Other.Instigator );

		if ( Other.IsA('Pawn') && (Pawn(Other).SpecialGoal == self) )
			Pawn(Other).SpecialGoal = None;
				
		if( Message != "" )
			// Send a string message to the toucher.
			Other.Instigator.ClientMessage( Message );

		if( bTriggerOnceOnly )
			// Ignore future touches.
			SetCollision(False);
		else if ( RepeatTriggerTime > 0 )
			SetTimer(RepeatTriggerTime, false);

		if( Projectile(Other) != None )
		{
			(Other.instigator).PlayerReplicationInfo.score += Point;
			SLoc = Location;
			SLoc.Z += 50;
		
			bonus = spawn(class 'HitPoint',Pawn(Other),'', SLoc);
			if (bonus != None)
				bonus.gotostate('Flowing');
		}

	}
}

function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, 
						Vector momentum, name damageType)
{
	Damage = 0;
	Super.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType);
}

defaultproperties
{
     Point=200
     TriggerType=TT_ClassProximity
     ClassProximityType=Class'Engine.Projectile'
}
