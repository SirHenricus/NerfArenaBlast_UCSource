class UWindowConsoleClientWindow extends UWindowClientWindow;

var UWindowConsoleTextAreaControl TextArea;

function Created()
{
	TextArea = UWindowConsoleTextAreaControl(CreateWindow(class'UWindowConsoleTextAreaControl', 0, 0, WinWidth, WinHeight));
	TextArea.SetScrollable(true);
}

function Paint(Canvas C, float X, float Y)
{
	DrawStretchedTexture(C, 0, 0, WinWidth, WinHeight, Texture'BlackTexture');
}

function Resized()
{
	Super.Resized();

	TextArea.SetSize(WinWidth, WinHeight);
}


function BeforePaint(Canvas C, float X, float Y)
{
	TextArea.WinWidth = WinWidth;
	TextArea.WinHeight = WinHeight;
}

defaultproperties
{
}
