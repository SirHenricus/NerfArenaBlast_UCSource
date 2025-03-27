//=============================================================================
// RBSarge
//=============================================================================
class RBSarge expands FemaleRaceBot;

function ForceMeshToExist()
{
    spawn( class'NerfKids.Sarge' );
}

function PreBeginPlay()
{
    Super.PreBeginPlay();
    PlayerReplicationInfo.TeamType=TEAM_Twisters;
    PlayerReplicationInfo.BotIndex=AKA_Sarge;
}

function Texture Face()
{
	return Texture'NerfKids.SkinIcons.I_Sarge';
}

defaultproperties
{
     FavoriteWeapon=Class'NerfWeapon.Pulsator'
     Accuracy=0.700000
     CampingRate=0.500000
     bIsFemale=True
     BaseEyeHeight=34.735603
     EyeHeight=34.735603
     CombatStyle=0.200000
     Skin=Texture'NerfKids.Skins.Sarge'
     Mesh=LodMesh'NerfKids.F_Regular'
     CollisionRadius=25.000000
     CollisionHeight=43.419506
}
