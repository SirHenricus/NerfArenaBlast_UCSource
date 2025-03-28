//=============================================================================
// NerfGameMenu
//
// Integrated by Wezo
//=============================================================================
class NerfGameMenu extends NerfLongMenu;

function bool ProcessSelection()
{
	local Menu ChildMenu;

	if ( (Selection == 1) && (Level.NetMode == NM_Standalone)
				&& !Level.Game.IsA('DeathMatchGame') )
		ChildMenu = spawn(class'NerfSaveMenu', owner);
	else if ( Selection == 2 ) 
		ChildMenu = spawn(class'NerfLoadMenu', owner);
	else if ( Selection == 3 )
		ChildMenu = spawn(class'NerfChooseGameMenu', owner);
	else if ( Selection == 4 )
	{
		if ( (Level.Game != None) && (Level.Game.GameMenuType != None) )
			ChildMenu = spawn(Level.Game.GameMenuType, owner);
	}
	else if ( Selection == 5 )
	{
		ChildMenu = spawn(class'NerfServerMenu', owner);
		NerfServerMenu(ChildMenu).bStandAlone = true;
	}
	else 
		return false;

	if ( ChildMenu != None )
	{
		HUD(Owner).MainMenu = ChildMenu;
		ChildMenu.ParentMenu = self;
		ChildMenu.PlayerOwner = PlayerOwner;
	}
	return true;
}

function SaveConfigs()
{
	Level.Game.SaveConfig();
	Level.Game.GameReplicationInfo.SaveConfig();
}

function DrawMenu(canvas Canvas)
{
	local int StartX, StartY, Spacing;
	local string SkillName;

	DrawBackGround(Canvas, false);

	Spacing = Clamp(0.1 * Canvas.ClipY, 16, 48);
	StartX = Max(40, 0.5 * Canvas.ClipX - 96);
	StartY = Max(4, 0.5 * (Canvas.ClipY - 5 * Spacing - 128));

	// draw text
	DrawList(Canvas, true, Spacing, StartX, StartY);  

	// Draw help panel
	DrawHelpPanel(Canvas, StartY + MenuLength * Spacing + 4, 228);
}

defaultproperties
{
     MenuLength=5
     HelpMessage(1)=Hit enter to save the current game.
     HelpMessage(2)=Hit enter to load a saved game.
     HelpMessage(3)=Select a difficulty level, and start a new game.
     HelpMessage(4)=Hit enter to modify game options.  Note that you cannot do this if you are playing in a multiplayer game.
     HelpMessage(5)=PointMatch against Bots.
     MenuList(1)=SAVE GAME
     MenuList(2)=LOAD GAME
     MenuList(3)=NEW GAME
     MenuList(4)=GAME OPTIONS
     MenuList(5)=BOTMATCH
}
