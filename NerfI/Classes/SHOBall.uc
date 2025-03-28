//=============================================================================
// SHOBall
//
// Created by Wezo
//=============================================================================
class SHOBall extends SHBallproj;

simulated function PostBeginPlay()
{
	 Skin=Texture(DynamicLoadObject("NerfRes.OrangeBallSkin", class'Texture'));
	 Super.PostBeginPlay();	
}


simulated function ProcessTouch( actor Other, vector HitLocation )
{
	local OrangeBall OB;

	if ( Other.IsA('Pawn'))
    {
   		if ((Other != instigator) || bCanHitOwner)
   		{
   			OB = Spawn(class'OrangeBall');
   			if( OB != None )
   			{
   				OB.GiveTo(Pawn(Other));
   	    		Pawn(Other).SetHoldingBall(OB.Sequence, True);
   				PlaySound(MiscSound,,2.0);
   				Pawn(Other).ClientMessage(OB.PickupMessage,'Pickup');	
   			}
   			Destroy();
        }
	}
	else if ( Other.IsA('BallTrigger'))
		Destroy();
}


	simulated function BecomeBallPickup()
	{
		local Vector TempLoc;
		local OrangeBall b;
		
		TempLoc = Location;
        SetCollision( false, false, false );

		if ( Level.NetMode != NM_Client ) 
		{
			b=Spawn(class 'OrangeBall',,'',TempLoc,rot(0,0,0));
		}
		destroy();
	}

defaultproperties
{
     Points=1500
     Slot=4
}
