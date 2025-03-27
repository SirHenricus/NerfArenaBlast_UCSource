class NerfConsole extends WindowConsole;

event bool KeyEvent( EInputKey Key, EInputAction Action, FLOAT Delta )
{
	return Super(Console).KeyEvent( Key, Action, Delta );
}

exec function ShowNerfMenu()
{
	Super.LaunchUWindow();
}

state UWindow
{
	function BeginState()
	{
		Log("NERF Console entering UWindow state");
		if (Root != None)
			NerfRootWindow(Root).Display(True);		// notify root window
	}
	function EndState()
	{
		Log("NERF Console leaving UWindow state");
		if (Root != None)
			NerfRootWindow(Root).Display(False);		// notify root window
	}
}

defaultproperties
{
     RootWindow=NerfMenu.NerfRootWindow
     MouseScale=0.850000
}
