//=============================================================================
// SHBBall
//
// Created by Wezo
//=============================================================================
class SHBBall extends SHBallproj;

simulated function PostBeginPlay()
{
	 Skin=Texture(DynamicLoadObject("NerfRes.BlueBallSkin", class'Texture'));
	 Super.PostBeginPlay();	
}

simulated function ProcessTouch( actor Other, vector HitLocation )
{
	local BlueBall BB;

	if ( Other.IsA('Pawn'))
    {
   		if ((Other != instigator) || bCanHitOwner)
  		{
   			BB = Spawn(class'BlueBall');
  			if( BB != None )
   			{
   				BB.GiveTo(Pawn(Other));
        		Pawn(Other).SetHoldingBall(BB.Sequence, True);
   				PlaySound(MiscSound,,2.0);
    			Pawn(Other).ClientMessage(BB.PickupMessage, 'Pickup');	
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
	local BlueBall b;
	
	TempLoc = Location;
    SetCollision( false, false, false );
	if ( Level.NetMode != NM_Client ) 
	{
		b=Spawn(class 'BlueBall',,'',TempLoc,rot(0,0,0));
	}
	Destroy();
}

defaultproperties
{
     Points=750
     Slot=1
}
