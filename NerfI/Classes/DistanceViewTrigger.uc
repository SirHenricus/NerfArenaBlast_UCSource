//=============================================================================
// DistanceViewTrigger: When touched, triggers all pawns within its collision radius
//
// Intergrated by Wezo at 7-7-99
//=============================================================================
class DistanceViewTrigger extends Triggers;

function Trigger( actor Other, pawn EventInstigator )
{
	local int i;

	for ( i=0; i<4; i++ )
		if (  Pawn(Touching[i]) != None )
			Touching[i].Trigger(Other, EventInstigator);
}

defaultproperties
{
}
