class NerfHelpWindow extends UWindowWindow;

var bool UseDefaultHelp;
var string ContextHelp;
var localized string DefaultHelp;
var localized string DefaultMultiPlayerHelp;

function Created()
{
	Super.Created();
}

function SetHelp(string NewHelp)
{
	ContextHelp = NewHelp;
	UseDefaultHelp = (NewHelp == "");
}

function Paint(Canvas C, float X, float Y)
{
	local float W, H;

	C.DrawColor.R = 255;
	C.DrawColor.G = 255;
	C.DrawColor.B = 255;

	if (UseDefaultHelp)
	{
		C.Font = Root.Fonts[F_Large];

		if (NerfRootWindow(Root).PDAMainWindow().MultiplayerScreenShown)
			ContextHelp = DefaultMultiPlayerHelp;
		else
			ContextHelp = DefaultHelp;
	}
	else
		C.Font = Root.Fonts[F_Normal];

	if (WrapClipText(C, W, H, ContextHelp,,,,True) > 1)
		WrapClipText(C, W, H, ContextHelp);		
	else
	{
		// centered
		TextSize(C, ContextHelp, W, H);
		W = (WinWidth-W)/2;
		H = (WinHeight-H)/2;
		ClipText(C, W, H, ContextHelp);
	}
}

defaultproperties
{
     DefaultHelp=Click PLAY button or press ESC key to play
     DefaultMultiPlayerHelp=Click PLAY to start Mulitplayer game, F5 to Refresh
}
