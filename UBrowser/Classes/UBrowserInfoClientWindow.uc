//=============================================================================
// UBrowserInfoClientWindow - extra info on a specific server
//=============================================================================
class UBrowserInfoClientWindow extends UWindowClientWindow;

var UBrowserServerList Server;
var UWindowVSplitter VSplitter;
var UBrowserRulesGrid Rules;
var float PrevSplitPos;

function Created()
{
	Super.Created();
	
	VSplitter = UWindowVSplitter(CreateWindow(class'UWindowVSplitter', 0, 0, WinWidth, WinHeight));

	VSplitter.TopClientWindow = UBrowserPlayerGrid(VSplitter.CreateWindow(class'UBrowserPlayerGrid', 0, 0, WinWidth, WinHeight));
	Rules = UBrowserRulesGrid(CreateWindow(class'UBrowserRulesGrid', 0, 0, WinWidth, WinHeight));
	VSplitter.BottomClientWindow = Rules;
}

function Resized()
{
	VSplitter.SetSize(WinWidth, WinHeight);

	VSplitter.OldWinHeight = VSplitter.WinHeight;
	VSplitter.SplitPos = WinHeight / 2;
	PrevSplitPos = VSplitter.SplitPos;
}

function Paint(Canvas C, float X, float Y)
{
	DrawStretchedTexture(C, 0, 0, WinWidth, WinHeight, Texture'BlackTexture');
	if(VSplitter.SplitPos != PrevSplitPos)
		PrevSplitPos = VSplitter.SplitPos;
}

function BeforePaint(Canvas C, float X, float Y)
{
	Super.BeforePaint(C, X, Y);
	if(VSplitter.SplitPos != PrevSplitPos)
		PrevSplitPos = VSplitter.SplitPos;
}

defaultproperties
{
}
