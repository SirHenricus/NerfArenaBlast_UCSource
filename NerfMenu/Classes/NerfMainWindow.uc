//=============================================================================
// NerfMainWindow - The main window
//=============================================================================
class NerfMainWindow extends UWindowFramedWindow;

var string StatusBarDefaultText;
var bool bStandaloneBrowser;
var class<UWindowWindow> ClientAreaClass;

function Created()
{
	bSizable = False;
	bStatusBar = False;

	NerfRootWindow(Root).GetScreenSize();
	
	ClientAreaClass = GetClientClass();
	ClientArea = CreateWindow(ClientAreaClass, 0, 0, WinWidth, WinHeight, OwnerWindow);

	NerfPDA(ClientArea).CenterWindow();
}

function Display(bool bShow)
{
	NerfPDA(ClientArea).Display(bShow);		// propigate msg to child window
}

function Close(optional bool bByParent) 
{
	ClientArea.SaveConfigs();

	if(bStandaloneBrowser)
		Root.Console.CloseUWindow();
	else
		Super.Close(bByParent);
}

function ResolutionChanged(float W, float H)
{
	local class<UWindowWindow> NewClientAreaClass;

	Super.ResolutionChanged(W, H);

	if (NerfRootWindow(Root).ScreenWidth == 0 && NerfRootWindow(Root).ScreenHeight == 0)
	{
		NerfRootWindow(Root).ScreenWidth = W;
		NerfRootWindow(Root).ScreenHeight = H;
	}

	if (W != NerfRootWindow(Root).ScreenWidth || H != NerfRootWindow(Root).ScreenHeight)
	{
		// Resolution changed
		log("NerfMenu: Resolution change detected.  Oldres = " $ NerfRootWindow(Root).ScreenWidth $ "x" $ NerfRootWindow(Root).ScreenHeight $ "  Newres = " $ int(W) $ "x" $ int(H));
		NerfRootWindow(Root).ScreenWidth = W;
		NerfRootWindow(Root).ScreenHeight = H;
		NewClientAreaClass = GetClientClass();

		if (NewClientAreaClass != ClientAreaClass)
		{
			// switch menu classes
			log("NerfMenu: Switching menu from " $ ClientAreaClass $ " to " $ NewClientAreaClass);
			ClientAreaClass = NewClientAreaClass;

			// close old and open new client area window
			ClientArea.Close();
			ClientArea = None;
			ClientArea = CreateWindow(ClientAreaClass, 0, 0, NerfRootWindow(Root).ScreenWidth, NerfRootWindow(Root).ScreenHeight, OwnerWindow);
		}
	}

	NerfPDA(ClientArea).CenterWindow();
	ClientArea.ResolutionChanged(W,H);
}

function class<UWindowWindow> GetClientClass()
{
	// pick the new client window class to use
	if (NerfRootWindow(Root).ScreenWidth < 512 || NerfRootWindow(Root).ScreenHeight < 384)
	{
		//Root.GUIScale = 0.5;
		NerfRootWindow(Root).bPDALowRes = True;
		return class'NerfMenu.NerfPDALow';
	}
	else
	{
		//Root.GUIScale = 1.0;
		NerfRootWindow(Root).bPDALowRes = False;
		return class'NerfMenu.NerfPDAMed';
	}
}	

function BeforePaint(Canvas C, float X, float Y)
{
	if(StatusBarText == "")
		StatusBarText = StatusBarDefaultText;

	Super.BeforePaint(C, X, Y);
}


function DefaultStatusBarText(string Text)
{
	StatusBarText = Text;
}

defaultproperties
{
}
