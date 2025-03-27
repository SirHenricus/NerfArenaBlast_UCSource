//=============================================================================
// RBSam
//=============================================================================
class RBSam expands MaleRaceBot;

function ForceMeshToExist()
{
    spawn( class'NerfKids.Sam' );
}

function PreBeginPlay()
{
    Super.PreBeginPlay();
    PlayerReplicationInfo.TeamType=TEAM_Rockheads;
    PlayerReplicationInfo.BotIndex=AKA_Sam;
}


function Texture Face()
{
	return Texture'NerfKids.SkinIcons.I_Sam';
}

defaultproperties
{
     FavoriteWeapon=Class'NerfWeapon.Pulsator'
     Accuracy=0.600000
     CampingRate=0.400000
     Alertness=0.300000
     BaseEyeHeight=31.524525
     EyeHeight=31.524525
     CombatStyle=0.100000
     Skin=Texture'NerfKids.Skins.Sam'
     Mesh=LodMesh'NerfKids.M_Fireplug'
     CollisionRadius=25.000000
     CollisionHeight=39.405655
}
