//=============================================================================
// NerfRootWindow - root window subclass for Nerf
//=============================================================================
class NerfRootWindow extends UWindowRootWindow;

var int ScreenWidth, ScreenHeight;
var	NerfMainWindow MainWindow;
var bool bPDALowRes;

function NerfPDA PDAMainWindow()
{
	return NerfPDA(MainWindow.ClientArea);
}

function DoQuitGame()
{
	if (GetLevel().Game != None)
	{
		GetLevel().Game.SaveConfig();
		GetLevel().Game.GameReplicationInfo.SaveConfig();
	}
	
	MainWindow.Close();		// trigger window saveconfigs

	Super.DoQuitGame();
}

function Display(bool bShow)
{
	MainWindow.Display(bShow);		// propigate the message
}

function Created()
{
	Super.Created();

	MainWindow = NerfMainWindow(CreateWindow(class'NerfMainWindow', 0, 0, 512, 384));
	MainWindow.bStandaloneBrowser = True;
	MainWindow.ResolutionChanged(WinWidth, WinHeight);
}

function SetupFonts()
{
	local string Sizes[5];
	local int UseSize;

	UseSize = 0;

	// try using UWindowFonts
	Sizes[F_Normal]		= "Tahoma";
	Sizes[F_Bold]		= "TahomaB";
	Sizes[F_Large]		= "TahomaL";
//	Sizes[F_LargeBold]	= "Tahoma20";

	Fonts[F_Normal] = Font(DynamicLoadObject("UWindowFonts." $ Sizes[UseSize+F_Normal], class'Font'));
	Fonts[F_Bold] = Font(DynamicLoadObject("UWindowFonts." $ Sizes[UseSize+F_Bold], class'Font'));
	Fonts[F_Large] = Font(DynamicLoadObject("UWindowFonts." $ Sizes[UseSize+F_Large], class'Font'));
//	Fonts[F_LargeBold] = Font(DynamicLoadObject("UWindowFonts." $ Sizes[UseSize+F_LargeBold], class'Font'));
	Fonts[F_LargeBold] = Fonts[F_Large];

	if (Fonts[F_Normal] != None)
	{
		Log("Using font: "$Sizes[UseSize]);
		return;
	}

	// try using Engine fonts
	Sizes[F_Normal]		= "SmallFont";
	Sizes[F_Bold]		= "MedFont";
	Sizes[F_Large]		= "LargeFont";
	Sizes[F_LargeBold]	= "BigFont";

	Fonts[F_Normal] = Font(DynamicLoadObject("Engine." $ Sizes[UseSize], class'Font'));
	Fonts[F_Bold] = Font(DynamicLoadObject("Engine." $ Sizes[UseSize+F_Bold], class'Font'));
	Fonts[F_Large] = Font(DynamicLoadObject("Engine." $ Sizes[UseSize+F_Large], class'Font'));
	Fonts[F_LargeBold] = Font(DynamicLoadObject("Engine." $ Sizes[UseSize+F_LargeBold], class'Font'));

	if (Fonts[F_LargeBold] != None)
	{
		Log("Using font: "$Sizes[UseSize]);
		return;
	}

	Log("Could not use Engine font!!!");

	// try using basic engine font
	Fonts[F_Normal] = Font(DynamicLoadObject("Engine.MedFont", class'Font'));
	Fonts[F_Bold] = Fonts[F_Normal];
	Fonts[F_Large] = Fonts[F_Normal];
	Fonts[F_LargeBold] = Fonts[F_Normal];
}

function bool GetScreenSize()
{
	local string CurrentRes;
	local int	 x;

	CurrentRes = GetPlayerOwner().ConsoleCommand("GetCurrentRes");

	x = InStr(CurrentRes, "x");		// find the 'x' in resolution string i.e. 800x600

	if (x < 1) return false;

	ScreenWidth = int(Left(CurrentRes, x));
	ScreenHeight = int(Right(CurrentRes, Len(CurrentRes) - x - 1));

	return true;
}

defaultproperties
{
     LookAndFeelClass=NerfMenu.NerfLookAndFeel
}
