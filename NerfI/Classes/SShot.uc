//=============================================================================
// SShot.
//=============================================================================
class SShot expands NerfWeapon;

// pickup version

#exec MESH IMPORT MESH=SShotpick ANIVFILE=g:\NerfRes\weaponMesh\MODELS\secret_shot_pu_a.3d DATAFILE=g:\NerfRes\weaponMesh\MODELS\secret_shot_pu_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=SShotpick X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=SShotpick SEQ=All                      STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=SShotpick SEQ=still                      STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=SShotpick MESH=SShotpick
#exec MESHMAP SCALE MESHMAP=SShotpick X=0.05 Y=0.05 Z=0.1

//#exec TEXTURE IMPORT NAME=secret_shot_pu_01 FILE=g:\NerfRes\weaponMesh\Textures\secret_shot_pu_01.PCX GROUP=Skins FLAGS=2	//secretshotbody01
#exec TEXTURE IMPORT NAME=secret_shot_pu_01 FILE=G:\NerfRes\WeaponAnimation\Textures\secret_shot_03.PCX GROUP=Skins Mips=Off FLAGS=2	//secretshotbody01

#exec MESHMAP SETTEXTURE MESHMAP=SShotpick NUM=1 TEXTURE=secret_shot_pu_01

// 3rd person perspective version 

#exec MESH IMPORT MESH=SShot3rd ANIVFILE=g:\NerfRes\weaponMesh\MODELS\secretshot_a.3d DATAFILE=g:\NerfRes\weaponMesh\MODELS\secretshot_d.3d X=0 Y=0 Z=0 LODSTYLE=8
#exec MESH ORIGIN MESH=SShot3rd X=-525 Y=0 Z=0 PITCH=30

#exec MESH SEQUENCE MESH=SShot3rd SEQ=All                      STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=SShot3rd MESH=SShot3rd
#exec MESHMAP SCALE MESHMAP=SShot3rd X=0.02 Y=0.02 Z=0.04

#exec TEXTURE IMPORT NAME=Jsecretshot_01 FILE=g:\NerfRes\weaponMesh\MODELS\secretshot_01.PCX GROUP=Skins FLAGS=2	//Sercetshot_01.tga

#exec MESHMAP SETTEXTURE MESHMAP=SShot3rd NUM=1 TEXTURE=Jsecretshot_01

//  player view version

// Right Handed

#exec MESH IMPORT MESH=SShotR ANIVFILE=G:\NerfRes\WeaponAnimation\MODELS\secret_shot_a.3d DATAFILE=G:\NerfRes\WeaponAnimation\MODELS\secret_shot_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=SShotR X=0 Y=100 Z=-175 YAW=128 ROLL=2

#exec MESH SEQUENCE MESH=SShotR SEQ=All                      STARTFRAME=0 NUMFRAMES=95
#exec MESH SEQUENCE MESH=SShotR SEQ=select                   STARTFRAME=0 NUMFRAMES=21
#exec MESH SEQUENCE MESH=SShotR SEQ=idle                     STARTFRAME=21 NUMFRAMES=21 RATE=15
#exec MESH SEQUENCE MESH=SShotR SEQ=fire                     STARTFRAME=42 NUMFRAMES=7
#exec MESH SEQUENCE MESH=SShotR SEQ=alt_fire_open            STARTFRAME=49 NUMFRAMES=5 
#exec MESH SEQUENCE MESH=SShotR SEQ=alt_fire                 STARTFRAME=54 NUMFRAMES=7 
#exec MESH SEQUENCE MESH=SShotR SEQ=alt_fire_close           STARTFRAME=61 NUMFRAMES=9 
#exec MESH SEQUENCE MESH=SShotR SEQ=down                     STARTFRAME=70 NUMFRAMES=25
#exec MESH SEQUENCE MESH=SShotR SEQ=still                    STARTFRAME=20 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=SShotR MESH=SShotR
#exec MESHMAP SCALE MESHMAP=SShotR X=0.04 Y=0.04 Z=0.08

#exec MESHMAP SETTEXTURE MESHMAP=SShotR NUM=1 TEXTURE=NerfRes.Skins.Hand_back
#exec MESHMAP SETTEXTURE MESHMAP=SShotR NUM=2 TEXTURE=NerfRes.Skins.Hand_in
#exec MESHMAP SETTEXTURE MESHMAP=SShotR NUM=3 TEXTURE=secret_shot_pu_01

// left handed player view version

#exec MESH IMPORT MESH=SShotL ANIVFILE=G:\NerfRes\WeaponAnimation\MODELS\secret_shot_a.3d DATAFILE=G:\NerfRes\WeaponAnimation\MODELS\secret_shot_d.3d unmirror=1
#exec MESH ORIGIN MESH=SShotL X=0 Y=100 Z=-175 ROLL=2

#exec MESH SEQUENCE MESH=SShotL SEQ=All                      STARTFRAME=0 NUMFRAMES=95
#exec MESH SEQUENCE MESH=SShotL SEQ=select                   STARTFRAME=0 NUMFRAMES=21
#exec MESH SEQUENCE MESH=SShotL SEQ=idle                     STARTFRAME=21 NUMFRAMES=21  RATE=15
#exec MESH SEQUENCE MESH=SShotL SEQ=fire                     STARTFRAME=42 NUMFRAMES=7
#exec MESH SEQUENCE MESH=SShotL SEQ=alt_fire_open            STARTFRAME=49 NUMFRAMES=5 
#exec MESH SEQUENCE MESH=SShotL SEQ=alt_fire                 STARTFRAME=54 NUMFRAMES=7 
#exec MESH SEQUENCE MESH=SShotL SEQ=alt_fire_close           STARTFRAME=61 NUMFRAMES=9 
#exec MESH SEQUENCE MESH=SShotL SEQ=down                     STARTFRAME=70 NUMFRAMES=25
#exec MESH SEQUENCE MESH=SShotL SEQ=still                    STARTFRAME=20 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=SShotL MESH=SShotL
#exec MESHMAP SCALE MESHMAP=SShotL X=0.04 Y=0.04 Z=0.08

#exec MESHMAP SETTEXTURE MESHMAP=SShotL NUM=1 TEXTURE=NerfRes.Skins.Hand_back
#exec MESHMAP SETTEXTURE MESHMAP=SShotL NUM=2 TEXTURE=NerfRes.Skins.Hand_in
#exec MESHMAP SETTEXTURE MESHMAP=SShotL NUM=3 TEXTURE=secret_shot_pu_01

// Audio sound effects
// ##nerf WES FIXME Sounds
// Pickup sound is generic. need a special sound for the particular weapon.
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\pickups\pkwp1.wav" NAME="SShotpickS" GROUP="SShot"
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\weapons\wshot.wav" NAME="SShotfireS" GROUP="SShot"
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\weapons\wshotalt.wav" NAME="SShotAltfireS" GROUP="SShot"
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\weapons\wshotfx.wav" NAME="SShotFlipS" GROUP="SShot"

function float RateSelf( out int bUseAltMode )
{
	if ( Pawn(Owner).Enemy == None )
	{
		bUseAltMode = 0;
		return AIRating;
	}
	bUseAltMode = int( FRand() < 0.3 );
	return AIRating;
}

function setHand(float Hand)
{
	local rotator newRot;

	Super.SetHand(Hand);
	if ( Hand == 1 )
		Mesh = Mesh(DynamicLoadObject("NerfI.SShotL", class'Mesh'));
	else if ( Hand == -1 )
		Mesh = Mesh'NerfI.SShotR';
	else
	{
		PlayerViewOffset.Y = 0;
		FireOffset.Y = 0;
		bHideWeapon = true;
	}

}

///////////////////////////////////////////////////////
simulated function PlayFiring()
{
	Owner.PlaySound(FireSound, SLOT_Misc,Pawn(Owner).SoundDampening);
	PlayAnim('fire', 0.5, 0.05);
}

function Fire(float Value)
{
	Super.Fire(Value);
	if (AmmoType.AmmoAmount < 11)
		AmmoType.AmmoAmount = 10;
}

///////////////////////////////////////////////////////
simulated function PlayAltFiring()
{
	Owner.PlaySound(AltFireSound, SLOT_Misc,Pawn(Owner).SoundDampening);
	PlayAnim('alt_fire_close', 0.5, 0.05);
}

simulated function PlayOpenFiring()
{
	Owner.PlaySound(Misc1Sound, SLOT_Misc,2.0*Pawn(Owner).SoundDampening);		
	PlayAnim('alt_fire_open', 1.0, 0.05);
}

simulated function PlayAltShot()
{
	PlayAnim('alt_fire', 1.0, 0.05);
}

function AltFire( float Value )
{
	if (AmmoType.UseAmmo(1))
	{
		PlayOpenFiring();
		GotoState('AltFiring');
		bPointing=True;
		if (AmmoType.AmmoAmount < 5)
			AmmoType.AmmoAmount = 5;
		PlayAltShot();
		ProjectileFire(AltProjectileClass, AltProjectileSpeed, bAltWarnTarget);
		bCanClientFire = true;
		ClientAltFire(Value);
	}
}

///////////////////////////////////////////////////////////////

simulated function PlayIdleAnim()
{
	PlayAnim('idle',0.5,0.05);
}
///////////////////////////////////////////////////////////

state Idle
{
	function Timer()
	{
		if (FRand()>0.8) PlayIdleAnim();
	}

Begin:
	bPointing=False;
	if ( (AmmoType != None) && (AmmoType.AmmoAmount<=0) ) 
		Pawn(Owner).SwitchToBestWeapon();  //Goto Weapon that has Ammo
	Disable('AnimEnd');
//	log(class$ " WES: Setting Timer");
	SetTimer(3.0,True);
	if ( /*bFireMem ||*/ Pawn(Owner).bFire!=0 ) Global.Fire(0.0);
	if ( /*bAltFireMem ||*/ Pawn(Owner).bAltFire!=0 ) Global.AltFire(0.0);	
}

defaultproperties
{
     WeaponDescription=<
     AimAdjust=64.000000
     AmmoName=Class'NerfI.DDartAmmo'
     PickupAmmoCount=40
     bAltWarnTarget=True
     FireOffset=(X=20.000000,Y=-14.000000,Z=-5.000000)
     ProjectileClass=Class'NerfI.DefaultDart'
     AltProjectileClass=Class'NerfI.DefaultPowerDart'
     shakemag=120.000000
     shaketime=0.130000
     shakevert=2.000000
     RefireRate=0.800000
     AltRefireRate=0.600000
     FireSound=Sound'NerfI.SShot.SShotfireS'
     AltFireSound=Sound'NerfI.SShot.SShotAltfireS'
     Misc1Sound=Sound'NerfI.SShot.SShotFlipS'
     PickupMessage=You picked up the Secret Shot
     ItemName=Secret Shot
     PlayerViewOffset=(X=11.000000,Y=-5.000000,Z=-7.000000)
     PlayerViewMesh=LodMesh'NerfI.SShotR'
     PickupViewMesh=LodMesh'NerfI.SShotpick'
     PickupViewScale=2.500000
     ThirdPersonMesh=LodMesh'NerfI.SShot3rd'
     PickupSound=Sound'NerfI.SShot.SShotpickS'
     Mesh=LodMesh'NerfI.SShot3rd'
     DrawScale=2.500000
     bNoSmooth=False
     SoundRadius=64
     SoundVolume=255
     CollisionRadius=22.000000
     CollisionHeight=28.000000
     Mass=15.000000
}
