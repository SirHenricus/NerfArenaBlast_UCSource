//=============================================================================
// SHGOBall
//
// Created by Wezo
//=============================================================================

class SHGOBall extends SHBallproj;

simulated function PostBeginPlay()
{
	 Skin=Texture(DynamicLoadObject("NerfRes.GoldBallSkin", class'Texture'));
	 Super.PostBeginPlay();	
}


	simulated function ProcessTouch( actor Other, vector HitLocation )
	{
		local GoldBall GOB;

		if ( Other.IsA('Pawn'))
        {
    		if ((Other != instigator) || bCanHitOwner)
    		{
    			GOB = Spawn(class'GoldBall');
    			if( GOB != None )
    			{
    				GOB.GiveTo(Pawn(Other));
    	    		Pawn(Other).SetHoldingBall(GOB.Sequence, True);
    				PlaySound(MiscSound,,2.0);
    				Pawn(Other).ClientMessage(GOB.PickupMessage,'Pickup');	
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
		local GoldBall b;
		
		TempLoc = Location;
        SetCollision( false, false, false );

		if ( Level.NetMode != NM_Client ) 
		{
			b=Spawn(class 'GoldBall',,'',TempLoc,rot(0,0,0));
		}
		Destroy();
	}

defaultproperties
{
     Points=5000
     Slot=7
}
