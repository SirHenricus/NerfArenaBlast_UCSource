//=============================================================================
// HBVince
//=============================================================================
class HBVince expands MaleHuntBot;

function ForceMeshToExist()
{
    spawn( class'NerfKids.Vince' );
}

function PreBeginPlay()
{
    Super.PreBeginPlay();
    PlayerReplicationInfo.TeamType=TEAM_Gators;
    PlayerReplicationInfo.BotIndex=AKA_Vince;
}

function Texture Face()
{
	return Texture'NerfKids.SkinIcons.I_Vince';
}

defaultproperties
{
     FavoriteWeapon=Class'NerfWeapon.TripleShot'
     Accuracy=0.600000
     CampingRate=0.300000
     Alertness=0.300000
     BaseEyeHeight=34.957966
     EyeHeight=34.957966
     CombatStyle=0.300000
     Skin=Texture'NerfKids.Skins.Vince'
     Mesh=LodMesh'NerfKids.M_Regular'
     CollisionRadius=25.000000
     CollisionHeight=43.697456
}
