//=============================================================================
// SHRBall
//
// Created by Wezo
//=============================================================================
class SHRBall extends SHBallproj;


simulated function PostBeginPlay()
{
	 Skin=Texture(DynamicLoadObject("NerfRes.RedBallSkin", class'Texture'));
	 Super.PostBeginPlay();	
}

	simulated function ProcessTouch( actor Other, vector HitLocation )
	{
		local RedBall RB;

		if ( Other.IsA('Pawn'))
        {
    		if ((Other != instigator) || bCanHitOwner)
    		{
    			RB = Spawn(class'RedBall');
    			if( RB != None )
    			{
    				RB.GiveTo(Pawn(Other));
    	    		Pawn(Other).SetHoldingBall(RB.Sequence, True);
    				PlaySound(MiscSound,,2.0);
    				Pawn(Other).ClientMessage(RB.PickupMessage,'Pickup');	
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
		local RedBall b;
		
		TempLoc = Location;
        SetCollision( false, false, false );

		if ( Level.NetMode != NM_Client ) 
		{
			b=Spawn(class 'RedBall',,'',TempLoc,rot(0,0,0));
		}
		destroy();
	}

defaultproperties
{
     Points=1750
     Slot=5
}
