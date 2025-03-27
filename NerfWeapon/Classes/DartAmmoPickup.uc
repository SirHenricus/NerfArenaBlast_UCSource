//=============================================================================
// DartAmmoPickup.
//=============================================================================
class DartAmmoPickup expands Ammo;

#exec TEXTURE IMPORT NAME=I_DartAmmo FILE=g:\NerfRes\weaponMesh\TEXTURES\HUD\Darts.PCX GROUP="Icons" MIPS=OFF

#exec MESH IMPORT MESH=DartAmmoPickup ANIVFILE=g:\NerfRes\weaponMesh\MODELS\DartAmmoPickup_a.3d DATAFILE=g:\NerfRes\weaponMesh\MODELS\DartAmmoPickup_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=DartAmmoPickup X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=DartAmmoPickup SEQ=All            STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=DartAmmoPickup SEQ=DartAmmoPickup STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JDartAmmoPickup1 FILE=g:\NerfRes\weaponMesh\MODELS\DartAmmoPickup1.PCX GROUP=Skins FLAGS=2 // Masked
#exec TEXTURE IMPORT NAME=JDartAmmoPickup2 FILE=g:\NerfRes\weaponMesh\MODELS\DartAmmoPickup2.PCX GROUP=Skins PALETTE=JDartAmmoPickup1 // Material #26

#exec MESHMAP NEW   MESHMAP=DartAmmoPickup MESH=DartAmmoPickup
#exec MESHMAP SCALE MESHMAP=DartAmmoPickup X=0.01 Y=0.01 Z=0.08

#exec MESHMAP SETTEXTURE MESHMAP=DartAmmoPickup NUM=1 TEXTURE=JDartAmmoPickup1
#exec MESHMAP SETTEXTURE MESHMAP=DartAmmoPickup NUM=2 TEXTURE=JDartAmmoPickup2

// Audio sound effects
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\pickups\pkamrack.wav" NAME="DartpickS" GROUP="Pickups"

defaultproperties
{
     AmmoAmount=20
     MaxAmmo=50
     UsedInWeaponSlot(3)=1
     PickupMessage=You picked up 20 Darts
     PickupViewMesh=LodMesh'NerfWeapon.DartAmmoPickup'
     MaxDesireability=1.000000
     PickupSound=Sound'NerfWeapon.Pickups.DartpickS'
     Icon=Texture'NerfWeapon.Icons.I_DartAmmo'
     Mesh=LodMesh'NerfWeapon.DartAmmoPickup'
     CollisionRadius=22.000000
     CollisionHeight=7.000000
     bCollideActors=True
}
