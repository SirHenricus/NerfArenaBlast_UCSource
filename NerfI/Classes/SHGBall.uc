//=============================================================================
// SHGBall
//
// Created by Wezo
//=============================================================================
class SHGBall extends SHBallproj;

simulated function PostBeginPlay()
{
	 Skin=Texture(DynamicLoadObject("NerfRes.GreenBallSkin", class'Texture'));
	 Super.PostBeginPlay();	
}

simulated function ProcessTouch( actor Other, vector HitLocation )
{
	local GreenBall GB;

	if ( Other.IsA('Pawn'))
    {
   		if ((Other != instigator) || bCanHitOwner)
   		{
   			GB = Spawn(class'GreenBall');
   			if( GB != None )
   			{
   				GB.GiveTo(Pawn(Other));
   	    		Pawn(Other).SetHoldingBall(GB.Sequence, True);
   				PlaySound(MiscSound,,2.0);
   				Pawn(Other).ClientMessage(GB.PickupMessage,'Pickup');	
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
	local GreenBall b;
		
	TempLoc = Location;
    SetCollision( false, false, false );

	if ( Level.NetMode != NM_Client ) 
	{
		b=Spawn(class 'GreenBall',,'',TempLoc,rot(0,0,0));
	}
	Destroy();
}

defaultproperties
{
     Points=1000
     Slot=2
}
