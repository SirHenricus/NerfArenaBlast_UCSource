//=============================================================================
// Justin
//=============================================================================
class Justin expands Male;

#exec TEXTURE IMPORT NAME=Justin FILE=MODELS\T02d_01.pcx GROUP=Skins FLAGS=2 // T02d_01.pcx

function PreBeginPlay()
{
    Super.PreBeginPlay();
    PlayerReplicationInfo.TeamType=TEAM_Tycoons;
    PlayerReplicationInfo.BotIndex=AKA_Justin;
}

function Texture Face()
{
    return Texture'NerfKids.SkinIcons.I_Justin';
}

defaultproperties
{
     BaseEyeHeight=34.957966
     Skin=Texture'NerfKids.Skins.Justin'
     Mesh=LodMesh'NerfKids.M_Regular'
     CollisionRadius=25.000000
     CollisionHeight=43.697456
}
