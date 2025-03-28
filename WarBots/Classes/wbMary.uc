//=============================================================================
// WBMary
//=============================================================================
class WBMary expands FemaleWarBot;

function ForceMeshToExist()
{
    spawn( class'NerfKids.Mary' );
}

function PreBeginPlay()
{
    Super.PreBeginPlay();
    PlayerReplicationInfo.TeamType=TEAM_Orbiteers;
    PlayerReplicationInfo.BotIndex=AKA_Mary;
}

function Texture Face()
{
	return Texture'NerfKids.SkinIcons.I_Mary';
}

defaultproperties
{
     FavoriteWeapon=Class'NerfWeapon.TripleShot'
     Accuracy=0.300000
     bIsFemale=True
     Alertness=0.500000
     BaseEyeHeight=42.686970
     EyeHeight=42.686970
     Skin=Texture'NerfKids.Skins.Mary'
     Mesh=LodMesh'NerfKids.F_Tall'
     CollisionRadius=25.000000
     CollisionHeight=53.358711
}
