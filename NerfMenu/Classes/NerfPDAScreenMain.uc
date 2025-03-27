class NerfPDAScreenMain extends NerfWindow;

// Background
var() bool BackgroundSmooth;
var() string BackgroundName;
var texture Background;

//
// Components
//

// Character info
var UWindowLabelControl CharacterNameLabel;
//var UWindowLabelControl CharacterRankLabel;
var UWindowLabelControl CharacterPointsLabel;
var UWindowLabelControl CharacterLevelLabel;
var UWindowLabelControl CharacterEventsLabel;
var localized String NameLabelText;
//var localized String RankLabelText;
var localized String PointsLabelText;
var localized String LevelLabelText;
var localized String EventsLabelText;

var int		ControlLeft;
var int		ControlHeight;


function Created() 
{
	local Color TextColor;
	local int ControlTop;

	Super.Created();

	TextColor.R = 255;
	TextColor.G = 255;
	TextColor.B = 255;

	//
	// Load the background.
	//
	Background = Texture(DynamicLoadObject(BackgroundName, Class'Texture'));

	//
	// Create components.
	//
	ControlTop = 100;

	// Name
	CharacterNameLabel = UWindowLabelControl(CreateControl(class'UWindowLabelControl', ControlLeft, ControlTop, 150, 20));
	CharacterNameLabel.SetTextColor(TextColor);
	CharacterNameLabel.SetText(NameLabelText);
	CharacterNameLabel.SetFont(F_Normal);
	ControlTop += ControlHeight;	

//	// Rank
//	CharacterRankLabel = UWindowLabelControl(CreateControl(class'UWindowLabelControl', ControlLeft, ControlTop, 150, 20));
//	CharacterRankLabel.SetTextColor(TextColor);
//	CharacterRankLabel.SetText(RankLabelText);
//	CharacterRankLabel.SetFont(F_Normal);
//	ControlTop += ControlHeight;	

	// Points
	CharacterPointsLabel = UWindowLabelControl(CreateControl(class'UWindowLabelControl', ControlLeft, ControlTop, 150, 20));
	CharacterPointsLabel.SetTextColor(TextColor);
	CharacterPointsLabel.SetText(PointsLabelText);
	CharacterPointsLabel.SetFont(F_Normal);
	ControlTop += ControlHeight;	

	// Level
	CharacterLevelLabel = UWindowLabelControl(CreateControl(class'UWindowLabelControl', ControlLeft, ControlTop, 150, 20));
	CharacterLevelLabel.SetTextColor(TextColor);
	CharacterLevelLabel.SetText(LevelLabelText);
	CharacterLevelLabel.SetFont(F_Normal);
	ControlTop += ControlHeight;	

	// Events
	CharacterEventsLabel = UWindowLabelControl(CreateControl(class'UWindowLabelControl', ControlLeft, ControlTop, 150, 20));
	CharacterEventsLabel.SetTextColor(TextColor);
	CharacterEventsLabel.SetText(EventsLabelText);
	CharacterEventsLabel.SetFont(F_Normal);
}

function ShowCharInfo(string Name, string Rank, int Points, string Level, int Events)
{
	// name
	CharacterNameLabel.SetText(NameLabelText $ Name);	

	// rank
//	CharacterRankLabel.SetText(RankLabelText $ Rank);	

	// level
	CharacterLevelLabel.SetText(LevelLabelText $ Level);	

	// points
	CharacterPointsLabel.SetText(PointsLabelText $ Points);	

	// events
	CharacterEventsLabel.SetText(EventsLabelText $ Events);	
}

function Paint(Canvas C, float X, float Y)
{
	C.bNoSmooth = !BackgroundSmooth;			// note: false causes tiling artifacts (gaps)
	C.SetPos(0, 24);
	C.DrawIcon(Background, 1.0);
}

defaultproperties
{
     BackgroundName=NerfRes.MainScrBack
     NameLabelText=Name: 
     PointsLabelText=Score: 
     LevelLabelText=Level: 
     EventsLabelText=Completed Events: 
     ControlLeft=100
     ControlHeight=20
}
