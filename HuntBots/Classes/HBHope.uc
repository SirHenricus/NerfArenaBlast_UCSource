//=============================================================================
// HBHope
//=============================================================================
class HBHope expands FemaleHuntBot;

function ForceMeshToExist()
{
    spawn( class'NerfKids.Hope' );
}

function PreBeginPlay()
{
    Super.PreBeginPlay();
    PlayerReplicationInfo.TeamType=TEAM_Tycoons;
    PlayerReplicationInfo.BotIndex=AKA_Hope;
}

function Texture Face()
{
	return Texture'NerfKids.SkinIcons.I_Hope';
}

defaultproperties
{
     FavoriteWeapon=Class'NerfWeapon.TripleShot'
     Accuracy=0.500000
     CampingRate=0.300000
     bIsFemale=True
     Alertness=0.200000
     BaseEyeHeight=39.452862
     EyeHeight=39.452862
     Skill=1.000000
     CombatStyle=0.200000
     Skin=Texture'NerfKids.Skins.Hope'
     Mesh=LodMesh'NerfKids.F_Model'
     CollisionRadius=25.000000
     CollisionHeight=50.617947
}
