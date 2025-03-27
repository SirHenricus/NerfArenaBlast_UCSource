//=============================================================================
// RBGranite
//=============================================================================
class RBGranite expands MaleRaceBot;

function ForceMeshToExist()
{
    spawn( class'NerfKids.Granite' );
}

function PreBeginPlay()
{
    Super.PreBeginPlay();
    PlayerReplicationInfo.TeamType=TEAM_Tribe;
    PlayerReplicationInfo.BotIndex=AKA_Granite;
}

function Texture Face()
{
	return Texture'NerfKids.SkinIcons.I_Granite';
}

defaultproperties
{
     FavoriteWeapon=Class'NerfWeapon.Whomper'
     Accuracy=0.700000
     Alertness=0.400000
     BaseEyeHeight=38.882938
     EyeHeight=38.882938
     CombatStyle=0.400000
     Skin=Texture'NerfKids.Skins.Granite'
     Mesh=LodMesh'NerfKids.M_Wide_T'
     CollisionRadius=35.000000
     CollisionHeight=49.099998
}
