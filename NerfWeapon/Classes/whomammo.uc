//=============================================================================
// WhomAmmo.
//=============================================================================
class WhomAmmo expands Ammo;

//##nerf WES Textures FIXME
//Need Mesh and sound

#exec MESH IMPORT MESH=WhomAmmo ANIVFILE=g:\NerfRes\weaponMesh\MODELS\tri_sprj_a.3d DATAFILE=g:\NerfRes\weaponMesh\MODELS\tri_sprj_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=WhomAmmo X=0 Y=0 Z=0 ROLL=-64

#exec MESH SEQUENCE MESH=WhomAmmo SEQ=All                      STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=WhomAmmo MESH=WhomAmmo
#exec MESHMAP SCALE MESHMAP=WhomAmmo X=0.05 Y=0.025 Z=0.1

#exec TEXTURE IMPORT NAME=Jwhom_01 FILE=g:\NerfRes\weaponMesh\Models\whomam.PCX GROUP=Skins FLAGS=2	//Material #5

#exec MESHMAP SETTEXTURE MESHMAP=WhomAmmo NUM=0 TEXTURE=DefaultTexture

defaultproperties
{
     AmmoAmount=50
     MaxAmmo=250
     UsedInWeaponSlot(10)=1
     PickupMessage=You picked up 50 Whomper Ammo
     PickupViewMesh=LodMesh'NerfWeapon.whomammo'
     MaxDesireability=1.000000
     Skin=Texture'NerfWeapon.Skins.Jwhom_01'
     Mesh=LodMesh'NerfWeapon.whomammo'
     CollisionRadius=22.000000
     CollisionHeight=22.000000
     bCollideActors=True
}
