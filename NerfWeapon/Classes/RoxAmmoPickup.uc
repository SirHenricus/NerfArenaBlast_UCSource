//=============================================================================
// RoxAmmoPickup.
//=============================================================================
class RoxAmmoPickup expands Ammo;

#exec MESH IMPORT MESH=tripleStrike ANIVFILE=g:\NerfRes\weaponMesh\MODELS\tripleStrike_a.3d DATAFILE=g:\NerfRes\weaponMesh\MODELS\tripleStrike_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=tripleStrike X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=tripleStrike SEQ=All                      STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=tripleStrike MESH=tripleStrike
#exec MESHMAP SCALE MESHMAP=tripleStrike X=0.05 Y=0.05 Z=0.1

#exec TEXTURE IMPORT NAME=JtripleStrike_01 FILE=g:\NerfRes\weaponMesh\MODELS\tripleStrike_01.PCX GROUP=Skins FLAGS=2	//Material #9
#exec TEXTURE IMPORT NAME=JtripleStrike_02 FILE=g:\NerfRes\weaponMesh\MODELS\tripleStrike_02.PCX GROUP=Skins FLAGS=2	//Material #5
#exec TEXTURE IMPORT NAME=JtripleStrike_03 FILE=g:\NerfRes\weaponMesh\MODELS\tripleStrike_03.PCX GROUP=Skins FLAGS=2	//Material #4

#exec MESHMAP SETTEXTURE MESHMAP=tripleStrike NUM=1 TEXTURE=JtripleStrike_01
#exec MESHMAP SETTEXTURE MESHMAP=tripleStrike NUM=2 TEXTURE=JtripleStrike_02
#exec MESHMAP SETTEXTURE MESHMAP=tripleStrike NUM=3 TEXTURE=JtripleStrike_03

#exec TEXTURE IMPORT NAME=I_Rox FILE=g:\NerfRes\weaponMesh\TEXTURES\HUD\rocket.PCX GROUP="Icons" MIPS=OFF

// Audio sound effects
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\pickups\pkamtrip.wav" NAME="RoxpickS" GROUP="Pickups"

defaultproperties
{
     AmmoAmount=9
     MaxAmmo=30
     UsedInWeaponSlot(7)=1
     UsedInWeaponSlot(8)=1
     PickupMessage=You picked up 9 Rockets
     PickupViewMesh=LodMesh'NerfWeapon.tripleStrike'
     MaxDesireability=1.000000
     PickupSound=Sound'NerfWeapon.Pickups.RoxpickS'
     Icon=Texture'NerfWeapon.Icons.I_Rox'
     Mesh=LodMesh'NerfWeapon.tripleStrike'
     CollisionRadius=22.000000
     CollisionHeight=20.000000
     bCollideActors=True
}
