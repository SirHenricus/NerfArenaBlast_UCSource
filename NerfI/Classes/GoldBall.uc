//=============================================================================
// GoldBall.
//
// Created by Wezo
//=============================================================================

class GoldBall extends SHBallPick;

function PostBeginPlay()
{
	 Skin=Texture(DynamicLoadObject("NerfRes.GoldBallSkin", class'Texture'));
	 Super.PostBeginPlay();	
}

defaultproperties
{
     Sequence=7
     PickupMessage=You got The Gold Ball. Press 1 to Shoot
     Event=Gold
}
