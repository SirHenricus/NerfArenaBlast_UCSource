class FontInfo expands Info;

static function font GetHugeFont(float Width)
{
//	if (Width < 512)
		return Font'SmallFont';
/*
	else if (Width < 640)
		return Font(DynamicLoadObject("LadderFonts.UTLadder16", class'Font'));
	else if (Width < 800)
		return Font(DynamicLoadObject("LadderFonts.UTLadder20", class'Font'));
	else if (Width < 1024)
		return Font(DynamicLoadObject("LadderFonts.UTLadder22", class'Font'));
	else
		return Font(DynamicLoadObject("LadderFonts.UTLadder30", class'Font'));
*/
}

static function font GetBigFont(float Width)
{
//	if (Width < 512)
		return Font'SmallFont';
/*
	else if (Width < 640)
		return Font(DynamicLoadObject("LadderFonts.UTLadder16", class'Font'));
	else if (Width < 800)
		return Font(DynamicLoadObject("LadderFonts.UTLadder18", class'Font'));
	else if (Width < 1024)
		return Font(DynamicLoadObject("LadderFonts.UTLadder20", class'Font'));
	else
		return Font(DynamicLoadObject("LadderFonts.UTLadder22", class'Font'));
*/
}

static function font GetSmallFont(float Width)
{
//	if (Width < 640)
		return Font'SmallFont';
/*
	else if (Width < 800)
		return Font(DynamicLoadObject("LadderFonts.UTLadder10", class'Font'));
	else if (Width < 1024)
		return Font(DynamicLoadObject("LadderFonts.UTLadder14", class'Font'));
	else
		return Font(DynamicLoadObject("LadderFonts.UTLadder16", class'Font'));
*/
}

static function font GetSmallestFont(float Width)
{
		return Font'SmallFont';

/*
	if (Width < 640)
		return Font'SmallFont';
	else if (Width < 800)
		return Font(DynamicLoadObject("LadderFonts.UTLadder10", class'Font'));
	else if (Width < 1024)
		return Font(DynamicLoadObject("LadderFonts.UTLadder12", class'Font'));
	else
		return Font(DynamicLoadObject("LadderFonts.UTLadder14", class'Font'));
*/
}

static function font GetAReallySmallFont(float Width)
{
		return Font'SmallFont';
/*
	if (Width < 800)
		return Font'SmallFont';
	else if (Width < 1024)
		return Font(DynamicLoadObject("LadderFonts.UTLadder8", class'Font'));
	else
		return Font(DynamicLoadObject("LadderFonts.UTLadder10", class'Font'));
*/
}

static function font GetACompletelyUnreadableFont(float Width)
{
		return Font'SmallFont';
/*
	if (Width < 800)
		return Font'SmallFont';
	else if (Width < 1024)
		return Font(DynamicLoadObject("LadderFonts.UTLadder8", class'Font'));
	else
		return Font(DynamicLoadObject("LadderFonts.UTLadder8", class'Font'));
*/
}

defaultproperties
{
}
