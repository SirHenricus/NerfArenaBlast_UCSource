class NerfPDAScreenJoinGame extends NerfWindow;

var UBrowserMainWindow BrowserWindow;
var UBrowserServerList	Server;


function JoinGame()
{
	local int i;
	local UBrowserServerGrid G;
	local UBrowserServerListWindow W;

	// find the active page in the tab control
	for (i = 0; i < 20; i++)
	{
		W = UBrowserMainClientWindow(BrowserWindow.ClientArea).FactoryWindows[i];
		if (W != None && W.WindowIsVisible())
			break;
	}

	G = UBrowserMainClientWindow(BrowserWindow.ClientArea).FactoryWindows[i].Grid;

	// join the game
	if (G != None)
	{
		Server = G.GetServerUnderRow(G.GetSelectedRow());
//		UBrowserServerListWindow(UBrowserMainClientWindow(BrowserWindow.ClientArea).Favorites.Page).AddFavorite(Server);
		G.JoinServer(Server);
	}
}

function Created()
{
	BrowserWindow = UBrowserMainWindow(CreateWindow(class'UBrowserMainWindow', 0, 4, WinWidth-8, WinHeight, OwnerWindow));
}

function ShowBrowserWindow()
{
	ShowChildWindow(BrowserWindow);
}

defaultproperties
{
}
