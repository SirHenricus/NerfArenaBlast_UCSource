//=============================================================================
// NerfNewGameMenu
//
// Integrated by Wezo 
//=============================================================================
class NerfNewGameMenu extends NerfGameMenu;

var string StartMap;

function Destroyed()
{
	Super.Destroyed();
}

function PostBeginPlay()
{
	Super.PostBeginPlay();
	Selection = Clamp(Level.Game.Difficulty + 1,1,4);
} 

function bool ProcessSelection()
{
	local Menu ChildMenu;

	ChildMenu = spawn(class'NerfMeshMenu', owner);
	HUD(Owner).MainMenu = ChildMenu;
	ChildMenu.ParentMenu = self;
	ChildMenu.PlayerOwner = PlayerOwner;
	StartMap = StartMap$"?Difficulty="$(Selection - 1);
	if ( Level.Game != None )
		StartMap = StartMap$"?GameSpeed="$Level.Game.GameSpeed;
	NerfMeshMenu(ChildMenu).StartMap = StartMap;
	NerfMeshMenu(ChildMenu).SinglePlayerOnly = true;
	return true;
}

function SaveConfigs();


function DrawMenu(canvas Canvas)
{
	local int StartX, StartY, Spacing;
	
	DrawBackGround(Canvas, false);	
	
	Spacing = Clamp(0.1 * Canvas.ClipY, 16, 48);
	StartX = Max(40, 0.5 * Canvas.ClipX - 96);
	StartY = Max(8, 0.5 * (Canvas.ClipY - 5 * Spacing - 128));

	DrawList(Canvas, true, Spacing, StartX, StartY); 
	DrawHelpPanel(Canvas, StartY + MenuLength * Spacing + 8, 228);
}

defaultproperties
{
     MenuLength=4
     HelpMessage(1)=Tourist mode.
     HelpMessage(2)=Ready for some action!
     HelpMessage(3)=Not for the faint of heart.
     HelpMessage(4)=Death wish.
     MenuList(1)=AMATEUR
     MenuList(2)=PROFESSIONAL
     MenuList(3)=FINALIST
     MenuList(4)=CHAMPION
}
