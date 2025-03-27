//=============================================================================
// WaterSpirit
//=============================================================================
class WaterSpirit expands Female;

#exec TEXTURE IMPORT NAME=WaterSpirit FILE=MODELS\T04b_01.pcx GROUP=Skins FLAGS=2 // T04b_01.pcx

function PreBeginPlay()
{
    Super.PreBeginPlay();
    PlayerReplicationInfo.TeamType=TEAM_Tribe;
    PlayerReplicationInfo.BotIndex=AKA_WaterSpirit;
}

function Texture Face()
{
    return Texture'NerfKids.SkinIcons.I_WaterSpirit';
}

defaultproperties
{
     bIsFemale=True
     BaseEyeHeight=39.452862
     Skin=Texture'NerfKids.Skins.WaterSpirit'
     Mesh=LodMesh'NerfKids.F_Model'
     CollisionRadius=25.000000
     CollisionHeight=50.617947
}
