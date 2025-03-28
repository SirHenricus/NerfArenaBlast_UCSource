//=============================================================================
// EndGame.
//
// Intergrated by Wezo at 7-7-99
//=============================================================================
class EndGame extends NerfGameInfo;

event AcceptInventory(pawn PlayerPawn)
{
	local inventory Inv;

	// accept no inventory
	for ( Inv=PlayerPawn.Inventory; Inv!=None; Inv=Inv.Inventory )
		Inv.Destroy(); 
}


function PlayTeleportEffect( actor Incoming, bool bOut, bool bSound)
{
}

defaultproperties
{
     HUDType=Class'NerfI.EndgameHud'
}
