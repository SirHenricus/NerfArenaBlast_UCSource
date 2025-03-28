//=============================================================================
// PawnTeleportEffect.
//
// Intergrated by Wezo at 7-7-99
//=============================================================================
class PawnTeleportEffect extends Effects;

//##nerf WES FIXME
// Need art for the effect and might put it in NerfRes.u
/*
#exec MESH IMPORT MESH=TeleEffect3 ANIVFILE=MODELS\telepo_a.3D DATAFILE=MODELS\telepo_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=TeleEffect3 X=0 Y=0 Z=-200 YAW=64
#exec MESH SEQUENCE MESH=TeleEffect3 SEQ=All  STARTFRAME=0  NUMFRAMES=30
#exec MESH SEQUENCE MESH=TeleEffect3  SEQ=Burst  STARTFRAME=0  NUMFRAMES=30
#exec MESHMAP SCALE MESHMAP=TeleEffect3 X=0.06 Y=0.06 Z=0.16
*/

//##nerf WES FIXME
// Texture for the effect.
//#exec TEXTURE IMPORT NAME=T_PawnT FILE=MODELS\Dr_a03.pcx GROUP=Effects

function Initialize(pawn Other, bool bOut)
{

}

auto state Explode
{
	simulated function Tick(float DeltaTime)
	{
		if ( (Level.NetMode == NM_DedicatedServer) || !Level.bHighDetailMode )
		{
			Disable('Tick');
			return;
		}
		ScaleGlow = (Lifespan/Default.Lifespan);	
		LightBrightness = ScaleGlow*210.0;

	}

	simulated function BeginState()
	{
		PlaySound (EffectSound1,,0.5,,500);

//##nerf WES FIXME
//We will play the animation once we have the mesh and only if we are using mesh
//		PlayAnim('All',0.6);
	}
}

defaultproperties
{
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=1.000000
     AnimSequence=All
     DrawType=DT_Mesh
     Style=STY_Translucent
     DrawScale=0.200000
     bParticles=True
     LightType=LT_Pulse
     LightEffect=LE_NonIncidence
     LightBrightness=255
     LightHue=170
     LightSaturation=96
     LightRadius=12
}
