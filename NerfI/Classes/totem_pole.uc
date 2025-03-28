//=============================================================================
// totem_pole.
//
// Created by Wezo
//=============================================================================
class totem_pole extends Decoration;

#exec MESH IMPORT MESH=totem_pole ANIVFILE=g:\NerfRes\NerfMesh\MODELS\totem_pole_a.3d DATAFILE=g:\NerfRes\NerfMesh\MODELS\totem_pole_d.3d X=0 Y=0 Z=0 LODSTYLE=8
#exec MESH ORIGIN MESH=totem_pole X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=totem_pole SEQ=All                      STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=totem_pole SEQ=totem01                  STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=totem_pole MESH=totem_pole
#exec MESHMAP SCALE MESHMAP=totem_pole X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jtotem_pole_01 FILE=g:\NerfRes\NerfMesh\Textures\totem_pole_01.PCX GROUP=Skins FLAGS=2	//Material #3
#exec TEXTURE IMPORT NAME=Jtotem_pole_02 FILE=g:\NerfRes\NerfMesh\Textures\totem_pole_02.PCX GROUP=Skins FLAGS=2	//Material #2
#exec TEXTURE IMPORT NAME=Jtotem_pole_03 FILE=g:\NerfRes\NerfMesh\Textures\totem_pole_03.PCX GROUP=Skins FLAGS=2	//Material #1
#exec TEXTURE IMPORT NAME=Jtotem_pole_04 FILE=g:\NerfRes\NerfMesh\Textures\totem_pole_04.PCX GROUP=Skins FLAGS=2	//Material #4
#exec TEXTURE IMPORT NAME=Jtotem_pole_05 FILE=g:\NerfRes\NerfMesh\Textures\totem_pole_05.PCX GROUP=Skins FLAGS=2	//Material #5

#exec MESHMAP SETTEXTURE MESHMAP=totem_pole NUM=1 TEXTURE=Jtotem_pole_01
#exec MESHMAP SETTEXTURE MESHMAP=totem_pole NUM=2 TEXTURE=Jtotem_pole_02
#exec MESHMAP SETTEXTURE MESHMAP=totem_pole NUM=3 TEXTURE=Jtotem_pole_03
#exec MESHMAP SETTEXTURE MESHMAP=totem_pole NUM=4 TEXTURE=Jtotem_pole_04
#exec MESHMAP SETTEXTURE MESHMAP=totem_pole NUM=5 TEXTURE=Jtotem_pole_05

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=LodMesh'NerfI.totem_pole'
     DrawScale=2.000000
     CollisionRadius=35.000000
     CollisionHeight=80.000000
     bCollideActors=True
     bCollideWorld=True
     bBlockActors=True
     bBlockPlayers=True
}
