//=============================================================================
// BallTrigger.
// Trigger for Scavenger Hunt. Color Ball touched this trigger will be destroyed
// and regenerated by the BallGenerater.
//
// Usage :	1) Put the Trigger in the proper place.
//			2) Set the PointScale which will multiply the points of the ball
//			   depends on the difficulty.	
//
//	If you link this trigger to the Pointevent, make sure the property point in
//  the PointEvent is zero, since the BallTrigger already give points to the 
//  Player.
//
// Created by Wezo
//=============================================================================
class BallTrigger extends Trigger;

var() int PointScale;
var Pawn Pending;
//DSL 
var VoxBox myVox;
var bool bNewEvent;
var bool bNewBall;
var bool bFirstBallIn;  // always announce first NerfIPlayer ball
var int BallCount;      // then make announcement every BallCount balls
var int BallCounter;

// sportcaster --
// make sure we have a valid voice connection:
//  if found, make announcement
//  else complain to the log
// 

function BTReport( EBallEvent BE )
{
// make sure we can talk
    if ( myVox == None )
    {
        foreach AllActors(class 'VoxBox', myVox )
            break;
    }
    if ( myVox != None )
    {
//log( self$" calling VJ with "$BE );
        myVox.VJBallEvent( BE );
        bNewEvent = false;      // this event has been handled
    }
//    else
//        log( self$" still no voxbox" );
}



function Touch( actor Other )
{
	local actor A;
	local int i;

	if( IsRelevant( Other ) )
	{
		bNewEvent = true;
        bNewBall = true;
		if ( ReTriggerDelay > 0 )
		{
			if ( Level.TimeSeconds - TriggerTime < ReTriggerDelay )
				return;
			TriggerTime = Level.TimeSeconds;
		}
		// Broadcast the Trigger message to all matching actors.
		if( Event != '' )
			foreach AllActors( class 'Actor', A, Event )
				A.Trigger( Other, Other.Instigator );

		if ( Other.IsA('Pawn') && (Pawn(Other).SpecialGoal == self) )
			Pawn(Other).SpecialGoal = None;
				
		if ( Other.IsA('SHBallproj') )
		{

			Pending = Other.instigator;
			Pending.PlayerReplicationInfo.score += (SHBallproj(Other).points*PointScale);
			Pending.SetDepositBall(SHBallproj(Other).slot, True);

//##nerf WES. 
// Check gold ball spawned 
			if (!Level.Game.Goldspawned)
			{
				if (Pending.ShouldDropGoldBall()) 
				{
                    BTReport( BE_Gold );
					Level.Game.RespawnColorBall(7);
					Level.Game.Goldspawned=True;
				}
			}
			else if (SHBallproj(Other).slot == 7)
			{
				if (Pending.AllBallsDeposited())
                {
                    BTReport( BE_Ball7 );
//					Level.Game.EndGame("fraglimit");
                    Level.Game.CeasePlay();
                    bNewBall = false;
                }
			}
            if ( bNewEvent )            // no announcement yet?
            {
                if ( bFirstBallIn )     // can bots get reports yet?
                {
                    BallCounter--;
                    if ( BallCounter < 1 )
                    {
                        BallCounter = BallCount;
                        if ( FRand() < 0.5 )
                            BTReport( BE_Bull );
                        else
                            BTReport( BE_Slam );
                    }
                }
                else                    // only humans get first ball announcement
                {
                    if ( Other.instigator.IsA('NerfIPlayer') )
                    {
                        BTReport( BE_Bull );
                        bFirstBallIn = true;
                        BallCounter = BallCount;
                    }
                }
            }
			

			Level.Game.RespawnColorBall(SHBallproj(Other).slot);

//##nerf WES
// Messing with the Touching array to make the balltrigger function correctly.

			for (i=0;i<4;i++)
				Touching[i] = None;

		}


//		if( Message != "" )
			// Send a string message to the toucher.
//			Other.Instigator.ClientMessage( Message );


		if( bTriggerOnceOnly )
			// Ignore future touches.
			SetCollision(False);
		else if ( RepeatTriggerTime > 0 )
			SetTimer(RepeatTriggerTime, false);
	}
}

defaultproperties
{
     PointScale=1
     BallCount=3
     TriggerType=TT_ClassProximity
     ClassProximityType=Class'NerfI.SHBallproj'
     ReTriggerDelay=0.010000
     bBlockActors=True
     bBlockPlayers=True
}
