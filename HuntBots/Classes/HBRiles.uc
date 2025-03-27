//=============================================================================
// HBRiles
//=============================================================================
class HBRiles expands MaleHuntBot;

function ForceMeshToExist()
{
    spawn( class'NerfKids.Riles' );
}

function PreBeginPlay()
{
    Super.PreBeginPlay();
    PlayerReplicationInfo.TeamType=TEAM_Rockheads;
    PlayerReplicationInfo.BotIndex=AKA_Riles;

}


function Texture Face()
{
	return Texture'NerfKids.SkinIcons.I_Riles';
}

defaultproperties
{
     FavoriteWeapon=Class'NerfWeapon.Sidewind'
     Accuracy=0.500000
     CampingRate=0.200000
     Alertness=0.500000
     BaseEyeHeight=40.024925
     EyeHeight=40.024925
     CombatStyle=0.300000
     Skin=Texture'NerfKids.Skins.Riles'
     Mesh=LodMesh'NerfKids.M_Sport'
     CollisionRadius=25.000000
     CollisionHeight=47.754002
}
