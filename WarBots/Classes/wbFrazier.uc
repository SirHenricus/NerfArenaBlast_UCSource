//=============================================================================
// WBFrazier
//=============================================================================
class WBFrazier expands MaleWarBot;

function ForceMeshToExist()
{
    spawn( class'NerfKids.Frazier' );
}

function PreBeginPlay()
{
    Super.PreBeginPlay();
    PlayerReplicationInfo.TeamType=TEAM_Orbiteers;
    PlayerReplicationInfo.BotIndex=AKA_Frazier;
}

function Texture Face()
{
	return Texture'NerfKids.SkinIcons.I_Frazier';
}

defaultproperties
{
     FavoriteWeapon=Class'NerfWeapon.Hyperst'
     Accuracy=0.500000
     CampingRate=0.200000
     Alertness=0.300000
     BaseEyeHeight=33.528698
     EyeHeight=33.528698
     CombatStyle=0.100000
     Skin=Texture'NerfKids.Skins.Frazier'
     Mesh=LodMesh'NerfKids.M_Small'
     CollisionRadius=25.000000
     CollisionHeight=41.910873
}
