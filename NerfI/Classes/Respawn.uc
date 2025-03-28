//=============================================================================
// ReSpawn.
//=============================================================================
class ReSpawn expands Effects;

//##nerf WES Textures FIXME
// Unreal ReSpawn effect. We need to have our own effect.
/*
#exec MESH IMPORT MESH=TeleEffect2 ANIVFILE=MODELS\telepo_a.3D DATAFILE=MODELS\telepo_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=TeleEffect2 X=0 Y=0 Z=-200 YAW=0
#exec MESH SEQUENCE MESH=TeleEffect2 SEQ=All  STARTFRAME=0  NUMFRAMES=30
#exec MESH SEQUENCE MESH=TeleEffect2  SEQ=Burst  STARTFRAME=0  NUMFRAMES=30
#exec MESHMAP SCALE MESHMAP=TeleEffect2 X=0.03 Y=0.03 Z=0.06
#exec MESHMAP SETTEXTURE MESHMAP=TeleEffect2 NUM=1 TEXTURE=Default
*/

//##nerf WES FIXME
// Roll back to the previous version after the milestone is done.

#exec MESH IMPORT MESH=TeleEffect2 ANIVFILE=g:\NerfRes\Nerfmesh\MODELS\telepot_a.3d DATAFILE=g:\NerfRes\Nerfmesh\MODELS\telepot_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=TeleEffect2 X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=TeleEffect2 SEQ=All     STARTFRAME=0 NUMFRAMES=60
#exec MESH SEQUENCE MESH=TeleEffect2 SEQ=Burst STARTFRAME=0 NUMFRAMES=60

#exec TEXTURE IMPORT NAME=Jtelepot1 FILE=g:\NerfRes\Nerfmesh\MODELS\telepot_01.PCX GROUP=Skins FLAGS=2 // Material #2
#exec TEXTURE IMPORT NAME=Jtelepot2 FILE=g:\NerfRes\Nerfmesh\MODELS\telepot_02.PCX GROUP=Skins PALETTE=Jtelepot1 // Material #1
#exec TEXTURE IMPORT NAME=Jtelepot3 FILE=g:\NerfRes\Nerfmesh\MODELS\telepot_03.PCX GROUP=Skins PALETTE=Jtelepot1 // Material #3

#exec MESHMAP NEW   MESHMAP=TeleEffect2 MESH=TeleEffect2
#exec MESHMAP SCALE MESHMAP=TeleEffect2 X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=TeleEffect2 NUM=1 TEXTURE=Jtelepot1
#exec MESHMAP SETTEXTURE MESHMAP=TeleEffect2 NUM=2 TEXTURE=Jtelepot2
#exec MESHMAP SETTEXTURE MESHMAP=TeleEffect2 NUM=3 TEXTURE=Jtelepot3

#exec OBJ LOAD FILE=g:\NerfRes\weaponeffects\TeleEffect.utx PACKAGE=NerfI.TeleEffect


#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\genericfx\Gplrspwn.WAV" NAME="RespawnSound" GROUP="Generic"

simulated function BeginPlay()
{
	Super.BeginPlay();
	Playsound(EffectSound1);
	PlayAnim('All',0.8);
}

auto state Explode
{
	simulated function Tick( float DeltaTime )
	{
		ScaleGlow = (Lifespan/Default.Lifespan);	
		LightBrightness = ScaleGlow*210.0;
	}

	simulated function AnimEnd()
	{
		RemoteRole = ROLE_None;
		Destroy();
	}
}

defaultproperties
{
     EffectSound1=Sound'NerfI.Generic.RespawnSound'
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=1.000000
     DrawType=DT_Mesh
     Style=STY_Translucent
     Texture=Texture'NerfI.TeleEffect.mat_a00'
     Mesh=LodMesh'NerfI.TeleEffect2'
     DrawScale=0.250000
     bUnlit=True
     bParticles=True
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightBrightness=210
     LightHue=30
     LightSaturation=224
     LightRadius=8
}
