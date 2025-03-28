//=============================================================================
// WBRoger
//=============================================================================
class WBRoger expands MaleWarBot;

function ForceMeshToExist()
{
    spawn( class'NerfKids.Roger' );
}

function PreBeginPlay()
{
    Super.PreBeginPlay();
    PlayerReplicationInfo.TeamType=TEAM_Baracudas;
    PlayerReplicationInfo.BotIndex=AKA_Roger;
}

function Texture Face()
{
	return Texture'NerfKids.SkinIcons.I_Roger';
}

defaultproperties
{
     FavoriteWeapon=Class'NerfWeapon.Ballzoka'
     Accuracy=0.600000
     CampingRate=0.100000
     Alertness=0.300000
     BaseEyeHeight=37.929207
     EyeHeight=37.929207
     CombatStyle=0.600000
     Skin=Texture'NerfKids.Skins.Roger'
     Mesh=LodMesh'NerfKids.M_Regular_M'
     CollisionRadius=25.000000
     CollisionHeight=43.696999
}
