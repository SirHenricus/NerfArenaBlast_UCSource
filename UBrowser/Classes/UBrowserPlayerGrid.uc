//=============================================================================
// UBrowserPlayerGrid
//=============================================================================
class UBrowserPlayerGrid extends UWindowGrid;

var localized string NameText;
var localized string FragsText;
var localized string PingText;
var localized string TeamText;
var localized string SkinText;

function Created() 
{
	Super.Created();

	RowHeight = 12;

	AddColumn(NameText, 85);
	AddColumn(FragsText, 30);
	AddColumn(PingText, 30);
	AddColumn(TeamText, 50);
	AddColumn(SkinText, 86);
}

function PaintColumn(Canvas C, UWindowGridColumn Column, float MouseX, float MouseY) 
{
	local UBrowserServerList Server;
	local UBrowserPlayerList PlayerList, l;
	local int Visible;
	local int Count;
	local int Skipped;
	local int Y;
	local int TopMargin;
	local int BottomMargin;
	
	if(bShowHorizSB)
		BottomMargin = LookAndFeel.Size_ScrollbarWidth;
	else
		BottomMargin = 0;

	TopMargin = LookAndFeel.ColumnHeadingHeight;

	Server = UBrowserInfoClientWindow(GetParent(class'UBrowserInfoClientWindow')).Server;
	if(Server == None)
		return;
	PlayerList = Server.PlayerList;
	if(PlayerList == None)
		return;
	Count = PlayerList.Count();

	C.Font = Root.Fonts[F_Normal];
	Visible = int((WinHeight - (TopMargin + BottomMargin))/RowHeight);
	
	VertSB.SetRange(0, Count+1, Visible);
	TopRow = VertSB.Pos;

	Skipped = 0;

	Y = 1;
	l = UBrowserPlayerList(PlayerList.Next);
	while((Y < RowHeight + WinHeight - RowHeight - (TopMargin + BottomMargin)) && (l != None))
	{
		if(Skipped >= VertSB.Pos)
		{
			switch(Column.ColumnNum)
			{
			case 0:
				Column.ClipText( C, 2, Y + TopMargin, l.PlayerName );
				break;
			case 1:
				Column.ClipText( C, 2, Y + TopMargin, l.PlayerFrags );
				break;
			case 2:
				Column.ClipText( C, 2, Y + TopMargin, l.PlayerPing);
				break;
			case 3:
				Column.ClipText( C, 2, Y + TopMargin, l.PlayerTeam );
				break;
			case 4:
				Column.ClipText( C, 2, Y + TopMargin, l.PlayerMesh );
				break;
			case 5:
				Column.ClipText( C, 2, Y + TopMargin, l.PlayerSkin );
				break;
			case 6:
				Column.ClipText( C, 2, Y + TopMargin, l.PlayerFace );
				break;
			case 7:
				Column.ClipText( C, 2, Y + TopMargin, l.PlayerID );
				break;
			}

			Y = Y + RowHeight;			
		} 
		Skipped ++;
		l = UBrowserPlayerList(l.Next);
	}
}

function RightClickRow(int Row, float X, float Y)
{
	local UBrowserInfoMenu Menu;
	local float MenuX, MenuY;

	Menu = UBrowserInfoWindow(GetParent(class'UBrowserInfoWindow')).Menu;

	WindowToGlobal(X, Y, MenuX, MenuY);
	Menu.WinLeft = MenuX;
	Menu.WinTop = MenuY;

	Menu.ShowWindow();
}

function SortColumn(UWindowGridColumn Column) 
{
	UBrowserInfoClientWindow(GetParent(class'UBrowserInfoClientWindow')).Server.PlayerList.SortByColumn(Column.ColumnNum);
}

function SelectRow(int Row) 
{
}

defaultproperties
{
     NameText=Name
     FragsText=Points
     PingText=Ping
     TeamText=Team
     SkinText=Character
     bNoKeyboard=True
}
