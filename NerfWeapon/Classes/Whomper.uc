//=============================================================================
// Whomper.
//=============================================================================
class Whomper expands NerfWeapon;

// Pickup version
#exec MESH IMPORT MESH=Whomperpick ANIVFILE=g:\NerfRes\weaponMesh\MODELS\whomper_pu_a.3d DATAFILE=g:\NerfRes\weaponMesh\MODELS\whomper_pu_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=Whomperpick X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=Whomperpick SEQ=All                      STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Whomperpick SEQ=idle                      STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=Whomperpick MESH=Whomperpick
#exec MESHMAP SCALE MESHMAP=Whomperpick X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=whomper_pu_01 FILE=g:\NerfRes\weaponMesh\Textures\whomper_pu_01.PCX GROUP=Skins FLAGS=2	//whompernew

#exec MESHMAP SETTEXTURE MESHMAP=Whomperpick NUM=1 TEXTURE=whomper_pu_01

//3rd person
#exec MESH IMPORT MESH=Whomper3rd ANIVFILE=g:\NerfRes\weaponMesh\MODELS\whomper_pu_a.3d DATAFILE=g:\NerfRes\weaponMesh\MODELS\whomper_pu_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=Whomper3rd X=-100 Y=0 Z=50 PITCH=40 ROLL=-25

#exec MESH SEQUENCE MESH=Whomper3rd SEQ=All                      STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=Whomper3rd MESH=Whomper3rd
#exec MESHMAP SCALE MESHMAP=Whomper3rd X=0.065 Y=0.065 Z=0.13

#exec MESHMAP SETTEXTURE MESHMAP=Whomper3rd NUM=1 TEXTURE=whomper_pu_01


//POV
//Right handed

#exec MESH IMPORT MESH=WhomR ANIVFILE=g:\NerfRes\weaponanimation\MODELS\whomper_a.3d DATAFILE=g:\NerfRes\weaponanimation\MODELS\whomper_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=WhomR X=-200 Y=-150 Z=10 YAW=128

#exec MESH SEQUENCE MESH=WhomR SEQ=All                      STARTFRAME=0 NUMFRAMES=169
#exec MESH SEQUENCE MESH=WhomR SEQ=select                   STARTFRAME=0 NUMFRAMES=37
#exec MESH SEQUENCE MESH=WhomR SEQ=idle01                   STARTFRAME=37 NUMFRAMES=25
#exec MESH SEQUENCE MESH=WhomR SEQ=idle03                   STARTFRAME=62 NUMFRAMES=31
#exec MESH SEQUENCE MESH=WhomR SEQ=fire_alt                 STARTFRAME=93 NUMFRAMES=27
#exec MESH SEQUENCE MESH=WhomR SEQ=fire                     STARTFRAME=120 NUMFRAMES=17
#exec MESH SEQUENCE MESH=WhomR SEQ=down                     STARTFRAME=137 NUMFRAMES=31
#exec MESH SEQUENCE MESH=WhomR SEQ=still                    STARTFRAME=168 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=WhomR MESH=WhomR
#exec MESHMAP SCALE MESHMAP=WhomR X=0.08 Y=0.08 Z=0.16

#exec MESHMAP SETTEXTURE MESHMAP=WhomR NUM=1 TEXTURE=NerfRes.Skins.Hand_back
#exec MESHMAP SETTEXTURE MESHMAP=WhomR NUM=2 TEXTURE=NerfRes.Skins.Hand_in
#exec MESHMAP SETTEXTURE MESHMAP=WhomR NUM=3 TEXTURE=whomper_pu_01

//Left handed

#exec MESH IMPORT MESH=WhomL ANIVFILE=g:\NerfRes\weaponanimation\MODELS\whomper_a.3d DATAFILE=g:\NerfRes\weaponanimation\MODELS\whomper_d.3d unmirror=1
#exec MESH ORIGIN MESH=WhomL X=200 Y=-150 Z=10 

#exec MESH SEQUENCE MESH=WhomL SEQ=All                      STARTFRAME=0 NUMFRAMES=169
#exec MESH SEQUENCE MESH=WhomL SEQ=select                   STARTFRAME=0 NUMFRAMES=37
#exec MESH SEQUENCE MESH=WhomL SEQ=idle01                   STARTFRAME=37 NUMFRAMES=25
#exec MESH SEQUENCE MESH=WhomL SEQ=idle03                   STARTFRAME=62 NUMFRAMES=31
#exec MESH SEQUENCE MESH=WhomL SEQ=fire_alt                 STARTFRAME=93 NUMFRAMES=27
#exec MESH SEQUENCE MESH=WhomL SEQ=fire                     STARTFRAME=120 NUMFRAMES=17
#exec MESH SEQUENCE MESH=WhomL SEQ=down                     STARTFRAME=137 NUMFRAMES=31
#exec MESH SEQUENCE MESH=WhomL SEQ=still                    STARTFRAME=168 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=WhomL MESH=WhomL
#exec MESHMAP SCALE MESHMAP=WhomL X=0.08 Y=0.08 Z=0.16

#exec MESHMAP SETTEXTURE MESHMAP=WhomL NUM=1 TEXTURE=NerfRes.Skins.Hand_back
#exec MESHMAP SETTEXTURE MESHMAP=WhomL NUM=2 TEXTURE=NerfRes.Skins.Hand_in
#exec MESHMAP SETTEXTURE MESHMAP=WhomL NUM=3 TEXTURE=whomper_pu_01

// Audio sound effects
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\pickups\pkwpwmpr.wav" NAME="WhomperpickS" GROUP="Whomper"
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\weapons\wwmp.wav" NAME="WhomperfireS" GROUP="Whomper"
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\weapons\wwmpalt.wav" NAME="WhomperAltfireS" GROUP="Whomper"

#exec MESH NOTIFY MESH=WhomR SEQ=idle03 TIME=0.001 FUNCTION=FireSoundTrigger
#exec MESH NOTIFY MESH=WhomL SEQ=idle03 TIME=0.001 FUNCTION=FireSoundTrigger

var Ccball CB;

function Projectile ProjectileFire(class<projectile> ProjClass, float ProjSpeed, bool bWarn)
{
	local Vector Start, X,Y,Z;

	Owner.MakeNoise(Pawn(Owner).SoundDampening);
	GetAxes(Pawn(owner).ViewRotation,X,Y,Z);
	Start = Owner.Location + CalcDrawOffset() + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z; 
	AdjustedAim = pawn(owner).AdjustAim(ProjSpeed, Start, AimError, True, bWarn);	
	return Spawn(ProjClass,,, Start,AdjustedAim);	
}

function setHand(float Hand)
{
	local rotator newRot;

	Super.SetHand(Hand);
	if ( Hand == 1 )
		Mesh = Mesh(DynamicLoadObject("NerfWeapon.WhomL", class'Mesh'));
	else if ( Hand == -1 )
		Mesh = Mesh'WhomR';
	else
	{
		PlayerViewOffset.Y = 0;
		FireOffset.Y = 0;
		bHideWeapon = true;
	}
}

///////////////////////////////////////////////////////
simulated function FireSoundTrigger()
{
	Owner.PlaySound(FireSound, SLOT_Misc,Pawn(Owner).SoundDampening);
}


simulated function PlayFiring()
{
	PlayAnim('Fire', 1.0, 0.05);
}

simulated function PlayOpenFiring()
{
	PlayAnim('idle03', 1.0, 0.05);
}

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
	if ( AmmoType.UseAmmo(1) )
	{
		bPointing=True;
		bCanClientFire = true;
		ClientAltFire(Value);
		if ( bRapidFire || (FiringSpeed > 0) )
			Pawn(Owner).PlayRecoil(FiringSpeed);
	}
}

state NormalFire
{
	function AnimEnd()
	{
	}

	simulated function Tick (float deltatime)
	{
		local Vector Start, X, Y, Z;

		GetAxes(Pawn(owner).ViewRotation,X,Y,Z);
		start = Owner.Location + calcDrawOffset() + 30.0 * X + FireOffset.Y * Y + FireOffset.Z * Z;
		CB.setrotation(pawn(owner).viewrotation);
		CB.setlocation(start);
		if (CB.bomb)
		{
			if ( PlayerPawn(Owner) != None )
			{
				PlayerPawn(Owner).ClientInstantFlash( -0.4, vect( 370, 580, 190));
				PlayerPawn(Owner).ShakeView(ShakeTime, ShakeMag, ShakeVert);
			}
			bPointing=True;
			PlayFiring();
			Gotostate('FireBAP');
			ProjectileFire(ProjectileClass, ProjectileSpeed, bWarnTarget);
			Disable('Tick');
		}
	}

	simulated function BeginState()
	{
		local Vector Start, X, Y, Z;

		GetAxes(Pawn(owner).ViewRotation,X,Y,Z);
		start = Owner.Location + calcDrawOffset() + 30.0 * X + FireOffset.Y * Y + FireOffset.Z * Z;
		CB=spawn(class'ccball',,,Start);
		CB.setrotation(pawn(owner).viewrotation);
		CB.setlocation(start);
		PlayOpenFiring();
		Enable('Tick');
	}

Begin:
	FinishAnim();	
	Sleep(1.0);
	Finish();

}

state AltFiring
{
	function AnimEnd()
	{
	}

	simulated function Tick (float deltatime)
	{
		local Vector Start, X, Y, Z;

		GetAxes(Pawn(owner).ViewRotation,X,Y,Z);
		start = Owner.Location + calcDrawOffset() + 30.0 * X + FireOffset.Y * Y + FireOffset.Z * Z;
		CB.setrotation(pawn(owner).viewrotation);
		CB.setlocation(start);
		if (CB.bomb)
		{
			if ( PlayerPawn(Owner) != None )
			{
				PlayerPawn(Owner).ClientInstantFlash( -0.4, vect( 370, 580, 190));
				PlayerPawn(Owner).ShakeView(ShakeTime, ShakeMag, ShakeVert);
			}
			bPointing=True;
			PlayFiring();
			Gotostate('FireBAP');
			ProjectileFire(AltProjectileClass, AltProjectileSpeed, bWarnTarget);
			Disable('Tick');
		}
	}

	simulated function BeginState()
	{
		local Vector Start, X, Y, Z;

		GetAxes(Pawn(owner).ViewRotation,X,Y,Z);
		start = Owner.Location + calcDrawOffset() + 30.0 * X + FireOffset.Y * Y + FireOffset.Z * Z;
		CB=spawn(class'ccball',,,Start);
		CB.setrotation(pawn(owner).viewrotation);
		CB.setlocation(start);
		PlayOpenFiring();
		Enable('Tick');
	}

Begin:
	FinishAnim();	
	Sleep(1.0);
	Finish();

}

state FireBAP
{
Begin:
	FinishAnim();
	Sleep(1.0);
	Finish();
}

defaultproperties
{
     WeaponDescription=<
     AmmoName=Class'NerfI.ElectroPak'
     PickupAmmoCount=1
     bAltWarnTarget=True
     FireOffset=(X=12.000000,Y=-7.000000,Z=-6.000000)
     ProjectileClass=Class'NerfWeapon.WhomProj'
     AltProjectileClass=Class'NerfWeapon.BAP'
     shakemag=200.000000
     shaketime=0.300000
     AIRating=0.400000
     RefireRate=1.600000
     FireSound=Sound'NerfWeapon.Whomper.WhomperfireS'
     AltFireSound=Sound'NerfWeapon.Whomper.WhomperAltfireS'
     AutoSwitchPriority=10
     InventoryGroup=10
     PickupMessage=You picked up the Whomper
     ItemName=Whomper
     PlayerViewOffset=(X=10.000000,Y=-7.000000)
     PlayerViewMesh=LodMesh'NerfWeapon.WhomR'
     PlayerViewScale=0.250000
     PickupViewMesh=LodMesh'NerfWeapon.Whomperpick'
     ThirdPersonMesh=LodMesh'NerfWeapon.Whomper3rd'
     PickupSound=Sound'NerfWeapon.Whomper.WhomperpickS'
     Mesh=LodMesh'NerfWeapon.Whomperpick'
     bNoSmooth=False
     SoundRadius=64
     SoundVolume=255
     CollisionRadius=40.000000
     CollisionHeight=28.000000
     Mass=50.000000
}
