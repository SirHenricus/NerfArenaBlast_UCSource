//=============================================================================
// NerfSpectator.
//=============================================================================
class NerfSpectator extends Spectator;

function PostBeginPlay()
{
	Super.PostBeginPlay();
	if ( (Level.Game != None) && Level.Game.IsA('Intro') )
		HUDType = Level.Game.HUDType;		
}

exec function Fire( optional float F )
{
	if ( (Role == ROLE_Authority) && (Level.Game == None || !Level.Game.IsA('Intro')) )
		Super.Fire( F );
}

defaultproperties
{
     HUDType=Class'NerfI.spectatorhud'
     AirSpeed=400.000000
     CollisionRadius=17.000000
}
