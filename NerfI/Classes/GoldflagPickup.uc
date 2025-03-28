////////////////////////////////////////////////////////////////////////////////
// Class GoldflagPickup
////////////////////////////////////////////////////////////////////////////////

class GoldflagPickup extends RaceflagPickup;

var PlayerPawn Winner;
var bool bPlucked;

// DSL: all other flagpickups use auto state from parent class RaceflagPickup
// but the gold flag can end the game


auto state Pickup
{	
/*
    function Timer()
    {
log("gold flag sez its over" );
        Level.Game.EndGame("fraglimit");
//        if ( Winner != None )
//            Winner.myHud.SetWinnerSplash( false,"" );
    }
*/
	function Touch( actor Other )
	{
		local Inventory Copy;
        local string Runner;
	
		if ( ValidTouch(Other) && Other.IsA('Pawn') )
		{
			if (Priority > Pawn(Other).RFNum)
			{
				if ( Priority == (Pawn(Other).RFNum+1))
				{
					Pawn(Other).RFNum++;
					Pawn(Other).ClientMessage(PickupMessage);				
                    Pawn(Other).RegisterFlag(ReSpawnNode);
                    if ( bPlucked == false )        // first one here?
                    {
                        bPlucked = true;            // yes, no one else gets 'em
    					Pawn(Other).PlayerReplicationInfo.Score += FlagPoints;
                        FPReport();
                    }
					PlaySound (PickupSound,,2.0);
                    if ( Pawn(Other).RFNum == 7 )
                    {
                        if ( Pawn(Other).IsA('NerfBots') )
                        {
//                          PawnMoveOutOfTheWayAnd--()
                            Pawn(Other).PlayVictoryDance();
                            Level.Game.CeasePlay();
                        }
                        else                        // first human here
                        {
                            Winner = PlayerPawn(Other);
                            Level.Game.CeasePlay();
//			Pawn(Other).ClientMessage("YOU WIN!",, true);
//          PlayerPawn(Other).myHud.SetWinnerSplash( true, );
//          Runner = Winner.PlayerReplicationInfo.PlayerName;
//          Winner.myHud.SetWinnerSplash( true, Runner );
                        }
                    }
				}
				else 
					Pawn(Other).ClientMessage(ErrorMessage);				
			}
			else 
			{
				Pawn(Other).ClientMessage(" You already have this flag ");
			}
		}
	}
}

defaultproperties
{
     Priority=7
     FlagPoints=5000
     PickupMessage=End of the Race!
}
