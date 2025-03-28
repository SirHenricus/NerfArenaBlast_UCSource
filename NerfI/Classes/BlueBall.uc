//=============================================================================
// BlueBall.
//
// Created by Wezo
//=============================================================================
class BlueBall extends SHBallPick;

function PostBeginPlay()
{
	 Skin=Texture(DynamicLoadObject("NerfRes.BlueBallSkin", class'Texture'));
	 Super.PostBeginPlay();	
}

defaultproperties
{
     Sequence=1
     PickupMessage=You got The Blue Ball. Press 1 to Shoot
     Event=Blue
}
