//=============================================================================
// Newton
//=============================================================================
class Newton expands Male;

#exec TEXTURE IMPORT NAME=Newton FILE=MODELS\T07a_01.pcx GROUP=Skins FLAGS=2 // T07a_01.pcx

function PreBeginPlay()
{
    Super.PreBeginPlay();
    PlayerReplicationInfo.TeamType=TEAM_Orbiteers;
    PlayerReplicationInfo.BotIndex=AKA_Newton;
}

function Texture Face()
{
    return Texture'NerfKids.SkinIcons.I_Newton';
}

defaultproperties
{
     BaseEyeHeight=41.080006
     Skin=Texture'NerfKids.Skins.Newton'
     Mesh=LodMesh'NerfKids.M_Tall'
     CollisionRadius=25.000000
     CollisionHeight=51.612370
}
