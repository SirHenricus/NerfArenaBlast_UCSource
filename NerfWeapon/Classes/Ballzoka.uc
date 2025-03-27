//=============================================================================
// Ballzoka.
//=============================================================================
class Ballzoka expands NerfWeapon;

// pickup view
#exec MESH IMPORT MESH=Ballzokapick ANIVFILE=g:\NerfRes\weaponMesh\MODELS\ballzooka_pu_a.3d DATAFILE=g:\NerfRes\weaponMesh\MODELS\ballzooka_pu_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=Ballzokapick X=0 Y=0 Z=0 

#exec MESH SEQUENCE MESH=Ballzokapick SEQ=All                      STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Ballzokapick SEQ=idle                      STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=Ballzokapick MESH=Ballzokapick
#exec MESHMAP SCALE MESHMAP=Ballzokapick X=0.09 Y=0.09 Z=0.18  

#exec TEXTURE IMPORT NAME=balzoc_01 FILE=g:\NerfRes\weaponMesh\Textures\ballzooka_pu_01.PCX GROUP=Skins FLAGS=2	//Material #10

#exec MESHMAP SETTEXTURE MESHMAP=Ballzokapick NUM=1 TEXTURE=balzoc_01

// 3rd person view
#exec MESH IMPORT MESH=Ballzoka3rd ANIVFILE=g:\NerfRes\weaponMesh\MODELS\ballzooka_pu_a.3d DATAFILE=g:\NerfRes\weaponMesh\MODELS\ballzooka_pu_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=Ballzoka3rd X=400 Y=0 Z=50 YAW=128 PITCH=-40 

#exec MESH SEQUENCE MESH=Ballzoka3rd SEQ=All                      STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=Ballzoka3rd MESH=Ballzoka3rd
#exec MESHMAP SCALE MESHMAP=Ballzoka3rd X=0.045 Y=0.045 Z=0.09

#exec MESHMAP SETTEXTURE MESHMAP=Ballzoka3rd NUM=1 TEXTURE=balzoc_01


// POV
// Right hand

#exec MESH IMPORT MESH=BallzoR ANIVFILE=g:\NerfRes\weaponanimation\MODELS\ballzooka_a.3d DATAFILE=g:\NerfRes\weaponanimation\MODELS\ballzooka_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=BallzoR X=50 Y=75 Z=-75 YAW=128 ROLL=-1

#exec MESH SEQUENCE MESH=BallzoR SEQ=All                      STARTFRAME=0 NUMFRAMES=76
#exec MESH SEQUENCE MESH=BallzoR SEQ=select                   STARTFRAME=0 NUMFRAMES=25
#exec MESH SEQUENCE MESH=BallzoR SEQ=idle                     STARTFRAME=25 NUMFRAMES=7 Rate=15
#exec MESH SEQUENCE MESH=BallzoR SEQ=fire                     STARTFRAME=32 NUMFRAMES=21
#exec MESH SEQUENCE MESH=BallzoR SEQ=down                     STARTFRAME=53 NUMFRAMES=23
#exec MESH SEQUENCE MESH=BallzoR SEQ=still                    STARTFRAME=31 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=BallzoR MESH=BallzoR
#exec MESHMAP SCALE MESHMAP=BallzoR X=0.14 Y=0.21 Z=0.42

#exec MESHMAP SETTEXTURE MESHMAP=BallzoR NUM=1 TEXTURE=NerfRes.Skins.Hand_back
#exec MESHMAP SETTEXTURE MESHMAP=BallzoR NUM=2 TEXTURE=NerfRes.Skins.Hand_in
#exec MESHMAP SETTEXTURE MESHMAP=BallzoR NUM=3 TEXTURE=balzoc_01

// Left hand

#exec MESH IMPORT MESH=BallzoL ANIVFILE=g:\NerfRes\weaponanimation\MODELS\ballzooka_a.3d DATAFILE=g:\NerfRes\weaponanimation\MODELS\ballzooka_d.3d unmirror=1 ML
#exec MESH ORIGIN MESH=BallzoL X=-50 Y=75 Z=-75 ROLL=-1

#exec MESH SEQUENCE MESH=BallzoL SEQ=All                      STARTFRAME=0 NUMFRAMES=76
#exec MESH SEQUENCE MESH=BallzoL SEQ=select                   STARTFRAME=0 NUMFRAMES=25
#exec MESH SEQUENCE MESH=BallzoL SEQ=idle                     STARTFRAME=25 NUMFRAMES=7 Rate=15
#exec MESH SEQUENCE MESH=BallzoL SEQ=fire                     STARTFRAME=32 NUMFRAMES=21
#exec MESH SEQUENCE MESH=BallzoL SEQ=down                     STARTFRAME=53 NUMFRAMES=23
#exec MESH SEQUENCE MESH=BallzoL SEQ=still                    STARTFRAME=31 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=BallzoL MESH=BallzoL
#exec MESHMAP SCALE MESHMAP=BallzoL X=0.14 Y=0.21 Z=0.42

#exec MESHMAP SETTEXTURE MESHMAP=BallzoL NUM=1 TEXTURE=NerfRes.Skins.Hand_back
#exec MESHMAP SETTEXTURE MESHMAP=BallzoL NUM=2 TEXTURE=NerfRes.Skins.Hand_in
#exec MESHMAP SETTEXTURE MESHMAP=BallzoL NUM=3 TEXTURE=balzoc_01

// Audio sound effects
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\pickups\pkwpzook.wav" NAME="BallzopickS" GROUP="Ballzoka"
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\weapons\wzook.wav" NAME="BallzofireS" GROUP="Ballzoka"
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\weapons\wzookalt.wav" NAME="BallzoAltfireS" GROUP="Ballzoka"

function float RateSelf( out int bUseAltMode )
{
	local float EnemyDist;
	local bool bRetreating;
	local vector EnemyDir;

	if ( AmmoType.AmmoAmount <=0 )
		return -2;
	bUseAltMode = 0;
	if ( Pawn(Owner).Enemy == None )
		return AIRating;

	EnemyDir = Pawn(Owner).Enemy.Location - Owner.Location;
	EnemyDist = VSize(EnemyDir);
	if ( EnemyDist > 1400 )
		return 0;

	bRetreating = ( ((EnemyDir/EnemyDist) Dot Owner.Velocity) < -0.6 );
	if ( (EnemyDist > 600) && (EnemyDir.Z > -0.4 * EnemyDist) )
	{
		// only use if enemy not too far and retreating
		if ( !bRetreating )
			return 0;

		return AIRating;
	}

	bUseAltMode = int( FRand() < 0.3 );

	if ( bRetreating || (EnemyDir.Z < -0.7 * EnemyDist) )
		return (AIRating + 0.18);
	return AIRating;
}

// return delta to combat style
function float SuggestAttackStyle()
{
	return -0.3;
}

function float SuggestDefenseStyle()
{
	return -0.4;
}

function setHand(float Hand)
{
	local rotator newRot;

	Super.SetHand(Hand);
	if ( Hand == 1 )
		Mesh = Mesh(DynamicLoadObject("NerfWeapon.BallzoL", class'Mesh'));
	else if ( Hand == -1 )
		Mesh = Mesh'BallzoR';
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
state Idle
{
	function Timer()
	{
		if (FRand()>0.4) PlayIdleAnim();
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
///////////////////////////////////////////////////////

// DSL -- added "MyBall" kludge so winky_ and mover_ (actor) targets
// can process Touch, give credit to the instigator, and generally 
// act as if they were triggered by a ballzooka ball
function Projectile ProjectileFire(class<projectile> ProjClass, float ProjSpeed, bool bWarn)
{
	local Vector Start, X,Y,Z;
	local Pawn PawnOwner;
    local Ball MyBall;

	PawnOwner = Pawn(Owner);
	Owner.MakeNoise(PawnOwner.SoundDampening);
	GetAxes(PawnOwner.ViewRotation,X,Y,Z);
	Start = Owner.Location + CalcDrawOffset() + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z; 
	AdjustedAim = PawnOwner.AdjustToss(ProjSpeed, Start, AimError, True, bWarn);	

// DSL - this used to say:
//	return Spawn(ProjClass,,, Start,AdjustedAim);

// DSL - and now it says:
    if ( ProjClass == class'Ball' )
    {
    	MyBall = Spawn(class'Ball',,, Start,AdjustedAim);	
        MyBall.SetOwner(PawnOwner);
        return MyBall;
    }
    else
        return Spawn(ProjClass,,, Start,AdjustedAim);	
}

defaultproperties
{
     WeaponDescription=<
     AmmoName=Class'NerfWeapon.BallAmmo'
     PickupAmmoCount=15
     bWarnTarget=True
     bAltWarnTarget=True
     bSplashDamage=True
     FireOffset=(X=15.000000,Y=-5.000000,Z=-5.000000)
     ProjectileClass=Class'NerfWeapon.ball'
     AltProjectileClass=Class'NerfWeapon.Goo'
     shakemag=500.000000
     shaketime=0.300000
     shakevert=10.000000
     AIRating=0.600000
     RefireRate=0.250000
     AltRefireRate=0.050000
     FireSound=Sound'NerfWeapon.Ballzoka.BallzofireS'
     AltFireSound=Sound'NerfWeapon.Ballzoka.BallzoAltfireS'
     AutoSwitchPriority=2
     InventoryGroup=2
     PickupMessage=You got the Ballzooka
     ItemName=Ballzooka
     PlayerViewOffset=(X=1.900000,Y=-0.750000,Z=-1.890000)
     PlayerViewMesh=LodMesh'NerfWeapon.BallzoR'
     PlayerViewScale=0.050000
     BobDamping=0.985000
     PickupViewMesh=LodMesh'NerfWeapon.Ballzokapick'
     ThirdPersonMesh=LodMesh'NerfWeapon.Ballzoka3rd'
     PickupSound=Sound'NerfWeapon.Ballzoka.BallzopickS'
     Mesh=LodMesh'NerfWeapon.Ballzokapick'
     bNoSmooth=False
     CollisionRadius=40.000000
     CollisionHeight=28.000000
     Mass=50.000000
}
