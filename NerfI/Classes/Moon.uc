//=============================================================================
// Moon.
//=============================================================================
class Moon extends Decoration;

//##nerf WES FIXME
// I dont' know if I want to dynamic load this object yet, cause if I do that, you won't
// be able to see it in the editor.
#exec MESH IMPORT MESH=Earth_Moon ANIVFILE=g:\NerfRes\nerfmesh\MODELS\Earth_Moon_a.3d DATAFILE=g:\NerfRes\nerfmesh\MODELS\Earth_Moon_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=Earth_Moon X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=Earth_Moon SEQ=All                      STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=Earth_Moon MESH=Earth_Moon
#exec MESHMAP SCALE MESHMAP=Earth_Moon X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=JEarth_Moon_01 FILE=g:\NerfRes\nerfmesh\Textures\Earth_Moon_01.PCX GROUP=Skins FLAGS=2	//earth
#exec TEXTURE IMPORT NAME=JEarth_Moon_02 FILE=g:\NerfRes\nerfmesh\Textures\Earth_Moon_02.PCX GROUP=Skins FLAGS=2	//moon

#exec MESHMAP SETTEXTURE MESHMAP=Earth_Moon NUM=0 TEXTURE=JEarth_Moon_01

defaultproperties
{
     DrawType=DT_Mesh
     Skin=Texture'NerfI.Skins.JEarth_Moon_02'
     Mesh=LodMesh'NerfI.Earth_Moon'
}
