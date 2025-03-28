//=============================================================================
// WBJustin
//=============================================================================
class WBJustin expands MaleWarBot;

function ForceMeshToExist()
{
    spawn( class'NerfKids.Justin' );
}

function PreBeginPlay()
{
    Super.PreBeginPlay();
    PlayerReplicationInfo.TeamType=TEAM_Tycoons;
    PlayerReplicationInfo.BotIndex=AKA_Justin;
}


function Texture Face()
{
	return Texture'NerfKids.SkinIcons.I_Justin';
}

defaultproperties
{
     FavoriteWeapon=Class'NerfWeapon.Hyperst'
     Accuracy=0.500000
     CampingRate=0.700000
     Alertness=0.500000
     BaseEyeHeight=34.957966
     EyeHeight=34.957966
     Skin=Texture'NerfKids.Skins.Justin'
     Mesh=LodMesh'NerfKids.M_Regular'
     CollisionRadius=25.000000
     CollisionHeight=43.697456
}
