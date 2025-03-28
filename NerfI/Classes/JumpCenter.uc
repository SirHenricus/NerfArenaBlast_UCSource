//=============================================================================
// JumpCenter
// specifies positions that can be reached in jumpmatch or with jumpboots or translocator
//
// bDirectional = false makes this a regular jump trigger
// bDirectional = true acts just like bDirectional = false unless
//                jumpee is facing within +- 30 degrees of set directionality
//=============================================================================
class JumpCenter extends LiftCenter;

var Pawn Pending;
var() float JumpZ;
var() name LimitedToName;
var() float Scalar;
var int absyawleft;
var int absyawright;

// calc these now so we're not doin' it every time we're touched
function PostBeginPlay()
{
    absyawleft = abs(Rotation.Yaw - 8000);
    absyawright = abs(Rotation.Yaw + 8000);
    Super.PostBeginPlay();
}

event int SpecialCost(Pawn Seeker)
{
	return 0;
}

function Timer()
{
    local vector tmpvel;
    local int absyaw;
    local bool bDir;

	Pending.SetPhysics(PHYS_Falling);

    bDir = bDirectional;

/*
    if ( bDir )     // do we need to examine heading?
    {
        absyaw = abs(Pending.Rotation.Yaw);
        if ( (absyaw < absyawleft) || (absyaw > absyawright) )
            bDir = false;
    }
*/

// if we are not a directional device, use pawn's current directional values
    if ( !bDir )
    {
        tmpvel = (Sqrt(Pending.Velocity.X * Pending.Velocity.X
                               + Pending.Velocity.Y * Pending.Velocity.Y))
                             * Vector(Pending.Rotation);
        tmpvel.Z = JumpZ;
        Pending.Velocity = tmpvel;
    }
    else        // we are directional and want specific results
    {
/*
        Pending.SetRotation(Rotation);
        Pending.Velocity = Vector(Pending.Rotation) * Scalar;
        Pending.Velocity.Z = JumpZ;
*/
		Pending.DesiredRotation = Rotation;
        Pending.SetRotation(Rotation);
		tmpvel = Pending.Default.GroundSpeed * Scalar * Vector(Rotation);
        tmpvel.Z = JumpZ;
		Pending.Velocity = tmpvel;
    }


/*
    local Rotator rot;

    rot = Pending.Rotation;
    if ( bDirectional ) rot = Rotation;
    Pending.SetRotation(rot);
	Pending.Velocity = (Sqrt(Pending.Velocity.X * Pending.Velocity.X + Pending.Velocity.Y * Pending.Velocity.Y))
					 	* Vector(rot);
//					 	* Vector(Pending.Rotation);
	if ( JumpZ != 0 )
		Pending.Velocity.Z = JumpZ;
	else
		Pending.Velocity.Z = FMax(100, Pending.JumpZ);
*/

	Pending.bJumpOffPawn = true;
    if ( Pending.IsA('NerfBots') )
	{
        NerfBots(Pending).SetFall();      // DSL added from Unreal example
		NerfBots(Pending).WhatToDoNext('','');
	}
}

function Touch( actor Other )
{
    if (   ( (Other.IsA('Pawn')) && (LimitedToName==''))
        || (Other.IsA(LimitedToName)) )

	{
		Pending = Pawn(Other);
		SetTimer(0.01, false);
//		if ( bOnceOnly )
//			Disable('Touch');
	}
}

/* SpecialHandling is called by the navigation code when the next path has been found.  
It gives that path an opportunity to modify the result based on any special considerations
*/
function Actor SpecialHandling(Pawn Other)
{
/*
	if ( !Other.IsA('Bot') )
		return None;


	if ( (VSize(Location - Other.Location) < 200) && Other.ActorReachable(self) )
		return self;

	Other.SetPhysics(PHYS_Falling);
	Other.Velocity = Other.GroundSpeed * Normal(Location - Other.Location);
	Other.Velocity.Z = Other.JumpZ;
	Other.bJumpOffPawn = true;
	Other.DesiredRotation = Rotator(Location - Other.Location);
//	NerfBots(Other).SetFall();
*/
	return self;
}

defaultproperties
{
     JumpZ=450.000000
     LimitedToName=NerfBots
     Scalar=1.000000
     bSpecialCost=True
     bDirectional=True
     bCollideActors=True
}
