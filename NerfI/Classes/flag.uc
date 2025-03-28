//=============================================================================
// flag.
//
// Created by Wezo
//=============================================================================
class flag extends Decoration;

//##nerf WES FIXME
// I dont' know if I want to dynamic load this object yet, cause if I do that, you won't
// be able to see it in the editor.
#exec MESH IMPORT MESH=flagN ANIVFILE=g:\NerfRes\NerfMesh\MODELS\flag_a.3d DATAFILE=g:\NerfRes\NerfMesh\MODELS\flag_d.3d X=0 Y=0 Z=0 LODSTYLE=8
#exec MESH ORIGIN MESH=flagN X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=flagN SEQ=All                      STARTFRAME=0 NUMFRAMES=12
#exec MESH SEQUENCE MESH=flagN SEQ=s_flag                   STARTFRAME=0 NUMFRAMES=12

#exec TEXTURE IMPORT NAME=flagB FILE=g:\NerfRes\NerfMesh\TEXTURES\AR_BLUE_F.pcx GROUP=Skins Flags=2
#exec TEXTURE IMPORT NAME=flagG FILE=g:\NerfRes\NerfMesh\TEXTURES\AR_GREEN_F.pcx GROUP=Skins  Flags=2
#exec TEXTURE IMPORT NAME=flagY FILE=g:\NerfRes\NerfMesh\TEXTURES\AR_YELLOW_F.pcx GROUP=Skins  Flags=2
#exec TEXTURE IMPORT NAME=flagO FILE=g:\NerfRes\NerfMesh\TEXTURES\AR_ORANGE_F.pcx GROUP=Skins  Flags=2
#exec TEXTURE IMPORT NAME=flagR FILE=g:\NerfRes\NerfMesh\TEXTURES\AR_RED_F.pcx GROUP=Skins  Flags=2
#exec TEXTURE IMPORT NAME=flagP FILE=g:\NerfRes\NerfMesh\TEXTURES\AR_PURPLE_F.pcx GROUP=Skins  Flags=2
#exec TEXTURE IMPORT NAME=flagGO FILE=g:\NerfRes\NerfMesh\TEXTURES\AR_GOLD_F.pcx GROUP=Skins  Flags=2

#exec MESHMAP NEW   MESHMAP=flagN MESH=flagN
#exec MESHMAP SCALE MESHMAP=flagN X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=flag_01 FILE=g:\NerfRes\NerfMesh\Textures\flag_01.PCX GROUP=Skins FLAGS=2	//flagpole
#exec TEXTURE IMPORT NAME=flag_02 FILE=g:\NerfRes\NerfMesh\Textures\flag_02.PCX GROUP=Skins FLAGS=2	//skin

#exec MESHMAP SETTEXTURE MESHMAP=flagN NUM=0 TEXTURE=flag_02
#exec MESHMAP SETTEXTURE MESHMAP=flagN NUM=1 TEXTURE=flag_01


function PostBeginPlay()
{
	Super.PostBeginPlay();
	LoopAnim('All',0.25);
}

defaultproperties
{
     bStatic=False
     Physics=PHYS_Walking
     RemoteRole=ROLE_SimulatedProxy
     DrawType=DT_Mesh
     Texture=Texture'NerfI.Skins.flagGO'
     Mesh=LodMesh'NerfI.flagN'
     DrawScale=2.000000
     bMeshCurvy=True
}
