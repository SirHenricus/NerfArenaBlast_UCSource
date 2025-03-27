//=============================================================================
// Sharon
//=============================================================================
class Sharon expands Female;

#exec TEXTURE IMPORT NAME=Sharon FILE=MODELS\T08d_01.pcx GROUP=Skins FLAGS=2 // T08d_01.pcx

function PreBeginPlay()
{
    Super.PreBeginPlay();
    PlayerReplicationInfo.TeamType=TEAM_Gators;
    PlayerReplicationInfo.BotIndex=AKA_Sharon;
}

function Texture Face()
{
    return Texture'NerfKids.SkinIcons.I_Sharon';
}

defaultproperties
{
     bIsFemale=True
     BaseEyeHeight=34.734219
     Skin=Texture'NerfKids.Skins.Sharon'
     Mesh=LodMesh'NerfKids.F_Regular_T'
     CollisionRadius=25.000000
     CollisionHeight=43.418999
}
