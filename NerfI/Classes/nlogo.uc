//=============================================================================
// nlogo.
//
// Created by Wezo
//=============================================================================
class nlogo extends Decoration;

//##nerf WES FIXME
// I dont' know if I want to dynamic load this object yet, cause if I do that, you won't
// be able to see it in the editor.
#exec MESH IMPORT MESH=nlogo ANIVFILE=g:\NerfRes\NerfMesh\MODELS\nlogo_a.3d DATAFILE=g:\NerfRes\NerfMesh\MODELS\nlogo_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=nlogo X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=nlogo SEQ=All    STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=nlogo SEQ=Static STARTFRAME=0 NUMFRAMES=1 RATE=16

#exec TEXTURE IMPORT NAME=Jnlogo1 FILE=g:\NerfRes\NerfMesh\MODELS\NLogo_01.pcx GROUP=Skins FLAGS=2 // NLogo_01.pcx

#exec MESHMAP NEW   MESHMAP=nlogo MESH=nlogo
#exec MESHMAP SCALE MESHMAP=nlogo X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=nlogo NUM=1 TEXTURE=Jnlogo1

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=LodMesh'NerfI.nlogo'
     CollisionRadius=100.000000
     CollisionHeight=45.000000
     bCollideActors=True
     bCollideWorld=True
}
