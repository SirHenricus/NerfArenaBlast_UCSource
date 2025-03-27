//=============================================================================
// MMBallPick.
//=============================================================================
class MMBallPick expands Ammo;

#exec MESH IMPORT MESH=mightybal ANIVFILE=g:\NerfRes\weaponMesh\MODELS\mightybal_a.3d DATAFILE=g:\NerfRes\weaponMesh\MODELS\mightybal_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=mightybal X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=mightybal SEQ=All                      STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=mightybal SEQ=mightybal                STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=mightybal MESH=mightybal
#exec MESHMAP SCALE MESHMAP=mightybal X=0.035 Y=0.035 Z=0.07

#exec TEXTURE IMPORT NAME=MMBall FILE=g:\NerfRes\weaponMesh\MODELS\mightybal_01.PCX GROUP=Skins FLAGS=2	//scatpick

#exec MESHMAP SETTEXTURE MESHMAP=mightybal NUM=0 TEXTURE=DefaultTexture

#exec TEXTURE IMPORT NAME=I_MMAmmo FILE=g:\NerfRes\weaponMesh\TEXTURES\HUD\i_mm.PCX GROUP="Icons" MIPS=OFF

// Audio sound effects
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\pickups\pkammo.wav" NAME="MMBallpickS" GROUP="Pickups"

defaultproperties
{
     AmmoAmount=5
     MaxAmmo=15
     UsedInWeaponSlot(5)=1
     PickupMessage=You picked up 5 NerfCannon Ball Ammo.
     PlayerViewMesh=LodMesh'NerfWeapon.mightybal'
     PickupViewMesh=LodMesh'NerfWeapon.mightybal'
     MaxDesireability=1.000000
     PickupSound=Sound'NerfWeapon.Pickups.MMBallpickS'
     Icon=Texture'NerfWeapon.Icons.I_MMAmmo'
     Skin=Texture'NerfWeapon.Skins.MMBall'
     Mesh=LodMesh'NerfWeapon.mightybal'
     CollisionRadius=16.000000
     CollisionHeight=16.000000
     bCollideActors=True
}
