//=============================================================================
// ElectroPak - Recharges Whomper
//=============================================================================
class ElectroPak extends Ammo;

#exec MESH IMPORT MESH=ElectroPak ANIVFILE=g:\NerfRes\nerfmesh\MODELS\weaponShieldEnergyCell_a.3d DATAFILE=g:\NerfRes\nerfmesh\MODELS\weaponShieldEnergyCell_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=ElectroPak X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=ElectroPak SEQ=All                      STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=ElectroPak MESH=ElectroPak
#exec MESHMAP SCALE MESHMAP=ElectroPak X=0.05 Y=0.05 Z=0.1

#exec TEXTURE IMPORT NAME=weaponShieldEnergyCell_01 FILE=g:\NerfRes\nerfmesh\Models\weaponShieldEnergyCell_01.PCX GROUP=Skins FLAGS=2	//Material #11

#exec MESHMAP SETTEXTURE MESHMAP=ElectroPak NUM=1 TEXTURE=weaponShieldEnergyCell_01

// Audio sound effects
// ##nerf WES Sounds
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\pickups\pkepak.wav" NAME="EpakpickS" GROUP="Pickups"

function PostBeginPlay()
{
	PickupViewMesh=Mesh(DynamicLoadObject("NerfI.ElectroPak", class'Mesh'));
	Super.PostBeginPlay();
}

defaultproperties
{
     AmmoAmount=1
     MaxAmmo=5
     UsedInWeaponSlot(10)=1
     bRotatingPickup=True
     PickupMessage=You got a Whomper Battery
     MaxDesireability=1.800000
     PickupSound=Sound'NerfI.Pickups.EpakpickS'
     RemoteRole=ROLE_DumbProxy
     Mesh=LodMesh'NerfI.ElectroPak'
     AmbientGlow=64
     CollisionRadius=32.000000
     CollisionHeight=28.000000
     bCollideActors=True
}
