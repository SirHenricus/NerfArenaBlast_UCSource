//=============================================================================
// YellowBall.
//
// Created by Wezo
//=============================================================================
class YellowBall extends SHBallPick;

function PostBeginPlay()
{
	 Skin=Texture(DynamicLoadObject("NerfRes.YellowBallSkin", class'Texture'));
	 Super.PostBeginPlay();	
}

defaultproperties
{
     Sequence=3
     PickupMessage=You got The Yellow Ball. Press 1 to Shoot
     Event=Yellow
}
