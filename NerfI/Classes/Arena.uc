//=============================================================================
// Arena.
// replaces all weapons and ammo with Pulseguns and pulsegun ammo
//=============================================================================

class Arena expands Mutator
	abstract;

var name WeaponName, AmmoName;
var string WeaponString, AmmoString;


function AddMutator(Mutator M)
{
	if ( M.IsA('Arena') )
	{
		log(M$" not allowed (already have an Arena mutator)");
		return; //only allow one arena mutator
	}
	Super.AddMutator(M);
}

function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
	if ( Other.IsA('Weapon') && !Other.IsA(WeaponName) )
	{
		Level.Game.bCoopWeaponMode = false;
		ReplaceWith(Other, WeaponString);
		return false;
	}

	if ( Other.IsA('Ammo') && !Other.IsA(AmmoName) )
	{
		ReplaceWith(Other, AmmoString);
		return false;
	}

	bSuperRelevant = 0;
	return true;
}

defaultproperties
{
}
