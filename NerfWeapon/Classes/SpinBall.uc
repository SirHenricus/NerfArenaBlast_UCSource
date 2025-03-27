//=============================================================================
// SpinBall.
//=============================================================================
class SpinBall expands Projectile;

#exec TEXTURE IMPORT NAME=SpinBallProj0 FILE=G:\NerfRes\WeaponEffects\PULSE\PULSE_proj\bolprj_a00.pcx GROUP=Effects FLAG=2
#exec TEXTURE IMPORT NAME=SpinBallProj1 FILE=G:\NerfRes\WeaponEffects\PULSE\PULSE_proj\bolprj_a01.pcx GROUP=Effects FLAG=2
#exec TEXTURE IMPORT NAME=SpinBallProj2 FILE=G:\NerfRes\WeaponEffects\PULSE\PULSE_proj\bolprj_a02.pcx GROUP=Effects FLAG=2
#exec TEXTURE IMPORT NAME=SpinBallProj3 FILE=G:\NerfRes\WeaponEffects\PULSE\PULSE_proj\bolprj_a03.pcx GROUP=Effects FLAG=2
#exec TEXTURE IMPORT NAME=SpinBallProj4 FILE=G:\NerfRes\WeaponEffects\PULSE\PULSE_proj\bolprj_a04.pcx GROUP=Effects FLAG=2
#exec TEXTURE IMPORT NAME=SpinBallProj5 FILE=G:\NerfRes\WeaponEffects\PULSE\PULSE_proj\bolprj_a05.pcx GROUP=Effects FLAG=2
#exec TEXTURE IMPORT NAME=SpinBallProj6 FILE=G:\NerfRes\WeaponEffects\PULSE\PULSE_proj\bolprj_a06.pcx GROUP=Effects FLAG=2
#exec TEXTURE IMPORT NAME=SpinBallProj7 FILE=G:\NerfRes\WeaponEffects\PULSE\PULSE_proj\bolprj_a07.pcx GROUP=Effects FLAG=2
#exec TEXTURE IMPORT NAME=SpinBallProj8 FILE=G:\NerfRes\WeaponEffects\PULSE\PULSE_proj\bolprj_a08.pcx GROUP=Effects FLAG=2
#exec TEXTURE IMPORT NAME=SpinBallProj9 FILE=G:\NerfRes\WeaponEffects\PULSE\PULSE_proj\bolprj_a09.pcx GROUP=Effects FLAG=2
#exec TEXTURE IMPORT NAME=SpinBallProj10 FILE=G:\NerfRes\WeaponEffects\PULSE\PULSE_proj\bolprj_a10.pcx GROUP=Effects FLAG=2
#exec TEXTURE IMPORT NAME=SpinBallProj11 FILE=G:\NerfRes\WeaponEffects\PULSE\PULSE_proj\bolprj_a11.pcx GROUP=Effects FLAG=2
#exec TEXTURE IMPORT NAME=SpinBallProj12 FILE=G:\NerfRes\WeaponEffects\PULSE\PULSE_proj\bolprj_a12.pcx GROUP=Effects FLAG=2
#exec TEXTURE IMPORT NAME=SpinBallProj13 FILE=G:\NerfRes\WeaponEffects\PULSE\PULSE_proj\bolprj_a13.pcx GROUP=Effects FLAG=2
#exec TEXTURE IMPORT NAME=SpinBallProj14 FILE=G:\NerfRes\WeaponEffects\PULSE\PULSE_proj\bolprj_a14.pcx GROUP=Effects FLAG=2
#exec TEXTURE IMPORT NAME=SpinBallProj15 FILE=G:\NerfRes\WeaponEffects\PULSE\PULSE_proj\bolprj_a15.pcx GROUP=Effects FLAG=2

//##nerf WES Sounds FIXME
//Need fire sound
//#exec AUDIO IMPORT FILE="***" NAME="***" GROUP="***"

var() texture SpriteAnim[16];
var int i;


simulated function Timer()
{
	Texture = SpriteAnim[i];
	i++;
	if (i>=16) i=0;
}

function SetUp()
{
	Velocity = Vector(Rotation) * speed;
	MakeNoise ( 1.0 );
//	PlaySound(SpawnSound);		// DSL - don't play one until we have one
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


simulated function ProcessTouch (Actor Other, Vector HitLocation)
{
	if (Other != instigator)
	{
		if ( Role == ROLE_Authority )
		{
			if ((Pawn(Other) != None) && (Pawn(Other).ChestHit(HitLocation)))
				Pawn(Other).BoloStun();
			Explode(HitLocation, Vect(0,0,0));
		}
	}
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local SpinBallExp s;

	if ( (Role == ROLE_Authority) && (FRand() < 0.5) )
		MakeNoise(1.0); //FIXME - set appropriate loudness

	s = Spawn(class'SpinBallExp',,,HitLocation+HitNormal*9);
	s.RemoteRole = ROLE_None;
	HurtRadius(Damage,150.0, 'exploded', MomentumTransfer, HitLocation );
	Destroy();
}

Begin:
	Sleep(3);
	Explode(Location, Vect(0,0,0));
}

defaultproperties
{
     SpriteAnim(0)=Texture'NerfWeapon.Effects.SpinBallProj0'
     SpriteAnim(1)=Texture'NerfWeapon.Effects.SpinBallProj1'
     SpriteAnim(2)=Texture'NerfWeapon.Effects.SpinBallProj2'
     SpriteAnim(3)=Texture'NerfWeapon.Effects.SpinBallProj3'
     SpriteAnim(4)=Texture'NerfWeapon.Effects.SpinBallProj4'
     SpriteAnim(5)=Texture'NerfWeapon.Effects.SpinBallProj5'
     SpriteAnim(6)=Texture'NerfWeapon.Effects.SpinBallProj6'
     SpriteAnim(7)=Texture'NerfWeapon.Effects.SpinBallProj7'
     SpriteAnim(8)=Texture'NerfWeapon.Effects.SpinBallProj8'
     SpriteAnim(9)=Texture'NerfWeapon.Effects.SpinBallProj9'
     SpriteAnim(10)=Texture'NerfWeapon.Effects.SpinBallProj10'
     SpriteAnim(11)=Texture'NerfWeapon.Effects.SpinBallProj11'
     SpriteAnim(12)=Texture'NerfWeapon.Effects.SpinBallProj12'
     SpriteAnim(13)=Texture'NerfWeapon.Effects.SpinBallProj13'
     SpriteAnim(14)=Texture'NerfWeapon.Effects.SpinBallProj14'
     SpriteAnim(15)=Texture'NerfWeapon.Effects.SpinBallProj15'
     speed=1000.000000
     Damage=30.000000
     RemoteRole=ROLE_SimulatedProxy
     DrawType=DT_Sprite
     Style=STY_Translucent
     Texture=None
     DrawScale=0.300000
     Fatness=0
     bUnlit=True
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightBrightness=255
     LightHue=5
     LightSaturation=16
     LightRadius=4
}
