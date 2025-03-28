//=============================================================================
// SHBallproj
//
// Created by Wezo
//=============================================================================
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\pickups\pkball2.wav" NAME="SHBallprojpickS" GROUP="SHBall"

class SHBallproj extends Projectile
	abstract;

var int Points;
var byte slot;
var bool bCanHitOwner, bHitWater;
var float Count;
var NerfBots WarnTarget;	// warn this pawn away


simulated function PostBeginPlay()
{
	local vector X,Y,Z;
	local rotator RandRot;
	local vector InitialDir;

	Super.PostBeginPlay();

	if ( Role == ROLE_Authority )
	{

		bCanHitOwner = False;
		initialDir = vector(Rotation);	
		Velocity = speed*initialDir;
		Velocity.z += 210;
		Velocity = Velocity >> RandRot;
		RandSpin(50000);	
		if (Region.Zone.bWaterZone)
		{
			bHitWater = True;
			Velocity=0.6*Velocity;
		}
	}	
}

simulated function ZoneChange( Zoneinfo NewZone )
{
	local waterring w;
	
	if (!NewZone.bWaterZone || bHitWater) Return;

	if (NewZone.bWaterZone && NewZone.bPainZone)
	{
//		log(class$ " WES: Cloud zone killed Ball Generate");
		GeneratorRespawn();
	}

	bHitWater = True;
	w = Spawn(class'WaterRing',,,,rot(16384,0,0));
	w.DrawScale = 0.2;
	w.RemoteRole = ROLE_None;
	Velocity=0.6*Velocity;
}

simulated function Timer()
{
	Explosion(Location+Vect(0,0,1)*16);
}

simulated function Landed( vector HitNormal )
{
	HitWall( HitNormal, None );
}

simulated function ProcessTouch( actor Other, vector HitLocation )
{
	if ( (Other!=instigator) || bCanHitOwner )
		Explosion(HitLocation);
}

simulated function HitWall( vector HitNormal, actor Wall )
{
	bCanHitOwner = True;
	Velocity = 0.8*(( Velocity dot HitNormal ) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping
	RandSpin(100000);
	speed = VSize(Velocity);
	if ( Level.NetMode != NM_DedicatedServer )
		PlaySound(ImpactSound, SLOT_Misc, FMax(0.5, speed/800) );
	if ( Velocity.Z > 400 )
		Velocity.Z = 0.5 * (400 + Velocity.Z);	
	else if ( speed < 60 ) 
	{
		bBounce = False;
		SetPhysics(PHYS_Falling);
		Speed=0;
		BecomeBallPickup();
	}
}

simulated function Explosion(vector HitLocation)
{
// 	log(class$ " WES: calling destroy");
	Destroy();
}

//##nerf WES
// Implemented in sub-class
simulated function BecomeBallPickup()
{
}

function GeneratorRespawn()
{
//	log(class$ " WES: GeneratorRespawn ball");
	Level.Game.RespawnColorBall(slot);
	Destroy();
}

defaultproperties
{
     speed=800.000000
     MomentumTransfer=60000
     MiscSound=Sound'NerfI.SHBall.SHBallprojpickS'
     Physics=PHYS_Falling
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=0.000000
     AnimRate=1.000000
     Mesh=LodMesh'NerfI.SHBalls'
     AmbientGlow=64
     bUnlit=True
     bNoSmooth=True
     CollisionRadius=16.000000
     CollisionHeight=16.000000
     bBounce=True
     bFixedRotationDir=True
     Mass=50.000000
     DesiredRotation=(Pitch=12000,Yaw=5666,Roll=2334)
}
