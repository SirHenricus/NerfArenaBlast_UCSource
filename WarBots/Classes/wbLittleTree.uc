//=============================================================================
// WBLittleTree
//=============================================================================
class WBLittleTree expands MaleWarBot;

function ForceMeshToExist()
{
    spawn( class'NerfKids.LittleTree' );
}

function PreBeginPlay()
{
    Super.PreBeginPlay();
    PlayerReplicationInfo.TeamType=TEAM_Tribe;
    PlayerReplicationInfo.BotIndex=AKA_LittleTree;
}

function Texture Face()
{
	return Texture'NerfKids.SkinIcons.I_LittleTree';
}

defaultproperties
{
     FavoriteWeapon=Class'NerfWeapon.MightyMo'
     Accuracy=0.500000
     CampingRate=0.200000
     Alertness=0.500000
     BaseEyeHeight=41.080006
     EyeHeight=41.080006
     Skill=1.000000
     CombatStyle=0.500000
     Skin=Texture'NerfKids.Skins.LittleTree'
     Mesh=LodMesh'NerfKids.M_Tall'
     CollisionRadius=25.000000
     CollisionHeight=51.612370
}
