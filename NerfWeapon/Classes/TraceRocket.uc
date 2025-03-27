//=============================================================================
// TraceRocket.
//=============================================================================
class TraceRocket expands rocket;

var Vector TraceLocation;


simulated function Tick(float DeltaTime)
{
	local vector TraceDir;

	Super.Tick(DeltaTime);
	TraceDir = Normal(TraceLocation - Location);
	if ( (TraceDir Dot InitialDir) > 0 )
	{
		MagnitudeVel = VSize(Velocity);
		Velocity =  MagnitudeVel * Normal(TraceDir * 0.47 * MagnitudeVel + Velocity);		
		SetRotation(rotator(Velocity));
	}
}


auto state Flying
{

/*
	function BeginState()
	{
		if ( (Level.NetMode != NM_Standalone) && (Role == ROLE_Authority) )
			RemoteRole = ROLE_SimulatedProxy;
		else
			RemoteRole = ROLE_AutonomousProxy;
		Super.BeginState();

	}
*/
}	

defaultproperties
{
     speed=1200.000000
     MaxSpeed=2000.000000
     Damage=45.000000
     bNetTemporary=False
     RemoteRole=ROLE_DumbProxy
     LifeSpan=10.000000
     LightBrightness=182
     LightHue=27
     LightSaturation=75
     LightRadius=8
     bCorona=False
}
