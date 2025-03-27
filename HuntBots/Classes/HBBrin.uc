//=============================================================================
// HBBrin
//=============================================================================
class HBBrin expands FemaleHuntBot;

function ForceMeshToExist()
{
    spawn( class'NerfKids.Brin' );
}

function PreBeginPlay()
{
    Super.PreBeginPlay();
    PlayerReplicationInfo.TeamType=TEAM_Lunas;
    PlayerReplicationInfo.BotIndex=AKA_Brin;
}

function Texture Face()
{
	return Texture'NerfKids.SkinIcons.I_Brin';
}

defaultproperties
{
     FavoriteWeapon=Class'NerfWeapon.Pulsator'
     Accuracy=0.600000
     CampingRate=0.400000
     bIsFemale=True
     Alertness=0.600000
     BaseEyeHeight=39.452862
     EyeHeight=39.452862
     Skin=Texture'NerfKids.Skins.Brin'
     Mesh=LodMesh'NerfKids.F_Model'
     CollisionRadius=25.000000
     CollisionHeight=50.617947
}
