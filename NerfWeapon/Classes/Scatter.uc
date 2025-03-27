//================================================================================
// Scatter.	- by Wezo
// 
// Charateristic:	Shotgun like blast that causes scattered electronic mini-balls 
//					on contact with a surface.
// Primary fire :	Fire 4 instant hit blasts. Randomly spread. Used one ammo count.
// Alt fire	    :	Fire 4 instant hit blasts with a small explosion radius. More
//					damage and more accurate. Used 4 ammo counts.		
//=================================================================================
class Scatter expands NerfWeapon;

// pickup version
#exec MESH IMPORT MESH=Scatterpick ANIVFILE=g:\NerfRes\weaponMesh\MODELS\scatter_shot_pu_a.3d DATAFILE=g:\NerfRes\weaponMesh\MODELS\scatter_shot_pu_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=Scatterpick X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=Scatterpick SEQ=All                      STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Scatterpick SEQ=idle                      STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=Scatterpick MESH=Scatterpick
#exec MESHMAP SCALE MESHMAP=Scatterpick X=0.08 Y=0.08 Z=0.16 

#exec TEXTURE IMPORT NAME=scatter_shot_pu_01 FILE=g:\NerfRes\weaponMesh\Textures\scatter_shot_pu_01.PCX GROUP=Skins FLAGS=2	//ss cartridge toppy01

#exec MESHMAP SETTEXTURE MESHMAP=Scatterpick NUM=1 TEXTURE=scatter_shot_pu_01

//3rd person

#exec MESH IMPORT MESH=Scatter3rd ANIVFILE=g:\NerfRes\weaponMesh\MODELS\scatter_shot_pu_a.3d DATAFILE=g:\NerfRes\weaponMesh\MODELS\scatter_shot_pu_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=Scatter3rd X=125 Y=0 Z=0 YAW=128 PITCH=-32

#exec MESH SEQUENCE MESH=Scatter3rd SEQ=All                      STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=Scatter3rd MESH=Scatter3rd
#exec MESHMAP SCALE MESHMAP=Scatter3rd X=0.04 Y=0.04 Z=0.08

#exec MESHMAP SETTEXTURE MESHMAP=Scatter3rd NUM=1 TEXTURE=scatter_shot_pu_01

//POV

// Right handed 

#exec MESH IMPORT MESH=ScatterR ANIVFILE=g:\NerfRes\WeaponAnimation\MODELS\scatter_shot_a.3d DATAFILE=g:\NerfRes\WeaponAnimation\MODELS\scatter_shot_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=ScatterR X=-20 Y=0 Z=-35 YAW=128

#exec MESH SEQUENCE MESH=ScatterR SEQ=All                      STARTFRAME=0 NUMFRAMES=182
#exec MESH SEQUENCE MESH=ScatterR SEQ=select                   STARTFRAME=0 NUMFRAMES=31
#exec MESH SEQUENCE MESH=ScatterR SEQ=idle                     STARTFRAME=31 NUMFRAMES=11
#exec MESH SEQUENCE MESH=ScatterR SEQ=fire_select              STARTFRAME=42 NUMFRAMES=3
#exec MESH SEQUENCE MESH=ScatterR SEQ=fire                     STARTFRAME=45 NUMFRAMES=19
#exec MESH SEQUENCE MESH=ScatterR SEQ=fire_down                STARTFRAME=64 NUMFRAMES=4
#exec MESH SEQUENCE MESH=ScatterR SEQ=idle_alt                 STARTFRAME=68 NUMFRAMES=83
#exec MESH SEQUENCE MESH=ScatterR SEQ=down                     STARTFRAME=151 NUMFRAMES=31
#exec MESH SEQUENCE MESH=ScatterR SEQ=still                    STARTFRAME=41 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=ScatterR MESH=ScatterR
#exec MESHMAP SCALE MESHMAP=ScatterR X=0.02 Y=0.025 Z=0.05

#exec TEXTURE IMPORT NAME=scatter_shot_04 FILE=g:\NerfRes\WeaponAnimation\Textures\scatter_shot_04.PCX GROUP=Skins Mips=Off FLAGS=2	//ss canistergreen
#exec TEXTURE IMPORT NAME=scatter_shot_05 FILE=g:\NerfRes\WeaponAnimation\Textures\scatter_shot_05.PCX GROUP=Skins Mips=Off FLAGS=2	//sscartridge base

#exec MESHMAP SETTEXTURE MESHMAP=ScatterR NUM=1 TEXTURE=NerfRes.Skins.Hand_back
#exec MESHMAP SETTEXTURE MESHMAP=ScatterR NUM=2 TEXTURE=NerfRes.Skins.Hand_in
#exec MESHMAP SETTEXTURE MESHMAP=ScatterR NUM=3 TEXTURE=scatter_shot_pu_01
#exec MESHMAP SETTEXTURE MESHMAP=ScatterR NUM=4 TEXTURE=scatter_shot_04
#exec MESHMAP SETTEXTURE MESHMAP=ScatterR NUM=5 TEXTURE=scatter_shot_05

// Left Handed

#exec MESH IMPORT MESH=ScatterL ANIVFILE=g:\NerfRes\WeaponAnimation\MODELS\scatter_shot_a.3d DATAFILE=g:\NerfRes\WeaponAnimation\MODELS\scatter_shot_d.3d unmirror=1
#exec MESH ORIGIN MESH=ScatterL X=20 Y=0 Z=-35 

#exec MESH SEQUENCE MESH=ScatterL SEQ=All                      STARTFRAME=0 NUMFRAMES=182
#exec MESH SEQUENCE MESH=ScatterL SEQ=select                   STARTFRAME=0 NUMFRAMES=31
#exec MESH SEQUENCE MESH=ScatterL SEQ=idle                     STARTFRAME=31 NUMFRAMES=11
#exec MESH SEQUENCE MESH=ScatterL SEQ=fire_select              STARTFRAME=42 NUMFRAMES=3
#exec MESH SEQUENCE MESH=ScatterL SEQ=fire                     STARTFRAME=45 NUMFRAMES=19
#exec MESH SEQUENCE MESH=ScatterL SEQ=fire_down                STARTFRAME=64 NUMFRAMES=4
#exec MESH SEQUENCE MESH=ScatterL SEQ=idle_alt                 STARTFRAME=68 NUMFRAMES=83
#exec MESH SEQUENCE MESH=ScatterL SEQ=down                     STARTFRAME=151 NUMFRAMES=31
#exec MESH SEQUENCE MESH=ScatterL SEQ=still                    STARTFRAME=41 NUMFRAMES=1


#exec MESHMAP NEW   MESHMAP=ScatterL MESH=ScatterL
#exec MESHMAP SCALE MESHMAP=ScatterL X=0.02 Y=0.025 Z=0.05

#exec MESHMAP SETTEXTURE MESHMAP=ScatterL NUM=1 TEXTURE=NerfRes.Skins.Hand_back
#exec MESHMAP SETTEXTURE MESHMAP=ScatterL NUM=2 TEXTURE=NerfRes.Skins.Hand_in
#exec MESHMAP SETTEXTURE MESHMAP=ScatterL NUM=3 TEXTURE=scatter_shot_pu_01
#exec MESHMAP SETTEXTURE MESHMAP=ScatterL NUM=4 TEXTURE=scatter_shot_04
#exec MESHMAP SETTEXTURE MESHMAP=ScatterL NUM=5 TEXTURE=scatter_shot_05

// Audio sound effects
// ##nerf WES FIXME Sounds
// Pickup sound is generic. need a special sound for the particular weapon.
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\pickups\pkwp1.wav" NAME="ScatterpickS" GROUP="Scatter"
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\weapons\wscat.wav" NAME="ScatterfireS" GROUP="Scatter"
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\weapons\wscatalt.wav" NAME="ScatterAltfireS" GROUP="Scatter"

var int shots;
var int shotload;
var bool Fireload;
var bool AltFireload;
var float Accuracy; 
var float AltAccuracy;
var() int hitdamage;
var int ScatterInBarrel;

replication
{
	// Things the server should send to the client.
	reliable if( Role==ROLE_Authority && bNetOwner )
		ScatterInBarrel;
}

function float SuggestAttackStyle()
{
	local Nerfbots B;

	B = NerfBots(Owner);
	if (B != None)
		return 0.2;
	return 0.4;
}

function float SuggestDefenseStyle()
{
	return -0.3;
}

function float RateSelf( out int bUseAltMode )
{
	local float EnemyDist, rating;
	local vector EnemyDir;

	if ( AmmoType.AmmoAmount <=0 )
		return -2;
	if ( Pawn(Owner).Enemy == None )
	{
		bUseAltMode = 0;
		return AIRating;
	}
	EnemyDir = Pawn(Owner).Enemy.Location - Owner.Location;
	EnemyDist = VSize(EnemyDir);
	rating = FClamp(AIRating - (EnemyDist - 450) * 0.001, 0.2, AIRating);
	if ( EnemyDist > 900 )
	{
		bUseAltMode = 0;
		if ( EnemyDist > 2000 )
		{
			if ( EnemyDist > 3500 )
				return 0.2;
			return (AIRating - 0.3);
		}			
		if ( EnemyDir.Z < -0.5 * EnemyDist )
		{
			bUseAltMode = 1;
			return (AIRating - 0.3);
		}
	}
	else if ( (EnemyDist < 650) && (Pawn(Owner).Enemy.Weapon != None))
	{
		bUseAltMode = 0;
		return (AIRating + 0.3);
	}
	else if ( (EnemyDist < 340) || (EnemyDir.Z > 30) )
	{
		bUseAltMode = 0;
		return (AIRating + 0.2);
	}
	else
		bUseAltMode = int( FRand() < 0.65 );
	return rating;
}

function PreBeginPlay()
{
	Super.PreBeginPlay();
	Fireload=False;
	AltFireload=False;
	Accuracy=1.0;
	AltAccuracy=1.0;
	shotload=0;
}

function setHand(float Hand)
{
	local rotator newRot;

	Super.SetHand(Hand);
	if ( Hand == 1 )
		Mesh = Mesh(DynamicLoadObject("NerfWeapon.ScatterL", class'Mesh'));
	else if ( Hand == -1)
		Mesh = Mesh'ScatterR';
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
//	log(class$ " WES: Playfiring" @ScatterInBarrel);
	Owner.PlaySound(FireSound, SLOT_Misc,Pawn(Owner).SoundDampening);
	PlayAnim('fire', 0.65, 0.05);
}

function Fire( float Value )
{
	Fireload=True;
	AltFireload=False;
	if (AmmoType.UseAmmo(1))
	{
//		log(class$ " WES: ScatterInbarrel" @ScatterInBarrel);
		ScatterInBarrel--;
		bPointing=True;
		bCanClientFire = true;
		ClientFire(Value);
		GotoState('NormalFire');
		if ( bRapidFire || (FiringSpeed > 0) )
			Pawn(Owner).PlayRecoil(FiringSpeed);
		for (shots = 0; shots < 4; shots++) 
			TraceFire(Accuracy); 
//		log(class$ " WES: In BeginState" @ScatterInBarrel);
		if (ScatterInBarrel < 1)
		{
			if (AmmoType.Ammoamount > 0)
			{
				if (AmmoType.Ammoamount > 10)
					ScatterInBarrel=10;
				else ScatterInBarrel = AmmoType.Ammoamount;

//				log(class$ " WES: Calling the Loading function in Fire");
				PlayLoading();
			}
		}
	}
}

state ClientFiring
{
	simulated function BeginState()
	{
//		log(class$ " WES: ScatterInBarrel in ClientFiring Begin" @ScatterInBarrel);
		if (ScatterInBarrel < 2)
		{
/*
			if (AmmoType.Ammoamount > 0)
			{
				if (AmmoType.Ammoamount > 10)
					ScatterInBarrel=10;
				else ScatterInBarrel = AmmoType.Ammoamount;

//				log(class$ " WES: Calling the Loading function in Fire");
				PlayLoading();
			}
*/
				PlayLoading();
		}

	}
}

///////////////////////////////////////////////////////

simulated function PlayLoading()
{
//	log(class$ " WES: PlayLoading Animation");
	PlayAnim('idle_alt', 1.0, 0.05);
}

///////////////////////////////////////////////////////

simulated function PlayAltFiring()
{
//	log(class$ " WES: PlayAltfiring" @ScatterInBarrel);
	Owner.PlaySound(AltFireSound, SLOT_Misc,Pawn(Owner).SoundDampening);
	PlayAnim('fire', 0.75, 0.05);
}

simulated function PlayFireSelect()
{
	PlayAnim('fire_select', 0.75, 0.05);
}

simulated function PlayFireDown()
{
	PlayAnim('fire_down', 0.75, 0.05);
}

function AltFire( float Value )
{
	Fireload=False;
	AltFireload=True;
	if (AmmoType.Ammoamount < 4)
		ShotLoad=AmmoType.Ammoamount;
	else 
		ShotLoad =4;
	
	if (ScatterInBarrel < ShotLoad)
		ShotLoad = ScatterInBarrel;

//	log(class$ " WES: AltFire ShotLoad" @ShotLoad);
	if (AmmoType.UseAmmo(ShotLoad))
	{
//		log(class$ " WES: AltFire ScatterInBarrel" @ScatterInBarrel);
		ScatterInBarrel -= ShotLoad;
		PlayFireSelect();
		bPointing=True;
		bCanClientFire = true;
		ClientAltFire(Value);
//		log(class$ " WES: AltFire ScatterInBarrel After" @ScatterInBarrel);
		GotoState('AltFiring');
		if ( bRapidFire || (FiringSpeed > 0) )
			Pawn(Owner).PlayRecoil(FiringSpeed);
		for (shots = 0; shots < Shotload; shots++) 
			TraceFire(AltAccuracy); 
		if (ScatterInBarrel < 1)
		{
			if (AmmoType.Ammoamount > 0)
			{
				if (AmmoType.Ammoamount > 10)
					ScatterInBarrel=10;
				else ScatterInBarrel = AmmoType.Ammoamount;

//				log(class$ " WES: Calling the Loading function in Fire");
				PlayLoading();
			}
		}
	}
}

state ClientAltFiring
{
	simulated function BeginState()
	{
//		log(class$ " WES: ScatterInBarrel in ClientAltFiring Begin" @ScatterInBarrel);
		if (ScatterInBarrel < 5)
		{
/*
			if (AmmoType.Ammoamount > 0)
			{
				if (AmmoType.Ammoamount > 10)
					ScatterInBarrel=10;
				else ScatterInBarrel = AmmoType.Ammoamount;

//				log(class$ " WES: Calling the Loading function in Fire");
				PlayLoading();
			}
*/
				PlayLoading();
		}
	}

}
///////////////////////////////////////////////////////

function ProcessTraceHit(Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z)
{
	local ScatExp Exp; 

	if ( Fireload )
	{
		if (Other == Level) 
			spawn(class'Burst',,, HitLocation+HitNormal*9, Rotator(HitNormal));
		else if ((Other != self) && (Other != Owner))  
		{
		if ( FRand() < 0.2 )
			X *= 5;
		Other.TakeDamage(hitdamage, Pawn(Owner), HitLocation, 3000.0*X, 'shot'); //4 damage * 15 = med power
		if ( !Other.IsA('Pawn') && !Other.IsA('Carcass') )
			spawn(class'Burst',,,HitLocation+HitNormal*9);
		}       
	}
	else if (AltFireload)  
	{
		Exp = spawn(class'ScatExp',,, HitLocation+HitNormal*9, Rotator(HitNormal));
		Exp.DrawScale += FRand();
		HurtRadius(hitdamage+5, 100, 'exploded', 100.0, HitLocation);
	}
}

///////////////////////////////////////////////////////////
simulated function PlayIdleAnim()
{
	PlayAnim('Idle', 0.5, 0.05);
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
	SetTimer(1.5,True);
	if ( /*bFireMem ||*/ Pawn(Owner).bFire!=0 ) Global.Fire(0.0);
	if ( /*bAltFireMem ||*/ Pawn(Owner).bAltFire!=0 ) Global.AltFire(0.0);	
}

defaultproperties
{
     hitdamage=20
     ScatterInBarrel=10
     WeaponDescription=<
     AmmoName=Class'NerfWeapon.ScatAmmoPickup'
     PickupAmmoCount=15
     bInstantHit=True
     bAltInstantHit=True
     bAltWarnTarget=True
     FireOffset=(X=12.000000,Y=-10.000000,Z=-10.000000)
     aimerror=2000.000000
     shakemag=120.000000
     AIRating=0.650000
     RefireRate=0.800000
     FireSound=Sound'NerfWeapon.Scatter.ScatterfireS'
     AltFireSound=Sound'NerfWeapon.Scatter.ScatterAltfireS'
     AutoSwitchPriority=4
     InventoryGroup=4
     PickupMessage=You picked up the Scatter Shot
     ItemName=Scatter Shot
     PlayerViewOffset=(X=10.000000,Y=-6.000000,Z=-7.000000)
     PlayerViewMesh=LodMesh'NerfWeapon.ScatterR'
     PickupViewMesh=LodMesh'NerfWeapon.Scatterpick'
     ThirdPersonMesh=LodMesh'NerfWeapon.Scatter3rd'
     PickupSound=Sound'NerfWeapon.Scatter.ScatterpickS'
     Mesh=LodMesh'NerfWeapon.Scatterpick'
     bNoSmooth=False
     SoundRadius=64
     SoundVolume=255
     CollisionRadius=28.000000
     CollisionHeight=28.000000
     Mass=50.000000
}
