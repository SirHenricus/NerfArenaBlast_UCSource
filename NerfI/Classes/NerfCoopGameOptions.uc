//=============================================================================
// NerfCoopGameOptions
//
// Integrated by Wezo
//=============================================================================
class NerfCoopGameOptions extends NerfGameOptionsMenu;

var localized string Difficulties[4];

function bool ProcessLeft()
{
	if ( Selection == 3 )
		NerfServerMenu(ParentMenu).Difficulty = Max( 0, NerfServerMenu(ParentMenu).Difficulty - 1 );
	else 
		return Super.ProcessLeft();

	return true;
}

function bool ProcessRight()
{
	if ( Selection == 3 )
		NerfServerMenu(ParentMenu).Difficulty = Min( 3, NerfServerMenu(ParentMenu).Difficulty + 1 );
	else 
		return Super.ProcessRight();

	return true;
}

function DrawOptions(canvas Canvas, int StartX, int StartY, int Spacing)
{
	MenuList[3] = Default.MenuList[3];
	Super.DrawOptions(Canvas, StartX, StartY, Spacing);
}

function DrawValues(canvas Canvas, int StartX, int StartY, int Spacing)
{
	local DeathMatchGame DMGame;

	DMGame = DeathMatchGame(GameType);

	// draw text
	if ( NerfServerMenu(ParentMenu).Difficulty < 0 )
		NerfServerMenu(ParentMenu).Difficulty = 1;
	MenuList[3] = Difficulties[NerfServerMenu(ParentMenu).Difficulty];
	Super.DrawValues(Canvas, StartX, StartY, Spacing);
}

defaultproperties
{
     Difficulties(0)=AMATEUR
     Difficulties(1)=PROFESSIONAL
     Difficulties(2)=FINALIST
     Difficulties(3)=CHAMPION
     GameClass=None
     MenuLength=3
     HelpMessage(3)=Skill level setting.
     MenuList(3)=Difficulty
}
