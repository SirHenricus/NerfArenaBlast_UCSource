class NerfCardProfile extends NerfCard;

var NerfPlayerProfile pp;

//var NerfMessageBox ConfirmDelete;
//var localized string ConfirmDeleteTitle;
//var localized string ConfirmDeleteText;

// Profile info
var UWindowLabelControl ProfileNameLabel;
//var UWindowLabelControl ProfileRankLabel;
var UWindowLabelControl ProfilePointsLabel;
var UWindowLabelControl ProfileLevelLabel;
var UWindowLabelControl ProfileEventsLabel;
var localized String NameLabelText;
//var localized String RankLabelText;
var localized String PointsLabelText;
var localized String EventsLabelText;

var int		ControlLeft;
var int		ControlHeight;

//
// Controls
//

// Previous Player Profile Button
var NerfButtonControl PrevButton;
var localized string PrevButtonText;
var localized string PrevButtonHelp;

// Next Player Profile Button
var NerfButtonControl NextButton;
var localized string NextButtonText;
var localized string NextButtonHelp;

// New Game Button
var NerfButtonControl NewGameButton;
var localized string NewGameButtonText;
var localized string NewGameButtonHelp;

// New Player Button
var NerfButtonControl NewPlayerButton;
var localized string NewPlayerButtonText;
var localized string NewPlayerButtonHelp;

// Delete Player Button
var NerfButtonControl DeletePlayerButton;
var localized string DeletePlayerButtonText;
var localized string DeletePlayerButtonHelp;


function Created() 
{
	local Color TextColor;
	local int ControlTop;

	Super.Created();

	pp = NerfRootWindow(Root).PDAMainWindow().PlayerProfile;

	TextColor.R = 0;
	TextColor.G = 0;
	TextColor.B = 0;

	//
	// Create components.
	//
	ControlTop = 87;

	// Name
	ProfileNameLabel = UWindowLabelControl(CreateControl(class'UWindowLabelControl', ControlLeft, ControlTop, 150, 20));
	ProfileNameLabel.SetTextColor(TextColor);
	ProfileNameLabel.SetText(NameLabelText);
	ProfileNameLabel.SetFont(F_Normal);
	ControlTop += ControlHeight;	

	// Rank
/*
	ProfileRankLabel = UWindowLabelControl(CreateControl(class'UWindowLabelControl', ControlLeft, ControlTop, 150, 20));
	ProfileRankLabel.SetTextColor(TextColor);
	ProfileRankLabel.SetText(RankLabelText);
	ProfileRankLabel.SetFont(F_Normal);
	ControlTop += ControlHeight;	
*/

	// Points
	ProfilePointsLabel = UWindowLabelControl(CreateControl(class'UWindowLabelControl',ControlLeft, ControlTop, 150, 20));
	ProfilePointsLabel.SetTextColor(TextColor);
	ProfilePointsLabel.SetText(PointsLabelText);
	ProfilePointsLabel.SetFont(F_Normal);
	ControlTop += ControlHeight;	

	// Level
	ProfileLevelLabel = UWindowLabelControl(CreateControl(class'UWindowLabelControl', ControlLeft, ControlTop, 150, 20));
	ProfileLevelLabel.SetTextColor(TextColor);
	ProfileLevelLabel.SetText("");
	ProfileLevelLabel.SetFont(F_Normal);
	ControlTop += ControlHeight;	

	// Events
	ProfileEventsLabel = UWindowLabelControl(CreateControl(class'UWindowLabelControl', ControlLeft, ControlTop, 150, 20));
	ProfileEventsLabel.SetTextColor(TextColor);
	ProfileEventsLabel.SetText(EventsLabelText);
	ProfileEventsLabel.SetFont(F_Normal);

	// Previous Profile Button
	PrevButton = NerfButtonControl(CreateControl(class'NerfButtonControl', 1, 150, 32, 24));
	PrevButton.UpTexture   = texture'Previous';
	PrevButton.OverTexture = texture'PreviousOver';
	PrevButton.DownTexture = texture'PreviousDown';
	PrevButton.bIgnoreLDoubleclick = True;

	// Next Profile Button
	NextButton = NerfButtonControl(CreateControl(class'NerfButtonControl', 200, 150, 32, 24));
	NextButton.UpTexture   = texture'Next';
	NextButton.OverTexture = texture'NextOver';
	NextButton.DownTexture = texture'NextDown';
	NextButton.bIgnoreLDoubleclick = True;

	// New Game Button
	NewGameButton = NerfButtonControl(CreateControl(class'NerfButtonControl', 222, 50, 32, 32));
	NewGameButton.UpTexture   = texture'NewGame2';
	NewGameButton.OverTexture = texture'NewGameOver2';
	NewGameButton.DownTexture = texture'NewGameDown2';
	NewGameButton.bIgnoreLDoubleclick = True;

	// New Player Button
	NewPlayerButton = NerfButtonControl(CreateControl(class'NerfButtonControl', 222, 85, 32, 32));
	NewPlayerButton.UpTexture   = texture'NewPlayer';
	NewPlayerButton.OverTexture = texture'NewPlayerOver';
	NewPlayerButton.DownTexture = texture'NewPlayerDown';
	NewPlayerButton.bIgnoreLDoubleclick = True;

	// Delete Player Button
	DeletePlayerButton = NerfButtonControl(CreateControl(class'NerfButtonControl', 222, 120, 32, 32));
	DeletePlayerButton.UpTexture   = texture'DeletePlayer';
	DeletePlayerButton.OverTexture = texture'DeletePlayerOver';
	DeletePlayerButton.DownTexture = texture'DeletePlayerDown';
	DeletePlayerButton.bIgnoreLDoubleclick = True;

/*
 *	in case we ever want to internationalize...
 *
	PrevButton.SetText(PrevButtonText);
	PrevButton.SetHelpText(PrevButtonHelp);
	PrevButton.SetFont(F_Normal);
	PrevButton.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
	NextButton.SetText(NextButtonText);
	NextButton.SetHelpText(NextButtonHelp);
	NextButton.SetFont(F_Normal);
	NextButton.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
	NewGameButton.SetText(NewGameButtonText);
	NewGameButton.SetHelpText(NewGameButtonHelp);
	NewGameButton.SetFont(F_Normal);
	NewGameButton.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
	NewPlayerButton.SetText(NewPlayerButtonText);
	NewPlayerButton.SetHelpText(NewPlayerButtonHelp);
	NewPlayerButton.SetFont(F_Normal);
	NewPlayerButton.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
	DeletePlayerButton.SetText(DeletePlayerButtonText);
	DeletePlayerButton.SetHelpText(DeletePlayerButtonHelp);
	DeletePlayerButton.SetFont(F_Normal);
	DeletePlayerButton.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
*/

	// load card with first profile
//	if (pp.FindFirstProfile() > 0)
	pp.StoreCurrentProfile();
	pp.ReadProfileInfo();
	ShowProfileInfo();
}

function ShowProfileInfo()
{
	local string ProfClass;
	local int CompletedEvents;

	// picture
	ProfClass = NerfRootWindow(Root).PDAMainWindow().ClassToPic(pp.InfoClass);
	if (ProfClass != string(None))
		SetCharPicture(ProfClass);
	else
		CharacterPicture = None;

	CompletedEvents = pp.GetCompletions();
	ProfileNameLabel.SetText(NameLabelText $ pp.InfoName);
	ProfileLevelLabel.SetText(NerfRootWindow(Root).PDAMainWindow().LevelDescriptions[pp.InfoLevel]);
	ProfilePointsLabel.SetText(PointsLabelText $ pp.InfoPoints);
//	ProfileEventsLabel.SetText(EventsLabelText $ pp.InfoEvents);
	ProfileEventsLabel.SetText(EventsLabelText $ CompletedEvents);
}

function Notify(UWindowDialogControl C, byte E)
{
	Super.Notify(C, E);

	switch (E)
	{
	case DE_EnterPressed:
		bEscapeClose = False;
		Close();
		break;

	case DE_Click:
		switch (C)
		{
		case PrevButton:
			pp.FindPrevProfile();
			ShowProfileInfo();
			break;

		case NextButton:
			pp.FindNextProfile();
			ShowProfileInfo();
			break;

		case NewGameButton:
			ResetPlayerProfile();
			break;

		case NewPlayerButton:
			NewPlayerProfile();
			break;

		case DeletePlayerButton:
//			ConfirmDelete = NerfMessageBox(ConfirmDeleteTitle, ConfirmDeleteText, MB_YesNo, MR_No);
			DeletePlayerProfile();
			break;

		case GoButton:
			bEscapeClose = False;
			Close();
			break;
		}
		break;
	}
}

function Close(optional bool bByParent)
{
	NerfRootWindow(Root).PDAMainWindow().CardProfileClosed();
	Super.Close(bByParent);
}

function NewPlayerProfile()
{
//	log(class$ " WES: PDA NewPlayerProfile");
	Close();
	NerfRootWindow(Root).PDAMainWindow().ShowNameCard();
}


function DeletePlayerProfile()
{
	pp.DeleteProfile(pp.CurrentProfile);
	ShowProfileInfo();
//	SaveConfig();
//	if (pp.FindNextProfile() > 0)
//		ShowProfileInfo();
//	else
//	{
//		Close();
//		//NerfRootWindow(Root).PDAMainWindow().NewPlayerProfile();
//	}
}

/*
function NerfMessageBoxDone(NerfMessageBox W, MessageBoxResult Result)
{
	if (W == ConfirmDelete)
	{
		ConfirmDelete = None;
		if (Result == MR_Yes)
			DeletePlayerProfile();
	}
}
*/

function ResetPlayerProfile()
{
// FIXME: TODO: add confirm dialog here
	pp.ResetPlayerProfile();
	ShowProfileInfo();
}

defaultproperties
{
     NameLabelText=Name: 
     PointsLabelText=Points: 
     EventsLabelText=Events: 
     ControlLeft=120
     ControlHeight=12
     PrevButtonHelp=Previous Card
     NextButtonHelp=Next Card
     BackgroundSmooth=True
     Title=Pick Your Card
}
