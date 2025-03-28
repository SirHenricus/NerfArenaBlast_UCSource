//=============================================================================
// GreenBall.
//
// Created by Wezo
//=============================================================================
class GreenBall extends SHBallPick;

function PostBeginPlay()
{
	 Skin=Texture(DynamicLoadObject("NerfRes.GreenBallSkin", class'Texture'));
	 Super.PostBeginPlay();	
}

defaultproperties
{
     Sequence=2
     PickupMessage=You got The Green Ball. Press 1 to Shoot
     Event=Green
}
