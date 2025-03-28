//=============================================================================
// UpgradeMenu
//
// Integrated by Wezo
//=============================================================================
class UpgradeMenu extends YesNoMenu;

function ProcessResponse()
{
	//process based on state of bResponse
	if ( bResponse )
		PlayerOwner.ConsoleCommand("start http://www.Nerf.com/upgrade");

	ExitMenu();
}

defaultproperties
{
     MenuList(1)=You need a newer version of Nerf to play on this server. Would you like to go to the Nerf web site for a newer version?
}
