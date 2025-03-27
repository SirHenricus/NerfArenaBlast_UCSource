//=============================================================================
// pulsator.
//=============================================================================
class pulsator expands NerfWeapon;

//Pickup
#exec MESH IMPORT MESH=pulsatorPick ANIVFILE=g:\NerfRes\weaponmesh\MODELS\pulsator_pu_a.3d DATAFILE=g:\NerfRes\weaponmesh\MODELS\pulsator_pu_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=pulsatorPick X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=pulsatorPick SEQ=All                      STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=pulsatorPick SEQ=idle                      STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=pulsatorPick MESH=pulsatorPick
#exec MESHMAP SCALE MESHMAP=pulsatorPick X=0.08 Y=0.08 Z=0.16 

#exec TEXTURE IMPORT NAME=pulsator_pu_01 FILE=g:\NerfRes\weaponmesh\Textures\pulsator_pu_01.PCX GROUP=Skins FLAGS=2	//big p

#exec MESHMAP SETTEXTURE MESHMAP=pulsatorPick NUM=1 TEXTURE=pulsator_pu_01

//3rd persoin
#exec MESH IMPORT MESH=pulsator3rd ANIVFILE=g:\NerfRes\weaponmesh\MODELS\pulsator_pu_a.3d DATAFILE=g:\NerfRes\weaponmesh\MODELS\pulsator_pu_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=pulsator3rd X=200 Y=0 Z=50 YAW=128 PITCH=-40

#exec MESH SEQUENCE MESH=pulsator3rd SEQ=All      STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=pulsator3rd MESH=pulsator3rd
#exec MESHMAP SCALE MESHMAP=pulsator3rd X=0.04 Y=0.04 Z=0.08

#exec MESHMAP SETTEXTURE MESHMAP=pulsator3rd NUM=1 TEXTURE=pulsator_pu_01

//Right handed

#exec MESH IMPORT MESH=pulsatorR ANIVFILE=g:\NerfRes\weaponanimation\MODELS\pulsator_a.3d DATAFILE=g:\NerfRes\weaponanimation\MODELS\pulsator_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=pulsatorR X=100 Y=0 Z=-50 YAW=128 PITCH=-5 ROLL=5

#exec MESH SEQUENCE MESH=pulsatorR SEQ=All                      STARTFRAME=0 NUMFRAMES=81
#exec MESH SEQUENCE MESH=pulsatorR SEQ=select                   STARTFRAME=0 NUMFRAMES=29
#exec MESH SEQUENCE MESH=pulsatorR SEQ=idle                     STARTFRAME=29 NUMFRAMES=3
#exec MESH SEQUENCE MESH=pulsatorR SEQ=fire                     STARTFRAME=32 NUMFRAMES=9
#exec MESH SEQUENCE MESH=pulsatorR SEQ=fire_alt                 STARTFRAME=41 NUMFRAMES=9
#exec MESH SEQUENCE MESH=pulsatorR SEQ=down                     STARTFRAME=50 NUMFRAMES=31
#exec MESH SEQUENCE MESH=pulsatorR SEQ=still                    STARTFRAME=31 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=pulsatorR MESH=pulsatorR
#exec MESHMAP SCALE MESHMAP=pulsatorR X=0.06 Y=0.06 Z=0.12

#exec MESHMAP SETTEXTURE MESHMAP=pulsatorR NUM=1 TEXTURE=NerfRes.Skins.Hand_back
#exec MESHMAP SETTEXTURE MESHMAP=pulsatorR NUM=2 TEXTURE=NerfRes.Skins.Hand_in
#exec MESHMAP SETTEXTURE MESHMAP=pulsatorR NUM=3 TEXTURE=pulsator_pu_01


//Left handed

#exec MESH IMPORT MESH=pulsatorL ANIVFILE=g:\NerfRes\weaponanimation\MODELS\pulsator_a.3d DATAFILE=g:\NerfRes\weaponanimation\MODELS\pulsator_d.3d unmirror=1
#exec MESH ORIGIN MESH=pulsatorL X=-100 Y=0 Z=-50 PITCH=5 ROLL=5

#exec MESH SEQUENCE MESH=pulsatorL SEQ=All                      STARTFRAME=0 NUMFRAMES=81
#exec MESH SEQUENCE MESH=pulsatorL SEQ=select                   STARTFRAME=0 NUMFRAMES=29
#exec MESH SEQUENCE MESH=pulsatorL SEQ=idle                     STARTFRAME=29 NUMFRAMES=3
#exec MESH SEQUENCE MESH=pulsatorL SEQ=fire                     STARTFRAME=32 NUMFRAMES=9
#exec MESH SEQUENCE MESH=pulsatorL SEQ=fire_alt                 STARTFRAME=41 NUMFRAMES=9
#exec MESH SEQUENCE MESH=pulsatorL SEQ=down                     STARTFRAME=50 NUMFRAMES=31
#exec MESH SEQUENCE MESH=pulsatorL SEQ=still                    STARTFRAME=31 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=pulsatorL MESH=pulsatorL
#exec MESHMAP SCALE MESHMAP=pulsatorL X=0.06 Y=0.06 Z=0.12

#exec MESHMAP SETTEXTURE MESHMAP=pulsatorL NUM=1 TEXTURE=NerfRes.Skins.Hand_back
#exec MESHMAP SETTEXTURE MESHMAP=pulsatorL NUM=2 TEXTURE=NerfRes.Skins.Hand_in
#exec MESHMAP SETTEXTURE MESHMAP=pulsatorL NUM=3 TEXTURE=pulsator_pu_01

// Audio sound effects	`````						
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\pickups\pkwpuls.wav" NAME="PulspickS" GROUP="Puls"
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\weapons\wpulsalt.wav" NAME="PulsfireS" GROUP="Puls"
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\weapons\wpulstr.wav" NAME="PulsAltfireS" GROUP="Puls"

// return delta to combat style
function float SuggestAttackStyle()
{
	local float EnemyDist;

	EnemyDist = VSize(Pawn(Owner).Enemy.Location - Owner.Location);
	if ( EnemyDist < 1000 )
		return 0.4;
	else
		return 0;
}

function float RateSelf( out int bUseAltMode )
{
	local Pawn P;

	if ( AmmoType.AmmoAmount <=0 )
		return -2;

	P = Pawn(Owner);
	if ( (P.Enemy == None) || (Owner.IsA('NerfBots')) )
	{
		bUseAltMode = 0;
		return AIRating;
	}

	return AIRating;
}

function setHand(float Hand)
{
	local rotator newRot;

	Super.SetHand(Hand);
	if ( Hand == 1 )
		Mesh = Mesh(DynamicLoadObject("NerfWeapon.pulsatorL", class'Mesh'));
	else if ( Hand == -1 )
		Mesh = Mesh'pulsatorR';
	else
	{
		PlayerViewOffset.Y = 0;
		FireOffset.Y = 0;
		bHideWeapon = true;
	}
}

///////////////////////////////////////////////////////
function Projectile ProjectileFire(class<projectile> ProjClass, float ProjSpeed, bool bWarn)
{
	local Vector Start, X,Y,Z;

	Owner.MakeNoise(Pawn(Owner).SoundDampening);
	GetAxes(Pawn(Owner).ViewRotation,X,Y,Z);
	Start = Owner.Location + CalcDrawOffset() + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z; 
	AdjustedAim = Pawn(Owner).AdjustAim(ProjSpeed, Start, AimError, True, bWarn);	
	if (PlayerPawn(Owner) != None)	
		AdjustedAim.YAW = AdjustedAim.YAW + (PlayerPawn(Owner).Handedness * AimAdjust);
	AdjustedAim.PITCH = AdjustedAim.PITCH + AimAdjust;
	return Spawn(ProjClass,,, Start,AdjustedAim);	
}

function TraceFire( float Accuracy )
{
	local vector HitLocation, HitNormal, StartTrace, EndTrace, X,Y,Z;
	local actor Other;
	local Pawn PawnOwner;

	PawnOwner = Pawn(Owner);

	Owner.MakeNoise(PawnOwner.SoundDampening);
	GetAxes(PawnOwner.ViewRotation,X,Y,Z);
	StartTrace = Owner.Location + CalcDrawOffset() + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z; 
	AdjustedAim = PawnOwner.AdjustAim(100000, StartTrace, 4.75*AimError, False, False);	
	if (PlayerPawn(Owner) != None)	
		AdjustedAim.YAW = AdjustedAim.YAW + (PlayerPawn(Owner).Handedness * AimAdjust);
	AdjustedAim.PITCH = AdjustedAim.PITCH + AimAdjust;
	EndTrace = StartTrace + Accuracy * (FRand() - 0.5 )* Y * 1000
		+ Accuracy * (FRand() - 0.5 ) * Z * 1000;
	X = vector(AdjustedAim);
	EndTrace += (10000 * X); 
	Other = PawnOwner.TraceShot(HitLocation,HitNormal,EndTrace,StartTrace);
	ProcessTraceHit(Other, HitLocation, HitNormal, X,Y,Z);
}

function ProcessTraceHit(Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z)
{
	local int rndDam;

	if ( PlayerPawn(Owner) != None )
		PlayerPawn(Owner).ShakeView(ShakeTime, ShakeMag, ShakeVert);
	
	if (Other == Level) 
		Spawn(class'BallHitExp',,, HitLocation+HitNormal*9, Rotator(HitNormal));
	else if ( (Other!=self) && (Other!=Owner) && (Other != None) ) 
	{
		if ( Other.IsA('Pawn') && (FRand() < 0.2) )
			Pawn(Other).WarnTarget(Pawn(Owner), 500, X);

		rndDam = 8;
		if ( FRand() < 0.2 )
			X *= 2;
		Other.TakeDamage(rndDam, Pawn(Owner), HitLocation, rndDam*500.0*X, 'shot');
	}
}

function AltFire( float Value )
{
	local float ShotAccuracy;

	if (AmmoType.UseAmmo(1))
	{
		ShotAccuracy = 0.1;
		GotoState('AltFiring');
		bPointing=True;
		bCanClientFire = true;
		ClientAltFire(Value);

// Firing twice.

		TraceFire(ShotAccuracy);
		TraceFire(ShotAccuracy);
	}
}

simulated function PlayAltFiring()
{
	Owner.PlaySound(AltFireSound, SLOT_Misc,Pawn(Owner).SoundDampening);
	PlayAnim('fire', 1.5, 0.05);
}


///////////////////////////////////////////////////////
simulated function PlayFiring()
{
	Owner.PlaySound(FireSound, SLOT_Misc,Pawn(Owner).SoundDampening);
	PlayAnim('fire_alt', 0.25, 0.05);
}

///////////////////////////////////////////////////////

defaultproperties
{
     WeaponDescription=<
     AimAdjust=128.000000
     AmmoName=Class'NerfWeapon.BallAmmo'
     PickupAmmoCount=30
     bAltWarnTarget=True
     FireOffset=(X=20.000000,Y=-16.000000,Z=-8.000000)
     ProjectileClass=Class'NerfWeapon.SpinBall'
     shakemag=120.000000
     AIRating=0.600000
     RefireRate=0.900000
     AltRefireRate=0.700000
     FireSound=Sound'NerfWeapon.Puls.PulsfireS'
     AltFireSound=Sound'NerfWeapon.Puls.PulsAltfireS'
     AutoSwitchPriority=6
     InventoryGroup=6
     PickupMessage=You picked up the Pulsator
     ItemName=Pulsator
     PlayerViewOffset=(X=12.000000,Y=-7.000000,Z=-7.000000)
     PlayerViewMesh=LodMesh'NerfWeapon.pulsatorR'
     PlayerViewScale=0.250000
     PickupViewMesh=LodMesh'NerfWeapon.pulsatorPick'
     ThirdPersonMesh=LodMesh'NerfWeapon.pulsator3rd'
     PickupSound=Sound'NerfWeapon.Puls.PulspickS'
     Mesh=LodMesh'NerfWeapon.pulsatorPick'
     bNoSmooth=False
     SoundRadius=64
     SoundVolume=255
     CollisionRadius=34.000000
     CollisionHeight=28.000000
     Mass=30.000000
}
