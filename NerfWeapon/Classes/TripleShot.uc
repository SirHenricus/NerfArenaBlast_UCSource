//=============================================================================
// TripleShot.
//=============================================================================
class TripleShot expands NerfWeapon;

// pickup version
#exec MESH IMPORT MESH=TripleShotpick ANIVFILE=g:\NerfRes\WeaponMesh\MODELS\triple_shot_pu_a.3d DATAFILE=g:\NerfRes\WeaponMesh\MODELS\triple_shot_pu_d.3d X=0 Y=0 Z=0 LODSTYLE=8
#exec MESH ORIGIN MESH=TripleShotpick X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=TripleShotpick SEQ=All                      STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=TripleShotpick SEQ=Idle                      STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=TripleShotpick MESH=TripleShotpick
#exec MESHMAP SCALE MESHMAP=TripleShotpick X=0.072 Y=0.072 Z=0.144

#exec TEXTURE IMPORT NAME=triple_strike_pu_01 FILE=g:\NerfRes\WeaponMesh\Textures\triple_shot_pu_01.PCX GROUP=Skins FLAGS=2	//Material #14
#exec TEXTURE IMPORT NAME=triple_strike_pu_02 FILE=g:\NerfRes\WeaponMesh\Textures\triple_shot_pu_02.PCX GROUP=Skins FLAGS=2	//triple_fire _back01
#exec TEXTURE IMPORT NAME=triple_strike_pu_03 FILE=g:\NerfRes\WeaponMesh\Textures\triple_shot_pu_03.PCX GROUP=Skins FLAGS=2	//Material #265
#exec TEXTURE IMPORT NAME=triple_strike_pu_04 FILE=g:\NerfRes\WeaponMesh\Textures\triple_shot_pu_04.PCX GROUP=Skins FLAGS=2	//trifire03

#exec MESHMAP SETTEXTURE MESHMAP=TripleShotpick NUM=1 TEXTURE=triple_strike_pu_01
#exec MESHMAP SETTEXTURE MESHMAP=TripleShotpick NUM=2 TEXTURE=triple_strike_pu_02
#exec MESHMAP SETTEXTURE MESHMAP=TripleShotpick NUM=3 TEXTURE=triple_strike_pu_03
#exec MESHMAP SETTEXTURE MESHMAP=TripleShotpick NUM=4 TEXTURE=triple_strike_pu_04

// 3rd person
#exec MESH IMPORT MESH=TripleShot3rd ANIVFILE=g:\NerfRes\WeaponMesh\MODELS\triple_shot_pu_a.3d DATAFILE=g:\NerfRes\WeaponMesh\MODELS\triple_shot_pu_d.3d X=0 Y=0 Z=0 LODSTYLE=8
#exec MESH ORIGIN MESH=TripleShot3rd X=400 Y=0 Z=0 YAW=128 PITCH=-32

#exec MESH SEQUENCE MESH=TripleShot3rd SEQ=All                      STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=TripleShot3rd MESH=TripleShot3rd
#exec MESHMAP SCALE MESHMAP=TripleShot3rd X=0.036 Y=0.036 Z=0.072
//#exec MESHMAP SCALE MESHMAP=TripleShot3rd X=0.04 Y=0.04 Z=0.08

#exec MESHMAP SETTEXTURE MESHMAP=TripleShot3rd NUM=1 TEXTURE=triple_strike_pu_01
#exec MESHMAP SETTEXTURE MESHMAP=TripleShot3rd NUM=2 TEXTURE=triple_strike_pu_02
#exec MESHMAP SETTEXTURE MESHMAP=TripleShot3rd NUM=3 TEXTURE=triple_strike_pu_03
#exec MESHMAP SETTEXTURE MESHMAP=TripleShot3rd NUM=4 TEXTURE=triple_strike_pu_04


//  player view version

// Right Handed

#exec MESH IMPORT MESH=TripleShotR ANIVFILE=g:\NerfRes\weaponanimation\MODELS\Triple_Shot_a.3d DATAFILE=g:\NerfRes\weaponanimation\MODELS\Triple_Shot_d.3d X=0 Y=0 Z=0
//#exec MESH ORIGIN MESH=TripleShotR X=-200 Y=-100 Z=60 YAW=127 
#exec MESH ORIGIN MESH=TripleShotR X=-300 Y=0 Z=125 YAW=128 

#exec MESH SEQUENCE MESH=TripleShotR SEQ=All                      STARTFRAME=0 NUMFRAMES=249
#exec MESH SEQUENCE MESH=TripleShotR SEQ=select                   STARTFRAME=0 NUMFRAMES=23
#exec MESH SEQUENCE MESH=TripleShotR SEQ=fire_01                  STARTFRAME=23 NUMFRAMES=7
#exec MESH SEQUENCE MESH=TripleShotR SEQ=fire_02                  STARTFRAME=30 NUMFRAMES=7
#exec MESH SEQUENCE MESH=TripleShotR SEQ=fire_03                  STARTFRAME=37 NUMFRAMES=6
#exec MESH SEQUENCE MESH=TripleShotR SEQ=fire_alt                 STARTFRAME=43 NUMFRAMES=7
#exec MESH SEQUENCE MESH=TripleShotR SEQ=fire_alt_02              STARTFRAME=50 NUMFRAMES=7
#exec MESH SEQUENCE MESH=TripleShotR SEQ=load                     STARTFRAME=57 NUMFRAMES=31
#exec MESH SEQUENCE MESH=TripleShotR SEQ=idle_alt                 STARTFRAME=88 NUMFRAMES=31
#exec MESH SEQUENCE MESH=TripleShotR SEQ=down                     STARTFRAME=119 NUMFRAMES=21
#exec MESH SEQUENCE MESH=TripleShotR SEQ=select_01                STARTFRAME=140 NUMFRAMES=23
#exec MESH SEQUENCE MESH=TripleShotR SEQ=select_02                STARTFRAME=163 NUMFRAMES=23
#exec MESH SEQUENCE MESH=TripleShotR SEQ=down_02                  STARTFRAME=186 NUMFRAMES=21
#exec MESH SEQUENCE MESH=TripleShotR SEQ=down_01                  STARTFRAME=207 NUMFRAMES=21
#exec MESH SEQUENCE MESH=TripleShotR SEQ=down_03                  STARTFRAME=228 NUMFRAMES=21
#exec MESH SEQUENCE MESH=TripleShotR SEQ=still_01                 STARTFRAME=23 NUMFRAMES=1
#exec MESH SEQUENCE MESH=TripleShotR SEQ=still_02                 STARTFRAME=30 NUMFRAMES=1
#exec MESH SEQUENCE MESH=TripleShotR SEQ=still_03                 STARTFRAME=37 NUMFRAMES=1


#exec MESHMAP NEW   MESHMAP=TripleShotR MESH=TripleShotR
#exec MESHMAP SCALE MESHMAP=TripleShotR X=0.035 Y=0.035 Z=0.07

//##nerf WES FIXME
// Taking out the Musle flash right for the Beta demo
//#exec TEXTURE IMPORT NAME=Triple_Shot_07 FILE=g:\NerfRes\weaponanimation\Textures\Triple_Shot_07.PCX GROUP=Skins Mips=Off FLAGS=2	//Material #9

#exec MESHMAP SETTEXTURE MESHMAP=TripleShotR NUM=1 TEXTURE=NerfRes.Skins.Hand_back
#exec MESHMAP SETTEXTURE MESHMAP=TripleShotR NUM=2 TEXTURE=NerfRes.Skins.Hand_in
#exec MESHMAP SETTEXTURE MESHMAP=TripleShotR NUM=3 TEXTURE=triple_strike_pu_01
#exec MESHMAP SETTEXTURE MESHMAP=TripleShotR NUM=4 TEXTURE=triple_strike_pu_02
#exec MESHMAP SETTEXTURE MESHMAP=TripleShotR NUM=5 TEXTURE=triple_strike_pu_03
#exec MESHMAP SETTEXTURE MESHMAP=TripleShotR NUM=6 TEXTURE=triple_strike_pu_04

// Left Handed

#exec MESH IMPORT MESH=TripleShotL ANIVFILE=g:\NerfRes\weaponanimation\MODELS\Triple_Shot_a.3d DATAFILE=g:\NerfRes\weaponanimation\MODELS\Triple_Shot_d.3d unmirror=1
#exec MESH ORIGIN MESH=TripleShotL X=300 Y=0 Z=125 

#exec MESH SEQUENCE MESH=TripleShotL SEQ=All                      STARTFRAME=0 NUMFRAMES=249
#exec MESH SEQUENCE MESH=TripleShotL SEQ=select                   STARTFRAME=0 NUMFRAMES=23
#exec MESH SEQUENCE MESH=TripleShotL SEQ=fire_01                  STARTFRAME=23 NUMFRAMES=7
#exec MESH SEQUENCE MESH=TripleShotL SEQ=fire_02                  STARTFRAME=30 NUMFRAMES=7
#exec MESH SEQUENCE MESH=TripleShotL SEQ=fire_03                  STARTFRAME=37 NUMFRAMES=6
#exec MESH SEQUENCE MESH=TripleShotL SEQ=fire_alt                 STARTFRAME=43 NUMFRAMES=7
#exec MESH SEQUENCE MESH=TripleShotL SEQ=fire_alt_02              STARTFRAME=50 NUMFRAMES=7
#exec MESH SEQUENCE MESH=TripleShotL SEQ=load                     STARTFRAME=57 NUMFRAMES=31
#exec MESH SEQUENCE MESH=TripleShotL SEQ=idle_alt                 STARTFRAME=88 NUMFRAMES=31
#exec MESH SEQUENCE MESH=TripleShotL SEQ=down                     STARTFRAME=119 NUMFRAMES=21
#exec MESH SEQUENCE MESH=TripleShotL SEQ=select_01                STARTFRAME=140 NUMFRAMES=23
#exec MESH SEQUENCE MESH=TripleShotL SEQ=select_02                STARTFRAME=163 NUMFRAMES=23
#exec MESH SEQUENCE MESH=TripleShotL SEQ=down_02                  STARTFRAME=186 NUMFRAMES=21
#exec MESH SEQUENCE MESH=TripleShotL SEQ=down_01                  STARTFRAME=207 NUMFRAMES=21
#exec MESH SEQUENCE MESH=TripleShotL SEQ=down_03                  STARTFRAME=228 NUMFRAMES=21
#exec MESH SEQUENCE MESH=TripleShotL SEQ=still_01                 STARTFRAME=23 NUMFRAMES=1
#exec MESH SEQUENCE MESH=TripleShotL SEQ=still_02                 STARTFRAME=30 NUMFRAMES=1
#exec MESH SEQUENCE MESH=TripleShotL SEQ=still_03                 STARTFRAME=37 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=TripleShotL MESH=TripleShotL
#exec MESHMAP SCALE MESHMAP=TripleShotL X=0.035 Y=0.035 Z=0.07

#exec MESHMAP SETTEXTURE MESHMAP=TripleShotL NUM=1 TEXTURE=NerfRes.Skins.Hand_back
#exec MESHMAP SETTEXTURE MESHMAP=TripleShotL NUM=2 TEXTURE=NerfRes.Skins.Hand_in
#exec MESHMAP SETTEXTURE MESHMAP=TripleShotL NUM=3 TEXTURE=triple_strike_pu_01
#exec MESHMAP SETTEXTURE MESHMAP=TripleShotL NUM=4 TEXTURE=triple_strike_pu_02
#exec MESHMAP SETTEXTURE MESHMAP=TripleShotL NUM=5 TEXTURE=triple_strike_pu_03
#exec MESHMAP SETTEXTURE MESHMAP=TripleShotL NUM=6 TEXTURE=triple_strike_pu_04

//##nerf WES FIXME
// Taking out the Musle flash right for the Beta demo
//#exec MESHMAP SETTEXTURE MESHMAP=TripleShotL NUM=7 TEXTURE=Triple_Shot_07

// Audio sound effects
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\pickups\pkwtrip.wav" NAME="TriplepickS" GROUP="TripleShot"
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\weapons\wtriple.wav" NAME="TriplefireS" GROUP="TripleShot"
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\weapons\wtripalt.wav" NAME="TripleAltfireS" GROUP="TripleShot"

var int RocketsLoaded;
var bool bFireLoad;
var float Offset[3];
var int RoxInBarrel;

replication
{
	// Things the server should send to the client.
	reliable if( Role==ROLE_Authority && bNetOwner )
		RoxInBarrel;
}

function float RateSelf( out int bUseAltMode )
{
	local float EnemyDist;
	local bool bRetreating;
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
	if ( EnemyDist < 270 )
	{
		bUseAltMode = 0;
		return -0.1;
	}

	if ( Owner.Physics == PHYS_Falling )
		bUseAltMode = 0;
	else if ( EnemyDist < -1.5 * EnemyDir.Z )
		bUseAltMode = int( FRand() < 0.5 );
	else
	{
		bRetreating = ( ((EnemyDir/EnemyDist) Dot Owner.Velocity) < -0.7 );
		bUseAltMode = 0;
		if ( ((EnemyDist < 600) || (bRetreating && (EnemyDist < 800)))
			&& (FRand() < 0.4) )
			bUseAltMode = 1;
	}
	return AIRating;
}

// return delta to combat style
function float SuggestAttackStyle()
{
	local float EnemyDist;

	EnemyDist = VSize(Pawn(Owner).Enemy.Location - Owner.Location);
	if ( EnemyDist < 500 )
		return -0.6;
	else
		return -0.2;
}

function setHand(float Hand)
{
	local rotator newRot;

	Super.SetHand(Hand);
	if ( Hand == 1 )
		Mesh = Mesh(DynamicLoadObject("NerfWeapon.TripleShotL", class'Mesh'));
	else if ( Hand == -1 )
		Mesh = Mesh'TripleShotR';
	else
	{
		PlayerViewOffset.Y = 0;
		FireOffset.Y = 0;
		bHideWeapon = true;
	}
}

simulated function TweenDown()
{
	local float animerate;

	if ( (AnimSequence != '') && (GetAnimGroup(AnimSequence) == 'Select') )
		TweenAnim( AnimSequence, AnimFrame * 0.4 );
	else
	{
		if ((Level.Game != None) && (Level.Game.bFastWeaponSwitch))
			animerate = 2.0;
		else
			animerate = 1.0;

		switch (RoxInBarrel)
		{
			case 0: PlayAnim('Down_03', animerate, 0.05);
					break;
			case 1: PlayAnim('Down_02', animerate, 0.05);
					break;
			case 2: PlayAnim('Down_01', animerate, 0.05);
					break;
			case 3: PlayAnim('Down', animerate, 0.05);
					break;
		}
	}
}

simulated function TweenToStill()
{
	switch (RoxInBarrel)
	{
		case 1: TweenAnim('Still_03', 0.1);
				break;
		case 2: TweenAnim('Still_02', 0.1);
				break;
		case 3: TweenAnim('Still_01', 0.1);
				break;
	}
}

simulated function PlaySelect()
{
	local float animerate;
	if (RoxInBarrel <= 0)
	{
		if (AmmoType.Ammoamount >= 3)
			RoxInBarrel = 3;
		else 
			RoxInBarrel = AmmoType.Ammoamount;
	}

	if ((Level.Game != None) && (Level.Game.bFastWeaponSwitch))
		animerate = 2.0;
	else
		animerate = 1.0;

	switch (RoxInBarrel)
	{
		case 1: PlayAnim('Select_02', animerate, 0.0);
				break;
		case 2: PlayAnim('Select_01', animerate, 0.0);
				break;
		case 3: PlayAnim('Select', animerate, 0.0);
				break;
	}
	Owner.PlaySound(SelectSound, SLOT_Misc, Pawn(Owner).SoundDampening);	
}

simulated function PlayLoading()
{
	PlayAnim('Load', 1.0, 0.05);
}

simulated function PlayFiring()
{
//	log(class$ " WES: RoxInBarrel in PlayFiring" @RoxInBarrel);
	Owner.PlaySound(FireSound, SLOT_Misc,Pawn(Owner).SoundDampening);
	if (RoxInBarrel == 3)
	{
		PlayAnim('Fire_01', 0.5, 0.05);
		RoxInBarrel--;
	}
	else if (RoxInBarrel == 2)
	{
		PlayAnim('Fire_02', 0.5, 0.05);
		RoxInBarrel--;
	}
	else if (RoxInBarrel == 1)
	{
		PlayAnim('Fire_03', 0.5, 0.05);
		RoxInBarrel=3;
	}

}

/*************************************************************************************/
State AltFireLoading
{
	function Fire(float F) 
	{
	}
	function AltFire(float F) 
	{
	}

Begin:
		FinishAnim();
		PlayAnim('idle_alt', 1.0, 0.05);
		FinishAnim();
		Sleep(0.2);
		Finish();
}

simulated function PlayAltFiring()
{
	Owner.PlaySound(AltFireSound, SLOT_Misc,Pawn(Owner).SoundDampening);
	if (RoxInBarrel == 3)
	{
		PlayAnim('Fire_alt', 0.5, 0.05);
	}
	else if (RoxInBarrel == 2)
	{
		PlayAnim('Fire_alt_02', 0.5, 0.05);
	}
	else if (RoxInBarrel == 1)
	{
		PlayAnim('Fire_03', 0.5, 0.05);
	}
	if (AmmoType.Ammoamount > 3)
		RoxInBarrel=3;
	else 
		RoxInBarrel=AmmoType.Ammoamount;
}
///////////////////////////////////////////////////////
simulated function TraceRoxFire(bool bWarn)
{
	local Vector Start,EndTrace, X,Y,Z;
	local TraceRocket RR;
	local int i;
	local Rotator FirRot;

	Owner.MakeNoise(Pawn(Owner).SoundDampening);
	GetAxes(Pawn(owner).ViewRotation,X,Y,Z);
	Start = Owner.Location + CalcDrawOffset() + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z; 
	AdjustedAim = pawn(owner).AdjustAim(AltProjectileClass.Default.Speed, Start, 0*AimError, False, False);	
	EndTrace = Start;
	EndTrace += (10000 * vector(AdjustedAim)); 
	for (i=0; i < RocketsLoaded; i++)
	{
		if (i == 1)
			Start = Owner.Location + CalcDrawOffset() + FireOffset.X * X + (FireOffset.Y - 5) * Y + (FireOffset.Z -5 ) * Z; 
		else if ( i == 2 )
			Start = Owner.Location + CalcDrawOffset() + FireOffset.X * X + (FireOffset.Y + 5) * Y + (FireOffset.Z -5 ) * Z; 
		else
			Start = Owner.Location + CalcDrawOffset() + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z; 

/*
		FirRot = AdjustedAim;
		FirRot.Yaw += 8000*(FRand()*2-1);
		FirRot.Pitch += 6000*(FRand()*2-1);
		RR = Spawn(class'Rocket',,, Start,FirRot);	
		RR.TraceLocation = EndTrace;
*/
		Spawn(class'Rocket',,, Start,AdjustedAim);
	}
}

simulated function PlayIdleAnim()
{
	TweenToStill();
}
/*****************************************************************************/

simulated function bool ClientFire( float Value )
{
	if ( bCanClientFire && ((Role == ROLE_Authority) || (AmmoType == None) || (AmmoType.AmmoAmount > 0)) )
	{
		if ( (PlayerPawn(Owner) != None) 
			&& ((Level.NetMode == NM_Standalone) || PlayerPawn(Owner).Player.IsA('ViewPort')) )
		{
			if ( InstFlash != 0.0 )
				PlayerPawn(Owner).ClientInstantFlash( InstFlash, InstFog);
			PlayerPawn(Owner).ShakeView(ShakeTime, ShakeMag, ShakeVert);
			if ( Affector != None )
				Affector.FireEffect();
		}
		GotoState('NormalFire');
		return true;
	}
	return false;
}		

function Fire( float Value )
{
	if ( AmmoType.UseAmmo(1) )
	{
		bPointing=True;
		bCanClientFire = true;
		ClientFire(Value);
		if ( bRapidFire || (FiringSpeed > 0) )
			Pawn(Owner).PlayRecoil(FiringSpeed);
	}
}

state NormalFire
{
	function AnimEnd()
	{
	}

	simulated function FireRox()
	{
		PlayFiring();
		ProjectileFire(ProjectileClass, ProjectileSpeed, bWarnTarget);
	}

	simulated function CheckLoad()
	{
		if ((AmmoType.Ammoamount > 0) && (RoxInBarrel == 3))
			PlayLoading();
	}

Begin:
	FireRox();
	FinishAnim();	
	CheckLoad();
	FinishAnim();	
	Sleep(0.4);
	Finish();

}

/*****************************************************************************/

state AltFiring
{
	function AnimEnd()
	{
	}

	simulated function FireRox()
	{
		PlayAltFiring();
		TraceRoxFire(bAltWarnTarget);
	}

	simulated function CheckLoad()
	{
		if ((AmmoType.Ammoamount > 0) && (RoxInBarrel == 3))
			PlayLoading();
	}

	simulated function Pumping()
	{
		Gotostate('AltfireLoading');
	}

Begin:
	FireRox();
	FinishAnim();	
	CheckLoad();
	FinishAnim();	
	Pumping();
	FinishAnim();
//	Sleep(0.4);
	Finish();

}

simulated function bool ClientAltFire( float Value )
{
	if ( bCanClientFire && ((Role == ROLE_Authority) || (AmmoType == None) || (AmmoType.AmmoAmount > 0)) )
	{
		if ( (PlayerPawn(Owner) != None) 
			&& ((Level.NetMode == NM_Standalone) || PlayerPawn(Owner).Player.IsA('ViewPort')) )
		{
			if ( InstFlash != 0.0 )
				PlayerPawn(Owner).ClientInstantFlash( InstFlash, InstFog);
			PlayerPawn(Owner).ShakeView(ShakeTime, ShakeMag, ShakeVert);
			if ( Affector != None )
				Affector.FireEffect();
		}
		GotoState('AltFiring');
		return true;
	}
	return false;
}		

function AltFire( float Value )
{
	if (AmmoType.UseAmmo(RoxInBarrel))
	{
		RocketsLoaded=RoxInBarrel;
	}
	else 
	{
		RocketsLoaded=AmmoType.AmmoAmount;
		RoxInBarrel=RocketsLoaded;
		AmmoType.UseAmmo(RocketsLoaded);
	}
	bPointing=True;
	bCanClientFire = true;
	ClientAltFire(Value);
	if ( bRapidFire || (FiringSpeed > 0) )
		Pawn(Owner).PlayRecoil(FiringSpeed);

//	TraceRoxFire(bAltWarnTarget);

}

/*
state FirePause
{
Begin:
	FinishAnim();
	Sleep(0.5);
	Finish();
}
*/

defaultproperties
{
     RoxInBarrel=3
     WeaponDescription=<
     AimAdjust=64.000000
     AmmoName=Class'NerfWeapon.RoxAmmoPickup'
     PickupAmmoCount=15
     bSplashDamage=True
     bRecommendSplashDamage=True
     FireOffset=(X=10.000000,Y=-10.000000)
     ProjectileClass=Class'NerfWeapon.Rocket'
     AltProjectileClass=Class'NerfWeapon.Rocket'
     shakemag=350.000000
     shaketime=0.200000
     shakevert=7.500000
     AIRating=0.700000
     RefireRate=0.250000
     AltRefireRate=0.250000
     FireSound=Sound'NerfWeapon.TripleShot.TriplefireS'
     AltFireSound=Sound'NerfWeapon.TripleShot.TripleAltfireS'
     DeathMessage=%o was smacked down multiple times by %k's %w.
     AutoSwitchPriority=7
     InventoryGroup=7
     PickupMessage=You got the TripleStrike
     ItemName=Triple Strike
     PlayerViewOffset=(X=13.000000,Y=-7.000000)
     PlayerViewMesh=LodMesh'NerfWeapon.TripleShotR'
     PlayerViewScale=0.500000
     BobDamping=0.985000
     PickupViewMesh=LodMesh'NerfWeapon.TripleShotpick'
     ThirdPersonMesh=LodMesh'NerfWeapon.TripleShot3rd'
     PickupSound=Sound'NerfWeapon.TripleShot.TriplepickS'
     Mesh=LodMesh'NerfWeapon.TripleShotpick'
     bNoSmooth=False
     CollisionRadius=35.000000
     CollisionHeight=28.000000
}
