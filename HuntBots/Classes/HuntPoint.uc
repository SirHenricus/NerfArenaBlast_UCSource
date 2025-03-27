//=============================================================================
// HuntPoint.
//=============================================================================
class HuntPoint expands NavigationPoint;

#exec Texture Import File=g:\NerfRes\nerfmesh\Textures\Hunt.pcx Name=S_Hunt Mips=Off Flags=2

var()       name        LiftTag;			// if to be associated with a mover
var         mover       MyLift;

var(AI)     EBotAdvice  BotAdvice;          
var(AI)     int         iBackTrack;         // how many steps back if advice fails
var(AI)     int         iPatience;          // how much patience to exhibit
var(Jump)   float       JumpZ;              // how far to jump
var(Jump)   float       ChanceOfSuccess;    // 0.0 = always fail, 1.0 = always succeed
var(Switch)   name      SwitchTag;
var(Switch)   class<Weapon> SwitchWeapon;
var(Shoot)  name        TargetTag;          // tag of intended target if ADV_Shoot
var         trigger     Target;
var(Inspect)    name    MoverTag;           // if this mover...
var(Inspect)    int     DesiredKeyNum;      // ..is not in this position, shoot target
var         mover       CheckMover;
var         bool        bHuntStarted;       // True if ADV_Start and Hunt has begun
//var()       name        NextHunt;           // next point to go to
var()       float       pausetime;          // how long to pause here
var()       name        HuntAnim;
var()       sound       HuntSound;
var()       byte        numAnims;

var	        vector      lookdir;            // direction to look while stopped
var         int         AnimCount;
var(Aux)    bool        bAux;
var(Aux)    name        AuxTag;             // auxillary Huntpoint
var         HuntPoint   AuxHuntPoint;

function PreBeginPlay()
{
    if ( bDirectional )
        lookdir = vector(Rotation);

// if advice == ADV_Shoot, we will want to have a target

   if ( TargetTag != '' )
        foreach AllActors(class 'Trigger', Target, TargetTag )
             break;

// if advice == ADV_Inspect, we will want to have a subject

    if ( MoverTag != '' )
        foreach AllActors(class 'Mover', CheckMover, MoverTag )
            break;

// if this Huntpoint has associated auxillary action, here
// is the link to it

    if ( AuxTag != '' )
        foreach AllActors(class 'HuntPoint', AuxHuntPoint, AuxTag )
            break;


	Super.PreBeginPlay();
}


function PostBeginPlay()
{
	if ( LiftTag != '' )
		ForEach AllActors(class'Mover', MyLift, LiftTag )
		{
//TraceLog( class, 5, "found my mover "$MyLift );
			MyLift.myMarker = self;
			SetBase(MyLift);
			break;
		}

	Super.PostBeginPlay();
}



function HandleJump( NerfBots Other )
{
    Other.SetPhysics(PHYS_Falling);
    Other.Velocity = (Sqrt(Other.Velocity.X * Other.Velocity.X
                           + Other.Velocity.Y * Other.Velocity.Y))
                         * Vector(Other.Rotation);

   if ( FRand() < ChanceOfSuccess )
      Other.RecommendedJumpZ = JumpZ;
   else Other.RecommendedJumpZ = JumpZ/2;

   Other.bAvoidLedges = false;
   Other.bJumpOffPawn = true;
}

defaultproperties
{
     iBackTrack=1
     iPatience=10
     JumpZ=500.000000
     ChanceOfSuccess=0.500000
     bHuntStarted=True
     bStatic=False
     Texture=Texture'HuntBots.S_Hunt'
     CollisionRadius=20.000000
     CollisionHeight=40.000000
     bCollideActors=True
}
