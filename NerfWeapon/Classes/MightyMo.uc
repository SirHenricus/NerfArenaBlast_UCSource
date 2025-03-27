//=============================================================================
// MightyMo.
//=============================================================================
class MightyMo expands NerfWeapon;

// Pickup version
#exec MESH IMPORT MESH=MightyMopick ANIVFILE=g:\NerfRes\weaponMesh\MODELS\mighty_mo_pu_a.3d DATAFILE=g:\NerfRes\weaponMesh\MODELS\mighty_mo_pu_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=MightyMopick X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=MightyMopick SEQ=All                      STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=MightyMopick SEQ=idle                      STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=MightyMopick MESH=MightyMopick
#exec MESHMAP SCALE MESHMAP=MightyMopick X=0.11 Y=0.11 Z=0.22

#exec TEXTURE IMPORT NAME=mighty_mo_pu_01 FILE=g:\NerfRes\weaponmesh\Textures\mighty_mo_pu_01.PCX GROUP=Skins FLAGS=2	//mightymobody

#exec MESHMAP SETTEXTURE MESHMAP=MightyMopick NUM=1 TEXTURE=mighty_mo_pu_01

//3rd person

#exec MESH IMPORT MESH=MightyMo3rd ANIVFILE=g:\NerfRes\weaponMesh\MODELS\mighty_mo_pu_a.3d DATAFILE=g:\NerfRes\weaponMesh\MODELS\mighty_mo_pu_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=MightyMo3rd X=0 Y=0 Z=0 YAW=128 PITCH=-40

#exec MESH SEQUENCE MESH=MightyMo3rd SEQ=All                      STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=MightyMo3rd MESH=MightyMo3rd
#exec MESHMAP SCALE MESHMAP=MightyMo3rd X=0.055 Y=0.055 Z=0.11

#exec MESHMAP SETTEXTURE MESHMAP=MightyMo3rd NUM=1 TEXTURE=mighty_mo_pu_01


//POV
// Right hand

#exec MESH IMPORT MESH=MMR ANIVFILE=g:\NerfRes\weaponanimation\MODELS\MightyMo_a.3d DATAFILE=g:\NerfRes\weaponanimation\MODELS\MightyMo_d.3d X=0 Y=0 Z=0
//#exec MESH ORIGIN MESH=MMR X=400 Y=10 Z=-50 YAW=-5 PITCH=10 ROLL=0
#exec MESH ORIGIN MESH=MMR X=-20 Y=-20 Z=-75 YAW=-5 PITCH=5

#exec MESH SEQUENCE MESH=MMR SEQ=All                      STARTFRAME=0 NUMFRAMES=120
#exec MESH SEQUENCE MESH=MMR SEQ=select                   STARTFRAME=0 NUMFRAMES=34
#exec MESH SEQUENCE MESH=MMR SEQ=idle                     STARTFRAME=34 NUMFRAMES=30
#exec MESH SEQUENCE MESH=MMR SEQ=fire                     STARTFRAME=64 NUMFRAMES=30
#exec MESH SEQUENCE MESH=MMR SEQ=down                     STARTFRAME=94 NUMFRAMES=26
#exec MESH SEQUENCE MESH=MMR SEQ=still                    STARTFRAME=63 NUMFRAMES=1


#exec MESHMAP NEW   MESHMAP=MMR MESH=MMR
#exec MESHMAP SCALE MESHMAP=MMR X=0.02 Y=0.02 Z=0.04

#exec MESHMAP SETTEXTURE MESHMAP=MMR NUM=1 TEXTURE=NerfRes.Skins.Hand_back
#exec MESHMAP SETTEXTURE MESHMAP=MMR NUM=2 TEXTURE=NerfRes.Skins.Hand_in
#exec MESHMAP SETTEXTURE MESHMAP=MMR NUM=3 TEXTURE=mighty_mo_pu_01

// Left hand

#exec MESH IMPORT MESH=MML ANIVFILE=g:\NerfRes\weaponanimation\MODELS\MightyMo_a.3d DATAFILE=g:\NerfRes\weaponanimation\MODELS\MightyMo_d.3d unmirror=1
//#exec MESH ORIGIN MESH=MML X=-400 Y=10 Z=-50 YAW=132 PITCH=-10 ROLL=0
#exec MESH ORIGIN MESH=MML X=20 Y=-20 Z=-75 YAW=132 PITCH=-5

#exec MESH SEQUENCE MESH=MML SEQ=All                      STARTFRAME=0 NUMFRAMES=120
#exec MESH SEQUENCE MESH=MML SEQ=select                   STARTFRAME=0 NUMFRAMES=34
#exec MESH SEQUENCE MESH=MML SEQ=idle                     STARTFRAME=34 NUMFRAMES=30
#exec MESH SEQUENCE MESH=MML SEQ=fire                     STARTFRAME=64 NUMFRAMES=30
#exec MESH SEQUENCE MESH=MML SEQ=down                     STARTFRAME=94 NUMFRAMES=26
#exec MESH SEQUENCE MESH=MML SEQ=still                    STARTFRAME=63 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=MML MESH=MML
#exec MESHMAP SCALE MESHMAP=MML X=0.02 Y=0.02 Z=0.04

#exec MESHMAP SETTEXTURE MESHMAP=MML NUM=1 TEXTURE=NerfRes.Skins.Hand_back
#exec MESHMAP SETTEXTURE MESHMAP=MML NUM=2 TEXTURE=NerfRes.Skins.Hand_in
#exec MESHMAP SETTEXTURE MESHMAP=MML NUM=3 TEXTURE=mighty_mo_pu_01

// Audio sound effects
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\pickups\pkwpmo.wav" NAME="MMpickS" GROUP="MightyMo"
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\weapons\wmo.wav" NAME="MMfireS" GROUP="MightyMo"
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\weapons\wmoalt.wav" NAME="MMAltfireS" GROUP="MightyMo"

var bool bDetBall;
var MMDetBall DetBall;
var bool bAltFireOff;

/*
replication
{
	// Things the client should send to the server
	reliable if ( Role<ROLE_Authority )
		bDetBallActive;
}
*/

function float RateSelf( out int bUseAltMode )
{
	local float EnemyDist;
	local bool bRetreating;
	local vector EnemyDir;

	//TraceLog(class, 10, "in RateSelf(...)");

	if (AmmoType.AmmoAmount <=0)
		return -2;
	if (Pawn(Owner).Enemy == None)
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

	if ( EnemyDist < -1.5 * EnemyDir.Z )
		bUseAltMode = int( FRand() < 0.5 );
	else if ( Pawn(Owner).Location.Z < Pawn(Owner).Enemy.Location.Z )
		bUseAltMode = 0;
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

	//TraceLog(class, 10, "in SuggestAttackStyle()");

	EnemyDist = VSize(Pawn(Owner).Enemy.Location - Owner.Location);
	if ( EnemyDist < 400 )
		return -0.6;
	else
		return -0.2;
}

function setHand(float Hand)
{
	local rotator newRot;

	Super.SetHand(Hand);
	if ( Hand == 1 )
		Mesh = Mesh(DynamicLoadObject("NerfWeapon.MML", class'Mesh'));
	else if ( Hand == -1 )
		Mesh = Mesh'MMR';
	else
	{
		PlayerViewOffset.Y = 0;
		FireOffset.Y = 0;
		bHideWeapon = true;
	}
}

///////////////////////////////////////////////////////
function AltFire( float Value )
{
//	log(class$ " WES: DetBall" @DetBall);
	if( DetBall == None)
	{
		bPointing=True;
		if( AmmoType.UseAmmo( 1 ) )
		{
//			log(class$ " WES: goto altfiring state");
			GoToState( 'AltFiring' );
		}
	}
	else
	{
//		log(class$ " WES: Human Destroy");
		if( !Owner.IsA( 'NerfBots' ) )
		{
			DestroyBall();
		}
	}
}

simulated function DestroyBall()
{
//	log(class$ " WES: Explode in DestroyBall function");
	DetBall.explode( DetBall.Location + Vect( 0, 0, 1 ) * 16, Normal(DetBall.Location + Vect( 0, 0, 1 ) * 16));
	DetBall = None;
}

state AltFiring
{
	
	function Fire(float F) 
	{
//		log(class$ " WES: fire at altfiring state");
	}
	function AltFire(float F) 
	{
//		log(class$ " WES: altfire at altfiring state");
	}

	function BeginState()
	{
		local vector FireLocation, StartLoc, X, Y, Z;
		local float Angle;
						
//		log(class$ " WES: goto altfiring beginstate");
		if( bDetBall && Owner.IsA( 'NerfBots' ) )
		{
			GotoState( 'Idle' );
		}
		GetAxes( Pawn( Owner ).ViewRotation, X , Y, Z );
		StartLoc = Owner.Location + CalcDrawOffset(); 
		FireLocation = StartLoc + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z; 
		Firelocation = StartLoc - 10.78*Z + X * (10 + 8 * FRand());
	
		AdjustedAim = Pawn( Owner ).AdjustToss( AltProjectileSpeed, FireLocation, AimError, True, bAltWarnTarget );	
		if( PlayerPawn( Owner ) != None )
		{
			AdjustedAim = Pawn( Owner ).ViewRotation;
		}

//		log(class$ " WES: create DetBall");
	
		DetBall = Spawn( class 'MMDetBall',, '', FireLocation, AdjustedAim );
		DetBall.Launcher = Self;
		PlayAltFiring();	

		if( PlayerPawn(Owner) != None )
		{
			PlayerPawn( Owner ).ShakeView( ShakeTime, ShakeMag * 1.5, ShakeVert * 1.5 ); 
		}
//		log(class$ " WES: Seting Player Altfire button to none" @Pawn(Owner).bAltFire);
		Pawn( Owner ).bAltFire = 0;
		Disable( 'Tick' );

//		log(class$ " WES: pause for half second" );
		
		SetTimer( 0.5, false );

	}
	simulated function Timer()
	{
		enable( 'Tick' );
	}
	
	simulated function Tick( float DeltaTime )
	{
//		log(class$ " WES: Ticking Altfire button down?" @Pawn(Owner).bAltFire);
		if( Pawn( Owner ).bAltFire != 0 )
		{
//			log(class$ " WES: Altfire button down. Explode" @Pawn(Owner).bAltFire);
			DetBall.explode( DetBall.Location , Vect( 0, 0, 1 ));
			DetBall = None;
			bDetBall= False;
			Disable( 'Tick' );
		}
	}
							
Begin:
	FinishAnim();
	Sleep( 0.2 );
	Finish();
}

///////////////////////////////////////////////////////
simulated function PlayFiring()
{
	Owner.PlaySound(FireSound, SLOT_Misc,Pawn(Owner).SoundDampening);
	PlayAnim('fire', 1.0, 0.05);
}

///////////////////////////////////////////////////////
simulated function PlayAltFiring()
{
	Owner.PlaySound(AltFireSound, SLOT_Misc,Pawn(Owner).SoundDampening);
	PlayAnim('fire', 0.75, 0.05);
}

///////////////////////////////////////////////////////
simulated function PlayIdleAnim()
{
	PlayAnim('idle',0.25,0.05);
}
///////////////////////////////////////////////////////////

function Projectile ProjectileFire(class<projectile> ProjClass, float ProjSpeed, bool bWarn)
{
	local Vector Start, X,Y,Z;
	local Pawn PawnOwner;

	PawnOwner = Pawn(Owner);
	Owner.MakeNoise(PawnOwner.SoundDampening);
	GetAxes(PawnOwner.ViewRotation,X,Y,Z);
	Start = Owner.Location + CalcDrawOffset() + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z; 
	AdjustedAim = PawnOwner.AdjustToss(ProjSpeed, Start, AimError, True, bWarn);	
	return Spawn(ProjClass,,, Start,AdjustedAim);	
}
///////////////////////////////////////////////////////

defaultproperties
{
     WeaponDescription=<
     AmmoName=Class'NerfWeapon.MMBallPick'
     PickupAmmoCount=5
     bAltWarnTarget=True
     FireOffset=(X=30.000000,Y=-10.000000,Z=-4.500000)
     ProjectileClass=Class'NerfWeapon.MMBall'
     AltProjectileClass=Class'NerfWeapon.MMDetBall'
     shakemag=500.000000
     shaketime=0.300000
     shakevert=10.000000
     AIRating=0.400000
     RefireRate=0.800000
     FireSound=Sound'NerfWeapon.MightyMo.MMfireS'
     AltFireSound=Sound'NerfWeapon.MightyMo.MMAltfireS'
     AutoSwitchPriority=5
     InventoryGroup=5
     PickupMessage=You picked up the NerfCannon
     ItemName=NerfCannon
     PlayerViewOffset=(X=7.000000,Y=-1.500000,Z=-4.500000)
     PlayerViewMesh=LodMesh'NerfWeapon.MMR'
     PickupViewMesh=LodMesh'NerfWeapon.MightyMopick'
     ThirdPersonMesh=LodMesh'NerfWeapon.MightyMo3rd'
     PickupSound=Sound'NerfWeapon.MightyMo.MMpickS'
     Mesh=LodMesh'NerfWeapon.MightyMopick'
     bNoSmooth=False
     SoundRadius=64
     SoundVolume=255
     CollisionRadius=40.000000
     CollisionHeight=28.000000
     Mass=50.000000
}
