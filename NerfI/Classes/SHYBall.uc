//=============================================================================
// SHYBall
//
// Created by Wezo
//=============================================================================
class SHYBall extends SHBallproj;

simulated function PostBeginPlay()
{
	 Skin=Texture(DynamicLoadObject("NerfRes.YellowBallSkin", class'Texture'));
	 Super.PostBeginPlay();	
}

	simulated function ProcessTouch( actor Other, vector HitLocation )
	{
		local YellowBall YB;

		if ( Other.IsA('Pawn'))
        {
    		if ((Other != instigator) || bCanHitOwner)
    		{
    			YB = Spawn(class'YellowBall');
    			if( YB != None )
    			{
    				YB.GiveTo(Pawn(Other));
    	    		Pawn(Other).SetHoldingBall(YB.Sequence, True);
    				PlaySound(MiscSound,,2.0);
    				Pawn(Other).ClientMessage(YB.PickupMessage,'Pickup');	
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
		local YellowBall b;
		
		TempLoc = Location;
        SetCollision( false, false, false );

		if ( Level.NetMode != NM_Client ) 
		{
			b=Spawn(class 'YellowBall',,'',TempLoc,rot(0,0,0));
		}
		self.destroy();
	}

defaultproperties
{
     Points=1250
     Slot=3
}
