//=============================================================================
// Riles
//=============================================================================
class Riles expands Male;

#exec TEXTURE IMPORT NAME=Riles FILE=MODELS\T03c_01.pcx GROUP=Skins FLAGS=2 // T03c_01.pcx

function PreBeginPlay()
{
    Super.PreBeginPlay();
    PlayerReplicationInfo.TeamType=TEAM_Rockheads;
    PlayerReplicationInfo.BotIndex=AKA_Ted;
}

function Texture Face()
{
    return Texture'NerfKids.SkinIcons.I_Riles';
}

defaultproperties
{
     BaseEyeHeight=40.024925
     Skin=Texture'NerfKids.Skins.Riles'
     Mesh=LodMesh'NerfKids.M_Sport'
     CollisionRadius=25.000000
     CollisionHeight=47.754002
}
