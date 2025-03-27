//=============================================================================
// HBWes
//=============================================================================
class HBWes expands MaleHuntBot;

function ForceMeshToExist()
{
    spawn( class'NerfKids.Wes' );
}

function PreBeginPlay()
{
    Super.PreBeginPlay();
    PlayerReplicationInfo.TeamType=TEAM_Gators;
    PlayerReplicationInfo.BotIndex=AKA_Wes;
}

function Texture Face()
{
	return Texture'NerfKids.SkinIcons.I_Wes';
}

defaultproperties
{
     FavoriteWeapon=Class'NerfWeapon.Hyperst'
     Accuracy=0.500000
     CampingRate=0.100000
     Alertness=0.600000
     BaseEyeHeight=39.281078
     EyeHeight=39.281078
     Skill=1.000000
     CombatStyle=0.500000
     Skin=Texture'NerfKids.Skins.Wes'
     Mesh=LodMesh'NerfKids.M_Wide'
     CollisionRadius=35.000000
     CollisionHeight=49.101345
}
