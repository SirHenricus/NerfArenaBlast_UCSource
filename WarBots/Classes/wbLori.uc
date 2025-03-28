//=============================================================================
// WBLori
//=============================================================================
class WBLori expands FemaleWarBot;

function ForceMeshToExist()
{
    spawn( class'NerfKids.Lori' );
}

function PreBeginPlay()
{
    Super.PreBeginPlay();
    PlayerReplicationInfo.TeamType=TEAM_Baracudas;
    PlayerReplicationInfo.BotIndex=AKA_Lori;
}

function Texture Face()
{
	return Texture'NerfKids.SkinIcons.I_Lori';
}

defaultproperties
{
     FavoriteWeapon=Class'NerfWeapon.TripleShot'
     Accuracy=0.700000
     CampingRate=0.200000
     bIsFemale=True
     Alertness=0.400000
     BaseEyeHeight=34.299393
     EyeHeight=34.299393
     CombatStyle=0.300000
     Skin=Texture'NerfKids.Skins.Lori'
     Mesh=LodMesh'NerfKids.F_Small_L'
     CollisionRadius=25.000000
     CollisionHeight=42.754242
}
