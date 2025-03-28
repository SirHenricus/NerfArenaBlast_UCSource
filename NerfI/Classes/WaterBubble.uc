//=============================================================================
// WaterBubble.
//
// Intergrated by Wezo
//=============================================================================
class WaterBubble extends Effects;
    
simulated function ZoneChange( ZoneInfo NewZone )
{
	if ( !NewZone.bWaterZone ) 
	{
		Destroy();
		PlaySound (EffectSound1);
	}	
}

simulated function BeginPlay()
{
	Super.BeginPlay();
	if ( Level.NetMode != NM_DedicatedServer )
	{
		PlaySound(EffectSound2); //Spawned Sound
		LifeSpan = 3 + 4 * FRand();
		Buoyancy = Mass + FRand()+0.1;
		if (FRand()<0.3) Texture = texture(DynamicLoadObject("NerfRes.W_Bubble2", class'Texture'));
		else if (FRand()<0.6) Texture = texture(DynamicLoadObject("NerfRes.W_Bubble3", class'Texture'));
		else Texture=Texture(DynamicLoadObject("NerfRes.W_bubble1", class'Texture'));
		DrawScale += FRand()*DrawScale/2;
	}
}

defaultproperties
{
     bNetOptional=True
     Physics=PHYS_Falling
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=2.000000
     DrawType=DT_Sprite
     Style=STY_Translucent
     Mass=3.000000
     Buoyancy=3.750000
}
