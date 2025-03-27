//=============================================================================
// RBJami
//=============================================================================
class RBJami expands FemaleRaceBot;

function ForceMeshToExist()
{
    spawn( class'NerfKids.Jami' );
}

function PreBeginPlay()
{
    Super.PreBeginPlay();
    PlayerReplicationInfo.TeamType=TEAM_Twisters;
    PlayerReplicationInfo.BotIndex=AKA_Jami;
}

function Texture Face()
{
    return Texture'NerfKids.SkinIcons.I_Jami';
}

defaultproperties
{
     FavoriteWeapon=Class'NerfWeapon.Ballzoka'
     Accuracy=0.600000
     CampingRate=0.300000
     bIsFemale=True
     BaseEyeHeight=34.203213
     EyeHeight=34.203213
     Skin=Texture'NerfKids.Skins.Jami'
     Mesh=LodMesh'NerfKids.F_Small'
     CollisionRadius=25.000000
     CollisionHeight=42.754017
}
