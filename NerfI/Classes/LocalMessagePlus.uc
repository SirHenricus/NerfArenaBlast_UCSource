//
// Designed for NerfHUD
//
class LocalMessagePlus expands LocalMessage;

var int FontSize;						// Relative font size.
										// 0: Huge
										// 1: Big
										// 2: Small ...

static function font GetFont( Canvas Canvas )
{
	switch (Default.FontSize)
	{
		case 0:
			return class'FontInfo'.Static.GetHugeFont( Canvas.ClipX );
			break;
		case 1:
			return class'FontInfo'.Static.GetBigFont( Canvas.ClipX );
			break;
		case 2:
			return class'FontInfo'.Static.GetSmallFont( Canvas.ClipX );
			break;
		case 3:
			return class'FontInfo'.Static.GetSmallestFont( Canvas.ClipX );
			break;
	}
}

defaultproperties
{
     bIsConsoleMessage=True
}
