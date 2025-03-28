//=============================================================================
// TimedTrigger: causes an event after X seconds.
//
// Intergrated by Wezo at 7-7-99
//=============================================================================
class TimedTrigger extends Trigger;

var() float DelaySeconds;
var() bool bRepeating;

function PostBeginPlay()
{
	if ( !Level.Game.IsA('DeathMatchGame') || !DeathMatchGame(Level.Game).bRequireReady )
		SetTimer(DelaySeconds, bRepeating);
	Super.PostBeginPlay();
}

function Timer()
{
	local Actor A;

	if ( event != '' )
		ForEach AllActors(class'Actor', A, Event )
			A.Trigger(self, None);

	if ( !bRepeating )
		Destroy();
}

defaultproperties
{
     DelaySeconds=1.000000
}
