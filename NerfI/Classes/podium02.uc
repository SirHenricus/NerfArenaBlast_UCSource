//=============================================================================
// podium02.
//=============================================================================
class podium02 expands Actor;

#exec MESH IMPORT MESH=podium02 ANIVFILE=g:\NerfRes\NerfMesh\MODELS\podium02_a.3d DATAFILE=g:\NerfRes\NerfMesh\MODELS\podium02_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=podium02 X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=podium02 SEQ=All                      STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=podium02 SEQ=podium02                 STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=podium02 MESH=podium02
#exec MESHMAP SCALE MESHMAP=podium02 X=0.1 Y=0.1 Z=0.2

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=LodMesh'NerfI.podium02'
     DrawScale=4.000000
     CollisionRadius=170.000000
     CollisionHeight=30.000000
}
