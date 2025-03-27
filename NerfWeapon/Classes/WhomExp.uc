//=============================================================================
// WhomExp.
//=============================================================================
class WhomExp expands AnimSpriteEffect;

// Impact Sound
//#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\specialfx\htpuls.wav" NAME="SpinBallhitS" GROUP="Puls"

function MakeSound()
{
	PlaySound (EffectSound1,,3.0);	
}

defaultproperties
{
     NumFrames=8
     Pause=0.050000
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=0.500000
     DrawType=DT_SpriteAnimOnce
     Style=STY_Translucent
     Texture=Texture'NerfI.ExpEffect.wmprexfx_a00'
     DrawScale=1.500000
     LightType=LT_TexturePaletteOnce
     LightEffect=LE_NonIncidence
     LightBrightness=159
     LightHue=32
     LightSaturation=79
     LightRadius=2
     bCorona=False
}
