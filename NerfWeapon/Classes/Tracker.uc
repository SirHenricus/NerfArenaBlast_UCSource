//=============================================================================
// Tracker.
//=============================================================================
class Tracker expands Ammo;

#exec MESH IMPORT MESH=sidewinderammo ANIVFILE=g:\NerfRes\weaponMesh\MODELS\sidewinderammo_a.3d DATAFILE=g:\NerfRes\weaponMesh\MODELS\sidewinderammo_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=sidewinderammo X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=sidewinderammo SEQ=All                      STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=sidewinderammo MESH=sidewinderammo
#exec MESHMAP SCALE MESHMAP=sidewinderammo X=0.03 Y=0.03 Z=0.06

#exec TEXTURE IMPORT NAME=Jsidewinderammo_01 FILE=g:\NerfRes\weaponMesh\MODELS\sidewinderammo_01.PCX GROUP=Skins FLAGS=2	//Material #2
#exec TEXTURE IMPORT NAME=Jsidewinderammo_02 FILE=g:\NerfRes\weaponMesh\MODELS\sidewinderammo_02.PCX GROUP=Skins FLAGS=2	//Material #1
#exec TEXTURE IMPORT NAME=Jsidewinderammo_03 FILE=g:\NerfRes\weaponMesh\MODELS\sidewinderammo_03.PCX GROUP=Skins FLAGS=2	//Material #3

#exec MESHMAP SETTEXTURE MESHMAP=sidewinderammo NUM=1 TEXTURE=Jsidewinderammo_01
#exec MESHMAP SETTEXTURE MESHMAP=sidewinderammo NUM=2 TEXTURE=Jsidewinderammo_02
#exec MESHMAP SETTEXTURE MESHMAP=sidewinderammo NUM=3 TEXTURE=Jsidewinderammo_03

#exec TEXTURE IMPORT NAME=I_Disks FILE=g:\NerfRes\weaponMesh\TEXTURES\HUD\Disks.PCX GROUP="Icons" MIPS=OFF

// Audio sound effects
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\pickups\pkamsdwr.wav" NAME="SideAmpickS" GROUP="Pickups"

defaultproperties
{
     AmmoAmount=10
     MaxAmmo=30
     UsedInWeaponSlot(9)=1
     PickupMessage=You picked up 10 Sidewinder Ammo
     PickupViewMesh=LodMesh'NerfWeapon.sidewinderammo'
     MaxDesireability=1.000000
     PickupSound=Sound'NerfWeapon.Pickups.SideAmpickS'
     Icon=Texture'NerfWeapon.Icons.I_Disks'
     Mesh=LodMesh'NerfWeapon.sidewinderammo'
     CollisionRadius=16.000000
     CollisionHeight=10.000000
     bCollideActors=True
}
