//=============================================================================
// rocket.
//=============================================================================
class rocket expands Projectile;
//##nerf WES Texture FIXME
//Need Mesh and Sounds

#exec MESH IMPORT MESH=Rocket ANIVFILE=g:\NerfRes\weaponMesh\MODELS\triple_shot_rocket_a.3d DATAFILE=g:\NerfRes\weaponMesh\MODELS\triple_shot_rocket_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=Rocket X=0 Y=0 Z=0 YAW=-128

#exec MESH SEQUENCE MESH=Rocket SEQ=All                      STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=Rocket MESH=triple_shot_rocket
#exec MESHMAP SCALE MESHMAP=Rocket X=0.06 Y=0.06 Z=0.12

#exec MESHMAP SETTEXTURE MESHMAP=Rocket NUM=1 TEXTURE=NerfWeapon.triple_strike_pu_03

// Impact Sound
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\specialfx\httriple.wav" NAME="RoxhitS" GROUP="TripleShot"

var float MagnitudeVel,Count,SmokeRate;
var vector InitialDir;
var bool bRing,bHitWater,bWaterStart;
var int NumExtraRockets;

simulated function PostBeginPlay()
{
	Count = -0.1;
	if (Level.bHighDetailMode) SmokeRate = 0.035;
	else SmokeRate = 0.15;
}

simulated function Tick(float DeltaTime)
{
	local SpriteRoxTrail b;

	if (bHitWater)
	{
		Disable('Tick');
		Return;
	}
	Count += DeltaTime;
	if ( (Count>(SmokeRate+FRand()*(SmokeRate+NumExtraRockets*0.035))) && (Level.NetMode!=NM_DedicatedServer) ) 
	{
		b = Spawn(class'SpriteRoxTrail');
		b.RemoteRole = ROLE_None;		
		Count=0.0;
	}
}

auto state Flying
{

	simulated function ZoneChange( Zoneinfo NewZone )
	{
//		local waterring w;
		
		if (!NewZone.bWaterZone || bHitWater) Return;

		bHitWater = True;
		Disable('Tick');
		if ( Level.NetMode != NM_DedicatedServer )
		{
//##nerf WES Texture FIXME
//Water ring effect.
/*
			w = Spawn(class'WaterRing',,,,rot(16384,0,0));
			w.DrawScale = 0.2;
			w.RemoteRole = ROLE_None;
			PlayAnim( 'Still', 3.0 );
*/
		}		
		Velocity=0.6*Velocity;
	}

	simulated function ProcessTouch (Actor Other, Vector HitLocation)
	{
		if ((Other != instigator) && (Rocket(Other) == none)) 
			Explode(HitLocation,Normal(HitLocation-Other.Location));
	}

	function BlowUp(vector HitLocation)
	{
		if ( Level.Game.IsA('DeathMatchGame') ) //bigger damage radius
			HurtRadius(Damage,200.0, 'exploded', MomentumTransfer, HitLocation );
		else
			HurtRadius(Damage,150.0, 'exploded', MomentumTransfer, HitLocation );
		MakeNoise(1.0);
		PlaySound(ImpactSound, SLOT_None, 2.3);	

	}

	simulated function Explode(vector HitLocation, vector HitNormal)
	{
//##nerf WES Texture FIXME
//Some kind of explosion effect.
/*
		local SpriteBallExplosion s;
		local RingExplosion3 r;

		s = spawn(class'SpriteBallExplosion',,,HitLocation + HitNormal*16);	
 		s.RemoteRole = ROLE_None;

		if (bRing) 
		{
			r = Spawn(class'RingExplosion3',,,HitLocation + HitNormal*16,rotator(HitNormal));
			r.RemoteRole = ROLE_None;
		}
*/
		local TripleExp s;

		s = spawn(class'TripleExp',,,HitLocation + HitNormal*16);	
 		s.RemoteRole = ROLE_None;

		BlowUp(HitLocation);

 		Destroy();
	}

	function BeginState()
	{
		initialDir = vector(Rotation);	
		Velocity = speed*initialDir;
		Acceleration = initialDir*50;
//		PlaySound(SpawnSound, SLOT_None, 2.3);	
//		PlayAnim( 'Armed', 0.2 );
		if (Region.Zone.bWaterZone)
		{
			bHitWater = True;
			Velocity=0.6*Velocity;
		}
	}
}

defaultproperties
{
     speed=1500.000000
     MaxSpeed=3000.000000
     Damage=70.000000
     MomentumTransfer=80000
     ImpactSound=Sound'NerfWeapon.TripleShot.RoxhitS'
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=6.000000
     AnimSequence=Armed
     Mesh=LodMesh'NerfWeapon.Rocket'
     AmbientGlow=96
     bUnlit=True
     SoundRadius=9
     SoundVolume=255
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightBrightness=126
     LightHue=28
     LightSaturation=64
     LightRadius=6
     bCorona=True
     bBounce=True
}
