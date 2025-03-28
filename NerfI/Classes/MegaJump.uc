//=============================================================================
// MegaJump Pickup - Lets actor jump higher for a set period of time
// DWG 2/26/99
//=============================================================================


class MegaJump expands Pickup;

#exec MESH IMPORT MESH=MegaJumpm ANIVFILE=g:\NerfRes\NerfMesh\MODELS\megjump_a.3d DATAFILE=g:\NerfRes\NerfMesh\MODELS\megjump_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=MegaJumpm X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=MegaJumpm SEQ=All                   STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=MegaJumpm SEQ=Static                STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=MegaJumpm MESH=MegaJumpm
#exec MESHMAP SCALE MESHMAP=MegaJumpm X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=MegaJumpSkin FILE=g:\NerfRes\NerfMesh\MODELS\megjump1.PCX GROUP=Skins FLAGS=2	

#exec MESHMAP SETTEXTURE MESHMAP=MegaJumpm NUM=1 TEXTURE=MegaJumpSkin

// Audio sound effects
// ##nerf WES Sounds
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\pickups\pkjump.wav" NAME="MJpickS" GROUP="Pickups"

var() int TimeLasts;
var() float JumpFactor;

function PostBeginPlay()
{
	PickupViewMesh=Mesh(DynamicLoadObject("NerfI.MegaJumpm", class'Mesh'));
	Charge=TimeLasts;
	Super.PostBeginPlay();
}

/*
function PickupFunction(Pawn Other)
{
	//TraceLog(class, 1, "in PickupFunction()");

	SetTimer(TimeLasts, True);

	if (Owner.IsA('PlayerPawn'))
		PlayerPawn(Owner).bCountJumps = True;
	Pawn(Owner).JumpZ = Pawn(Owner).Default.JumpZ * JumpFactor;
	Owner.PlaySound(ActivateSound);
			
	// glow effect
	if (Owner.IsA('PlayerPawn'))
		PlayerPawn(Owner).ClientAdjustGlow(-0.1,vect(100,0,20));
	Owner.LightType = LT_Steady;	
	Owner.LightRadius = 6;
	Owner.LightEffect = LE_NonIncidence;
	Owner.LightSaturation = 0;
	Owner.LightHue = 56;
	Owner.LightBrightness = 255;
}

function Timer()
{
	// time used up - deactivate effect
	Owner.PlaySound(DeActivateSound);						
	Pawn(Owner).JumpZ = Pawn(Owner).Default.JumpZ * Level.Game.PlayerJumpZScaling();	
	if (Owner.IsA('PlayerPawn'))
		PlayerPawn(Owner).ClientAdjustGlow(0.1,vect(-100,0,-20));
	Owner.LightType = LT_None;
	Owner.AmbientGlow = 0;	
	UsedUp();
	SetRespawn();
}
*/
function PickupFunction(Pawn Other)
{
//	log(class$ " WES: setting timer at pickupfunction" @other);
	if (Owner.IsA('PlayerPawn'))
		PlayerPawn(Owner).bCountJumps = True;
	Pawn(Owner).JumpZ = Pawn(Owner).Default.JumpZ * JumpFactor;
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
			PlayerPawn(Owner).ClientAdjustGlow(0.1,vect(-100,0,-20));
		Owner.AmbientSound=None;
		Owner.LightType=LT_None;
		Owner.AmbientGlow=0;	
		Owner.PlaySound(DeActivateSound);						
		Pawn(Owner).JumpZ = Pawn(Owner).Default.JumpZ * Level.Game.PlayerJumpZScaling();	

		bActive = false;		
	}
Begin:
	SetTimer(1.0,True);
	// glow effect
	if (Owner.IsA('PlayerPawn'))
		PlayerPawn(Owner).ClientAdjustGlow(-0.1,vect(100,0,20));
	Owner.LightType = LT_Steady;	
	Owner.LightRadius = 6;
	Owner.LightEffect = LE_NonIncidence;
	Owner.LightSaturation = 0;
	Owner.LightHue = 56;
	Owner.LightBrightness = 255;

}

state DeActivated
{
Begin:

}

defaultproperties
{
     TimeLasts=20
     JumpFactor=2.000000
     bCanActivate=True
     ExpireMessage=Mega Jump expired
     bAutoActivate=True
     bActivatable=True
     bDisplayableInv=True
     bRotatingPickup=True
     PickupMessage=You got the Mega Jump
     RespawnTime=90.000000
     MaxDesireability=1.000000
     PickupSound=Sound'NerfI.Pickups.MJpickS'
     RemoteRole=ROLE_DumbProxy
     AmbientGlow=64
     CollisionRadius=20.000000
     CollisionHeight=28.000000
}
