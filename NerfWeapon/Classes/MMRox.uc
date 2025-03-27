//=============================================================================
// MMRox
//=============================================================================
class MMRox expands Projectile;

// Explosion Sound
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\specialfx\htmo.wav" NAME="MMExpS" GROUP="MightyMo"

var bool bCanHitOwner, bHitWater;
var float Count, SmokeRate;
var NerfBots WarnTarget;	// warn this pawn away
var int NumExtraBalls;
var vector InitialDir;
var bool bRing,bWaterStart;

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
			PlayAnim( 'Still', 3.0 );
		}		

		Velocity=0.6*Velocity;
	}

	simulated function ProcessTouch (Actor Other, Vector HitLocation)
	{

		if ((Other != instigator) && (MMRox(Other) == none)) 
			Explode(HitLocation,Normal(HitLocation-Other.Location));
	}

//##nerf WES
// Put back the blow up function and not it takes the MMRing param

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
		local MMRing r;
		local MightyMExp s;

		s = spawn(class'MightyMExp',,,HitLocation + HitNormal*16);	
 		s.RemoteRole = ROLE_None;

		if (bRing) 
		{
// DSL -- using a customized ring
    		r = Spawn(class'MMRing',,,HitLocation + HitNormal*16,rotator(HitNormal));
    		r.RemoteRole = ROLE_None;
		}
		BlowUp(HitLocation);
		
 		Destroy();
	}

	function BeginState()
	{
		initialDir = vector(Rotation);	
		Velocity = speed*initialDir;
		Acceleration = initialDir*80;
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
     bRing=True
     speed=2000.000000
     MaxSpeed=5000.000000
     Damage=30.000000
     MomentumTransfer=80000
     ImpactSound=Sound'NerfWeapon.MightyMo.MMExpS'
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=6.000000
     AnimRate=1.000000
     Skin=Texture'NerfWeapon.Skins.MMBall'
     Mesh=LodMesh'NerfWeapon.mightybal'
     AmbientGlow=64
     bUnlit=True
     bNoSmooth=True
     CollisionRadius=16.000000
     CollisionHeight=16.000000
     bBounce=True
     bFixedRotationDir=True
     DesiredRotation=(Pitch=12000,Yaw=5666,Roll=2334)
}
