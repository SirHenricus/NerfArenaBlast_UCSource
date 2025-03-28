//=============================================================================
// MegaSpeed - Inreases player movement and weapon fire speed for period of time
// DWG 2/26/99
//=============================================================================

class MegaSpeed extends Pickup;

#exec MESH IMPORT MESH=MegaSpeedm ANIVFILE=g:\NerfRes\NerfMesh\MODELS\speedbo_a.3d DATAFILE=g:\NerfRes\NerfMesh\MODELS\speedbo_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=MegaSpeedm X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=MegaSpeedm SEQ=All     STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=MegaSpeedSkin FILE=g:\NerfRes\NerfMesh\MODELS\speedbo1.PCX GROUP=Skins FLAGS=2 // Material #1

#exec MESHMAP NEW   MESHMAP=MegaSpeedm MESH=MegaSpeedm
#exec MESHMAP SCALE MESHMAP=MegaSpeedm X=0.0375 Y=0.0375 Z=0.065

#exec MESHMAP SETTEXTURE MESHMAP=MegaSpeedm NUM=1 TEXTURE=MegaSpeedSkin

// Audio sound effects
// ##nerf WES Sounds
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\pickups\pkspeed.wav" NAME="MSpickS" GROUP="Pickups"

var() int TimeLasts;
var() float SpeedFactor;
var() float AccelFactor;

function PostBeginPlay()
{
	PickupViewMesh=Mesh(DynamicLoadObject("NerfI.MegaSpeedm", class'Mesh'));
	Charge=TimeLasts;
	Super.PostBeginPlay();
}

/*
function PickupFunction(Pawn Other)
{
	SetTimer(TimeLasts, True);

	Pawn(Owner).GroundSpeed = Pawn(Owner).Default.GroundSpeed * SpeedFactor;
	Pawn(Owner).AccelRate = Pawn(Owner).Default.AccelRate * AccelFactor;
	Owner.PlaySound(ActivateSound);
			
	// glow effect
	if ( Owner.IsA('PlayerPawn') )
		PlayerPawn(Owner).ClientAdjustGlow(-0.1,vect(20,0,100));
	Owner.LightType = LT_Steady;	
	Owner.LightRadius = 6;
	Owner.LightEffect = LE_NonIncidence;
	Owner.LightSaturation = 0;
	Owner.LightHue = 12;
	Owner.LightBrightness = 255;
}

function Timer()
{
	// time used up - deactivate effect
	Owner.PlaySound(DeActivateSound);						
	Pawn(Owner).GroundSpeed = Pawn(Owner).Default.GroundSpeed;
	Pawn(Owner).AccelRate = Pawn(Owner).Default.AccelRate;
	if ( Owner.IsA('PlayerPawn') )
		PlayerPawn(Owner).ClientAdjustGlow(0.1,vect(-20,0,-100));
	Owner.LightType = LT_None;
	Owner.AmbientGlow = 0;	
	UsedUp();
	SetRespawn();
}
*/

function PickupFunction(Pawn Other)
{
//	log(class$ " WES: setting timer at pickupfunction" @other);
	Pawn(Owner).GroundSpeed = Pawn(Owner).Default.GroundSpeed * SpeedFactor;
	Pawn(Owner).AccelRate = Pawn(Owner).Default.AccelRate * AccelFactor;
	Owner.PlaySound(ActivateSound);
	SetTimer(1.0,True);
}

state Activated
{
	function Timer()
	{
		Charge -= 1;
		if (Charge<=0) 
		{
			UsedUp();		
		}
	}

	function EndState()
	{
		local Inventory Qd;
		
		if ( Owner.IsA('PlayerPawn') )
			PlayerPawn(Owner).ClientAdjustGlow(0.1,vect(-20,0,-100));
		Owner.AmbientSound=None;
		Owner.LightType=LT_None;
		Owner.AmbientGlow=0;	
		Owner.PlaySound(DeActivateSound);						
		Pawn(Owner).GroundSpeed = Pawn(Owner).Default.GroundSpeed;
		Pawn(Owner).AccelRate = Pawn(Owner).Default.AccelRate;

		bActive = false;		
	}
Begin:
	SetTimer(1.0,True);
	// glow effect
	if (Owner.IsA('PlayerPawn'))
		PlayerPawn(Owner).ClientAdjustGlow(-0.1,vect(20,0,100));
	Owner.LightType = LT_Steady;	
	Owner.LightRadius = 6;
	Owner.LightEffect = LE_NonIncidence;
	Owner.LightSaturation = 0;
	Owner.LightHue = 12;
	Owner.LightBrightness = 255;

}

state DeActivated
{
Begin:

}

defaultproperties
{
     TimeLasts=5
     SpeedFactor=2.000000
     AccelFactor=2.000000
     bCanActivate=True
     ExpireMessage=Mega Speed expired
     bAutoActivate=True
     bActivatable=True
     bDisplayableInv=True
     bRotatingPickup=True
     PickupMessage=You got the Mega Speed
     RespawnTime=90.000000
     MaxDesireability=1.000000
     PickupSound=Sound'NerfI.Pickups.MSpickS'
     RemoteRole=ROLE_DumbProxy
     AmbientGlow=64
     CollisionRadius=20.000000
     CollisionHeight=28.000000
}
