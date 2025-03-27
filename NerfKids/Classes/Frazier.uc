//=============================================================================
// Frazier
//=============================================================================
class Frazier expands Male;

#exec TEXTURE IMPORT NAME=Frazier FILE=MODELS\T07b_01.pcx GROUP=Skins FLAGS=2 // T07b_01.pcx

function PreBeginPlay()
{
    Super.PreBeginPlay();
    PlayerReplicationInfo.TeamType=TEAM_Orbiteers;
    PlayerReplicationInfo.BotIndex=AKA_Frazier;
}

function Texture Face()
{
    return Texture'NerfKids.SkinIcons.I_Frazier';
}

defaultproperties
{
     BaseEyeHeight=33.528698
     Skin=Texture'NerfKids.Skins.Frazier'
     Mesh=LodMesh'NerfKids.M_Small'
     CollisionRadius=25.000000
     CollisionHeight=41.910873
}
