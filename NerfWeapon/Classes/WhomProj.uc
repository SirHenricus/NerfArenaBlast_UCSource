//=============================================================================
// WhomProj.
//=============================================================================
class WhomProj expands Projectile;

#exec TEXTURE IMPORT NAME=WhomProj0 FILE=G:\NerfRes\WeaponEffects\WHOMPER\WMPRproj\fx009_a00.pcx GROUP=Effects FLAG=2
#exec TEXTURE IMPORT NAME=WhomProj1 FILE=G:\NerfRes\WeaponEffects\WHOMPER\WMPRproj\fx009_a01.pcx GROUP=Effects FLAG=2
#exec TEXTURE IMPORT NAME=WhomProj2 FILE=G:\NerfRes\WeaponEffects\WHOMPER\WMPRproj\fx009_a02.pcx GROUP=Effects FLAG=2
#exec TEXTURE IMPORT NAME=WhomProj3 FILE=G:\NerfRes\WeaponEffects\WHOMPER\WMPRproj\fx009_a03.pcx GROUP=Effects FLAG=2
#exec TEXTURE IMPORT NAME=WhomProj4 FILE=G:\NerfRes\WeaponEffects\WHOMPER\WMPRproj\fx009_a04.pcx GROUP=Effects FLAG=2
#exec TEXTURE IMPORT NAME=WhomProj5 FILE=G:\NerfRes\WeaponEffects\WHOMPER\WMPRproj\fx009_a05.pcx GROUP=Effects FLAG=2
#exec TEXTURE IMPORT NAME=WhomProj6 FILE=G:\NerfRes\WeaponEffects\WHOMPER\WMPRproj\fx009_a06.pcx GROUP=Effects FLAG=2
#exec TEXTURE IMPORT NAME=WhomProj7 FILE=G:\NerfRes\WeaponEffects\WHOMPER\WMPRproj\fx009_a07.pcx GROUP=Effects FLAG=2
#exec TEXTURE IMPORT NAME=WhomProj8 FILE=G:\NerfRes\WeaponEffects\WHOMPER\WMPRproj\fx009_a08.pcx GROUP=Effects FLAG=2
#exec TEXTURE IMPORT NAME=WhomProj9 FILE=G:\NerfRes\WeaponEffects\WHOMPER\WMPRproj\fx009_a09.pcx GROUP=Effects FLAG=2
#exec TEXTURE IMPORT NAME=WhomProj10 FILE=G:\NerfRes\WeaponEffects\WHOMPER\WMPRproj\fx009_a10.pcx GROUP=Effects FLAG=2

#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\specialfx\htwmp.wav" NAME="BAPImpactS" GROUP="Whomper"

var() texture SpriteAnim[11];
var int i;


simulated function Timer()
{
	Texture = SpriteAnim[i];
	i++;
	if (i>=11) i=0;
}

function SetUp()
{
	Velocity = Vector(Rotation) * speed;
	MakeNoise ( 1.0 );
	PlaySound(SpawnSound);
}

simulated function PostBeginPlay()
{
	SetUp();
	if ( Level.NetMode != NM_DedicatedServer )
	{
		Texture = SpriteAnim[0];
		i=1;
		SetTimer(0.06,True);
	}
	Super.PostBeginPlay();
}

auto state Flying
{

	simulated function ZoneChange( Zoneinfo NewZone )
	{
		local waterring w;
		
		if ( NewZone.bWaterZone != Region.Zone.bWaterZone )
		{
			w = Spawn(class'WaterRing',,,,rot(16384,0,0));
			w.DrawScale = 0.2;
			w.RemoteRole = ROLE_None; 
		}	
	}

	function ProcessTouch (Actor Other, Vector HitLocation)
	{
		if ( Other != instigator ) 
			Explode(HitLocation,Normal(HitLocation-Other.Location));
	}

	simulated function Explode(vector HitLocation, vector HitNormal)
	{
		local WhomExp s;

		HurtRadius(Damage,300.0, MyDamageType, MomentumTransfer, HitLocation );	 		 		
		s = Spawn(class'WhomExp',,,HitLocation+HitNormal*9);
		s.RemoteRole = ROLE_None;
 		spawn(class'ShockWave',,,HitLocation+ HitNormal*16);
		PlaySound(ImpactSound);
 		Destroy();
	}

	function BeginState()
	{
		local vector InitialDir;

		initialDir = vector(Rotation);
		if ( Role == ROLE_Authority )	
			Velocity = speed*initialDir;
		Acceleration = initialDir*50;
	}
}

defaultproperties
{
     SpriteAnim(0)=Texture'NerfWeapon.Effects.WhomProj0'
     SpriteAnim(1)=Texture'NerfWeapon.Effects.WhomProj1'
     SpriteAnim(2)=Texture'NerfWeapon.Effects.WhomProj2'
     SpriteAnim(3)=Texture'NerfWeapon.Effects.WhomProj3'
     SpriteAnim(4)=Texture'NerfWeapon.Effects.WhomProj4'
     SpriteAnim(5)=Texture'NerfWeapon.Effects.WhomProj5'
     SpriteAnim(6)=Texture'NerfWeapon.Effects.WhomProj6'
     SpriteAnim(7)=Texture'NerfWeapon.Effects.WhomProj7'
     SpriteAnim(8)=Texture'NerfWeapon.Effects.WhomProj8'
     SpriteAnim(9)=Texture'NerfWeapon.Effects.WhomProj9'
     SpriteAnim(10)=Texture'NerfWeapon.Effects.WhomProj10'
     speed=800.000000
     Damage=100.000000
     MomentumTransfer=40000
     ImpactSound=Sound'NerfWeapon.Whomper.BAPImpactS'
     RemoteRole=ROLE_SimulatedProxy
     DrawType=DT_Sprite
     Style=STY_Translucent
     Texture=None
     DrawScale=0.750000
     Fatness=0
     bUnlit=True
     CollisionRadius=30.000000
     CollisionHeight=30.000000
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightBrightness=255
     LightHue=5
     LightSaturation=16
     LightRadius=4
}
