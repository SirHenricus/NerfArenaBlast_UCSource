//=============================================================================
// RedBall.
//
// Created by Wezo
//=============================================================================
class RedBall extends SHBallPick;

function PostBeginPlay()
{
	 Skin=Texture(DynamicLoadObject("NerfRes.RedBallSkin", class'Texture'));
	 Super.PostBeginPlay();	
}

defaultproperties
{
     Sequence=5
     PickupMessage=You got The Red Ball. Press 1 to Shoot
     Event=Red
}
