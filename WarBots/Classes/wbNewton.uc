//=============================================================================
// WBNewton
//=============================================================================
class WBNewton expands MaleWarBot;

function ForceMeshToExist()
{
    spawn( class'NerfKids.Newton' );
}

function PreBeginPlay()
{
    Super.PreBeginPlay();
    PlayerReplicationInfo.TeamType=TEAM_Orbiteers;
    PlayerReplicationInfo.BotIndex=AKA_Newton;
}

function Texture Face()
{
	return Texture'NerfKids.SkinIcons.I_Newton';
}

defaultproperties
{
     FavoriteWeapon=Class'NerfWeapon.Scatter'
     Accuracy=0.600000
     CampingRate=0.200000
     Alertness=0.500000
     BaseEyeHeight=41.080006
     EyeHeight=41.080006
     Skill=1.000000
     CombatStyle=0.400000
     Skin=Texture'NerfKids.Skins.Newton'
     Mesh=LodMesh'NerfKids.M_Tall'
     CollisionRadius=25.000000
     CollisionHeight=51.612370
}
