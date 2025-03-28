//=============================================================================
// SHPBall
//
// Created by Wezo
//=============================================================================
class SHPBall extends SHBallproj;

simulated function PostBeginPlay()
{
	 Skin=Texture(DynamicLoadObject("NerfRes.PurpleBallSkin", class'Texture'));
	 Super.PostBeginPlay();	
}


	simulated function ProcessTouch( actor Other, vector HitLocation )
	{
		local PurpleBall PB;

		if ( Other.IsA('Pawn'))
        {
    		if ((Other != instigator) || bCanHitOwner)
    		{
    			PB = Spawn(class'PurpleBall');
    			if( PB != None )
    			{
    				PB.GiveTo(Pawn(Other));
    	    		Pawn(Other).SetHoldingBall(PB.Sequence, True);
    				PlaySound(MiscSound,,2.0);
    				Pawn(Other).ClientMessage(PB.PickupMessage,'Pickup');	
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
		local PurpleBall b;
		
		TempLoc = Location;
        SetCollision( false, false, false );

		if ( Level.NetMode != NM_Client ) 
		{
			b=Spawn(class 'PurpleBall',,'',TempLoc,rot(0,0,0));
		}
		destroy();
	}

defaultproperties
{
     Points=2000
     Slot=6
}
