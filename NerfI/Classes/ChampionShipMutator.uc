//=============================================================================
// ChampionShipMutator.
// removes all powerups
//=============================================================================

class ChampionShipMutator expands Mutator;

function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
	if ( Other.IsA('Pickup')) 
	{
//		log(class$ " WES: Remove the Pickup" @Pickup(Other).Owner);
		If (Pickup(Other).Owner == None)
		{
			Pickup(Other).Respawntime = 0.0;
			Other.Destroy();
		}
		//ReplaceWith( Other, "NerfI.SuitPowerPlus" );
		return false;
	}
	else if ( Other.IsA('Weapon')) 
	{
//		log(class$ " WES: Remove the Pickup" @Pickup(Other).Owner);
		If (Weapon(Other).Owner == None)
		{
			Weapon(Other).Respawntime = 0.0;
			Other.Destroy();
		}
		//ReplaceWith( Other, "NerfI.SuitPowerPlus" );
		return false;
	}
	bSuperRelevant = 0;
	return true;
}

function Class<Weapon> MutatedDefaultWeapon()
{
	local Class<Weapon> W;

//	log(class$ " WES: Next Mutator is" @NextMutator);
	if ( NextMutator != None )
	{
		W = NextMutator.MutatedDefaultWeapon();
//		log(class$ " WES: W MutatedDefaultWeapon" @W);
		if ( W == Level.Game.DefaultWeapon )
			W = MyDefaultWeapon();
	}
	else
		W = MyDefaultWeapon();
	return W;
}

function ModifyPlayer(Pawn Other)
{
	// called by Gameinfo.RestartPlayer()
	local Inventory Inv;

	Inv = Other.FindInventoryType(class'SShot');
	if ( Inv != None )
		;
	else
	{
		inv = Spawn(class'SShot');
		if( inv != None )
		{
			inv.bHeldItem = true;
			inv.RespawnTime = 0.0;
			inv.GiveTo(Other);
			inv.Activate();
		}
	}
	if ( NextMutator != None )
		NextMutator.ModifyPlayer(Other);
}

function Class<Weapon> MyDefaultWeapon()
{
//	log(class$ " WES: DefaultWeapon" @DefaultWeapon);
//	log(class$ " WES: Game DefaultWeapon" @Level.Game.DefaultWeapon);
	if ( DefaultWeapon != None )
		return DefaultWeapon;
	else
		return Level.Game.DefaultWeapon;
}

function bool IsRelevant(Actor Other, out byte bSuperRelevant)
{
	local bool bResult;

	// allow mutators to remove actors
//	log(class$ " WES: IsRelevant got call" @NextMutator);
	bResult = CheckReplacement(Other, bSuperRelevant);
//	log(class$ " WES: bResult is" @bResult);
	if ( bResult && (NextMutator != None) )
		bResult = NextMutator.IsRelevant(Other, bSuperRelevant);

	return bResult;
}

defaultproperties
{
}
