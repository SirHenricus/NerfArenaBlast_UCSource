//=============================================================================
// ball.
//=============================================================================
class ball expands Projectile;

#exec MESH IMPORT MESH=ball ANIVFILE=g:\NerfRes\weaponMesh\MODELS\ball01_a.3d DATAFILE=g:\NerfRes\weaponMesh\MODELS\ball01_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=ball X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=ball SEQ=All  STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=Jball0 FILE=g:\NerfRes\weaponMesh\MODELS\ball01_01.PCX GROUP=Skins FLAGS=2 // Skin

#exec MESHMAP NEW   MESHMAP=ball MESH=ball
#exec MESHMAP SCALE MESHMAP=ball X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=ball NUM=1 TEXTURE=Jball0

// Impact Sound
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\specialfx\htzok.wav" NAME="BallhitS" GROUP="Ballzoka"

var bool bCanHitOwner, bHitWater;
var float Count, SmokeRate;
var NerfBots WarnTarget;	// warn this pawn away
var int NumExtraBalls;

function PostBeginPlay()
{
	local vector X,Y,Z;
	local rotator RandRot;

	Super.PostBeginPlay();
	GetAxes(Instigator.ViewRotation,X,Y,Z);	
	Velocity = X * (Instigator.Velocity Dot X)*0.4 + Vector(Rotation) * Speed +
		FRand() * 100 * Vector(Rotation);
	Velocity.z += 210;
	SetTimer(2.5+FRand()*0.5,false);                  //Ball begins unarmed
	MaxSpeed = 2000;
	Velocity = Velocity >> RandRot;
	RandSpin(50000);	
	bCanHitOwner = False;
	if (Instigator.HeadRegion.Zone.bWaterZone)
	{
		bHitWater = True;
		Disable('Tick');
		Velocity=0.6*Velocity;			
	}	
}

simulated function BeginPlay()
{
	if (Level.bHighDetailMode) SmokeRate = 0.03;
	else SmokeRate = 0.15;
}

	simulated function ZoneChange( Zoneinfo NewZone )
	{
		local waterring w;
		
		if (!NewZone.bWaterZone || bHitWater) Return;

		bHitWater = True;
		w = Spawn(class'WaterRing',,,,rot(16384,0,0));
		w.DrawScale = 0.2;
		w.RemoteRole = ROLE_None;
		Velocity=0.6*Velocity;
	}

	function Timer()
	{
//		Explosion(Location+Vect(0,0,1)*16);
	}

	simulated function Tick(float DeltaTime)
	{

		if (bHitWater) 
		{
			Disable('Tick');
			Return;
		}
		Count += DeltaTime;
		if ( (Physics == PHYS_None) && (WarnTarget != None) && WarnTarget.bCanDuck 
			&& (WarnTarget.Physics == PHYS_Walking) && (WarnTarget.Acceleration != vect(0,0,0)) )
			WarnTarget.Velocity = WarnTarget.Velocity + 2 * DeltaTime * WarnTarget.GroundSpeed 
									* Normal(WarnTarget.Location - Location);
	}

	simulated function Landed( vector HitNormal )
	{
		HitWall( HitNormal, None );
	}

	function ProcessTouch( actor Other, vector HitLocation )
	{
		local BallExp s;

		if (((Other!=instigator) || bCanHitOwner ) && (Pawn(Other)!=None))
		{
			Explosion(HitLocation);

			s = spawn(class'BallExp',,,HitLocation);	
			s.RemoteRole = ROLE_None;

			destroy();
		}
	}

	simulated function HitWall( vector HitNormal, actor Wall )
	{
		
		Velocity = 0.8*(( Velocity dot HitNormal ) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping
		RandSpin(100000);
		speed = VSize(Velocity);

//##nerf WES 
		Wall.TakeDamage(0, Instigator, Location, Vect(0,0,0), 'shot');

		if ( Level.NetMode != NM_DedicatedServer )
			PlaySound(ImpactSound, SLOT_Misc, FMax(0.5, speed/800) );
		if ( Velocity.Z > 400 )
			Velocity.Z = 0.5 * (400 + Velocity.Z);	
		else if ( speed < 20 ) 
		{
			bBounce = False;
			SetPhysics(PHYS_None);
			BecomeBallPickup();
		}
	}

	///////////////////////////////////////////////////////
	function Explosion(vector HitLocation)
	{
		PlaySound(SpawnSound);
		HurtRadius(damage, 50, 'exploded', MomentumTransfer, HitLocation);

	}
	
	simulated function BecomeBallPickup()
	{
		local Vector TempLoc;
		local BallPickup b;
		
		TempLoc = Location;
		Destroy();
	
		if ( Level.NetMode != NM_Client ) 
		{
			b=Spawn(class 'BallPickup',,'',TempLoc,rot(0,0,0));
			b.LifeSpan=+10.0;
		}
	}

defaultproperties
{
     speed=1600.000000
     Damage=25.000000
     MomentumTransfer=6000
     Physics=PHYS_Falling
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=0.000000
     AnimRate=1.000000
     Mesh=LodMesh'NerfWeapon.ball'
     DrawScale=0.150000
     AmbientGlow=64
     bUnlit=True
     bNoSmooth=True
     CollisionRadius=5.000000
     CollisionHeight=5.000000
     bBounce=True
     bFixedRotationDir=True
     Mass=50.000000
     DesiredRotation=(Pitch=12000,Yaw=5666,Roll=2334)
}
