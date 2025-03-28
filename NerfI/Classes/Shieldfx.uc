//=============================================================================
// Shieldfx
//=============================================================================
class Shieldfx extends Effects;

#exec OBJ LOAD FILE=g:\NerfRes\NerfMesh\Textures\Haha.utx PACKAGE=NerfI.Haha

#exec MESH IMPORT MESH=shield_fx ANIVFILE=g:\NerfRes\NerfMesh\MODELS\shield_fx_a.3d DATAFILE=g:\NerfRes\NerfMesh\MODELS\shield_fx_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=shield_fx X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=shield_fx SEQ=All                      STARTFRAME=0 NUMFRAMES=3 

#exec MESHMAP NEW   MESHMAP=shield_fx MESH=shield_fxn
#exec MESHMAP SCALE MESHMAP=shield_fx X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=shield_fx NUM=0 TEXTURE=NerfI.Haha.HitEffect


simulated function PostBeginPlay()
{
	PlayAnim('All');
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
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=0.200000
     DrawType=DT_Mesh
     Style=STY_Translucent
     Mesh=LodMesh'NerfI.shield_fx'
     DrawScale=0.750000
}
