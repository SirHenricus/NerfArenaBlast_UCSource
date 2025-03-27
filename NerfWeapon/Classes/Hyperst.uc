//=================================================================================
// hyperst.	- by Wezo
// 
// Charateristic:	Shoots super high-speed shot that can knock out player in one 
//					hit but requires precise targeting.
// Primary fire :	Fire 1 instant hit blast. Used one ammo count.
// Alt fire	    :	Allow the player to zoom in for a sniper shot but it's less 
//					accurate. 
//=================================================================================
class hyperst expands NerfWeapon;

//pickup version
#exec MESH IMPORT MESH=hyperstpick ANIVFILE=g:\NerfRes\weaponmesh\MODELS\hypershot_pu_a.3d DATAFILE=g:\NerfRes\weaponmesh\MODELS\hypershot_pu_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=hyperstpick X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=hyperstpick SEQ=All                      STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=hyperstpick SEQ=idle                      STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=hyperstpick MESH=hyperstpick
#exec MESHMAP SCALE MESHMAP=hyperstpick X=0.1 Y=0.1 Z=0.2 

#exec TEXTURE IMPORT NAME=hypershot_pu_01 FILE=g:\NerfRes\weaponmesh\Textures\hypershot_pu_01.PCX GROUP=Skins FLAGS=2	//hsammocomp

#exec MESHMAP SETTEXTURE MESHMAP=hyperstpick NUM=1 TEXTURE=hypershot_pu_01

//3rd person
#exec MESH IMPORT MESH=hyperst3rd ANIVFILE=g:\NerfRes\weaponmesh\MODELS\hypershot_pu_a.3d DATAFILE=g:\NerfRes\weaponmesh\MODELS\hypershot_pu_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=hyperst3rd X=100 Y=50 Z=0 YAW=128 PITCH=-40

#exec MESH SEQUENCE MESH=hyperst3rd SEQ=All                      STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=hyperst3rd MESH=hyperst3rd
#exec MESHMAP SCALE MESHMAP=hyperst3rd X=0.05 Y=0.05 Z=0.1

#exec MESHMAP SETTEXTURE MESHMAP=hyperst3rd NUM=1 TEXTURE=hypershot_pu_01


//POV

//Right handed

#exec MESH IMPORT MESH=hyperstR ANIVFILE=g:\NerfRes\weaponanimation\MODELS\Hypershot_a.3d DATAFILE=g:\NerfRes\weaponanimation\MODELS\Hypershot_d.3d unmirror=1
#exec MESH ORIGIN MESH=hyperstR X=0 Y=0 Z=150 YAW=20 ROLL=5

#exec MESH SEQUENCE MESH=hyperstR SEQ=All                      STARTFRAME=0 NUMFRAMES=116
#exec MESH SEQUENCE MESH=hyperstR SEQ=select                   STARTFRAME=0 NUMFRAMES=29
#exec MESH SEQUENCE MESH=hyperstR SEQ=idle                     STARTFRAME=29 NUMFRAMES=41
#exec MESH SEQUENCE MESH=hyperstR SEQ=fire                     STARTFRAME=70 NUMFRAMES=19 RATE=18
#exec MESH SEQUENCE MESH=hyperstR SEQ=down                     STARTFRAME=89 NUMFRAMES=27
#exec MESH SEQUENCE MESH=hyperstR SEQ=still                    STARTFRAME=69 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=hyperstR MESH=hyperstR
#exec MESHMAP SCALE MESHMAP=hyperstR X=0.12 Y=0.15 Z=0.30

#exec MESHMAP SETTEXTURE MESHMAP=hyperstR NUM=1 TEXTURE=NerfRes.Skins.Hand_back
#exec MESHMAP SETTEXTURE MESHMAP=hyperstR NUM=2 TEXTURE=NerfRes.Skins.Hand_in
#exec MESHMAP SETTEXTURE MESHMAP=hyperstR NUM=3 TEXTURE=hypershot_pu_01
//Left handed

#exec MESH IMPORT MESH=hyperstL ANIVFILE=g:\NerfRes\weaponanimation\MODELS\Hypershot_a.3d DATAFILE=g:\NerfRes\weaponanimation\MODELS\Hypershot_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=hyperstL X=0 Y=0 Z=150 YAW=108 ROLL=5

#exec MESH SEQUENCE MESH=hyperstL SEQ=All                      STARTFRAME=0 NUMFRAMES=116
#exec MESH SEQUENCE MESH=hyperstL SEQ=select                   STARTFRAME=0 NUMFRAMES=29
#exec MESH SEQUENCE MESH=hyperstL SEQ=idle                     STARTFRAME=29 NUMFRAMES=41
#exec MESH SEQUENCE MESH=hyperstL SEQ=fire                     STARTFRAME=70 NUMFRAMES=19 RATE=18
#exec MESH SEQUENCE MESH=hyperstL SEQ=down                     STARTFRAME=89 NUMFRAMES=27
#exec MESH SEQUENCE MESH=hyperstL SEQ=still                    STARTFRAME=69 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=hyperstL MESH=hyperstL
#exec MESHMAP SCALE MESHMAP=hyperstL X=0.12 Y=0.15 Z=0.3

#exec MESHMAP SETTEXTURE MESHMAP=hyperstL NUM=1 TEXTURE=NerfRes.Skins.Hand_back
#exec MESHMAP SETTEXTURE MESHMAP=hyperstL NUM=2 TEXTURE=NerfRes.Skins.Hand_in
#exec MESHMAP SETTEXTURE MESHMAP=hyperstL NUM=3 TEXTURE=hypershot_pu_01

#exec TEXTURE IMPORT NAME=AimX FILE=g:\NerfRes\WeaponMesh\Textures\aim2.PCX GROUP="Icons" FLAGS=2 MIPS=OFF

// Audio sound effects
// ##nerf WES FIXME Sounds
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\pickups\pkwphyp.wav" NAME="HyperstpickS" GROUP="Hyperst"
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\weapons\whyp.wav" NAME="HyperstfireS" GROUP="Hyperst"
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\weapons\whypalt.wav" NAME="HyperstAltfireS" GROUP="Hyperst"

//var int NumFire;
//var bool bZoomOn;
var vector OwnerLocation;
var float StillTime, StillStart;

simulated function PostRender( canvas Canvas )
{
	local int i, numReadouts, OldClipX, OldClipY;
	local actor Target;
	local float Dist;
	local Vector Dir;
	local vector HitLocation, HitNormal, X, Y, Z, StartTrace, EndTrace;
	local PlayerPawn P;


	Dist=0;

	Super.PostRender(Canvas);
	P = PlayerPawn(Owner);
	if ( (P != None) && (P.DesiredFOV != P.DefaultFOV) ) 
	{
		bOwnsCrossHair = True;
		OldClipX = Canvas.ClipX;
		OldClipY = Canvas.ClipY;
		Canvas.SetPos( 0.5 * OldClipX - 128, 0.5 * OldClipY - 64 );
		Canvas.Style = 3;
		Canvas.DrawIcon(Texture'AimX', 1.0);

		Canvas.Font = Font(DynamicLoadObject("NerfRes.TinyRedFont", class'Font'));
		StartTrace = PlayerPawn(Owner).Location;
		StartTrace.Z += PlayerPawn(Owner).BaseEyeHeight;

		EndTrace = StartTrace + vector(PlayerPawn(Owner).ViewRotation) * 2000.0;
		Target = Trace(HitLocation, HitNormal, EndTrace, StartTrace, true);
		if (Pawn(Target) != None)
		{
			Dir = Target.Location - Location;
			Dist = VSize(Dir);
		}
		Canvas.SetPos(0.5 * OldClipX + 70, 0.5 * OldClipY - 60);
		Canvas.DrawText(Dist, true);
		Canvas.Style = 2;
	}
	else 
		bOwnsCrossHair = false;

}	

function float RateSelf( out int bUseAltMode )
{
	local float dist;

	if ( AmmoType.AmmoAmount <=0 )
		return -2;

	bUseAltMode = 0;
	if ( (NerfBots(Owner) != None))
		return AIRating + 1.15;
	if (  Pawn(Owner).Enemy != None )
	{
		dist = VSize(Pawn(Owner).Enemy.Location - Owner.Location);
		if ( dist > 1200 )
		{
			if ( dist > 2000 )
				return (AIRating + 0.75);
			return (AIRating + FMin(0.0001 * dist, 0.45)); 
		}
	}
	return AIRating;
}


function AltFire( float Value )
{
	GoToState('AltFiring');
}


function setHand(float Hand)
{
	local rotator newRot;

	Super.SetHand(Hand);
	if ( Hand == 1 )
		Mesh = Mesh(DynamicLoadObject("NerfWeapon.hyperstL", class'Mesh'));
	else if ( Hand == -1 )
		Mesh = Mesh'hyperstR';
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
	PlayAnim('Fire', 1.0,0.05);
}

///////////////////////////////////////////////////////

function Timer()
{
	local actor targ;
	local float bestAim, bestDist;
	local vector FireDir;
	local Pawn P;

	bestAim = 0.95;
	P = Pawn(Owner);
	if ( P == None )
	{
		GotoState('');
		return;
	}
	if ( VSize(P.Location - OwnerLocation) < 6 )
		StillTime += FMin(2.0, Level.TimeSeconds - StillStart);

	else
		StillTime = 0;
	StillStart = Level.TimeSeconds;
	OwnerLocation = P.Location;
	FireDir = vector(P.ViewRotation);
	targ = P.PickTarget(bestAim, bestDist, FireDir, Owner.Location);
	if ( Pawn(targ) != None )
	{
		SetTimer(1 + 4 * FRand(), false);
		bPointing = true;
		Pawn(targ).WarnTarget(P, 200, FireDir);
	}
	else 
	{
		SetTimer(0.4 + 1.6 * FRand(), false);
		if ( (P.bFire == 0) && (P.bAltFire == 0) )
			bPointing = false;
	}
}	

function ProcessTraceHit(Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z)
{
	local vector AimLocation, DirVector;
	local rotator AimRotation;
	local int NumPoints;

	if ( PlayerPawn(Owner) != None )
		PlayerPawn(Owner).ClientInstantFlash( -0.4, vect(650, 450, 190));

//	AimLocation = Owner.Location + CalcDrawOffset() + FireOffset.X * X + FireOffset.Y * 3.3 * Y + FireOffset.Z * Z * 3.0;
	AimLocation = Owner.Location + CalcDrawOffset() + FireOffset.X * X + FireOffset.Y * Y+ FireOffset.Z * Z;
	DirVector = HitLocation - AimLocation;
	NumPoints = VSize(DirVector)/70.0;
	AimLocation += DirVector/NumPoints;
	AimRotation = rotator(HitLocation-Owner.Location);
	if (NumPoints>12) NumPoints=12;
	if ( NumPoints>1 ) SpawnEffect(DirVector, NumPoints, AimRotation, AimLocation);

	if (Other == Level) 
		Spawn(class'HyperExp',,, HitLocation+HitNormal*9, Rotator(HitNormal));
	else if ( (Other != self) && (Other != Owner) && (Other != None) ) 
	{
		if ( Other.bIsPawn && (HitLocation.Z - Other.Location.Z > 0.5 * Other.CollisionHeight) 
			&& (instigator.IsA('PlayerPawn') || (instigator.IsA('NerfBots'))) )
			Other.TakeDamage(100, Pawn(Owner), HitLocation, 35000 * X, AltDamageType);
		else
			Other.TakeDamage(45,  Pawn(Owner), HitLocation, 30000.0*X, MyDamageType);	
		if ( !Other.IsA('Pawn'))
			spawn(class'HyperExp',,,HitLocation+HitNormal*9);
	}
}

function Finish()
{
	if ( (Pawn(Owner).bFire!=0) && (FRand() < 0.6) )
		Timer();
	Super.Finish();
}

state Idle
{

	function AltFire( float Value )
	{
		GoToState('AltFiring');
	}

	function Fire( float Value )
	{
		if (AmmoType.UseAmmo(1))
		{
			GotoState('NormalFire');
			if ( PlayerPawn(Owner) != None )
				PlayerPawn(Owner).ShakeView(ShakeTime, ShakeMag, ShakeVert);
			bPointing=True;
			if ( Owner.IsA('NerfBots') )
			{
				// simulate bot using zoom
				if ( FRand() < 0.65) 
					AimError = AimError/FClamp(StillTime, 3.0, 8.0);
				else if ( VSize(Owner.Location - OwnerLocation) < 6 )
					AimError = AimError/FClamp(0.5 * StillTime, 3.0, 5.0);
				else
					StillTime = 0;
			}
			TraceFire(0.0);
			AimError = Default.AimError;
			Pawn(Owner).PlayRecoil(FiringSpeed);
			PlayFiring();
			if ( Affector != None )
				Affector.FireEffect();
		}
	}


	function BeginState()
	{
		if (Pawn(Owner).bFire!=0) Fire(0.0);		
		bPointing = false;
		SetTimer(0.4 + 1.6 * FRand(), false);
		Super.BeginState();
	}

	function EndState()
	{	
		SetTimer(0.0, false);
		Super.EndState();
	}
	
Begin:
	bPointing=False;
	if ( (AmmoType != None) && (AmmoType.AmmoAmount<=0) ) 
		Pawn(Owner).SwitchToBestWeapon();  //Goto Weapon that has Ammo
	if ( Pawn(Owner).bFire!=0 ) Fire(0.0);
	Disable('AnimEnd');
	PlayIdleAnim();
}

///////////////////////////////////////////////////////
function SpawnEffect(Vector DirVector, int NumPoints, Rotator AimRotation, Vector AimLocation)
{
	local HyperEffect HP;
	
	HP = Spawn(class'HyperEffect',,,AimLocation,AimRotation);
	HP.MoveAmount = DirVector/NumPoints;
	HP.NumPuffs = NumPoints;
}

///////////////////////////////////////////////////////
state AltFiring
{

function Timer()
{
	if (Pawn(Owner).bAltFire == 0)
	{
		if (PlayerPawn(Owner) != None)
			PlayerPawn(Owner).StopZoom();
		SetTimer(0.0,False);
		GoToState('Idle');
	}
	else
		Super.Timer();
}

Begin:
	if ( Owner.IsA('PlayerPawn') )
	{
		PlayerPawn(Owner).ToggleZoom();
		SetTimer(0.075,True);
	}
	else
	{
		Pawn(Owner).bFire = 1;
		Pawn(Owner).bAltFire = 0;
		Global.Fire(0);
	}
}

///////////////////////////////////////////////////////////
simulated function PlayIdleAnim()
{
	PlayAnim('idle',1.0, 0.05);
}

defaultproperties
{
     WeaponDescription=<
     AmmoName=Class'NerfWeapon.RoxAmmoPickup'
     PickupAmmoCount=15
     bInstantHit=True
     bAltInstantHit=True
     bAltWarnTarget=True
     FiringSpeed=1.600000
     FireOffset=(X=12.000000,Y=-14.000000,Z=-10.000000)
     aimerror=4400.000000
     shakemag=400.000000
     shaketime=0.150000
     shakevert=8.000000
     AIRating=0.540000
     RefireRate=0.600000
     AltRefireRate=0.300000
     FireSound=Sound'NerfWeapon.Hyperst.HyperstfireS'
     AltFireSound=Sound'NerfWeapon.Hyperst.HyperstAltfireS'
     AutoSwitchPriority=8
     InventoryGroup=8
     PickupMessage=You picked up the Hyper Strike
     ItemName=Hyper Strike
     PlayerViewOffset=(X=11.000000,Y=-5.000000,Z=-8.000000)
     PlayerViewMesh=LodMesh'NerfWeapon.hyperstR'
     PlayerViewScale=0.250000
     PickupViewMesh=LodMesh'NerfWeapon.hyperstpick'
     ThirdPersonMesh=LodMesh'NerfWeapon.hyperst3rd'
     PickupSound=Sound'NerfWeapon.Hyperst.HyperstpickS'
     Mesh=LodMesh'NerfWeapon.hyperstpick'
     bNoSmooth=False
     SoundRadius=64
     SoundVolume=255
     CollisionRadius=34.000000
     CollisionHeight=28.000000
     Mass=25.000000
}
