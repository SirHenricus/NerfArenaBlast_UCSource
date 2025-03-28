//=============================================================================
// NerfWeapon.
//=============================================================================
class NerfWeapon extends Weapon
	abstract;

var Pickup Affector;
var float FireAdjust;
var localized string WeaponDescription;
var float InstFlash;
var vector InstFog;
var bool bCanClientFire;
var bool bForceFire, bForceAltFire;
var() float FireTime, AltFireTime; //used to synch server and client firing up
var float FireStartTime;
var float AimAdjust;

Replication
{
	Reliable if ( bNetOwner && (Role == ROLE_Authority) )
		Affector, bCanClientFire;
}

function ForceFire()
{
	Fire(0);
}

function ForceAltFire()
{
	AltFire(0);
}

function SetWeaponStay()
{
	bWeaponStay = bWeaponStay || Level.Game.bCoopWeaponMode;
}

// Finish a firing sequence
function Finish()
{
	local Pawn PawnOwner;
	local bool bForce, bForceAlt;

	bForce = bForceFire;
	bForceAlt = bForceAltFire;
	bForceFire = false;
	bForceAltFire = false;

	if ( bChangeWeapon )
	{
		GotoState('DownWeapon');
		return;
	}

	PawnOwner = Pawn(Owner);
	if ( PlayerPawn(Owner) == None )
	{
		if ( (AmmoType != None) && (AmmoType.AmmoAmount<=0) )
		{
			PawnOwner.StopFiring();
			PawnOwner.SwitchToBestWeapon();
			if ( bChangeWeapon )
				GotoState('DownWeapon');
		}
		else if ( (PawnOwner.bFire != 0) && (FRand() < RefireRate) )
			Global.Fire(0);
		else if ( (PawnOwner.bAltFire != 0) && (FRand() < AltRefireRate) )
			Global.AltFire(0);	
		else 
		{
			PawnOwner.StopFiring();
			GotoState('Idle');
		}
		return;
	}
	if ( ((AmmoType != None) && (AmmoType.AmmoAmount<=0)) || (PawnOwner.Weapon != self) )
		GotoState('Idle');
	else if ( (PawnOwner.bFire!=0) || bForce )
		Global.Fire(0);
	else if ( (PawnOwner.bAltFire!=0) || bForceAlt )
		Global.AltFire(0);
	else 
		GotoState('Idle');
}

//
// Toss this item out.
//
function DropFrom(vector StartLocation)
{
	bCanClientFire = false;
	bSimFall = true;
	if ( !SetLocation(StartLocation) )
		return; 
	AIRating = Default.AIRating;
	bMuzzleFlash = 0;
	if ( AmmoType != None )
	{
		PickupAmmoCount = AmmoType.AmmoAmount;
		AmmoType.AmmoAmount = 0;
	}
	RespawnTime = 0.0; //don't respawn
	SetPhysics(PHYS_Falling);
	RemoteRole = ROLE_DumbProxy;
	BecomePickup();
	NetPriority = 2.5;
	bCollideWorld = true;
	if ( Pawn(Owner) != None )
		Pawn(Owner).DeleteInventory(self);
	GotoState('PickUp', 'Dropped');
}

simulated function ClientPutDown(weapon NextWeapon)
{
	if ( Level.NetMode == NM_Client )
	{
		bCanClientFire = false;
		bMuzzleFlash = 0;
		TweenDown();
		if ( NerfIPlayer(Owner) != None )
			NerfIPlayer(Owner).ClientPending = NextWeapon;
		GotoState('ClientDown');
	}
}

simulated function TweenToStill()
{
	TweenAnim('Still', 0.1);
}

function BecomeItem()
{
	local NerfBots B;
	local Pawn P;

	Super.BecomeItem();
	B = NerfBots(Instigator);
	if ( (B != None) && (B.Skill < 2) )
		FireAdjust = B.Skill * 0.5;
	else
		FireAdjust = 1.0;

	if ( (B != None) || !Level.Game.IsA('DeathMatchGame')
		|| (DeathMatchGame(Level.Game).NumBots != 1) )
		return;

	// let high skill bots hear pickup if close enough
	for ( P=Level.PawnList; P!=None; P=P.NextPawn )
	{
		B = NerfBots(p);
		if ( (B != None) && (B.Skill > 0)
			&& (VSize(B.Location - Instigator.Location) < 1400) )
		{
			B.HearPickup(Instigator);
			return;
		}
	}
}

simulated function AnimEnd()
{
	if ( (Level.NetMode == NM_Client) && (Mesh != PickupViewMesh) )
		PlayIdleAnim();
}

simulated event RenderOverlays( canvas Canvas )
{
	Super.RenderOverlays(Canvas);
	
}

simulated function ForceClientFire()
{
//	log(class$ " WES: ForceclientFire call ClientFire");
	ClientFire(0);
}

simulated function ForceClientAltFire()
{
	ClientAltFire(0);
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
//		log(class$ " WES: Calling PlayFiring");
		PlayFiring();
		if ( Role < ROLE_Authority )
		{
//			log(class$ " WES: Client Fire Weapon. Going to ClientFiring state");
			GotoState('ClientFiring');
		}
		return true;
	}
	return false;
}		

function Fire( float Value )
{
	if ( AmmoType.UseAmmo(1) )
	{
//		log(class$ " WES: Fire Weapon. Going to NormalFire state");
		GotoState('NormalFire');
//		log(class$ " WES: Back from NormalFire state");
		bPointing=True;
		bCanClientFire = true;
//		log(class$ " WES: Calling ClientFire ");
		ClientFire(Value);
		if ( bRapidFire || (FiringSpeed > 0) )
			Pawn(Owner).PlayRecoil(FiringSpeed);
		if ( bInstantHit )
			TraceFire(0.0);
		else
			ProjectileFire(ProjectileClass, ProjectileSpeed, bWarnTarget);
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
		PlayAltFiring();
		if ( Role < ROLE_Authority )
			GotoState('ClientAltFiring');
		return true;
	}
	return false;
}

function AltFire( float Value )
{
	if (AmmoType.UseAmmo(1))
	{
		GotoState('AltFiring');
		bPointing=True;
		bCanClientFire = true;
		ClientAltFire(Value);
		if ( bRapidFire || (FiringSpeed > 0) )
			Pawn(Owner).PlayRecoil(FiringSpeed);
		if ( bAltInstantHit )
			TraceFire(0.0);
		else
			ProjectileFire(AltProjectileClass, AltProjectileSpeed, bAltWarnTarget);
	}
}


simulated function PlaySelect()
{
	bForceFire = false;
	bForceAltFire = false;
	bCanClientFire = false;
	if ( !IsAnimating() || (AnimSequence != 'Select') )
		if ((Level.Game != None) && (Level.Game.bFastWeaponSwitch))
			PlayAnim('Select',2.0,0.0);
		else
			PlayAnim('Select',1.0,0.0);
	Owner.PlaySound(SelectSound, SLOT_Misc, Pawn(Owner).SoundDampening);	
}

simulated function PlayPostSelect()
{
	if ( Level.NetMode == NM_Client )
	{
		GotoState('idle');
		AnimEnd();
	}
}

simulated function TweenDown()
{
	if ( IsAnimating() && (AnimSequence != '') && (GetAnimGroup(AnimSequence) == 'Select') )
		TweenAnim( AnimSequence, AnimFrame * 0.4 );
	else
		PlayAnim('Down', 1.0, 0.05);
}

simulated function PlayIdleAnim()
{
}

simulated function Landed(vector HitNormal)
{
	local rotator newRot;

	newRot = Rotation;
	newRot.pitch = 0;
	SetRotation(newRot);
}

function bool HandlePickupQuery( inventory Item )
{
	local int OldAmmo;
	local Pawn P;

	if (Item.Class == Class)
	{
		if ( Weapon(item).bWeaponStay && (!Weapon(item).bHeldItem || Weapon(item).bTossedOut) )
			return true;
		P = Pawn(Owner);
		if ( AmmoType != None )
		{
			OldAmmo = AmmoType.AmmoAmount;
			if ( AmmoType.AddAmmo(PickupAmmoCount) && (OldAmmo == 0) 
				&& (P.Weapon.class != item.class) && !P.bNeverSwitchOnPickup )
					WeaponSet(P);
		}
//		P.ReceiveLocalizedMessage( class'PickupMessagePlus', 0, None, None, Self.Class );
		Item.PlaySound(Item.PickupSound);
		if (Level.Game.LocalLog != None)
			Level.Game.LocalLog.LogPickup(Item, Pawn(Owner));
		if (Level.Game.WorldLog != None)
			Level.Game.WorldLog.LogPickup(Item, Pawn(Owner));
		Item.SetRespawn();   
		return true;
	}
	if ( Inventory == None )
		return false;

	return Inventory.HandlePickupQuery(Item);
}

auto state Pickup
{
	ignores AnimEnd;

	// Landed on ground.
	simulated function Landed(Vector HitNormal)
	{
		local rotator newRot;

		newRot = Rotation;
		newRot.pitch = 0;
		SetRotation(newRot);
		if ( Role == ROLE_Authority )
		{
			bSimFall = false;
			SetTimer(2.0, false);
		}
	}
}

state ClientFiring
{
	simulated function bool ClientFire(float Value)
	{
		return false;
	}

	simulated function bool ClientAltFire(float Value)
	{
		return false;
	}

	simulated function AnimEnd()
	{
		if ( (Pawn(Owner) == None)
			|| ((AmmoType != None) && (AmmoType.AmmoAmount <= 0)) )
		{
//			log(class$ " WES: Gonna PlayIdleAnim in ClientFiring AnimEnd");
			PlayIdleAnim();
			GotoState('idle');
		}
		else if ( !bCanClientFire )
			GotoState('idle');
		else if ( Pawn(Owner).bFire != 0 )
		{
//			log(class$ " WES: State ClientFiring Call ClientFire");
		
			Global.ClientFire(0);
		}
		else if ( Pawn(Owner).bAltFire != 0 )
			Global.ClientAltFire(0);
		else
		{
//			log(class$ " WES: Gonna PlayIdleAnim in ClientFiring AnimEnd else");
			PlayIdleAnim();
			GotoState('idle');
		}
	}

	simulated function EndState()
	{
//		log(class$ " WES: In EndState function of ClientFiring State");
		AmbientSound = None;
	}

}

state ClientAltFiring
{
	simulated function bool ClientFire(float Value)
	{
		return false;
	}

	simulated function bool ClientAltFire(float Value)
	{
		return false;
	}
	simulated function AnimEnd()
	{
		if ( (Pawn(Owner) == None)
			|| ((AmmoType != None) && (AmmoType.AmmoAmount <= 0)) )
		{
			PlayIdleAnim();
			GotoState('idle');
		}
		else if ( !bCanClientFire )
			GotoState('idle');
		else if ( Pawn(Owner).bFire != 0 )
		{
//			log(class$ " WES: State ClientAltFiring Call ClientFire");
			Global.ClientFire(0);
		}
		else if ( Pawn(Owner).bAltFire != 0 )
			Global.ClientAltFire(0);
		else
		{
			PlayIdleAnim();
			GotoState('idle');
		}
	}

	simulated function EndState()
	{
		AmbientSound = None;
	}
}

///////////////////////////////////////////////////////
state NormalFire
{
	function ForceFire()
	{
		bForceFire = true;
	}

	function ForceAltFire()
	{
		bForceAltFire = true;
	}

	function Fire(float F) 
	{
	}
	function AltFire(float F) 
	{
	}

	function AnimEnd()
	{
//		log(class$ " WES: Normal Fire state AnimEnd");
		Finish();
	}

Begin:
//	log(class$ "WES: State Normal Fire begin label");
	Sleep(0.0);
}

////////////////////////////////////////////////////////
state AltFiring
{
	function Fire(float F) 
	{
	}

	function AltFire(float F) 
	{
	}

	function ForceFire()
	{
		bForceFire = true;
	}

	function ForceAltFire()
	{
		bForceAltFire = true;
	}

	function AnimEnd()
	{
		Finish();
	}

Begin:
	Sleep(0.0);
}

state Active
{
	ignores animend;

	function ForceFire()
	{
		bForceFire = true;
	}

	function ForceAltFire()
	{
		bForceAltFire = true;
	}

	function EndState()
	{
		Super.EndState();
		bForceFire = false;
		bForceAltFire = false;
	}

Begin:
	FinishAnim();
	if ( bChangeWeapon )
		GotoState('DownWeapon');
	bWeaponUp = True;
	PlayPostSelect();
	FinishAnim();
	bCanClientFire = true;
	
	if ( (Level.Netmode != NM_Standalone) && Owner.IsA('NerfIPlayer') )
	{
		if ( bForceFire || (Pawn(Owner).bFire != 0) )
			NerfIPlayer(Owner).SendFire(self);
		else if ( bForceAltFire || (Pawn(Owner).bAltFire != 0) )
			NerfIPlayer(Owner).SendAltFire(self);
		else if ( !bChangeWeapon )
			NerfIPlayer(Owner).UpdateRealWeapon(self);
	} 
	Finish();
}

State ClientActive
{
	simulated function ForceClientFire()
	{
//		log(class$ " WES: State ClientActive ForceClientFire");
		Global.ClientFire(0);
	}

	simulated function ForceClientAltFire()
	{
		Global.ClientAltFire(0);
	}

	simulated function bool ClientFire(float Value)
	{
		return true;
	}

	simulated function bool ClientAltFire(float Value)
	{
		return true;
	}

	simulated function AnimEnd()
	{
		if ( Owner == None )
		{
			Global.AnimEnd();
			GotoState('idle');
		}
		else if ( Owner.IsA('NerfIPlayer') 
			&& (NerfIPlayer(Owner).ClientPending != None) )
			GotoState('ClientDown');
		else if ( bWeaponUp )
		{
			PlayIdleAnim();
			GotoState('idle');
		}
		else
		{
			PlayPostSelect();
			bWeaponUp = true;
		}
	}

	simulated function BeginState()
	{
		bWeaponUp = false;
		PlaySelect();
	}
}

State ClientDown
{
	simulated function bool ClientFire(float Value)
	{
		return false;
	}

	simulated function bool ClientAltFire(float Value)
	{
		return false;
	}

	simulated function Tick(float DeltaTime)
	{
		local NerfIPlayer T;

		T = NerfIPlayer(Owner);
		if ( !T.bNeedActivate )
			GotoState('idle');
		else if ( (T.Weapon != self) && (T.Weapon != None) )
		{
			T.Weapon.GotoState('ClientActive');
			T.ClientPending = None;
			T.bNeedActivate = false;
			GotoState('idle');
		}
	}
		
	simulated function AnimEnd()
	{
		local NerfIPlayer T;

		T = NerfIPlayer(Owner);
		if ( T != None )
		{
			if ( (T.ClientPending != None) 
				&& (T.ClientPending.Owner == Owner) )
			{
				T.Weapon = T.ClientPending;
				T.Weapon.GotoState('ClientActive');
				T.ClientPending = None;
				GotoState('idle');
			}
			else
			{
				Enable('Tick');
				T.bNeedActivate = true;
			}
		}
	}

	simulated function BeginState()
	{
		Disable('Tick');
	}
}

State DownWeapon
{
ignores Fire, AltFire, AnimEnd;

	function BeginState()
	{
		Super.BeginState();
		bCanClientFire = false;
	}
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
	return Spawn(ProjClass,,, Start,AdjustedAim);	
}

defaultproperties
{
     FireAdjust=1.000000
     WeaponDescription=(no description avaliable)
     MyDamageType=Unspecified
     AltDamageType=Unspecified
     bClientAnim=True
}
