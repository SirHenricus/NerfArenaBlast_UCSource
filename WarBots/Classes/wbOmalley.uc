//=============================================================================
// WBOMalley
//=============================================================================
class WBOMalley expands MaleWarBot;

function ForceMeshToExist()
{
    spawn( class'NerfKids.OMalley' );
}

function PreBeginPlay()
{
    Super.PreBeginPlay();
    PlayerReplicationInfo.TeamType=TEAM_Rockheads;
    PlayerReplicationInfo.BotIndex=AKA_OMalley;
}

function Texture Face()
{
	return Texture'NerfKids.SkinIcons.I_OMalley';
}

defaultproperties
{
     FavoriteWeapon=Class'NerfWeapon.Whomper'
     Accuracy=0.700000
     BaseEyeHeight=39.281078
     EyeHeight=39.281078
     CombatStyle=0.500000
     Skin=Texture'NerfKids.Skins.OMalley'
     Mesh=LodMesh'NerfKids.M_Wide'
     CollisionRadius=35.000000
     CollisionHeight=49.101345
}
