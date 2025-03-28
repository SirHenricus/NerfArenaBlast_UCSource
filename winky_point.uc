//=============================================================================
// winky_point.
//
// Integrated by Wezo 7-8-99 (hitpoint.uc)
// Transmogrified by DSL 9-7-99
//=============================================================================
class winky_point extends Effects;


var vector DesLoc;


State Hanging
{
	function Tick( float DeltaTime )
	{
        if ( Level.NetMode != NM_DedicatedServer )
        {
            ScaleGlow = (Lifespan/Default.Lifespan);
            AmbientGlow = ScaleGlow * 255;
        }
	}


Begin:
	Enable('Tick');
}

defaultproperties
{
     Physics=PHYS_Flying
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=2.500000
     DrawType=DT_Sprite
     Style=STY_Translucent
     DrawScale=0.500000
     ScaleGlow=1.100000
     bUnlit=True
     Mass=3.000000
     Buoyancy=3.750000
}
