//=============================================================================
// YahooTrigger.
//
// Created by Wezo
//=============================================================================
class YahooTrigger extends Trigger;

var Pawn Toucher;

function Touch( actor Other )
{
	if( Pawn(Other) != None )
	{
		Toucher = Pawn(Other);
		Toucher.PlaySound(Toucher.Yahoo, SLOT_Talk, 2.0);
	}
	Super.Touch(Other);
}

defaultproperties
{
}
