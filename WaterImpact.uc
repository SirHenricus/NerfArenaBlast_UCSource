//=============================================================================
// WaterImpact.
//
// Integrated by Wezo
//=============================================================================
class WaterImpact extends Effects;

var bool bSpawnOnce;

simulated function Timer()
{
	local WaterRing r;

	if ( Level.NetMode != NM_DedicatedServer )
	{
		r = Spawn(class'WaterRing',,,,rot(16384,0,0));
		r.DrawScale = 0.15;
		r.RemoteRole = ROLE_None;
	}
	else 
		Destroy();
	if (bSpawnOnce) Destroy();
	bSpawnOnce=True;
}


simulated function PostBeginPlay()
{
	SetTimer(0.3,True);
}

defaultproperties
{
     bNetOptional=True
     RemoteRole=ROLE_SimulatedProxy
     AnimSequence=Burst
     DrawType=DT_Mesh
     AmbientGlow=79
}
