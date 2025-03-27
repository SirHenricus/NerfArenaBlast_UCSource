//=============================================================================
// BallAmmo.
//=============================================================================
class BallAmmo expands Ammo;

#exec MESH IMPORT MESH=ballzookaAmmo ANIVFILE=g:\NerfRes\WeaponMesh\MODELS\ballzookaAmmo_a.3d DATAFILE=g:\NerfRes\WeaponMesh\MODELS\ballzookaAmmo_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=ballzookaAmmo X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=ballzookaAmmo SEQ=All                      STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=ballzookaAmmo MESH=ballzookaAmmo
#exec MESHMAP SCALE MESHMAP=ballzookaAmmo X=0.04 Y=0.04 Z=0.08

#exec TEXTURE IMPORT NAME=JballzookaAmmo_01 FILE=g:\NerfRes\WeaponMesh\MODELS\ballzookaAmmo_01.PCX GROUP=Skins FLAGS=2	//Material #4
// DSL - these two are never seen
//#exec TEXTURE IMPORT NAME=JballzookaAmmo_02 FILE=g:\NerfRes\WeaponMesh\MODELS\ballzookaAmmo_02.PCX GROUP=Skins FLAGS=2	//Material #8
//#exec TEXTURE IMPORT NAME=JballzookaAmmo_03 FILE=g:\NerfRes\WeaponMesh\MODELS\ballzookaAmmo_03.PCX GROUP=Skins FLAGS=2	//Material #7

#exec MESHMAP SETTEXTURE MESHMAP=ballzookaAmmo NUM=1 TEXTURE=JballzookaAmmo_01
// DSL - these two are never seen ( and NUMs 2 & 3 don't exist )
//#exec MESHMAP SETTEXTURE MESHMAP=ballzookaAmmo NUM=2 TEXTURE=JballzookaAmmo_02
//#exec MESHMAP SETTEXTURE MESHMAP=ballzookaAmmo NUM=3 TEXTURE=JballzookaAmmo_03

#exec TEXTURE IMPORT NAME=I_BallAmmo FILE=g:\NerfRes\weaponMesh\TEXTURES\HUD\balls.PCX GROUP="Icons" MIPS=OFF

// Audio sound effects
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\pickups\pkamzook.wav" NAME="BallpickS" GROUP="Pickups"

defaultproperties
{
     AmmoAmount=15
     MaxAmmo=60
     UsedInWeaponSlot(2)=1
     UsedInWeaponSlot(6)=1
     PickupMessage=You picked up Ball Ammo Pack
     PlayerViewMesh=LodMesh'NerfWeapon.ballzookaAmmo'
     PickupViewMesh=LodMesh'NerfWeapon.ballzookaAmmo'
     MaxDesireability=1.000000
     PickupSound=Sound'NerfWeapon.Pickups.BallpickS'
     Icon=Texture'NerfWeapon.Icons.I_BallAmmo'
     Mesh=LodMesh'NerfWeapon.ballzookaAmmo'
     CollisionRadius=16.000000
     CollisionHeight=10.000000
     bCollideActors=True
}
