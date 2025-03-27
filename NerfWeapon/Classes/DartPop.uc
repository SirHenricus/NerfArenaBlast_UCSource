//=============================================================================
// DartPop -- bell & whistle effect for dart impact
//=============================================================================
class DartPop expands Effects;

simulated function Tick( float DeltaTime )
{
	if ( Level.NetMode != NM_DedicatedServer )
	{
		ScaleGlow = (Lifespan/Default.Lifespan);
		AmbientGlow = ScaleGlow * 255;		
	}
}

simulated function PostBeginPlay()
{
   	local actor a;

	if ( Level.NetMode != NM_DedicatedServer )
	{
// DSL: handy place for secondary effects
//    	 a = Spawn(class'EffectLight');
//    	 a.RemoteRole = ROLE_None;
	}	
}

defaultproperties
{
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=0.250000
     Style=STY_None
     ScaleGlow=64.000000
     bUnlit=True
     LightType=LT_Steady
     LightBrightness=255
     LightHue=44
     LightSaturation=255
     LightRadius=1
}
