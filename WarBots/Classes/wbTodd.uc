//=============================================================================
// WBTodd
//=============================================================================
class WBTodd expands MaleWarBot;

function ForceMeshToExist()
{
    spawn( class'NerfKids.Todd' );
}

function PreBeginPlay()
{
    Super.PreBeginPlay();
    PlayerReplicationInfo.TeamType=TEAM_Tycoons;
    PlayerReplicationInfo.BotIndex=AKA_Todd;
}

function Texture Face()
{
	return Texture'NerfKids.SkinIcons.I_Todd';
}

defaultproperties
{
     FavoriteWeapon=Class'NerfWeapon.MightyMo'
     Accuracy=0.600000
     CampingRate=0.300000
     BaseEyeHeight=33.528698
     EyeHeight=33.528698
     Mesh=LodMesh'NerfKids.M_Small'
     CollisionRadius=25.000000
     CollisionHeight=41.910873
}
