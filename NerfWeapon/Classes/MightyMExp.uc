//=============================================================================
// MightyMExp.
//=============================================================================
class MightyMExp expands AnimSpriteEffect;

function MakeSound()
{
	PlaySound (EffectSound1,,3.0);	
}

/*
simulated function PostBeginPlay()
{
	local actor a;

	Super.PostBeginPlay();
	if ( Level.NetMode != NM_DedicatedServer )
	{
		if (!Level.bHighDetailMode) Drawscale = 1.4;
		else 
		{	
			a = Spawn(class'ShortSmokeGen');
			a.RemoteRole = ROLE_None;	
		}
	}
	MakeSound();
}
*/

defaultproperties
{
     NumFrames=16
     Pause=0.050000
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=0.600000
     DrawType=DT_SpriteAnimOnce
     Style=STY_Translucent
     Texture=Texture'NerfI.ExpEffect.mimofx0222_a00'
     DrawScale=0.700000
     LightType=LT_TexturePaletteOnce
     LightEffect=LE_NonIncidence
     LightBrightness=100
     LightHue=32
     LightSaturation=79
     LightRadius=4
     bCorona=False
}
