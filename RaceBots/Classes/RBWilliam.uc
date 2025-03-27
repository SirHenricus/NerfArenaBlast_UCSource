//=============================================================================
// RBWilliam
//=============================================================================
class RBWilliam expands MaleRaceBot;

function ForceMeshToExist()
{
    spawn( class'NerfKids.William' );
}

function PreBeginPlay()
{
    Super.PreBeginPlay();
    PlayerReplicationInfo.TeamType=TEAM_Tycoons;
    PlayerReplicationInfo.BotIndex=AKA_William;

}


function Texture Face()
{
	return Texture'NerfKids.SkinIcons.I_William';
}

defaultproperties
{
     FavoriteWeapon=Class'NerfWeapon.Scatter'
     Accuracy=0.500000
     Alertness=0.300000
     BaseEyeHeight=40.024925
     EyeHeight=40.024925
     CombatStyle=0.500000
     Skin=Texture'NerfKids.Skins.William'
     Mesh=LodMesh'NerfKids.M_Sport'
     CollisionRadius=25.000000
     CollisionHeight=47.754002
}
