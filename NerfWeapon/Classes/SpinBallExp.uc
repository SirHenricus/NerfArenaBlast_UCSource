//=============================================================================
// SpinBallExp.
//=============================================================================
class SpinBallExp expands AnimSpriteEffect;

// Impact Sound
#exec AUDIO IMPORT FILE="g:\NerfRes\scrptsnd\specialfx\htpuls.wav" NAME="SpinBallhitS" GROUP="Puls"

function MakeSound()
{
	PlaySound (EffectSound1,,3.0);	
}

simulated function PostBeginPlay()
{
	local actor a;

	Super.PostBeginPlay();
/*
	if ( Level.NetMode != NM_DedicatedServer )
	{
		if (!Level.bHighDetailMode) Drawscale = 1.4;
		else 
		{	
			a = Spawn(class'ShortSmokeGen');
			a.RemoteRole = ROLE_None;	
		}
	}
*/
	MakeSound();
}

defaultproperties
{
     NumFrames=12
     Pause=0.050000
     EffectSound1=Sound'NerfWeapon.Puls.SpinBallhitS'
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=0.500000
     DrawType=DT_SpriteAnimOnce
     Style=STY_Translucent
     Texture=Texture'NerfI.ExpEffect.metafx01_a00'
     DrawScale=0.750000
     LightType=LT_TexturePaletteOnce
     LightEffect=LE_NonIncidence
     LightBrightness=159
     LightHue=32
     LightSaturation=79
     LightRadius=2
     bCorona=False
}
