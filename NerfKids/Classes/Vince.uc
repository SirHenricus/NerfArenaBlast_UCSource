//=============================================================================
// Vince
//=============================================================================
class Vince expands Male;

#exec TEXTURE IMPORT NAME=Vince FILE=MODELS\T08c_01.pcx GROUP=Skins FLAGS=2 // T08c_01.pcx

function PreBeginPlay()
{
    Super.PreBeginPlay();
    PlayerReplicationInfo.TeamType=TEAM_Gators;
    PlayerReplicationInfo.BotIndex=AKA_Vince;
}

function Texture Face()
{
    return Texture'NerfKids.SkinIcons.I_Vince';
}

defaultproperties
{
     BaseEyeHeight=34.957966
     Skin=Texture'NerfKids.Skins.Vince'
     Mesh=LodMesh'NerfKids.M_Regular'
     CollisionRadius=25.000000
     CollisionHeight=43.697456
}
