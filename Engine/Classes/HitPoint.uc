//=============================================================================
// HitPoint.
//
// Integrated by Wezo 7-8-99
//=============================================================================
class HitPoint extends Effects;

#exec Texture Import File=g:\nerfres\NerfMesh\textures\100c.pcx  Name=S_Hitpoint Mips=Off Flags=2

#exec AUDIO IMPORT FILE="g:\nerfres\scrptsnd\specialfx\httargA.wav" NAME="HitbonusS" GROUP="Generic"


var vector DesLoc;

simulated function BeginPlay()
{
	Super.BeginPlay();

	PlaySound(EffectSound2); //Spawned Sound
//	LifeSpan = 2 + 1 * FRand();
	Buoyancy = Mass + FRand()+0.1;
//	DrawScale += FRand()*DrawScale/2;
	DesLoc = Location;
	DesLoc.Z += 80;
	
}

State Flowing
{

	function Tick( float DeltaTime )
	{
		local vector		oLoc, nLoc;
		local vector		Direction, rpos;
		local float 		dist;
		
        if ( Level.NetMode != NM_DedicatedServer )		
        {

            ScaleGlow = (Lifespan/Default.Lifespan);
            AmbientGlow = ScaleGlow * 255;

    		oLoc = Location;// + (Velocity * DeltaTime);

    		Direction = Normal(DesLoc - oLoc);

    		dist = VSize(DesLoc - oLoc);

    		if (dist > 0) 
    		{
    			rpos = Direction * (dist - 10);
			
    			nLoc = DesLoc - rpos;
    			SetLocation (nLoc);
    		}
    	}
    }

Begin:
//	log(class$ " Enable Tick ");
	Enable('Tick');
}

defaultproperties
{
     EffectSound2=Sound'Engine.Generic.HitbonusS'
     Physics=PHYS_Flying
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=1.250000
     DrawType=DT_Sprite
     Style=STY_Translucent
     Texture=Texture'Engine.S_Hitpoint'
     DrawScale=0.400000
     ScaleGlow=1.100000
     bUnlit=True
     Mass=3.000000
     Buoyancy=3.750000
}
