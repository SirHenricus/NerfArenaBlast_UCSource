//=============================================================================
// TriggeredBlinker.
// A lightsource which can be triggered to blink.
//=============================================================================
class TriggeredBlinker extends Light;

//-----------------------------------------------------------------------------
// Variables.

var() bool  bInitiallyOn;       // Whether it's initially on.
var() float PulseWidth;         // duration of blink state
var() int   BlinkCount;

var   float RememberBrightness;  // Initial brightness.
var   float CurrentPulse;
var   actor SavedTrigger;
var   bool  bCurrentlyOn;
var   int   BlinkCounter;
//-----------------------------------------------------------------------------
// Engine functions.

// Called at start of gameplay.
function BeginPlay()
{
	// Remember initial light type and set new one.
	Disable( 'Tick' );
	RememberBrightness = LightBrightness;
	if( bInitiallyOn )
	{
        bCurrentlyOn = True;
	}
	else
	{
        bCurrentlyOn = False;
        LightBrightness = 0;
	}
	DrawType = DT_None;
}

// Called whenever time passes.
function Tick( float DeltaTime )
{
	CurrentPulse += DeltaTime;
	if( CurrentPulse > PulseWidth )
	{
        BlinkCounter--;
        if ( BlinkCounter > 0 )     // more blinks to go?
        {
            CurrentPulse = 0;
            if ( bCurrentlyOn )
            {
                bCurrentlyOn = False;
                LightBrightness = 0;
            }
            else
            {
                bCurrentlyOn = True;
                LightBrightness = RememberBrightness;
            }
        }
        else
        {
    		Disable( 'Tick' );
    		if( SavedTrigger != None )
    			SavedTrigger.EndEvent();
        }
    }
}

//-----------------------------------------------------------------------------
// Public states.

// Trigger causes light to start blinking
state() TriggerBlinks
{
	function Trigger( actor Other, pawn EventInstigator )
	{
		if( SavedTrigger!=None )
			SavedTrigger.EndEvent();
		SavedTrigger = Other;
		SavedTrigger.BeginEvent();
        CurrentPulse = 0;
        BlinkCounter = 2 * BlinkCount;
        if ( bInitiallyOn )
        {
            LightBrightness = 0;
            bCurrentlyOn = False;
        }
        else
        {
            LightBrightness = RememberBrightness;
            bCurrentlyOn = True;
        }
		Enable( 'Tick' );
	}
}

defaultproperties
{
     PulseWidth=0.500000
     BlinkCount=3
     bStatic=False
     bHidden=False
     bMovable=True
}
