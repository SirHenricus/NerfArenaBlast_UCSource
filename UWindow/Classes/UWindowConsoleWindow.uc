class UWindowConsoleWindow extends UWindowFramedWindow;

var float OldParentWidth, OldParentHeight;

function BeginPlay() 
{
	Super.BeginPlay();

	ClientClass = class'UWindowConsoleClientWindow';
}

function Created() 
{
	Super.Created();
	bSizable = True;
	bStatusBar = True;
	bLeaveOnScreen = True;

	OldParentWidth = ParentWindow.WinWidth;
	OldParentHeight = ParentWindow.WinHeight;

	SetDimensions();

	SetAcceptsFocus();
}


function ShowWindow()
{
	Super.ShowWindow();

	if(ParentWindow.WinWidth != OldParentWidth || ParentWindow.WinHeight != OldParentHeight)
	{
		SetDimensions();
		OldParentWidth = ParentWindow.WinWidth;
		OldParentHeight = ParentWindow.WinHeight;
	}
}

function ResolutionChanged(float W, float H)
{
	SetDimensions();
}


function SetDimensions()
{
	Log("Centering Console Window");

	if (ParentWindow.WinWidth < 500)
	{
		SetSize(200, 150);
	} else {
		SetSize(410, 310);
	}
	WinLeft = ParentWindow.WinWidth/2 - WinWidth/2;
	WinTop = ParentWindow.WinHeight/2 - WinHeight/2;
}

function KeyType( int Key, float MouseX, float MouseY )
{
	local WindowConsole Con;


	if( Key>=0x20 && Key<0x80 && Key!=Asc("`") && Key!=Asc("~") )
	{
		Con = Root.Console;
		Con.TypedStr = Con.TypedStr $ Chr(Key);
	}
}

function KeyDown(int Key, float X, float Y) {
	local string Temp;
	local WindowConsole Con;
	local PlayerPawn P;

	Con = Root.Console;

	P = GetPlayerOwner();
	switch (Key)
	{
		case P.EInputKey.IK_Escape:
			if( Con.TypedStr!="" )
				Con.TypedStr="";
			break;
		case P.EInputKey.IK_Enter:
			if( Con.TypedStr!="" )
			{
				Con.Message( None, "(> "$Con.TypedStr, 'Console' );

				// Update history buffer.
				Con.UpdateHistory();

				// Make a local copy of the string.
				Temp=Con.TypedStr;
				Con.TypedStr="";
				if( !Con.ConsoleCommand( Temp ) )
					Con.Message( None, Localize("Errors","Exec","Core"), 'Console' );
				Con.Message( None, "", 'Console' );
			}
			break;
		case P.EInputKey.IK_Up:
			Con.HistoryUp();
			break;
		case P.EInputKey.IK_Down:
			Con.HistoryDown();
			break;
		case P.EInputKey.IK_Backspace:
		case P.EInputKey.IK_Left:
			if( Len(Con.TypedStr)>0 )
				Con.TypedStr = Left(Con.TypedStr,Len(Con.TypedStr)-1);
			break;
		default:
			break;
	}
}

function Close(optional bool bByParent)
{
	Root.Console.HideConsole();
}

defaultproperties
{
     WindowTitle=System Console
}
