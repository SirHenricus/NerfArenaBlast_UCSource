//=============================================================================
// WBRabbit
//=============================================================================
class WBRabbit expands MaleWarBot;

function ForceMeshToExist()
{
    spawn( class'NerfKids.Rabbit' );
}

function PreBeginPlay()
{
    Super.PreBeginPlay();
    PlayerReplicationInfo.TeamType=TEAM_Tribe;
    PlayerReplicationInfo.BotIndex=AKA_Rabbit;
}

function Texture Face()
{
	return Texture'NerfKids.SkinIcons.I_Rabbit';
}

defaultproperties
{
     FavoriteWeapon=Class'NerfWeapon.Pulsator'
     Accuracy=0.600000
     CampingRate=0.200000
     Alertness=0.600000
     BaseEyeHeight=31.677443
     EyeHeight=31.677443
     CombatStyle=0.200000
     Skin=Texture'NerfKids.Skins.Rabbit'
     Mesh=LodMesh'NerfKids.M_Fireplug_T'
     CollisionRadius=25.000000
     CollisionHeight=39.400002
}
