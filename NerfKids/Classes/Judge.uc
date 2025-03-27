//=============================================================================
// Judge
//=============================================================================
class Judge expands Male;

#exec TEXTURE IMPORT NAME=Judge FILE=MODELS\T03a_01.pcx GROUP=Skins FLAGS=2 // T03a_01.pcx

function PreBeginPlay()
{
    Super.PreBeginPlay();
    PlayerReplicationInfo.TeamType=TEAM_Rockheads;
    PlayerReplicationInfo.BotIndex=AKA_Judge;
}

function Texture Face()
{
    return Texture'NerfKids.SkinIcons.I_Judge';
}

defaultproperties
{
     BaseEyeHeight=34.957966
     Skin=Texture'NerfKids.Skins.Judge'
     Mesh=LodMesh'NerfKids.M_Regular'
     CollisionRadius=25.000000
     CollisionHeight=43.697456
}
