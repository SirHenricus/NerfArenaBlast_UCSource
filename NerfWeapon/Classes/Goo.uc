//=============================================================================
// Goo.
//=============================================================================
class Goo extends Projectile;

#exec MESH IMPORT MESH=Goo ANIVFILE=g:\nerfres\weaponanimation\MODELS\ballzooka_alt_fire_goo_a.3d DATAFILE=g:\nerfres\weaponanimation\MODELS\ballzooka_alt_fire_goo_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=Goo X=0 Y=0 Z=0 ROLL=64

#exec MESH SEQUENCE MESH=Goo SEQ=All                      STARTFRAME=0 NUMFRAMES=32
#exec MESH SEQUENCE MESH=Goo SEQ=hit                      STARTFRAME=0 NUMFRAMES=7
#exec MESH SEQUENCE MESH=Goo SEQ=jiggle                   STARTFRAME=7 NUMFRAMES=9
#exec MESH SEQUENCE MESH=Goo SEQ=dissolve                 STARTFRAME=16 NUMFRAMES=7
#exec MESH SEQUENCE MESH=Goo SEQ=fly                      STARTFRAME=23 NUMFRAMES=9

#exec MESHMAP NEW   MESHMAP=Goo MESH=Goo
#exec MESHMAP SCALE MESHMAP=Goo X=0.035 Y=0.035 Z=0.07

#exec TEXTURE IMPORT NAME=ballzooka_alt_fire_goo_01 FILE=g:\nerfres\weaponanimation\Textures\ballzooka_alt_fire_goo_01.PCX GROUP=Skins FLAGS=2	//Material #9

#exec MESHMAP SETTEXTURE MESHMAP=Goo NUM=1 TEXTURE=ballzooka_alt_fire_goo_01

// Impact Sound
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\specialfx\htzokalt.wav" NAME="GoohitS" GROUP="Ballzoka"

var vector SurfaceNormal;	
var bool bCanHitOwner, bOnGround;
var Pawn Hitpawn;

function Timer()
{
	Hitpawn.Groundspeed = Hitpawn.default.GroundSpeed;
	Hitpawn.JumpZ = Hitpawn.default.JumpZ;
	Destroy();	
}

simulated function SetWall(vector HitNormal, Actor Wall)
{
	local vector TraceNorm, TraceLoc, Extent;
	local actor HitActor;
	local rotator RandRot;

	SurfaceNormal = HitNormal;
	RandRot = rotator(HitNormal);
	RandRot.PITCH -= 16385;
	SetRotation(RandRot);
	if ( Mover(Wall) != None )
		SetBase(Wall);
}


auto state Flying
{
	function ProcessTouch (Actor Other, vector HitLocation) 
	{ 
		local vector hitDir;

		if (Pawn(Other) == None)
			return;
		if ((Pawn(Other).GroundSpeed < 0) && (Pawn(Other).JumpZ < 10))
		{
			Hitpawn = Pawn(Other);
			Hitpawn.TakeDamage(damage, instigator,HitLocation,
				(MomentumTransfer * hitDir), 'shot');
		}
		else if ( (Pawn(Other)!=Instigator || bCanHitOwner) && !bOnGround) 
		{
			hitDir = Normal(Velocity);
			if ( FRand() < 0.2 )
				hitDir *= 5;
			Hitpawn = Pawn(Other);
			Hitpawn.TakeDamage(damage, instigator,HitLocation,
				(MomentumTransfer * hitDir), 'shot');
			Hitpawn.Groundspeed = -1.0;
			Hitpawn.JumpZ = 9.0;
			Hitpawn.LoopAnim('StucknGoo');
			SetTimer(4, False);
		}
	}

	simulated function HitWall( vector HitNormal, actor Wall )
	{
		SetPhysics(PHYS_None);		
		MakeNoise(0.3);	
		bOnGround = True;
		bCanHitOwner = True;
		PlaySound(ImpactSound);
		SetWall(HitNormal, Wall);
		PlayAnim('hit');
		GoToState('OnSurface');
	}


	simulated function ZoneChange( Zoneinfo NewZone )
	{
		local waterring w;
		
		if (!NewZone.bWaterZone) Return;
	
		if (!bOnGround) 
		{
			w = Spawn(class'WaterRing',,,,rot(16384,0,0));
			w.DrawScale = 0.1;
		}
		bOnGround = True;
		bCanHitOwner = True;
		Velocity=0.1*Velocity;
	}
	
	function Timer()
	{
		Global.Timer();
	}

	function BeginState()
	{	
		if ( Role == ROLE_Authority )
		{
			Velocity = Vector(Rotation) * Speed;
			Velocity.z += 120;
			if( Region.zone.bWaterZone )
				Velocity=Velocity*0.7;
		}
		if ( Level.NetMode != NM_DedicatedServer )
			RandSpin(100000);
		LoopAnim('Fly',0.4);
		bOnGround=False;
		bCanHitOwner = False;
		PlaySound(SpawnSound);
	}
}


state OnSurface
{

	function Timer()
	{
		Global.Timer();
	}

	function ProcessTouch (Actor Other, vector HitLocation)
	{
		if (Pawn(Other) == None)
			return;
		if ((Pawn(Other).GroundSpeed > 0) && (Pawn(Other).JumpZ > 10))
		{
			Hitpawn = Pawn(Other);
			Hitpawn.Groundspeed = -1.0;
			Hitpawn.JumpZ = 9.0;
			Hitpawn.LoopAnim('StucknGoo');
			if(LifeSpan < 4)
				LifeSpan = 5;
			SetTimer(4, False);
		}
	}
Begin:
	LoopAnim('jiggle');
}

defaultproperties
{
     speed=800.000000
     MaxSpeed=1500.000000
     Damage=30.000000
     MyDamageType=Corroded
     ImpactSound=Sound'NerfWeapon.Ballzoka.GoohitS'
     bNetTemporary=False
     Physics=PHYS_Falling
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=8.000000
     AnimSequence=Fly
     Texture=Texture'NerfWeapon.Skins.ballzooka_alt_fire_goo_01'
     Mesh=LodMesh'NerfWeapon.Goo'
     AmbientGlow=255
     bUnlit=True
     bMeshEnviroMap=True
     CollisionRadius=10.000000
     CollisionHeight=10.000000
     bProjTarget=True
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightBrightness=100
     LightHue=91
     LightRadius=3
     bBounce=True
     Buoyancy=170.000000
}
