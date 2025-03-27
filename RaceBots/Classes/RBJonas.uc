//=============================================================================
// RBJonas
//=============================================================================
class RBJonas expands MaleRaceBot;

function ForceMeshToExist()
{
    spawn( class'NerfKids.Jonas' );
}

function PreBeginPlay()
{
    Super.PreBeginPlay();
    PlayerReplicationInfo.TeamType=TEAM_Baracudas;
    PlayerReplicationInfo.BotIndex=AKA_Jonas;
}

function Texture Face()
{
	return Texture'NerfKids.SkinIcons.I_Jonas';
}

defaultproperties
{
     FavoriteWeapon=Class'NerfWeapon.Turbofir'
     Accuracy=0.600000
     Alertness=0.500000
     BaseEyeHeight=31.524525
     EyeHeight=31.524525
     Skill=1.000000
     CombatStyle=0.500000
     Skin=Texture'NerfKids.Skins.Jonas'
     Mesh=LodMesh'NerfKids.M_Fireplug'
     CollisionRadius=25.000000
     CollisionHeight=39.405655
}
