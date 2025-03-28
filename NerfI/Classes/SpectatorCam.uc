//=============================================================================
// SpectatorCam.
//
// Integrated by Wezo
//=============================================================================
class SpectatorCam extends KeyPoint;

var() bool bSkipView; // spectators skip this camera when flipping through cams
var() float FadeOutTime;	// fade out time if used as EndCam

defaultproperties
{
     FadeOutTime=5.000000
     bDirectional=True
     Texture=Texture'Engine.S_Camera'
     CollisionRadius=20.000000
     CollisionHeight=40.000000
}
