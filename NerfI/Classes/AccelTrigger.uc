//=============================================================================
// AccelTrigger.
//
// Integrated by Wezo
//=============================================================================
class AccelTrigger extends Trigger;

var Pawn Toucher;
var() vector DesLoc;
var() float Rate;
var() vector Velocity;
var() bool UsingEditor;
var   vector OldLocation;
var   vector Direction;

function BeginPlay()
{
	Toucher = None;
}

function Touch( actor Other )
{
	Super.Touch(Other);
	if(Pawn(Other) != None ) 
	{
		if ((UsingEditor) || (TriggerTime == Level.TimeSeconds))
		{
			Toucher = Pawn(Other);
			Toucher.AirSpeed *= 2;
			Toucher.SetPhysics(PHYS_Flying);
			gotostate('Fly');
		}
	}
}

state Fly
{
	function Tick( float DeltaTime )
	{
		local vector		oLoc, nLoc;
//		local vector		Direction;
		local vector		rpos;
		local float 		dist;
		
		oLoc = Toucher.Location + (Toucher.Velocity * DeltaTime);
//		Direction = Normal(DesLoc - oLoc);
//		Direction = Normal(OldLocation - oLoc) * -1;
		dist = VSize(DesLoc - Toucher.Location);
//		if (dist < (2*Rate)) 
		if (DesLoc.Z < Toucher.Location.Z)
		{
			Disable('Tick');
			Toucher.SetPhysics(PHYS_Walking);
			gotostate ('rest');
		}
		else
		{

			rpos = Direction * (dist - Rate);
			nLoc = DesLoc - rpos;
			Toucher.Velocity = (nLoc - Toucher.Location) / DeltaTime;

//			OldLocation = Toucher.Location;
/*
			rpos = Direction * Rate;
			nLoc = Toucher.Location + rpos;
			Toucher.Velocity = (nLoc - OldLocation) / DeltaTime;
*/			
		}
	}
Begin:
	Direction = Normal(DesLoc - Toucher.Location);
	OldLocation = DesLoc;
	Enable('Tick');
}

state rest
{	
	function Tick(float DeltaTime)
	{

		Toucher.Velocity = Toucher.Velocity - Toucher.Velocity * DeltaTime/Rate;
				
		if (VSize(Toucher.Velocity) <= VSize(Toucher.Default.Velocity))
		{
			Toucher.Velocity = Toucher.Default.Velocity;
			Toucher.AirSpeed = Toucher.Default.AirSpeed;
			Toucher.SetPhysics(PHYS_Walking);
			Disable('Tick');
		}
		
	}
Begin:
	Enable('Tick');
}

defaultproperties
{
}
