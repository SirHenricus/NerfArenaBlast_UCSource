///=============================================================================
// Contains a configurable list of favorite destinations (as an internet starting point)
//
// Integrated by Wezo
//=============================================================================
class FavoritesTeleporter extends Teleporter;

var() byte FavoriteNumber;

function PostBeginPlay()
{
	local class<menu> MenuClass;
	local NerfFavoritesMenu TempM;

	MenuClass = class<menu>(DynamicLoadObject("NerfI.NerfFavoritesMenu", class'Class'));
	TempM = NerfFavoritesMenu(spawn(MenuClass));
	// FIXME (Help TIm?)
	//if ( FavoriteNumber < 12 )
	//	URL = TempM.Favorites[FavoriteNumber];
	Super.PostBeginPlay();
}

defaultproperties
{
}
