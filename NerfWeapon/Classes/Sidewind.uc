//=============================================================================
// sidewind.	- by Wezo
// 
// Charateristic:	Shoots light trailing projectile that seeks player or bots 
//					within a certain angle of deflection from the aimed direction
//					and within a certain amount of distance.
// Primary fire :	Fire 1 flying frisbe which could be a seeking frisbe if the 
//					enemy is locked on target.
// Alt fire	    :	Fire 1 flying frisbe which the player could control and navigate 
//					within the level.
//=================================================================================
class sidewind expands NerfWeapon;

//Pickup
#exec MESH IMPORT MESH=sidewindpick ANIVFILE=g:\NerfRes\weaponmesh\MODELS\sidewinder_pu_a.3d DATAFILE=g:\NerfRes\weaponmesh\MODELS\sidewinder_pu_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=sidewindpick X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=sidewindpick SEQ=All                      STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=sidewindpick SEQ=idle                      STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=sidewindpick MESH=sidewindpick
#exec MESHMAP SCALE MESHMAP=sidewindpick X=0.07 Y=0.07 Z=0.14

#exec TEXTURE IMPORT NAME=sidewinder_pu_01 FILE=g:\NerfRes\weaponmesh\Textures\sidewinder_pu_01.PCX GROUP=Skins FLAGS=2	//sidewinderbody01

#exec MESHMAP SETTEXTURE MESHMAP=sidewindpick NUM=1 TEXTURE=sidewinder_pu_01

//3rd
#exec MESH IMPORT MESH=sidewind3rd ANIVFILE=g:\NerfRes\weaponmesh\MODELS\sidewinder_pu_a.3d DATAFILE=g:\NerfRes\weaponmesh\MODELS\sidewinder_pu_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=sidewind3rd X=150 Y=0 Z=0 YAW=128 PITCH=-40

#exec MESH SEQUENCE MESH=sidewind3rd SEQ=All                      STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=sidewind3rd MESH=sidewind3rd
#exec MESHMAP SCALE MESHMAP=sidewind3rd X=0.035 Y=0.035 Z=0.07
//#exec MESHMAP SCALE MESHMAP=sidewind3rd X=0.04 Y=0.04 Z=0.08

#exec MESHMAP SETTEXTURE MESHMAP=sidewind3rd NUM=1 TEXTURE=sidewinder_pu_01

//POV
//Right handed

#exec MESH IMPORT MESH=sidewindR ANIVFILE=g:\NerfRes\weaponanimation\MODELS\Sidewinder_a.3d DATAFILE=g:\NerfRes\weaponanimation\MODELS\Sidewinder_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=sidewindR X=0 Y=25 Z=-75 YAW=125 PITCH=-5 ROLL=0

#exec MESH SEQUENCE MESH=sidewindR SEQ=All                      STARTFRAME=0 NUMFRAMES=104
#exec MESH SEQUENCE MESH=sidewindR SEQ=select                   STARTFRAME=0 NUMFRAMES=31
#exec MESH SEQUENCE MESH=sidewindR SEQ=idle                     STARTFRAME=31 NUMFRAMES=2
#exec MESH SEQUENCE MESH=sidewindR SEQ=fire                     STARTFRAME=33 NUMFRAMES=7
#exec MESH SEQUENCE MESH=sidewindR SEQ=idle_alt                 STARTFRAME=40 NUMFRAMES=31
#exec MESH SEQUENCE MESH=sidewindR SEQ=down                     STARTFRAME=71 NUMFRAMES=33
#exec MESH SEQUENCE MESH=sidewindR SEQ=still                    STARTFRAME=32 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=sidewindR MESH=sidewindR
#exec MESHMAP SCALE MESHMAP=sidewindR X=0.08 Y=0.08 Z=0.16

#exec TEXTURE IMPORT NAME=Side_Winder_03 FILE=g:\NerfRes\weaponanimation\Textures\Sidewinder_03.PCX GROUP=Skins Mips=Off FLAGS=2	//sidewinderbody01

#exec MESHMAP SETTEXTURE MESHMAP=sidewindR NUM=1 TEXTURE=NerfRes.Skins.Hand_back
#exec MESHMAP SETTEXTURE MESHMAP=sidewindR NUM=2 TEXTURE=NerfRes.Skins.Hand_in
#exec MESHMAP SETTEXTURE MESHMAP=sidewindR NUM=3 TEXTURE=Side_Winder_03
#exec MESHMAP SETTEXTURE MESHMAP=sidewindR NUM=4 TEXTURE=sidewinder_pu_01

//Left handed

#exec MESH IMPORT MESH=sidewindL ANIVFILE=g:\NerfRes\weaponanimation\MODELS\Sidewinder_a.3d DATAFILE=g:\NerfRes\weaponanimation\MODELS\Sidewinder_d.3d unmirror=1
#exec MESH ORIGIN MESH=sidewindL X=0 Y=25 Z=-75 YAW=3 PITCH=5 ROLL=0

#exec MESH SEQUENCE MESH=sidewindL SEQ=All                      STARTFRAME=0 NUMFRAMES=104
#exec MESH SEQUENCE MESH=sidewindL SEQ=select                   STARTFRAME=0 NUMFRAMES=31
#exec MESH SEQUENCE MESH=sidewindL SEQ=idle                     STARTFRAME=31 NUMFRAMES=2
#exec MESH SEQUENCE MESH=sidewindL SEQ=fire                     STARTFRAME=33 NUMFRAMES=7
#exec MESH SEQUENCE MESH=sidewindL SEQ=idle_alt                 STARTFRAME=40 NUMFRAMES=31
#exec MESH SEQUENCE MESH=sidewindL SEQ=down                     STARTFRAME=71 NUMFRAMES=33
#exec MESH SEQUENCE MESH=sidewindL SEQ=still                    STARTFRAME=32 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=sidewindL MESH=sidewindL
#exec MESHMAP SCALE MESHMAP=sidewindL X=0.08 Y=0.08 Z=0.16

#exec MESHMAP SETTEXTURE MESHMAP=sidewindL NUM=1 TEXTURE=NerfRes.Skins.Hand_back
#exec MESHMAP SETTEXTURE MESHMAP=sidewindL NUM=2 TEXTURE=NerfRes.Skins.Hand_in
#exec MESHMAP SETTEXTURE MESHMAP=sidewindL NUM=3 TEXTURE=Side_Winder_03
#exec MESHMAP SETTEXTURE MESHMAP=sidewindL NUM=4 TEXTURE=sidewinder_pu_01

#exec TEXTURE IMPORT NAME=LockedCross FILE=g:\NerfRes\NerfMesh\Textures\Hud\chair8.PCX GROUP="Icons" FLAGS=2 MIPS=OFF

#exec MESH NOTIFY MESH=sidewindR SEQ=select TIME=0.3 FUNCTION=ForkEngage
#exec MESH NOTIFY MESH=sidewindL SEQ=select TIME=0.3 FUNCTION=ForkEngage

// Audio sound effects
// ##nerf WES FIXME Sounds
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\pickups\pkwpsdwr.wav" NAME="SidewindpickS" GROUP="Sidewind"
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\weapons\wswdr.wav" NAME="SidewindfireS" GROUP="Sidewind"
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\weapons\wswdralt.wav" NAME="SidewindAltfireS" GROUP="Sidewind"
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\weapons\wsdwrfk.wav" NAME="ForkS" GROUP="Sidewind"

var GuidedFrisbe GFrisbe;
var PlayerPawn GuidingPawn;
var bool bGuiding,bCanFire,bShowStatic;
var rotator StartRotation;

var bool bFireLoad;
var Actor LockedTarget, NewTarget, OldTarget;

replication
{
	// Things the server should send to the client.
	unreliable if( Role==ROLE_Authority )
		bGuiding, bShowStatic;
}

simulated function PostRender( canvas Canvas )
{
	local int i, numReadouts, OldClipX, OldClipY, XScale;

	bOwnsCrossHair = ( bGuiding || bShowStatic );

	if ( bLockedOn )
	{
		bOwnsCrossHair = bLockedOn;
		// if locked on, draw special crosshair
		Canvas.SetPos(0.5 * Canvas.ClipX - 8, 0.5 * Canvas.ClipY - 8 );
		Canvas.Style = 2;
		Canvas.DrawIcon(Texture'LockedCross', 1.0);
		Canvas.Style = 1;	
		return;
	}
	else if ( !bGuiding )
	{
		if ( !bShowStatic )
			return;

		Canvas.SetPos( 0, 0);
		Canvas.Style = ERenderStyle.STY_Normal;
		if ( Owner.IsA('PlayerPawn') )
			PlayerPawn(Owner).ViewTarget = None;
		return;
	}

	if(GFrisbe!=None)
		GFrisbe.PostRender(Canvas);
	OldClipX = Canvas.ClipX;
	OldClipY = Canvas.ClipY;
	XScale = Canvas.ClipX/640.0;
	Canvas.SetPos( 0.5 * OldClipX - 128 * XScale, 0.5 * OldClipY - 128 * XScale );
	if ( Level.bHighDetailMode )
		Canvas.Style = ERenderStyle.STY_Translucent;
	else
		Canvas.Style = ERenderStyle.STY_Normal;

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
		bUseAltMode = 0;
	else
	{
		bRetreating = ( ((EnemyDir/EnemyDist) Dot Owner.Velocity) < -0.7 );
		bUseAltMode = 0;
		if ( ((EnemyDist < 600) || (bRetreating && (EnemyDist < 800)))
			&& (FRand() < 0.4) )
			bUseAltMode = 0;
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

simulated function PlayFiring()
{
	PlayAnim( 'Fire', 0.5, 0.05);		
	Owner.PlayOwnedSound(FireSound, SLOT_None,4.0*Pawn(Owner).SoundDampening);
}

function setHand(float Hand)
{
	local rotator newRot;

	Super.SetHand(Hand);
	if ( Hand == 1 )
		Mesh = Mesh(DynamicLoadObject("NerfWeapon.sidewindL", class'Mesh'));
	else if ( Hand == -1 )
		Mesh = Mesh'sidewindR';
	else
	{
		PlayerViewOffset.Y = 0;
		FireOffset.Y = 0;
		bHideWeapon = true;
	}
}

function ForkEngage()
{
	Owner.PlaySound(SelectSound, SLOT_Misc,Pawn(Owner).SoundDampening);
}

function Actor CheckTarget()
{
	local Actor ETarget;
	local Vector Start, X,Y,Z;
	local float bestDist, bestAim;
	local Pawn PawnOwner;

	PawnOwner = Pawn(Owner);
	if ( !PawnOwner.bIsPlayer && (PawnOwner.Enemy == None) )
		return None; 
	GetAxes(PawnOwner.ViewRotation,X,Y,Z);
	Start = Owner.Location + CalcDrawOffset() + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z; 
	bestAim = 0.93;
	ETarget = PawnOwner.PickTarget(bestAim, bestDist, X, Start);
	if ( !PawnOwner.bIsPlayer && (PawnOwner.Enemy != ETarget) )
		return None; 
	bPointing = (ETarget != None);
	Return ETarget;
}

///////////////////////////////////////////////////////
function Fire( float Value )
{
	if ( AmmoType.UseAmmo(1) )
	{
		bPointing=True;
		bCanClientFire = true;
//		log(class$ " WES: Calling ClientFire ");
		ClientFire(Value);
//		log(class$ " WES: Fire Weapon. Going to NormalFire state");
		GotoState('NormalFire');
//		log(class$ " WES: Back from NormalFire state");
		if ( bRapidFire || (FiringSpeed > 0) )
			Pawn(Owner).PlayRecoil(FiringSpeed);
	}
}

state NormalFire
{
	function Tick( float DeltaTime )
	{
 			GoToState('FireFrisbe');
	}

	function BeginState()
	{
		bFireLoad = True;
		Super.BeginState();
	}

Begin:
		if ( PlayerPawn(Owner) == None )
		{
	 			GoToState('FireFrisbe');
		}
		if (AmmoType.AmmoAmount<=0) GoToState('FireFrisbe');			
		NewTarget = CheckTarget();
		if ( Pawn(NewTarget) != None )
			Pawn(NewTarget).WarnTarget(Pawn(Owner), ProjectileSpeed, vector(Pawn(Owner).ViewRotation));	
		If ( (LockedTarget != None) && (NewTarget != LockedTarget) ) 
		{
			LockedTarget = None;
			Owner.PlaySound(Misc2Sound, SLOT_None, Pawn(Owner).SoundDampening);
			bLockedOn=False;
		}
		else if (LockedTarget != None)
 			Owner.PlaySound(Misc1Sound, SLOT_None, Pawn(Owner).SoundDampening);
		bPointing = true;
		if ( Level.Game.Difficulty > 0 )
			Owner.MakeNoise(0.15 * Level.Game.Difficulty * Pawn(Owner).SoundDampening);		
}

///////////////////////////////////////////////////////
state Idle
{
	function Timer()
	{
		NewTarget = CheckTarget();
		if ( NewTarget == OldTarget )
		{
			LockedTarget = NewTarget;
			If (LockedTarget != None) 
			{
				bLockedOn=True;		
				Owner.MakeNoise(Pawn(Owner).SoundDampening);
				Owner.PlaySound(Misc1Sound, SLOT_None,Pawn(Owner).SoundDampening);
				if ( (Pawn(LockedTarget) != None) && (FRand() < 0.7) )
					Pawn(LockedTarget).WarnTarget(Pawn(Owner), ProjectileSpeed, vector(Pawn(Owner).ViewRotation));	
			}
		}
		else if( (OldTarget != None) && (NewTarget == None) ) 
		{
			Owner.PlaySound(Misc2Sound, SLOT_None,Pawn(Owner).SoundDampening);
			bLockedOn = False;
		}
		else 
		{
			LockedTarget = None;
			bLockedOn = False;
		}
		OldTarget = NewTarget;
	}
Begin:
	bPointing=False;
	if ( (AmmoType != None) && (AmmoType.AmmoAmount<=0) ) 
		Pawn(Owner).SwitchToBestWeapon();  //Goto Weapon that has Ammo
	if ( Pawn(Owner).bFire!=0 ) Fire(0.0);
	if ( Pawn(Owner).bAltFire!=0 ) AltFire(0.0);	
	Disable('AnimEnd');
	OldTarget = CheckTarget();
	SetTimer(1.25,True);
	LockedTarget = None;
	bLockedOn = False;
}

///////////////////////////////////////////////////////
state FireFrisbe
{
	function Fire(float F) {}
	function AltFire(float F) {}

	function BeginState()
	{
		local vector FireLocation, StartLoc, X,Y,Z;
		local rotator FireRot;
		local side_cd r;
		local float Angle;
		local pawn BestTarget;

//		log(class$ " WES: BeginState at firefrisbe");
		Angle = 0;
		GetAxes(Pawn(Owner).ViewRotation,X,Y,Z);
		StartLoc = Owner.Location + CalcDrawOffset(); 
		FireLocation = StartLoc + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z; 
		AdjustedAim = pawn(owner).AdjustAim(ProjectileSpeed, FireLocation, AimError, True, bWarnTarget);
			
		if ( PlayerPawn(Owner) != None )
			AdjustedAim = Pawn(Owner).ViewRotation;
				
		Owner.MakeNoise(Pawn(Owner).SoundDampening);
		if ( (LockedTarget!=None) || !bFireLoad )
		{
			BestTarget = Pawn(CheckTarget());
			if ( (LockedTarget!=None) && (LockedTarget != BestTarget) ) 
			{
				LockedTarget = None;
				bLockedOn=False;
			}
		}
		else 
			BestTarget = None;
		bPointing = true;
		FireRot = AdjustedAim;

			if (bFireLoad)
			{
				if ( Angle > 0 )
				{
					if ( Angle < 3 )
						FireRot.Yaw = AdjustedAim.Yaw - Angle * 600;
					else if ( Angle > 3.5 )
						FireRot.Yaw = AdjustedAim.Yaw + (Angle - 3)  * 600;
					else
						FireRot.Yaw = AdjustedAim.Yaw;
				}
				if ( LockedTarget!=None )
				{
					r = Spawn( class 'SeekingFrisbe',, '', FireLocation,FireRot);	
					r.SeekActor = LockedTarget;
				}
				else 
				{
					if (PlayerPawn(Owner) != None)
						FireRot.YAW = FireRot.YAW + (PlayerPawn(Owner).Handedness * AimAdjust);
					FireRot.PITCH = FireRot.PITCH + 128;
					r = Spawn( class 'side_cd',, '', FireLocation,FireRot);
				}
				if ( Angle > 0 )
					r.Velocity *= (0.9 + 0.2 * FRand());			
			}

			Angle += 1.0484; //2*3.1415/6;
	}

Begin:
	FinishAnim();
	if (AmmoType.AmmoAmount > 0) 
	{	
		Owner.PlaySound(CockingSound, SLOT_None,Pawn(Owner).SoundDampening);
		if ( FRand() < 0.1)		
			PlayAnim('idle_alt', 1.0,0.05);	
		FinishAnim();		
	}
	LockedTarget = None;
	Finish();	
}

/////////////////////////////////////////////////////////////////////////////
function AltFire( float Value )
{
	if ( !Owner.IsA('PlayerPawn') )
	{
		Fire(Value);
		return;
	}

//	log(class$ " WES: press altfire button" @Owner);
	if (AmmoType.UseAmmo(1))
	{
		PlayerPawn(Owner).ShakeView(ShakeTime, ShakeMag, ShakeVert);
		bPointing=True;
		Pawn(Owner).PlayRecoil(FiringSpeed);
		PlayFiring();
		GFrisbe = GuidedFrisbe(ProjectileFire(AltProjectileClass, AltProjectileSpeed, bAltWarnTarget));
		GFrisbe.SetOwner(Owner);
//		log(class$ " WES: Setting GuidedFrisbe" @GFrisbe);
		PlayerPawn(Owner).ViewTarget = GFrisbe;
		GFrisbe.Guider = PlayerPawn(Owner);
//		log(class$ " WES: Going to Guiding State" @GFrisbe.Guider);
		ClientAltFire(0);
		GotoState('Guiding');
	}
}

simulated function bool ClientAltFire( float Value )
{
	if ( bCanClientFire && ((Role == ROLE_Authority) || (AmmoType == None) || (AmmoType.AmmoAmount > 0)) )
	{
		if ( (PlayerPawn(Owner) != None) 
			&& ((Level.NetMode == NM_Standalone) || PlayerPawn(Owner).Player.IsA('ViewPort')) )
		{
			if ( Affector != None )
				Affector.FireEffect();
		}
		Owner.PlayOwnedSound(FireSound, SLOT_None,4.0*Pawn(Owner).SoundDampening);
		return true;
	}
	return false;
}

State Guiding
{
	function Fire ( float Value )
	{
//		log(class$ " WES: Guiding State fire" @bCanFire);

		if ( !bCanFire )
			return;
		if ( GFrisbe != None )
		{
//			log(class$ " WES: Guiding State GFrisbe Explode");
			GFrisbe.Explode(GFrisbe.Location,Vect(0,0,1));
		}
		bCanClientFire = true;

//		log(class$ " WES: Going to state Finishing");
		GotoState('Finishing');
	}

	function AltFire ( float Value )
	{
//		log(class$ " WES: Guiding State Altfire");
		Fire(Value);
	}

	function BeginState()
	{
//		log(class$ " WES: Guiding BeginState" @GFrisbe);
//		log(class$ " WES: Who's my owner" @Owner);
	
		bGuiding = true;
		bCanFire = false;
		if ( Owner.IsA('PlayerPawn') )
		{
			GuidingPawn = PlayerPawn(Owner);
			StartRotation = PlayerPawn(Owner).ViewRotation;
			PlayerPawn(Owner).ClientAdjustGlow(-0.2,vect(50,0,0));
		}
	}

	function EndState()
	{
		bGuiding = false;
		if ( GuidingPawn != None )
		{
			GuidingPawn.ClientAdjustGlow(0.2,vect(-50,0,0));
			GuidingPawn.ClientSetRotation(StartRotation);
			GuidingPawn = None;
		}
	}


Begin:
//	log(class$ " WES: Guiding State Begin" @bCanFire);
//	Sleep(1.0);
	bCanFire = true;
}

State Finishing
{
	ignores Fire, AltFire;

	function BeginState()
	{
//		log(class$ " WES: State Finishing Begin State");
		bShowStatic = true;
	}

Begin:
//	log(class$ " WES: State Finishing Begin Label");
	Sleep(0.3);
	bShowStatic = false;
	Sleep(1.0);
	GotoState('Idle');
}

function Projectile ProjectileFire(class<projectile> ProjClass, float ProjSpeed, bool bWarn)
{
	local Vector Start, X,Y,Z;

	Owner.MakeNoise(Pawn(Owner).SoundDampening);
	GetAxes(Pawn(Owner).ViewRotation,X,Y,Z);
	Start = Owner.Location + CalcDrawOffset() + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z; 
	AdjustedAim = Pawn(Owner).AdjustAim(ProjSpeed, Start, AimError, True, bWarn);	
	if (PlayerPawn(Owner) != None)	
		AdjustedAim.YAW = AdjustedAim.YAW + (PlayerPawn(Owner).Handedness * AimAdjust);
	AdjustedAim.PITCH = AdjustedAim.PITCH + 128;
	return Spawn(ProjClass,,, Start,AdjustedAim);	
}

defaultproperties
{
     WeaponDescription=<
     InstFlash=-0.400000
     InstFog=(X=950.000000,Y=650.000000,Z=290.000000)
     AimAdjust=32.000000
     AmmoName=Class'NerfWeapon.Tracker'
     PickupAmmoCount=10
     bAltWarnTarget=True
     bSplashDamage=True
     FiringSpeed=0.400000
     FireOffset=(X=12.000000,Y=-12.000000,Z=-6.000000)
     ProjectileClass=Class'NerfWeapon.side_cd'
     AltProjectileClass=Class'NerfWeapon.GuidedFrisbe'
     shakemag=120.000000
     AIRating=0.800000
     RefireRate=0.800000
     FireSound=Sound'NerfWeapon.Sidewind.SidewindfireS'
     AltFireSound=Sound'NerfWeapon.Sidewind.SidewindAltfireS'
     SelectSound=Sound'NerfWeapon.Sidewind.ForkS'
     AutoSwitchPriority=9
     InventoryGroup=9
     PickupMessage=You picked up the Sidewinder
     ItemName=Sidewinder
     PlayerViewOffset=(X=12.000000,Y=-4.000000,Z=-7.000000)
     PlayerViewMesh=LodMesh'NerfWeapon.sidewindR'
     PlayerViewScale=0.250000
     PickupViewMesh=LodMesh'NerfWeapon.sidewindpick'
     ThirdPersonMesh=LodMesh'NerfWeapon.sidewind3rd'
     PickupSound=Sound'NerfWeapon.Sidewind.SidewindpickS'
     Mesh=LodMesh'NerfWeapon.sidewindpick'
     bNoSmooth=False
     SoundRadius=64
     SoundVolume=255
     CollisionHeight=28.000000
     Mass=10.000000
}
