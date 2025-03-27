//=============================================================================
// MMDetBall
//=============================================================================
class MMDetBall expands MMBall;

//var bool Det;
var MightyMo Launcher;

/*
replication
{
	// Things the server should send to the client.
	unreliable if( Role==ROLE_Authority )
		Det;
}


simulated function Tick( float DeltaTime )
{
	if (Det)
	{
		Disable('Tick');
		Explosion(Location);
	}
}
*/

auto state Flying
{
	function BeginState()
	{
		Super.BeginState();
		if ( (Level.NetMode != NM_Standalone) && (Role == ROLE_Authority) )
		{
			if (PlayerPawn(Instigator) != None) 
				RemoteRole = ROLE_SimulatedProxy;
			else
				RemoteRole = ROLE_AutonomousProxy;
		}
	}
}

defaultproperties
{
     TimeSpan=10
     speed=600.000000
     RemoteRole=ROLE_DumbProxy
}
