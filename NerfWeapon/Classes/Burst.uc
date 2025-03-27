//=============================================================================
// Burst
//=============================================================================
class Burst expands Effects;

#exec MESH IMPORT MESH=burst ANIVFILE=g:\NerfRes\weaponanimation\MODELS\ssburst_a.3D DATAFILE=g:\NerfRes\weaponanimation\MODELS\ssburst_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=burst X=0 Y=0 Z=0 //YAW=-64

#exec MESH SEQUENCE MESH=burst SEQ=All                      STARTFRAME=0 NUMFRAMES=9

#exec MESHMAP NEW   MESHMAP=burst MESH=burst
#exec MESHMAP SCALE MESHMAP=burst X=0.2 Y=0.2 Z=0.4 

#exec TEXTURE IMPORT NAME=ssburst_01 FILE=g:\NerfRes\weaponanimation\Textures\ssburst_01.PCX GROUP=Skins FLAGS=2	//Material #1

#exec MESHMAP SETTEXTURE MESHMAP=burst NUM=0 TEXTURE=ssburst_01

#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\specialfx\htstr.wav" NAME="NoiseBurst" GROUP="Generic"

simulated function PostBeginPlay()
{
	PlayAnim   ( 'all', 0.9 );
    PlaySound( EffectSound2 );
	Gotostate('Exploding');
}

///////////////////////////////////////////////////////
state Exploding
{
Begin:
	FinishAnim();
	Destroy();
}

defaultproperties
{
     EffectSound2=Sound'NerfWeapon.Generic.NoiseBurst'
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=0.500000
     DrawType=DT_Mesh
     Mesh=LodMesh'NerfWeapon.Burst'
     DrawScale=0.500000
     AmbientGlow=215
     bNoSmooth=True
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightBrightness=96
     LightHue=64
     LightSaturation=95
     LightRadius=5
     LightPeriod=50
     bBounce=True
     Mass=2.000000
}
