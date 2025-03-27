//=============================================================================
// SeekingFrisbe.
//=============================================================================
class SeekingFrisbe expands side_cd;

function Timer()
{
	local vector SeekingDir;

//	log( " In Timer ");
	If (SeekActor != None  && SeekActor != Instigator) 
	{
		SeekingDir = Normal(SeekActor.Location - Location);
		if ( (SeekingDir Dot InitialDir) > 0 )
		{
			MagnitudeVel = VSize(Velocity);
			Velocity =  MagnitudeVel * Normal(SeekingDir * 0.47 * MagnitudeVel + Velocity);		
			SetRotation(rotator(Velocity));
		}
	}
}

auto state Flying
{
	function BeginState()
	{	
		SetTimer(0.15,True);
		Super.BeginState();
	}
}	

defaultproperties
{
     RemoteRole=ROLE_DumbProxy
     LifeSpan=10.000000
     LightBrightness=182
     LightHue=27
     LightSaturation=75
     LightRadius=8
}
