//=============================================================================
// HBJane
//=============================================================================
class HBJane expands FemaleHuntBot;

function ForceMeshToExist()
{
    spawn( class'NerfKids.Jane' );
}

function PreBeginPlay()
{
    Super.PreBeginPlay();
    PlayerReplicationInfo.TeamType=TEAM_Gators;
    PlayerReplicationInfo.BotIndex=AKA_Jane;
}

function Texture Face()
{
	return Texture'NerfKids.SkinIcons.I_Jane';
}

defaultproperties
{
     FavoriteWeapon=Class'NerfWeapon.Ballzoka'
     Accuracy=0.600000
     CampingRate=0.300000
     bIsFemale=True
     Alertness=0.500000
     BaseEyeHeight=37.667934
     EyeHeight=37.667934
     CombatStyle=0.200000
     Skin=Texture'NerfKids.Skins.Jane'
     Mesh=LodMesh'NerfKids.F_Sport'
     CollisionRadius=25.000000
     CollisionHeight=47.084915
}
