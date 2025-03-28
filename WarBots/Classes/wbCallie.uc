//=============================================================================
// WBCallie
//=============================================================================
class WBCallie expands FemaleWarBot;

function ForceMeshToExist()
{
    spawn( class'NerfKids.Callie' );
}

function PreBeginPlay()
{
    Super.PreBeginPlay();
    PlayerReplicationInfo.TeamType=TEAM_Lunas;
    PlayerReplicationInfo.BotIndex=AKA_Callie;
}

function Texture Face()
{
	return Texture'NerfKids.SkinIcons.I_Callie';
}

defaultproperties
{
     FavoriteWeapon=Class'NerfWeapon.Scatter'
     Accuracy=0.600000
     CampingRate=0.200000
     bIsFemale=True
     Alertness=0.400000
     BaseEyeHeight=30.381954
     EyeHeight=30.381954
     CombatStyle=0.100000
     Skin=Texture'NerfKids.Skins.Callie'
     Mesh=LodMesh'NerfKids.F_Gymnast'
     CollisionRadius=22.000000
     CollisionHeight=37.774647
}
