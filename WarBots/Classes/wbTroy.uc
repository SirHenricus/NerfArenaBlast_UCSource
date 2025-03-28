//=============================================================================
// WBTroy
//=============================================================================
class WBTroy expands MaleWarBot;

function ForceMeshToExist()
{
    spawn( class'NerfKids.Troy' );
}

function PreBeginPlay()
{
    Super.PreBeginPlay();
    PlayerReplicationInfo.TeamType=TEAM_Baracudas;
    PlayerReplicationInfo.BotIndex=AKA_Troy;
}

function Texture Face()
{
	return Texture'NerfKids.SkinIcons.I_Troy';
}

defaultproperties
{
     FavoriteWeapon=Class'NerfWeapon.Pulsator'
     Accuracy=0.500000
     CampingRate=0.200000
     Alertness=0.300000
     BaseEyeHeight=41.260143
     EyeHeight=41.260143
     CombatStyle=0.200000
     Skin=Texture'NerfKids.Skins.Troy'
     Mesh=LodMesh'NerfKids.M_Tall_T'
     CollisionRadius=25.000000
     CollisionHeight=51.575180
}
