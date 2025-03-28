//=============================================================================
// Jumper.
// Creatures will jump on hitting this trigger in direction specified
//
// Intergrated by Wezo at 7-7-99
//=============================================================================
class Kicker extends Triggers;

var() vector KickVelocity;
var Actor Pending;

function Timer()
{
	Pending.SetPhysics(PHYS_Falling);
	Pending.Velocity += KickVelocity;
}

function Touch( actor Other )
{
	local Actor A;

	if ( Pending != None )
		Timer();

	Pending = Other;
	SetTimer(0.1, false);

	if( Event != '' )
		foreach AllActors( class 'Actor', A, Event )
			A.Trigger( Other, Other.Instigator );
}

defaultproperties
{
     bDirectional=True
}
