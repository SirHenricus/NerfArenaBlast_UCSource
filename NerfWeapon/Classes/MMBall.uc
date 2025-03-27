//=============================================================================
// MMBall
//=============================================================================
class MMBall expands Projectile;

// Impact Sound
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\specialfx\htmoalt.wav" NAME="MMBallhitS" GROUP="MightyMo"
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\specialfx\htmoalt2.wav" NAME="MMBallExpS" GROUP="MightyMo"

var bool bCanHitOwner, bHitWater;
var int TimeSpan;

auto state Flying
{

	simulated function ZoneChange( Zoneinfo NewZone )
	{
		local waterring w;
	
		if (!NewZone.bWaterZone || bHitWater) Return;
		bHitWater = True;
		Disable('Tick');
		if ( Level.NetMode != NM_DedicatedServer )
		{
			w = Spawn(class'WaterRing',,,,rot(16384,0,0));
			w.DrawScale = 0.2;
			w.RemoteRole = ROLE_None;
		}		
		Velocity=0.6*Velocity;
	}


	simulated function ProcessTouch (Actor Other, Vector HitLocation)
	{
		if ((Other != instigator) || bCanHitOwner ) 
			Explode(HitLocation,Normal(HitLocation-Other.Location));
	}

	function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, 
						Vector momentum, name damageType)
	{
		Explode(HitLocation,Normal(HitLocation));
	}


	simulated function Timer()
	{
		Explode(Location,Vect(0,0,1));
	}

	function BlowUp(vector HitLocation)
	{
		HurtRadius(damage, 150, MyDamageType, MomentumTransfer, HitLocation);
		MakeNoise(1.0);
	}

	simulated function HitWall( vector HitNormal, actor Wall )
	{
		bCanHitOwner = True;
		Velocity = 0.8*(( Velocity dot HitNormal ) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping
		RandSpin(100000);
		speed = VSize(Velocity);

		if (Wall != None)
			Wall.TakeDamage(0, Instigator, Location, Vect(0,0,0), 'shot');

		if ( Level.NetMode != NM_DedicatedServer )
			PlaySound(ImpactSound, SLOT_Misc, FMax(0.5, speed/800) );
		if ( Velocity.Z > 400 )
			Velocity.Z = 0.5 * (400 + Velocity.Z);	
		else if ( speed < 60 ) 
		{
			bBounce = False;
			SetPhysics(PHYS_Falling);
			GotoState('BombTicking');
/*
			Speed=0;
			SetTimer(TimeSpan, false);
*/
		}
	}

	simulated function Landed( vector HitNormal )
	{
		HitWall( HitNormal, None );
	}

	simulated function Explode(vector HitLocation, vector HitNormal)
	{
		local MightyMExp s;

		BlowUp(HitLocation);
		s = spawn(class'MightyMExp',,,HitLocation + HitNormal*16 );	
		s.RemoteRole = ROLE_None;
		PlaySound(MiscSound, SLOT_None, 2.3);	
		Destroy();
	}

	simulated function BeginState()
	{
		local rotator RandRot;
		local vector InitialDir;

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

State BombTicking
{

	simulated function ProcessTouch (Actor Other, Vector HitLocation)
	{
		Explode(HitLocation,Normal(HitLocation-Other.Location));
	}

	function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, 
						Vector momentum, name damageType)
	{
		Explode(HitLocation,Normal(HitLocation));
	}


	simulated function Timer()
	{
		Explode(Location,Vect(0,0,1));
	}

	function BlowUp(vector HitLocation)
	{
		HurtRadius(damage, 150, MyDamageType, MomentumTransfer, HitLocation);
		MakeNoise(1.0);
	}

	simulated function Explode(vector HitLocation, vector HitNormal)
	{
		local MightyMExp s;

		BlowUp(HitLocation);
		s = spawn(class'MightyMExp',,,HitLocation + HitNormal*16 );	
		s.RemoteRole = ROLE_None;
		PlaySound(MiscSound, SLOT_None, 2.3);	
		Destroy();
	}

	function BeginState()
	{
		Speed=0;
		SetTimer(TimeSpan, false);
	}

}

defaultproperties
{
     TimeSpan=8
     speed=800.000000
     Damage=50.000000
     MomentumTransfer=80000
     ImpactSound=Sound'NerfWeapon.MightyMo.MMBallhitS'
     MiscSound=Sound'NerfWeapon.MightyMo.MMBallExpS'
     Physics=PHYS_Falling
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=0.000000
     AnimRate=1.000000
     Skin=Texture'NerfWeapon.Skins.MMBall'
     Mesh=LodMesh'NerfWeapon.mightybal'
     AmbientGlow=64
     bUnlit=True
     bNoSmooth=True
     CollisionRadius=16.000000
     CollisionHeight=16.000000
     bProjTarget=True
     bBounce=True
     bFixedRotationDir=True
     Mass=50.000000
     DesiredRotation=(Pitch=12000,Yaw=5666,Roll=2334)
}
