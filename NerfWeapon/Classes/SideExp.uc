//=============================================================================
// SideExp.
//=============================================================================
class SideExp expands AnimSpriteEffect;

function MakeSound()
{
	PlaySound (EffectSound1,,3.0);	
}

defaultproperties
{
     NumFrames=10
     Pause=0.050000
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=0.500000
     DrawType=DT_SpriteAnimOnce
     Style=STY_Translucent
     Texture=Texture'NerfI.ExpEffect.SW_exp_a00'
     DrawScale=0.500000
     LightType=LT_TexturePaletteOnce
     LightEffect=LE_NonIncidence
     LightBrightness=159
     LightHue=32
     LightSaturation=79
     LightRadius=2
     bCorona=False
}
