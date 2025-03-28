////////////////////////////////////////////////////////////////////////////////
// Class RaceflagPickup
//
// This is a invisible pickup that you put right next to the flag for Arena Race.
// This Pickup will be added to the Player's Inventory and it will be respawned
// immediately at the flag spot. 
// 
// Raceflag has their priority so if you picked up a higher priority raceflag, the
// lower priority raceflag will be deleted at your inventory so you will only keep
// one raceflag in your inventory.
//
// For the last flag, you might want to set the Respawn time to 0.000 so there's 
// only one flag pickup for the winner.
//
// Usage:
//		1. Set the Priority of the RaceflagPickup from the Editor Property menu.
//		   (0-128). Ex. #1 flag should have Priority 0, #2 should have 1....etc.
//		2. Set the Event of the RaceflagPickup to corresponded flag color.
//		   (Event= Blue, for blue flag).
//		3. Type in the Error Message in the Property menu. 
//		   Ex. You already have this flag. Move on to the next flag YOU STUPID!!!
//
// P.S. RaceflagPickup does not have a Mesh so you have to switch to Icon View 
//		in the Editor in order to see it. 	
//
// Created by Wezo
////////////////////////////////////////////////////////////////////////////////

class RaceflagPickup extends PickUp
	abstract;

var() byte Priority;
var() string ErrorMessage;
var(ReSpawnTag) name ReSpawnTag;
var ReSpawnPoint ReSpawnNode;
var () int FlagPoints;

var VoxBox myVox;
var bool bHaveSpoken;


function PreBeginPlay()
{
// associate ourselfs with the respawn point whose tag we bear
    foreach AllActors( class 'ReSpawnPoint', ReSpawnNode, ReSpawnTag )
        break;
    bHaveSpoken = false;
}

function FPReport()
{
// mum's the word if we are training ( don't want to scare anybody )
    if ( Level.Game.Isa('ARTraining') )
        return;

// make sure we can talk
    if ( myVox == None )
    {
        foreach AllActors( class 'VoxBox', myVox )
            break;
    }
    if ( myVox != None )
    {
//log( self$" calling VJ for flag "$Priority );
        myVox.VJFlagEvent(Priority-1);      // convert flag no. into index
        bHaveSpoken = true;
    }        
}


auto state Pickup
{	
	function Touch( actor Other )
	{
		if ( ValidTouch(Other) && Other.IsA('Pawn') )
		{
			if (Priority > Pawn(Other).RFNum)
			{
				if ( Priority == (Pawn(Other).RFNum+1))
				{
					Pawn(Other).RFNum++;
					Pawn(Other).ClientMessage(PickupMessage);				
                    Pawn(Other).RegisterFlag(ReSpawnNode);
					Pawn(Other).PlayerReplicationInfo.Score += FlagPoints;
					PlaySound (PickupSound,,2.0);
                    if ( !bHaveSpoken )
                        FPReport();
				}
				else 
					Pawn(Other).ClientMessage(ErrorMessage);				
			}
			else 
			{
				Pawn(Other).ClientMessage(" You already have this flag ");
                Disable('Touch');
			}
		}
	}


    function UnTouch( actor Other )
    {
        Enable('Touch');
    }
}

defaultproperties
{
     FlagPoints=3000
     bInstantRespawn=True
     PickupMessage=Proceed to the next flag
}
