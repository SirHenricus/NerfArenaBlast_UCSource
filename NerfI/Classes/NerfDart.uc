//=============================================================================
// NerfDart.
//=============================================================================
class NerfDart extends Projectile;

#exec MESH IMPORT MESH=NerfDart ANIVFILE=g:\NerfRes\weaponMesh\MODELS\Nerf_Dart_a.3d DATAFILE=g:\NerfRes\weaponMesh\MODELS\Nerf_Dart_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=NerfDart X=0 Y=0 Z=0 PITCH=-64

#exec MESH SEQUENCE MESH=NerfDart SEQ=All      STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JNerfDart1 FILE=g:\NerfRes\weaponMesh\MODELS\NerfDart1.PCX GROUP=Skins FLAGS=2 // Twosided

#exec MESHMAP NEW   MESHMAP=NerfDart MESH=NerfDart
#exec MESHMAP SCALE MESHMAP=NerfDart X=0.05 Y=0.05 Z=0.1

#exec MESHMAP SETTEXTURE MESHMAP=NerfDart NUM=0 TEXTURE=JNerfDart1

// Audio sound effects
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\specialfx\htlarm.wav" NAME="DartHitS" GROUP="SShot"

var float DelayTime;
var vector SurfaceNormal;	
var bool bOnGround;

simulated function SetWall(vector HitNormal, Actor Wall)
{
	local rotator RandRot;

	SurfaceNormal = HitNormal;
	RandRot = rotator(-HitNormal);
	RandRot.Roll += 32768;
	SetRotation(RandRot);
	DrawScale=DrawScale*0.5;	
	Damage=0.0;
	bCollideWorld=False;
	if ( Mover(Wall) != None )
		SetBase(Wall);

}

/////////////////////////////////////////////////////
auto state Flying
{
	function ProcessTouch( Actor Other, Vector HitLocation )
	{
		local vector hitDir;
		
		if (Other != instigator )
		{
			hitDir = Normal(Velocity);
			if ( FRand() < 0.2 )
				hitDir *= 5;
			Other.TakeDamage(damage, instigator,HitLocation,
				(MomentumTransfer * hitDir), 'shot');
			Destroy();			
		}
	}

	simulated function HitWall( vector HitNormal, actor Wall )
	{
        local MOBlast mo;           // DSL: using projected sprite for now

		SetPhysics(PHYS_None);		
		MakeNoise(0.3);	
		PlaySound(ImpactSound);
		SetWall(HitNormal, Wall);

//##nerf WES 
		Wall.TakeDamage(0, Instigator, Location, Vect(0,0,0), 'shot');

// DSL -- using projected sprite in place of dartpop for now
        mo = Spawn(class'MOBlast',,,Location,Rotation);
        if ( mo != None )
        {
            mo.RemoteRole = ROLE_None;
            mo.DrawScale = 000.600;
        }

	}

	function Timer()
	{
		local Waterbubble b;
		if (Level.NetMode!=NM_DedicatedServer)
		{
	 		b=spawn(class'WaterBubble'); 
 			b.DrawScale= 0.1 + FRand()*0.2;
 			b.SetLocation(Location+FRand()*vect(2,0,0)+FRand()*Vect(0,2,0)+FRand()*Vect(0,0,2));
 			b.buoyancy = b.mass+(FRand()*0.4+0.1);
 		}
		DelayTime+=FRand()*0.1+0.1;
		SetTimer(DelayTime,False); 	
	}

	simulated function ZoneChange( Zoneinfo NewZone )
	{
		if (NewZone.bWaterZone) 
		{
			Velocity=0.7*Velocity;	
			DelayTime=0.03;		
			SetTimer(DelayTime,False);
		}
	}

	function BeginState()
	{
		local rotator RandRot;

		Velocity = Vector(Rotation) * speed;
		RandRot.Pitch = FRand() * 200 - 100;
		RandRot.Yaw = FRand() * 200 - 100;
		RandRot.Roll = FRand() * 200 - 100;
		Velocity = Velocity >> RandRot;
		if( Region.zone.bWaterZone )
			Velocity=0.7*Velocity;
	}
}

///////////////////////////////////////////////////////
state Exploding
{
Begin:
	FinishAnim();
	Destroy();
}

defaultproperties
{
     speed=1600.000000
     Damage=10.000000
     MomentumTransfer=4000
     ImpactSound=Sound'NerfI.SShot.DartHitS'
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=6.000000
     AnimRate=1.000000
     Skin=Texture'NerfI.Skins.JNerfDart1'
     Mesh=LodMesh'NerfI.NerfDart'
     AmbientGlow=215
     bUnlit=True
     bNoSmooth=True
     CollisionRadius=8.000000
     CollisionHeight=2.000000
     LightEffect=LE_NonIncidence
     LightBrightness=80
     LightHue=152
     LightSaturation=32
     LightPeriod=50
     bBounce=True
     Mass=200.000000
}
