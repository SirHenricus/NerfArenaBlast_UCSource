//=============================================================================
// SuitPowerPlusMutator.
// removes all powerups
//=============================================================================

class SuitPowerPlusMutator expands Mutator;

function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
	if ( Other.IsA('SuitPower')) 
	{
		ReplaceWith( Other, "NerfI.SuitPowerPlus" );
		return false;
	}
	bSuperRelevant = 0;
	return true;
}

defaultproperties
{
}
