//=============================================================================
// Sam
//=============================================================================
class Sam expands Male;

#exec TEXTURE IMPORT NAME=Sam FILE=MODELS\T03d_01.pcx GROUP=Skins FLAGS=2 // T03d_01.pcx

function PreBeginPlay()
{
    Super.PreBeginPlay();
    PlayerReplicationInfo.TeamType=TEAM_Rockheads;
    PlayerReplicationInfo.BotIndex=AKA_Sam;
}

function Texture Face()
{
    return Texture'NerfKids.SkinIcons.I_Sam';
}

defaultproperties
{
     BaseEyeHeight=31.524525
     Skin=Texture'NerfKids.Skins.Sam'
     Mesh=LodMesh'NerfKids.M_Fireplug'
     CollisionRadius=25.000000
     CollisionHeight=39.405655
}
