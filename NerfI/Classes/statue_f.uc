//=============================================================================
// statue_f.
//
// Created by Wezo
//=============================================================================
class statue_f extends Decoration;

#exec MESH IMPORT MESH=statue_f ANIVFILE=g:\NerfRes\NerfMesh\MODELS\statue_f_a.3d DATAFILE=g:\NerfRes\NerfMesh\MODELS\statue_f_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=statue_f X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=statue_f SEQ=All                      STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=statue_f MESH=statue_f
#exec MESHMAP SCALE MESHMAP=statue_f X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=statue_f_01 FILE=g:\NerfRes\NerfMesh\Textures\statue_f_01.PCX GROUP=Skins FLAGS=2	//frontb
#exec TEXTURE IMPORT NAME=statue_f_02 FILE=g:\NerfRes\NerfMesh\Textures\statue_f_02.PCX GROUP=Skins FLAGS=2	//backb
#exec TEXTURE IMPORT NAME=statue_f_03 FILE=g:\NerfRes\NerfMesh\Textures\statue_f_03.PCX GROUP=Skins FLAGS=2	//Material #8
#exec TEXTURE IMPORT NAME=statue_f_04 FILE=g:\NerfRes\NerfMesh\Textures\statue_f_04.PCX GROUP=Skins FLAGS=2	//Material #1

#exec MESHMAP SETTEXTURE MESHMAP=statue_f NUM=1 TEXTURE=statue_f_01
#exec MESHMAP SETTEXTURE MESHMAP=statue_f NUM=2 TEXTURE=statue_f_02
#exec MESHMAP SETTEXTURE MESHMAP=statue_f NUM=3 TEXTURE=statue_f_03
#exec MESHMAP SETTEXTURE MESHMAP=statue_f NUM=4 TEXTURE=statue_f_04

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=LodMesh'NerfI.statue_f'
     DrawScale=2.000000
     CollisionRadius=35.000000
     CollisionHeight=80.000000
     bCollideActors=True
     bCollideWorld=True
     bBlockActors=True
     bBlockPlayers=True
}
