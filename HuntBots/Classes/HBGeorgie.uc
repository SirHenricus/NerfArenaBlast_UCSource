//=============================================================================
// HBGeorgie
//=============================================================================
class HBGeorgie expands FemaleHuntBot;

function ForceMeshToExist()
{
    spawn( class'NerfKids.Georgie' );
}

function PreBeginPlay()
{
    Super.PreBeginPlay();
    PlayerReplicationInfo.TeamType=TEAM_Orbiteers;
    PlayerReplicationInfo.BotIndex=AKA_Georgie;
}

function Texture Face()
{
	return Texture'NerfKids.SkinIcons.I_Georgie';
}

defaultproperties
{
     FavoriteWeapon=Class'NerfWeapon.Sidewind'
     Accuracy=0.600000
     CampingRate=0.200000
     bIsFemale=True
     Alertness=0.300000
     BaseEyeHeight=37.667934
     EyeHeight=37.667934
     CombatStyle=0.300000
     Skin=Texture'NerfKids.Skins.Georgie'
     Mesh=LodMesh'NerfKids.F_Sport'
     CollisionRadius=25.000000
     CollisionHeight=47.084915
}
