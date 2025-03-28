//
// SHBallGun - ScavangerHunt Ball Gun
//   ripped off from MightyMo and tweaked for SH use
//
class SHBallGun expands NerfWeapon;

#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\pickups\pkwpmo.wav" NAME="SHpickS" GROUP="SHBallGun"
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\weapons\wmo.wav" NAME="SHfireS" GROUP="SHBallGun"
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\weapons\wmoalt.wav" NAME="SHAltfireS" GROUP="SHBallGun"

function PreBeginPlay()
{
	//TraceLog(class, 10, "in PreBeginPlay()");

	Super.PreBeginPlay();
    PickupViewMesh=Mesh(DynamicLoadObject("NerfRes.SHpickup", class'Mesh'));
	PlayerViewMesh=Mesh(DynamicLoadObject("NerfRes.SH", class'Mesh'));
	Mesh=Mesh(DynamicLoadObject("NerfRes.SHpickup", class'Mesh'));
    ThirdPersonMesh=Mesh(DynamicLoadObject("NerfRes.SH3rd", class'Mesh'));
}


function float SwitchPriority() 
{
	//TraceLog(class, 10, "in SwitchPriority()");
	
    	return 0.0;			// never autoswitch, even if playerpawn
}


function float RateSelf( out int bUseAltMode )
{
	local float EnemyDist;
	local bool bRetreating;
	local vector EnemyDir;

	//TraceLog(class, 10, "in RateSelf(...)");

	return 0.0;			//  NOT AIRating;  never auto-switch to this weapon!
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

function Finish()
{
	local Pawn PawnOwner;
	local bool bForce, bForceAlt;
	local int i, BallCount;

	BallCount = 0;
	for (i = 1; i < 8; i++)
		if (Pawn(Owner).IsHoldingBall(i))
			BallCount++;

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
/*
	if ( PawnOwner.IsA('NerfBots') )
	{
//		if (BallCount <= 0)
    	if ((BallCount <= 0) || (Pawn(Owner).Weapon != self))
		{
			Pawn(Owner).StopFiring();
			Pawn(Owner).SwitchToBestWeapon();
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
	
*/	
	if ( PawnOwner.IsA('NerfBots') )
        return;
    else if ( PawnOwner.IsA('NerfIPlayer') )
    {
    	if ((BallCount <= 0) || (Pawn(Owner).Weapon != self))
    	{
    			PawnOwner.StopFiring();
    			PawnOwner.SwitchToBestWeapon();
    			if ( bChangeWeapon )
    				GotoState('DownWeapon');
    	}
    	else if ( (PawnOwner.bFire!=0) || bForce )
    		Global.Fire(0);
    	else if ( (PawnOwner.bAltFire!=0) || bForceAlt )
    		Global.AltFire(0);
    	else 
    		GotoState('Idle');
    }
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
		PlayFiring();
		return true;
	}
	return false;
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
		PlayAltFiring();
		return true;
	}
	return false;
}



function Fire( float Value )
{
	local int i;
	local bool Shooting;
	
	bPointing=True;

//log( Pawn(Owner)$" is regfiring me with BH = "$Pawn(Owner).BallHolding );
	Shooting = false;
	for (i = 1; i < 8; i++)
	{
		if (Shooting)
			continue;		
		if (Pawn(Owner).IsHoldingBall(i))
		{
			Shooting = true;
			switch (i)
			{
				case 1:	ProjectileClass = class'SHBBall';	break;
				case 2:	ProjectileClass = class'SHGBall';	break;
				case 3:	ProjectileClass = class'SHYBall';	break;
				case 4:	ProjectileClass = class'SHOBall';	break;
				case 5:	ProjectileClass = class'SHRBall';	break;
				case 6:	ProjectileClass = class'SHPBall';	break;
				case 7:	ProjectileClass = class'SHGOBall';	break;
			}
			ProjectileSpeed = ProjectileClass.Default.speed;
			Pawn(Owner).SetHoldingBall(i, False);
			Level.Game.DiscardBall(Pawn(Owner), i);
		}
	}
	if (Shooting)
	{
//log( Owner$" is shooting a "$ProjectileClass );
		bPointing=True;
		bCanClientFire = true;
//		log(class$ " WES: Calling ClientFire ");
		ClientFire(Value);
//		PlayFiring();
//		log(class$ " WES: Fire Weapon. Going to NormalFire state");
		GotoState('NormalFire');
//		log(class$ " WES: Back from NormalFire state");
		if ( bRapidFire || (FiringSpeed > 0) )
			Pawn(Owner).PlayRecoil(FiringSpeed);
		ProjectileFire(ProjectileClass, ProjectileSpeed, bWarnTarget);
	}
//log( Pawn(Owner)$" has regfired me with BH = "$Pawn(Owner).BallHolding );
}

state NormalFire
{
	function AnimEnd()
	{
//		log(class$ " WES: Normal Fire state AnimEnd");
	}

Begin:
//	log(class$ "WES: State Normal Fire begin label");
	FinishAnim();
	Sleep(0.8);
	Finish();
}

function AltFire( float Value )
{
	local int i;
	local bool Shooting;
	
	bPointing=True;

//log( Pawn(Owner)$" is altfiring me with BH = "$Pawn(Owner).BallHolding );
	Shooting = false;
	for (i = 1; i < 8; i++)
	{
		if (Shooting)
			continue;		
		if (Pawn(Owner).IsHoldingBall(i))
		{
			Shooting = true;
			switch (i)
			{
				case 1:	AltProjectileClass = class'SHBBall';	break;
				case 2:	AltProjectileClass = class'SHGBall';	break;
				case 3:	AltProjectileClass = class'SHYBall';	break;
				case 4:	AltProjectileClass = class'SHOBall';	break;
				case 5:	AltProjectileClass = class'SHRBall';	break;
				case 6:	AltProjectileClass = class'SHPBall';	break;
				case 7:	AltProjectileClass = class'SHGOBall';	break;
			}
			AltProjectileSpeed = AltProjectileClass.Default.speed;
			Pawn(Owner).SetHoldingBall(i, False);
			Level.Game.DiscardBall(Pawn(Owner), i);
		}
	}
	if (Shooting)
	{
		bPointing=True;
		bCanClientFire = true;
//		log(class$ " WES: Calling ClientAltFire ");
		ClientAltFire(Value);
		PlayAltFiring();
//		log(class$ " WES: Fire Weapon. Going to AltFire state");
		GotoState('AltFiring');
//		log(class$ " WES: Back from AltFire state");
		if ( bRapidFire || (FiringSpeed > 0) )
			Pawn(Owner).PlayRecoil(FiringSpeed);
		ProjectileFire(AltProjectileClass, AltProjectileSpeed, bAltWarnTarget);
	}
//log( Pawn(Owner)$" has altfired me with BH = "$Pawn(Owner).BallHolding );
}

// DSL exact copy of AltFire, but allows bots to shoot at will
function AltFire2( float Value )
{
	local int i;
	local bool Shooting;
	
	bPointing=True;

//log( Pawn(Owner)$" is altfiring2 me with BH = "$Pawn(Owner).BallHolding );
	Shooting = false;
	for (i = 1; i < 8; i++)
	{
		if (Shooting)
			continue;		
		if (Pawn(Owner).IsHoldingBall(i))
		{
			Shooting = true;
			switch (i)
			{
				case 1:	AltProjectileClass = class'SHBBall';	break;
				case 2:	AltProjectileClass = class'SHGBall';	break;
				case 3:	AltProjectileClass = class'SHYBall';	break;
				case 4:	AltProjectileClass = class'SHOBall';	break;
				case 5:	AltProjectileClass = class'SHRBall';	break;
				case 6:	AltProjectileClass = class'SHPBall';	break;
				case 7:	AltProjectileClass = class'SHGOBall';	break;
			}
			AltProjectileSpeed = AltProjectileClass.Default.speed;
			Pawn(Owner).SetHoldingBall(i, False);
			Level.Game.DiscardBall(Pawn(Owner), i);
		}
	}
	if (Shooting)
	{
		bPointing=True;
		bCanClientFire = true;
//		log(class$ " WES: Calling ClientAltFire ");
		ClientAltFire(Value);
		PlayAltFiring();
//		log(class$ " WES: Fire Weapon. Going to AltFire state");
		GotoState('AltFiring');
//		log(class$ " WES: Back from AltFire state");
		if ( bRapidFire || (FiringSpeed > 0) )
			Pawn(Owner).PlayRecoil(FiringSpeed);
		ProjectileFire(AltProjectileClass, AltProjectileSpeed, bAltWarnTarget);
	}
//log( Pawn(Owner)$" has altfired2 me with BH = "$Pawn(Owner).BallHolding );
}

// DSL -- enabling bots to fire shballgun regardless of state of pseudoweapon --
// this works because it is not really a weapon, just a tool, and it doesn't need
// lots of internal machinery
state AltFiring
{
	function AnimEnd()
	{
	}


    function AltFire(float Value)
    {
        AltFire2( value );
    }
Begin:
//	log(class$ "WES: State AltFiring begin label");
	FinishAnim();
	Sleep(0.2);
	Finish();
}
state Active
{
    function AltFire(float Value)
    {
        AltFire2( value );
    }
}

/*
state AltFiring
{
	function AnimEnd()
	{
	}

Begin:
//	log(class$ "WES: State AltFiring begin label");
	FinishAnim();
	Sleep(0.2);
	Finish();
}


state Active
{
    function bool PutDown()
    {
        if ( bWeaponUp || (AnimFrame < 0.75) )
            GotoState('DownWeapon');
        else
            bChangeWeapon = true;
        return True;
    }

    function BeginState()
    {
        bChangeWeapon = false;
    }

Begin:
    FinishAnim();
    if ( bChangeWeapon )
        GotoState('DownWeapon');
    bWeaponUp = True;
    PlayPostSelect();
    FinishAnim();
    Finish();
}
*/

simulated function PlayFiring()
{
//log( self$" playing "$FireSound );
	Owner.PlaySound(FireSound, SLOT_Misc,Pawn(Owner).SoundDampening);
	PlayAnim('select', 1.0, 0.05);
}

simulated function PlayAltFiring()
{
//log( self$" altplaying "$FireSound );
	Owner.PlaySound(AltFireSound, SLOT_Misc,Pawn(Owner).SoundDampening);
	PlayAnim('select', 1.0, 0.05);
}
simulated function PlayIdleAnim()
{
	PlayAnim('idle',0.25,0.05);
}

///////////////////////////////////////////////////////

defaultproperties
{
     AmmoName=Class'NerfI.SHBall'
     PickupAmmoCount=1
     bAltWarnTarget=True
     bCanThrow=False
     FireOffset=(X=12.000000,Z=-4.500000)
     ProjectileClass=Class'NerfI.SHBallproj'
     AltProjectileClass=Class'NerfI.SHBallproj'
     shakemag=200.000000
     shaketime=0.300000
     AIRating=0.400000
     RefireRate=1.800000
     AltRefireRate=1.000000
     FireSound=Sound'NerfI.SHBallGun.SHAltfireS'
     AltFireSound=Sound'NerfI.SHBallGun.SHAltfireS'
     AutoSwitchPriority=0
     PickupMessage=You picked up the Ball Shooter
     ItemName=ScavengerHunt Gun
     PlayerViewOffset=(X=7.000000,Z=-4.500000)
     PlayerViewScale=0.150000
     PickupSound=Sound'NerfI.SHBallGun.SHpickS'
     bNoSmooth=False
     SoundRadius=64
     SoundVolume=255
     CollisionRadius=40.000000
     CollisionHeight=28.000000
     Mass=50.000000
}
