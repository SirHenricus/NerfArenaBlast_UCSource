//=============================================================================
// WBJamie
//=============================================================================
class WBJamie expands FemaleWarBot;

function ForceMeshToExist()
{
    spawn( class'NerfKids.Jamie' );
}

function PreBeginPlay()
{
    Super.PreBeginPlay();
    PlayerReplicationInfo.TeamType=TEAM_Lunas;
    PlayerReplicationInfo.BotIndex=AKA_Jamie;
}

function Texture Face()
{
	return Texture'NerfKids.SkinIcons.I_Jamie';
}

defaultproperties
{
     FavoriteWeapon=Class'NerfWeapon.Hyperst'
     Accuracy=0.500000
     CampingRate=0.300000
     bIsFemale=True
     Alertness=0.300000
     BaseEyeHeight=34.734219
     EyeHeight=34.734219
     Skill=1.000000
     Skin=Texture'NerfKids.Skins.Jamie'
     Mesh=LodMesh'NerfKids.F_Regular_T'
     CollisionRadius=25.000000
     CollisionHeight=43.418999
}
