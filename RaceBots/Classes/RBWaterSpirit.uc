//=============================================================================
// RBWaterSpirit
//=============================================================================
class RBWaterSpirit expands FemaleRaceBot;

function ForceMeshToExist()
{
    spawn( class'NerfKids.WaterSpirit' );
}

function PreBeginPlay()
{
    Super.PreBeginPlay();
    PlayerReplicationInfo.TeamType=TEAM_Tribe;
    PlayerReplicationInfo.BotIndex=AKA_WaterSpirit;
}

function Texture Face()
{
	return Texture'NerfKids.SkinIcons.I_WaterSpirit';
}

defaultproperties
{
     FavoriteWeapon=Class'NerfWeapon.TripleShot'
     Accuracy=0.600000
     CampingRate=0.200000
     bIsFemale=True
     Alertness=0.200000
     BaseEyeHeight=39.452862
     EyeHeight=39.452862
     Skin=Texture'NerfKids.Skins.WaterSpirit'
     Mesh=LodMesh'NerfKids.F_Model'
     CollisionRadius=25.000000
     CollisionHeight=50.617947
}
