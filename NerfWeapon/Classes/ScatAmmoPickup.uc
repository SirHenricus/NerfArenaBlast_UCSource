//=============================================================================
// ScatAmmoPickup.
//=============================================================================
class ScatAmmoPickup expands Ammo;

#exec TEXTURE IMPORT NAME=I_ScatAmmo FILE=g:\NerfRes\weaponMesh\TEXTURES\HUD\i_scat.PCX GROUP="Icons" MIPS=OFF

#exec MESH IMPORT MESH=ScatAmmoPickup ANIVFILE=g:\NerfRes\weaponMesh\MODELS\scatter_shot_ammo_pu_a.3d DATAFILE=g:\NerfRes\weaponMesh\MODELS\scatter_shot_ammo_pu_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=ScatAmmoPickup X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=ScatAmmoPickup SEQ=All                      STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=ScatAmmoPickup MESH=scatter_shot_ammo_pu
#exec MESHMAP SCALE MESHMAP=ScatAmmoPickup X=0.05 Y=0.05 Z=0.1

#exec MESHMAP SETTEXTURE MESHMAP=ScatAmmoPickup NUM=1 TEXTURE=scatter_shot_pu_01
#exec MESHMAP SETTEXTURE MESHMAP=ScatAmmoPickup NUM=2 TEXTURE=scatter_shot_04
#exec MESHMAP SETTEXTURE MESHMAP=ScatAmmoPickup NUM=3 TEXTURE=scatter_shot_05

/*
#exec MESH IMPORT MESH=ScatAmmoPickup ANIVFILE=g:\NerfRes\weaponMesh\MODELS\scatpick_a.3d DATAFILE=g:\NerfRes\weaponMesh\MODELS\scatpick_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=ScatAmmoPickup X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=ScatAmmoPickup SEQ=All            STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=ScatAmmoPickup SEQ=ScatAmmoPickup STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JScatAmmoPickup1 FILE=g:\NerfRes\weaponMesh\MODELS\Scatpick_01.PCX GROUP=Skins FLAGS=2 // Masked

#exec MESHMAP NEW   MESHMAP=ScatAmmoPickup MESH=ScatAmmoPickup
#exec MESHMAP SCALE MESHMAP=ScatAmmoPickup X=0.04 Y=0.04 Z=0.08

#exec MESHMAP SETTEXTURE MESHMAP=ScatAmmoPickup NUM=1 TEXTURE=JScatAmmoPickup1
*/

// Audio sound effects
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\pickups\pkamscat.wav" NAME="ScatAmpickS" GROUP="Pickups"

defaultproperties
{
     AmmoAmount=10
     MaxAmmo=30
     UsedInWeaponSlot(4)=1
     PickupMessage=You picked up 10 Scatter Pellets
     PickupViewMesh=LodMesh'NerfWeapon.ScatAmmoPickup'
     MaxDesireability=1.000000
     PickupSound=Sound'NerfWeapon.Pickups.ScatAmpickS'
     Icon=Texture'NerfWeapon.Icons.I_ScatAmmo'
     Mesh=LodMesh'NerfWeapon.ScatAmmoPickup'
     CollisionRadius=20.000000
     CollisionHeight=25.000000
     bCollideActors=True
}
