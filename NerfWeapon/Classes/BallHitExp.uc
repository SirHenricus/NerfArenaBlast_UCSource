//=============================================================================
// BallHitExp.
//=============================================================================
class BallHitExp expands AnimSpriteEffect;

// Impact Sound
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\specialfx\htpuls.wav" NAME="BallhitS" GROUP="Puls"

function MakeSound()
{
	PlaySound (EffectSound1,,3.0);	
}

defaultproperties
{
     NumFrames=6
     Pause=0.050000
     EffectSound1=Sound'NerfWeapon.Puls.BallhitS'
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=0.500000
     DrawType=DT_SpriteAnimOnce
     Style=STY_Translucent
     Texture=Texture'NerfI.ExpEffect.metafx011_a00'
     DrawScale=0.250000
     LightType=LT_TexturePaletteOnce
     LightEffect=LE_NonIncidence
     LightBrightness=100
     LightHue=32
     LightSaturation=79
     LightRadius=1
     bCorona=False
}
