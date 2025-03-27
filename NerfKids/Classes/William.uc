//=============================================================================
// William
//=============================================================================
class William expands Male;

#exec TEXTURE IMPORT NAME=William FILE=MODELS\T02c_01.pcx GROUP=Skins FLAGS=2 // T02c_01.pcx

function PreBeginPlay()
{
    Super.PreBeginPlay();
    PlayerReplicationInfo.TeamType=TEAM_Tycoons;
    PlayerReplicationInfo.BotIndex=AKA_Ted;
}

function Texture Face()
{
    return Texture'NerfKids.SkinIcons.I_William';
}

defaultproperties
{
     BaseEyeHeight=40.024925
     Skin=Texture'NerfKids.Skins.William'
     Mesh=LodMesh'NerfKids.M_Sport'
     CollisionRadius=25.000000
     CollisionHeight=47.754002
}
