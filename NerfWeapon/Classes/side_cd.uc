//=============================================================================
// side_cd.
//=============================================================================
class side_cd expands Projectile;

#exec MESH IMPORT MESH=side_cd ANIVFILE=g:\NerfRes\weaponmesh\MODELS\side_cd_a.3d DATAFILE=g:\NerfRes\weaponmesh\MODELS\side_cd_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=side_cd X=0 Y=0 Z=0 PITCH=5

#exec MESH SEQUENCE MESH=side_cd SEQ=All                      STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=side_cd SEQ=side_cd                  STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=side_cd MESH=side_cd
#exec MESHMAP SCALE MESHMAP=side_cd X=0.04 Y=0.03 Z=0.08

#exec TEXTURE IMPORT NAME=Jside_cd_01 FILE=g:\NerfRes\weaponmesh\MODELS\side_cd_01.PCX GROUP=Skins FLAGS=2	//Material #3

#exec MESHMAP SETTEXTURE MESHMAP=side_cd NUM=1 TEXTURE=Jside_cd_01

// Impact Sound
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\specialfx\htsdwr.wav" NAME="CdhitS" GROUP="Sidewind"
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\specialfx\htsdwr2.wav" NAME="CdExpS" GROUP="Sidewind"

var Actor SeekActor;
var float MagnitudeVel;
var vector InitialDir;
var bool bHitWater;
var int NumWallHits;
var bool bCanHitInstigator;

auto state Flying
{

	simulated function ZoneChange( Zoneinfo NewZone )
	{
		local waterring w;
		
		if (!NewZone.bWaterZone || bHitWater) Return;

		bHitWater = True;
		if ( Level.NetMode != NM_DedicatedServer )
		{

			w = Spawn(class'WaterRing',,,,rot(16384,0,0));
			w.DrawScale = 0.2;
			w.RemoteRole = ROLE_None;

		}		
		Velocity=0.6*Velocity;
	}

	function ProcessTouch (Actor Other, Vector HitLocation)
	{
		local SideExp s;

		if ( bCanHitInstigator || (Other != Instigator) ) 
		{
			if ( Role == ROLE_Authority )
			{
				if ( Other.IsA('Pawn') && (HitLocation.Z - Other.Location.Z > 0.62 * Other.CollisionHeight)
					&& (instigator.IsA('PlayerPawn') || (instigator.skill > 1)))
					Other.TakeDamage(2.0 * damage, instigator,HitLocation,
						(MomentumTransfer * Normal(Velocity)), 'decapitated' );
				else			 
					Other.TakeDamage(damage, instigator,HitLocation,
						(MomentumTransfer * Normal(Velocity)), 'shredded' );

			s = spawn(class'SideExp',,,HitLocation);	
			s.RemoteRole = ROLE_None;
			}
			PlaySound(MiscSound, SLOT_Misc, 2.0);


			RemoteRole = ROLE_SimulatedProxy;	 		 		
			Destroy();
		}
	}

	simulated function SetRoll(vector NewVelocity) 
	{
		local rotator newRot;	
	
		newRot = rotator(NewVelocity);	
		SetRotation(newRot);	
	}

	simulated function HitWall (vector HitNormal, actor Wall)
	{
		
		bCanHitInstigator = true;
		PlaySound(ImpactSound, SLOT_Misc, 2.0);

//##nerf WES 
		Wall.TakeDamage(0, Instigator, Location, Vect(0,0,0), 'shot');

//##nerf WES Textures
// need spinning animation
//		LoopAnim('Spin',1.0);
		if ( (Mover(Wall) != None) && Mover(Wall).bDamageTriggered )
		{
			if ( Role == ROLE_Authority )
				Wall.TakeDamage( Damage, instigator, Location, MomentumTransfer * Normal(Velocity), '');
			Destroy();
			return;
		}
		NumWallHits++;
		SetTimer(0, False);
		MakeNoise(0.3);
		if ( NumWallHits > 5 )
			Destroy();
		Velocity -= 2 * ( Velocity dot HitNormal) * HitNormal;  
		SetRoll(Velocity);
	}

	function Explode(vector HitLocation, vector HitNormal)
	{
		HurtRadius(Damage,50.0, MyDamageType, MomentumTransfer, HitLocation );	 		 		
		PlaySound(MiscSound, SLOT_Misc, 2.0);
		spawn(class'SideExp',,,HitLocation+ HitNormal*16);	
		RemoteRole = ROLE_SimulatedProxy;	 		 		
 		Destroy();
	}

	function BeginState()
	{
		initialDir = vector(Rotation);	
		if ( Role == ROLE_Authority )	
			Velocity = speed*initialDir;
		Acceleration = initialDir*50;
		PlaySound(SpawnSound, SLOT_None, 2.3);	
		if (Region.Zone.bWaterZone)
		{
			bHitWater = True;
			Velocity=0.6*Velocity;
		}
	}
}

defaultproperties
{
     speed=1000.000000
     MaxSpeed=1600.000000
     Damage=20.000000
     MomentumTransfer=18000
     ImpactSound=Sound'NerfWeapon.Sidewind.CdhitS'
     MiscSound=Sound'NerfWeapon.Sidewind.CdExpS'
     bNetTemporary=False
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=6.000000
     Mesh=LodMesh'NerfWeapon.side_cd'
     AmbientGlow=96
     bUnlit=True
     SoundRadius=9
     SoundVolume=255
     bProjTarget=True
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightBrightness=126
     LightHue=28
     LightSaturation=64
     LightRadius=6
     bBounce=True
}
