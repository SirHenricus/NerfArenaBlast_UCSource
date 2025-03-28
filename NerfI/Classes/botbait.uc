//=============================================================================
// BotBait
//=============================================================================
class BotBait extends Pickup;

#exec Texture Import File=g:\NerfRes\nerfmesh\Textures\BBait.pcx Name=S_BBait Mips=Off Flags=2

enum EBaitType
{
    BB_None,
    BB_ShootWinky,
    BB_ShootSpinner,
    BB_WillBe3
};


var() float         Likelihood;
var() name          MyTargetTag;
var() EBaitType     Bait;

var float           BetweenTime;
var winky_target    MyWinky;
var mover_target    MyMover;

function PostBeginPlay()
{
    if ( MyTargetTag != 'None' )
    {
        switch( Bait )
        {
            case BB_ShootWinky:
            foreach AllActors( class'winky_target', MyWinky, MyTargetTag )
                break;
            if ( MyWinky != None )
                BetweenTime = MyWinky.OpenDelay;
            break;

            case BB_ShootSpinner:
            foreach AllActors( class'mover_target', MyMover, MyTargetTag )
                break;
            if ( MyMover != None )
                BetweenTime = MyMover.SpinTime + MyMover.PulseTime;
            break;
        }
    }
    Super.PostBeginPlay();
}

event float BotDesireability( pawn Bot )
{
    local float desire;

    desire = -1;
    if ( MyWinky != None )
    {
        if ( MyWinky.bOpen == true )
            desire = MaxDesireability;
    }
    return desire;
}


function bool HandlePickupQuery( inventory Item )
{
    return true;             // true = abort pickup
}


//   if -- we are touched by a bot,
//  and -- we have an associated target,
//  and -- that target is ready to be shot,
//  and -- we meet our likelihood spec,
// then -- tell the bot to shoot it,
//  and -- go dormant for BetweenTime
auto state Pickup
{

    function Timer()
    {
        MaxDesireability = Default.MaxDesireability;
        enable( 'Touch' );
    }

    function Touch( actor Other )
    {
//log( self$" touched by "$Other );
        if ( Other.IsA('NerfBots') && ValidTouch(Other) )
        {
            switch( Bait )
            {
                case BB_ShootWinky:
                if ( MyWinky != None )
                {
                    if ( (MyWinky.bOpen == true) && (FRand() < Likelihood) )
                	    NerfBots(Other).ShootThatTarget(MyWinky);
                }
                break;

                case BB_ShootSpinner:
                if ( MyMover != None )
                {
                    if ( FRand() < Likelihood )
                	    NerfBots(Other).ShootThatTarget(MyMover);
                }
                break;
            }
            MaxDesireability = -1;
            disable( 'Touch' );
            SetTimer( BetweenTime*2, false );
        }
    }
}

defaultproperties
{
     Likelihood=1.000000
     Bait=BB_ShootWinky
     BetweenTime=5.000000
     bAutoActivate=True
     MaxDesireability=1.000000
     bHidden=True
     Texture=Texture'NerfI.S_BBait'
     Mesh=LodMesh'NerfI.SHBalls'
     CollisionRadius=75.000000
}
