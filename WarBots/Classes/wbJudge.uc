//=============================================================================
// WBJudge
//=============================================================================
class WBJudge expands MaleWarBot;

function ForceMeshToExist()
{
    spawn( class'NerfKids.Judge' );
}

function PreBeginPlay()
{
    Super.PreBeginPlay();
    PlayerReplicationInfo.TeamType=TEAM_Rockheads;
    PlayerReplicationInfo.BotIndex=AKA_Judge;
}

function Texture Face()
{
	return Texture'NerfKids.SkinIcons.I_Judge';
}

defaultproperties
{
     FavoriteWeapon=Class'NerfWeapon.Hyperst'
     Accuracy=0.500000
     CampingRate=0.300000
     Alertness=0.200000
     BaseEyeHeight=34.957966
     EyeHeight=34.957966
     Skill=1.000000
     CombatStyle=0.200000
     Skin=Texture'NerfKids.Skins.Judge'
     Mesh=LodMesh'NerfKids.M_Regular'
     CollisionRadius=25.000000
     CollisionHeight=43.697456
}
