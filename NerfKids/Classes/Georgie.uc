//=============================================================================
// Georgie
//=============================================================================
class Georgie expands Female;

#exec TEXTURE IMPORT NAME=Georgie FILE=MODELS\T07d_01.pcx GROUP=Skins FLAGS=2 // T07d_01.pcx

function PreBeginPlay()
{
    Super.PreBeginPlay();
    PlayerReplicationInfo.TeamType=TEAM_Orbiteers;
    PlayerReplicationInfo.BotIndex=AKA_Georgie;
}

function Texture Face()
{
    return Texture'NerfKids.SkinIcons.I_Georgie';
}

defaultproperties
{
     bIsFemale=True
     BaseEyeHeight=37.667934
     Skin=Texture'NerfKids.Skins.Georgie'
     Mesh=LodMesh'NerfKids.F_Sport'
     CollisionRadius=25.000000
     CollisionHeight=47.084915
}
