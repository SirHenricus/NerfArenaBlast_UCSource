//=============================================================================
// RingExplosion.
//
// Integrated by Wezo
//=============================================================================
class RingExplosion expands Effects;

//##nerf WES Textures FIXME
// Need a Ring Mesh. Now I am again Using Unreal Mesh
//
#exec MESH IMPORT MESH=Ringex ANIVFILE=g:\NerfRes\NerfMesh\MODELS\Ringex_a.3D DATAFILE=g:\NerfRes\NerfMesh\MODELS\Ringex_d.3D X=0 Y=0 Z=0 ZEROTEX=1
#exec MESH ORIGIN MESH=Ringex X=0 Y=0 Z=0 YAW=0 PITCH=64
#exec MESH SEQUENCE MESH=Ringex SEQ=All       STARTFRAME=0   NUMFRAMES=6
#exec MESH SEQUENCE MESH=Ringex SEQ=Explosion STARTFRAME=0   NUMFRAMES=6
#exec OBJ LOAD FILE=g:\NerfRes\NerfMesh\Textures\fireeffect50.utx PACKAGE=NerfI.Effect50
#exec MESHMAP SCALE MESHMAP=Ringex X=0.4 Y=0.4 Z=0.8 YAW=128
#exec MESHMAP SETTEXTURE MESHMAP=Ringex NUM=0 TEXTURE=NerfI.Effect50.FireEffect50

//##nerf WES FIXME
// Using the Unreal Sound. Damn I hate this.
//#exec AUDIO IMPORT FILE="Sounds\General\Expl03.wav" NAME="Exp103" GROUP="General"

var() Sound ExploSound;

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
	if ( Level.NetMode != NM_DedicatedServer )
	{
		PlayAnim( 'Explosion', 0.25 );
		SpawnEffects();
	}	
	if ( Instigator != None )
		MakeNoise(0.5);
}

simulated function SpawnEffects()
{
	local actor a;

//##nerf WES FIXME
// Commanding it out right now cause I don't want
// to use too much Unreal effect. Also, it will slow
// down the fps.
/*
	 a = Spawn(class'EffectLight');
	 a.RemoteRole = ROLE_None;
	 a = Spawn(class'ParticleBurst2');
	 a.RemoteRole = ROLE_None;	 
*/
}

defaultproperties
{
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=0.800000
     DrawType=DT_Mesh
     Style=STY_None
     Mesh=LodMesh'NerfI.Ringex'
     DrawScale=0.700000
     ScaleGlow=1.100000
     bUnlit=True
}
