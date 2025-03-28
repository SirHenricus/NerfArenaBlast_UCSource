//=============================================================================
// OrangeBall.
//
// Created by Wezo
//=============================================================================
class OrangeBall extends SHBallPick;

function PostBeginPlay()
{
	 Skin=Texture(DynamicLoadObject("NerfRes.OrangeBallSkin", class'Texture'));
	 Super.PostBeginPlay();	
}

defaultproperties
{
     Sequence=4
     PickupMessage=You got The Orange Ball. Press 1 to Shoot
     Event=Orange
}
