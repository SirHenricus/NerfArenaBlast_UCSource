//=============================================================================
// JumpTrigger.
// Players hitting this trigger will jump up towards the current running 
// direction. Bots will jump up towards the trigger's rotation.
//
// Usage :	1) Set the JumpZ to the appropriate high 
//			2) Set the LimitedToName to NONE
//			3) Set the bOnceOnly to your desire.
//=============================================================================
class JumpTrigger extends Triggers;

var() bool bOnceOnly;
var() name LimitedToName;
var Pawn Pending;
var() float JumpZ;
var() float Scaler;

function Timer()
{
	Pending.SetPhysics(PHYS_Falling);
	if (Pending.IsA('NerfBots'))
	{
		Pending.Velocity = Pending.GroundSpeed * Scaler * Vector(Rotation);
		Pending.DesiredRotation = Rotation;
	}
	else
		Pending.Velocity = (Sqrt(Pending.Velocity.X * Pending.Velocity.X + Pending.Velocity.Y * Pending.Velocity.Y))
					 	* Vector(Pending.Rotation);
	if ( JumpZ != 0 )
		Pending.Velocity.Z = JumpZ;
	else
		Pending.Velocity.Z = FMax(100, Pending.JumpZ);
	Pending.bJumpOffPawn = true;
    if ( Pending.IsA('NerfBots') )
        NerfBots(Pending).SetFall();      // DSL added from Unreal example
}

function Touch( actor Other )
{
	if (
        Other.IsA('Pawn') 
			&&
       ( (LimitedToName ==  '')
       ||(Other.IsA(LimitedToName)) )
       )
	{
		Pending = Pawn(Other);
		SetTimer(0.01, false);
		if ( bOnceOnly )
			Disable('Touch');
	}
}

defaultproperties
{
     Scaler=1.000000
     bDirectional=True
}
