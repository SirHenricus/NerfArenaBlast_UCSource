//=============================================================================
// SpriteRoxTrail.
//=============================================================================
class SpriteRoxTrail expands AnimSpriteEffect;

var() Texture SSprites[20];
var() int NumSets;
var() float RisingRate;
	
simulated function PostBeginPlay()
{
	Velocity = Vect(0,0,1)*RisingRate;
	Texture = SSPrites[int(FRand()*NumSets*0.97)];
	if (Texture == None) Texture = Texture'S_Actor';
}

defaultproperties
{
     SSprites(0)=Texture'NerfI.ExpEffect.tsrkt_smoke_a00'
     SSprites(1)=Texture'NerfI.ExpEffect.tsrktsmoke2_a00'
     SSprites(2)=Texture'NerfI.ExpEffect.tsrktsmk4_a00'
     NumSets=3
     RisingRate=50.000000
     NumFrames=11
     Pause=0.050000
     bNetOptional=True
     Physics=PHYS_Projectile
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=1.000000
     DrawType=DT_SpriteAnimOnce
     Style=STY_Translucent
     Texture=Texture'NerfI.ExpEffect.tsrkt_smoke_a00'
     DrawScale=1.000000
     LightType=LT_None
     LightBrightness=10
     LightHue=0
     LightSaturation=255
     LightRadius=7
     bCorona=False
}
