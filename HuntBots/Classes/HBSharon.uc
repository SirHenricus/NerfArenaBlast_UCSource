//=============================================================================
// HBSharon
//=============================================================================
class HBSharon expands FemaleHuntBot;

function ForceMeshToExist()
{
    spawn( class'NerfKids.Sharon' );
}

function PreBeginPlay()
{
    Super.PreBeginPlay();
    PlayerReplicationInfo.TeamType=TEAM_Gators;
    PlayerReplicationInfo.BotIndex=AKA_Sharon;
}

function Texture Face()
{
	return Texture'NerfKids.SkinIcons.I_Sharon';
}

defaultproperties
{
     FavoriteWeapon=Class'NerfWeapon.Scatter'
     Accuracy=0.700000
     CampingRate=0.200000
     bIsFemale=True
     Alertness=0.400000
     BaseEyeHeight=34.734219
     EyeHeight=34.734219
     CombatStyle=0.300000
     Skin=Texture'NerfKids.Skins.Sharon'
     Mesh=LodMesh'NerfKids.F_Regular_T'
     CollisionRadius=25.000000
     CollisionHeight=43.418999
}
