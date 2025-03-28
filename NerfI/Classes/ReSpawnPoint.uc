//=============================================================================
// ReSpawnPoint.
//
// Integrated by Wezo
//=============================================================================
#exec Texture Import File=g:\NerfRes\nerfmesh\Textures\ReSpawn.pcx Name=S_ReSpawn Mips=Off Flags=2

class ReSpawnPoint extends NavigationPoint;

defaultproperties
{
     bDirectional=True
     Texture=Texture'NerfI.S_ReSpawn'
     CollisionRadius=20.000000
     CollisionHeight=40.000000
}
