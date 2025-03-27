//=============================================================================
// Wes
//=============================================================================
class Wes expands Male;

#exec TEXTURE IMPORT NAME=Wes FILE=MODELS\T08b_01.pcx GROUP=Skins FLAGS=2 // T08b_01.pcx

function PreBeginPlay()
{
    Super.PreBeginPlay();
    PlayerReplicationInfo.TeamType=TEAM_Gators;
    PlayerReplicationInfo.BotIndex=AKA_Wes;
}

function Texture Face()
{
    return Texture'NerfKids.SkinIcons.I_Wes';
}

defaultproperties
{
     BaseEyeHeight=39.281078
     Skin=Texture'NerfKids.Skins.Wes'
     Mesh=LodMesh'NerfKids.M_Wide'
     CollisionRadius=35.000000
     CollisionHeight=49.101345
}
