//=============================================================================
// ScatExp.
//=============================================================================
class ScatExp expands AnimSpriteEffect;

#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\specialfx\htstralt.wav" NAME="ScatterAltImpactS" GROUP="Generic"

function MakeSound()
{
	PlaySound (EffectSound1,,3.0);	
}


simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	MakeSound();
}

defaultproperties
{
     NumFrames=11
     Pause=0.050000
     EffectSound1=Sound'NerfWeapon.Generic.ScatterAltImpactS'
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=0.500000
     DrawType=DT_SpriteAnimOnce
     Style=STY_Translucent
     Texture=Texture'NerfI.ExpEffect.scatxfx03_a00'
     DrawScale=0.100000
     LightType=LT_TexturePaletteOnce
     LightEffect=LE_NonIncidence
     LightBrightness=159
     LightHue=32
     LightSaturation=79
     LightRadius=2
     bCorona=False
}
