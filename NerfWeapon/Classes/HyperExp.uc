//=============================================================================
// HyperExp.
//=============================================================================
class HyperExp expands AnimSpriteEffect;

//##nerf WES Textures FIXME
//This is the palette for the Effect.
//#exec TEXTURE IMPORT NAME=ExplosionPal2 FILE=textures\exppal.pcx GROUP=Effects

//##nerf WES Sounds FIXME
//#exec AUDIO IMPORT FILE="sounds\general\expl04.wav" NAME="Expl04" GROUP="General"

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
     NumFrames=11
     Pause=0.050000
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=0.500000
     DrawType=DT_SpriteAnimOnce
     Style=STY_Translucent
     Texture=Texture'NerfI.ExpEffect.hsexplfx_a00'
     DrawScale=1.500000
     LightType=LT_TexturePaletteOnce
     LightEffect=LE_NonIncidence
     LightBrightness=159
     LightHue=32
     LightSaturation=79
     LightRadius=2
     bCorona=False
}
