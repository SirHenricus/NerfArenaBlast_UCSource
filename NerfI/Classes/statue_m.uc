//=============================================================================
// statue_m.
//
// Created by Wezo
//=============================================================================
class statue_m extends Decoration;

#exec MESH IMPORT MESH=statue_m ANIVFILE=g:\NerfRes\NerfMesh\MODELS\statue_m_a.3d DATAFILE=g:\NerfRes\NerfMesh\MODELS\statue_m_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=statue_m X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=statue_m SEQ=All                      STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=statue_m MESH=statue_m
#exec MESHMAP SCALE MESHMAP=statue_m X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=statue_m_01 FILE=g:\NerfRes\NerfMesh\Textures\statue_m_01.PCX GROUP=Skins FLAGS=2	//Material #3
#exec TEXTURE IMPORT NAME=statue_m_02 FILE=g:\NerfRes\NerfMesh\Textures\statue_m_02.PCX GROUP=Skins FLAGS=2	//twosided 

#exec MESHMAP SETTEXTURE MESHMAP=statue_m NUM=1 TEXTURE=statue_m_01
#exec MESHMAP SETTEXTURE MESHMAP=statue_m NUM=2 TEXTURE=statue_m_02

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=LodMesh'NerfI.statue_m'
     DrawScale=2.000000
     CollisionRadius=35.000000
     CollisionHeight=80.000000
     bCollideActors=True
     bCollideWorld=True
     bBlockActors=True
     bBlockPlayers=True
}
