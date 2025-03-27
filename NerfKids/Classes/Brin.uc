//=============================================================================
// Brin
//=============================================================================
class Brin expands Female;

#exec TEXTURE IMPORT NAME=Brin FILE=MODELS\T05c_01.pcx GROUP=Skins FLAGS=2 // T05c_01.pcx

function PreBeginPlay()
{
    Super.PreBeginPlay();
    PlayerReplicationInfo.TeamType=TEAM_Lunas;
    PlayerReplicationInfo.BotIndex=AKA_Brin;
}

function Texture Face()
{
    return Texture'NerfKids.SkinIcons.I_Brin';
}

defaultproperties
{
     bIsFemale=True
     BaseEyeHeight=39.452862
     Skin=Texture'NerfKids.Skins.Brin'
     Mesh=LodMesh'NerfKids.F_Model'
     CollisionRadius=25.000000
     CollisionHeight=50.617947
}
