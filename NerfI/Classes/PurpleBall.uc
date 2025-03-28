//=============================================================================
// PurpleBall.
//
// Created by Wezo
//=============================================================================
class PurpleBall extends SHBallPick;

function PostBeginPlay()
{
	 Skin=Texture(DynamicLoadObject("NerfRes.PurpleBallSkin", class'Texture'));
	 Super.PostBeginPlay();	
}

defaultproperties
{
     Sequence=6
     PickupMessage=You got The Purple Ball. Press 1 to Shoot
     Event=Purple
}
