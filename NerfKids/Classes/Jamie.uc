//=============================================================================
// Jamie
//=============================================================================
class Jamie expands Female;

#exec TEXTURE IMPORT NAME=Jamie FILE=MODELS\T05a_01.pcx GROUP=Skins FLAGS=2 // T05a_01.pcx

function PreBeginPlay()
{
    Super.PreBeginPlay();
    PlayerReplicationInfo.TeamType=TEAM_Lunas;
    PlayerReplicationInfo.BotIndex=AKA_Jamie;
}

function Texture Face()
{
    return Texture'NerfKids.SkinIcons.I_Jamie';
}

defaultproperties
{
     bIsFemale=True
     BaseEyeHeight=34.734219
     Skin=Texture'NerfKids.Skins.Jamie'
     Mesh=LodMesh'NerfKids.F_Regular_T'
     CollisionRadius=25.000000
     CollisionHeight=43.418999
}
