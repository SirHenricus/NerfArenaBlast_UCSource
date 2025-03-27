//=============================================================================
// turbofir.	- by Wezo
// 
// Charateristic:	Machinegun like bursts of luminescent darts 
// Primary fire :	Rapid fire 1 luminescent dart 
// Alt fire	    :	Fire 8 luminescent darts at the same time. 
//=================================================================================
class turbofir expands NerfWeapon;

// pickup version
#exec MESH IMPORT MESH=turbofirpick ANIVFILE=g:\NerfRes\weaponMesh\MODELS\Wild_Fire_pu_a.3d DATAFILE=g:\NerfRes\weaponMesh\MODELS\Wild_Fire_pu_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=turbofirpick X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=turbofirpick SEQ=All                      STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=turbofirpick SEQ=idle                      STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=turbofirpick MESH=turbofirpick
#exec MESHMAP SCALE MESHMAP=turbofirpick X=0.06 Y=0.06 Z=0.12

#exec TEXTURE IMPORT NAME=Wild_Fire_pu_01 FILE=g:\NerfRes\weaponMesh\Textures\Wild_Fire_pu_01.PCX GROUP=Skins FLAGS=2	//wf

#exec MESHMAP SETTEXTURE MESHMAP=turbofirpick NUM=1 TEXTURE=Wild_Fire_pu_01

// 3rd person

#exec MESH IMPORT MESH=turbofir3rd ANIVFILE=g:\NerfRes\weaponMesh\MODELS\Wild_Fire_pu_a.3d DATAFILE=g:\NerfRes\weaponMesh\MODELS\Wild_Fire_pu_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=turbofir3rd X=150 Y=0 Z=50 YAW=128 PITCH=-48

#exec MESH SEQUENCE MESH=turbofir3rd SEQ=All  STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=turbofir3rd MESH=turbofir3rd
//#exec MESHMAP SCALE MESHMAP=turbofir3rd X=0.028 Y=0.028 Z=0.056
#exec MESHMAP SCALE MESHMAP=turbofir3rd X=0.03 Y=0.03 Z=0.06

#exec MESHMAP SETTEXTURE MESHMAP=turbofir3rd NUM=1 TEXTURE=Wild_Fire_pu_01


// POV

// Right handed

#exec MESH IMPORT MESH=turbofirR ANIVFILE=g:\NerfRes\WeaponAnimation\MODELS\Wild_Fire_a.3d DATAFILE=g:\NerfRes\WeaponAnimation\MODELS\Wild_Fire_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=turbofirR X=25 Y=-75 Z=-50 YAW=128

#exec MESH SEQUENCE MESH=turbofirR SEQ=All                      STARTFRAME=0 NUMFRAMES=89
#exec MESH SEQUENCE MESH=turbofirR SEQ=select                   STARTFRAME=0 NUMFRAMES=25
#exec MESH SEQUENCE MESH=turbofirR SEQ=idle                     STARTFRAME=25 NUMFRAMES=7
#exec MESH SEQUENCE MESH=turbofirR SEQ=fire                     STARTFRAME=32 NUMFRAMES=11
#exec MESH SEQUENCE MESH=turbofirR SEQ=fire_alt                 STARTFRAME=43 NUMFRAMES=15
#exec MESH SEQUENCE MESH=turbofirR SEQ=down                     STARTFRAME=58 NUMFRAMES=31
#exec MESH SEQUENCE MESH=turbofirR SEQ=still                    STARTFRAME=31 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=turbofirR MESH=turbofirR
#exec MESHMAP SCALE MESHMAP=turbofirR X=0.03 Y=0.035 Z=0.07

#exec MESHMAP SETTEXTURE MESHMAP=turbofirR NUM=1 TEXTURE=NerfRes.Skins.Hand_back
#exec MESHMAP SETTEXTURE MESHMAP=turbofirR NUM=2 TEXTURE=NerfRes.Skins.Hand_in
#exec MESHMAP SETTEXTURE MESHMAP=turbofirR NUM=3 TEXTURE=Wild_Fire_pu_01

// Left handed

#exec MESH IMPORT MESH=turbofirL ANIVFILE=g:\NerfRes\WeaponAnimation\MODELS\Wild_Fire_a.3d DATAFILE=g:\NerfRes\WeaponAnimation\MODELS\Wild_Fire_d.3d unmirror=1
#exec MESH ORIGIN MESH=turbofirL X=-25 Y=-75 Z=-50 

#exec MESH SEQUENCE MESH=turbofirL SEQ=All                      STARTFRAME=0 NUMFRAMES=89
#exec MESH SEQUENCE MESH=turbofirL SEQ=select                   STARTFRAME=0 NUMFRAMES=25
#exec MESH SEQUENCE MESH=turbofirL SEQ=idle                     STARTFRAME=25 NUMFRAMES=7
#exec MESH SEQUENCE MESH=turbofirL SEQ=fire                     STARTFRAME=32 NUMFRAMES=11
#exec MESH SEQUENCE MESH=turbofirL SEQ=fire_alt                 STARTFRAME=43 NUMFRAMES=15
#exec MESH SEQUENCE MESH=turbofirL SEQ=down                     STARTFRAME=58 NUMFRAMES=31
#exec MESH SEQUENCE MESH=turbofirL SEQ=still                    STARTFRAME=31 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=turbofirL MESH=turbofirL
#exec MESHMAP SCALE MESHMAP=turbofirL X=0.03 Y=0.035 Z=0.07

#exec MESHMAP SETTEXTURE MESHMAP=turbofirL NUM=1 TEXTURE=NerfRes.Skins.Hand_back
#exec MESHMAP SETTEXTURE MESHMAP=turbofirL NUM=2 TEXTURE=NerfRes.Skins.Hand_in
#exec MESHMAP SETTEXTURE MESHMAP=turbofirL NUM=3 TEXTURE=Wild_Fire_pu_01

// Audio sound effects
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\pickups\pkwptrb.wav" NAME="TurbopickS" GROUP="Turbofir"
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\weapons\wturb.wav" NAME="TurbofireS" GROUP="Turbofir"
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\weapons\wturbalt.wav" NAME="TurboAltfireS" GROUP="Turbofir"

var bool bAlreadyFiring;

function float RateSelf( out int bUseAltMode )
{
	local float EnemyDist;

	if ( AmmoType.AmmoAmount <=0 )
		return -2;
	if ( Pawn(Owner).Enemy == None )
	{
		bUseAltMode = 0;
		return AIRating;
	}

	EnemyDist = VSize(Pawn(Owner).Enemy.Location - Owner.Location);
	bUseAltMode = int( 600 * FRand() > EnemyDist - 140 );
	return AIRating;
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


function setHand(float Hand)
{
	local rotator newRot;

	Super.SetHand(Hand);
	if ( Hand == 1 )
		Mesh = Mesh(DynamicLoadObject("NerfWeapon.turbofirL", class'Mesh'));
	else if ( Hand == -1)
		Mesh = Mesh'turbofirR';
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
	PlayAnim( 'Fire', 2.0, 0.05);	
}

///////////////////////////////////////////////////////////////
simulated function PlayAltFiring()
{
	Owner.PlaySound(AltFireSound, SLOT_Misc,2.0*Pawn(Owner).SoundDampening);		
	PlayAnim( 'Fire_Alt', 0.75, 0.05);	
}

///////////////////////////////////////////////////////////////
state AltFiring
{
	function Projectile ProjectileFire(class<projectile> ProjClass, float ProjSpeed, bool bWarn)
	{
		local Projectile S;
		local int i;
		local vector Start,X,Y,Z;
		local Rotator StartRot, AltRotation;

		S = Global.ProjectileFire(ProjClass, ProjSpeed, bWarn);
		StartRot = S.Rotation;
		Start = S.Location;
		for (i = 0; i< 9; i++)
		{
			if (AmmoType.UseAmmo(1)) 
			{
				AltRotation = StartRot;
				AltRotation.Pitch += FRand()*3000-1500;
				AltRotation.Yaw += FRand()*3000-1500;
				AltRotation.Roll += FRand()*9000-4500;				
				S = Spawn(AltProjectileClass,,, Start - 2 * VRand(), AltRotation);
			}
		}
	}

Begin:
	FinishAnim();	
	Finish();			
}

///////////////////////////////////////////////////////////
simulated function PlayIdleAnim()
{
	PlayAnim('Idle', 1.0, 0.05);
}
///////////////////////////////////////////////////////////

state Idle
{
	function Timer()
	{
		if (FRand()>0.8) 
		{
//			log(class$ " WES: Timer called PlayIdleAnim");
			PlayIdleAnim();
		}
	}

Begin:
	bPointing=False;
	if ( (AmmoType != None) && (AmmoType.AmmoAmount<=0) ) 
		Pawn(Owner).SwitchToBestWeapon();  //Goto Weapon that has Ammo
	Disable('AnimEnd');
//	log(class$ " WES: Setting the Timer");
	SetTimer(1.5,True);
	if ( /*bFireMem ||*/ Pawn(Owner).bFire!=0 ) Global.Fire(0.0);
	if ( /*bAltFireMem ||*/ Pawn(Owner).bAltFire!=0 ) Global.AltFire(0.0);
}

defaultproperties
{
     WeaponDescription=<
     AimAdjust=64.000000
     AmmoName=Class'NerfWeapon.DartAmmoPickup'
     PickupAmmoCount=40
     bAltWarnTarget=True
     FireOffset=(X=12.000000,Y=-10.000000,Z=-10.000000)
     ProjectileClass=Class'NerfI.NerfDart'
     AltProjectileClass=Class'NerfI.NerfDart'
     shakemag=150.000000
     AIRating=0.400000
     FireSound=Sound'NerfWeapon.Turbofir.TurbofireS'
     AltFireSound=Sound'NerfWeapon.Turbofir.TurboAltfireS'
     AutoSwitchPriority=3
     InventoryGroup=3
     PickupMessage=You picked up the WildFire
     ItemName=Wild Fire
     PlayerViewOffset=(X=12.000000,Y=-8.000000,Z=-8.000000)
     PlayerViewMesh=LodMesh'NerfWeapon.turbofirR'
     PickupViewMesh=LodMesh'NerfWeapon.turbofirpick'
     ThirdPersonMesh=LodMesh'NerfWeapon.turbofir3rd'
     PickupSound=Sound'NerfWeapon.Turbofir.TurbopickS'
     Mesh=LodMesh'NerfWeapon.turbofirpick'
     bNoSmooth=False
     CollisionRadius=22.000000
     CollisionHeight=28.000000
     Mass=15.000000
}
