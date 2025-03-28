//=============================================================================
// podium01.
//=============================================================================
class podium01 expands Actor;

#exec MESH IMPORT MESH=podium01 ANIVFILE=g:\NerfRes\NerfMesh\MODELS\podium01_a.3d DATAFILE=g:\NerfRes\NerfMesh\MODELS\podium01_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=podium01 X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=podium01 SEQ=All                      STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=podium01 SEQ=podium01                 STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=podium01 MESH=podium01
#exec MESHMAP SCALE MESHMAP=podium01 X=0.1 Y=0.1 Z=0.2

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=LodMesh'NerfI.podium01'
     DrawScale=4.000000
     CollisionRadius=60.000000
     CollisionHeight=100.000000
}
