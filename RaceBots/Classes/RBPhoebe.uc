//=============================================================================
// RBPhoebe
//=============================================================================
class RBPhoebe expands FemaleRaceBot;

function ForceMeshToExist()
{
    spawn( class'NerfKids.Phoebe' );
}

function PreBeginPlay()
{
    Super.PreBeginPlay();
    PlayerReplicationInfo.TeamType=TEAM_Lunas;
    PlayerReplicationInfo.BotIndex=AKA_Phoebe;
}

function Texture Face()
{
	return Texture'NerfKids.SkinIcons.I_Phoebe';
}

defaultproperties
{
     FavoriteWeapon=Class'NerfWeapon.MightyMo'
     Accuracy=0.600000
     bIsFemale=True
     Alertness=0.300000
     BaseEyeHeight=34.734219
     EyeHeight=34.734219
     Skill=1.000000
     CombatStyle=0.500000
     Skin=Texture'NerfKids.Skins.Phoebe'
     Mesh=LodMesh'NerfKids.F_Regular_T'
     CollisionRadius=25.000000
     CollisionHeight=43.418999
}
