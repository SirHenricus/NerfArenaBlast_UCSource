class NerfCardLevel extends NerfCard;

var byte	SelectedDifficulty;

//
// Components
//

var NerfButtonControl JuniorButton;
var NerfButtonControl AmateurButton;
var NerfButtonControl SuperButton;
var NerfButtonControl MegaButton;
//var localized string LevelButtonHelp[4];

var UWindowLabelControl LevelLabel[4];

var Color	TextColor;
var Color	SelectedTextColor;

var int		ControlLeft;
var int		LevelButtonWidth;
var int		LevelButtonHeight;


function Created() 
{
	local int i;
	local int ControlTop;

	Super.Created();

	TextColor.R = 0;
	TextColor.G = 0;
	TextColor.B = 0;

	SelectedTextColor.R = 255;
	SelectedTextColor.G = 0;
	SelectedTextColor.B = 0;

	//
	// Load the Character Picture
	//
	SetCharPicture(NerfRootWindow(Root).PDAMainWindow().CharPicName[NerfRootWindow(Root).PDAMainWindow().CharIndex]);

	//
	// Create components.
	//
	ControlTop = 87;

	// Level Buttons
	JuniorButton = NerfButtonControl(CreateControl(class'NerfButtonControl', ControlLeft, ControlTop+2, LevelButtonWidth, LevelButtonHeight));
	JuniorButton.UpTexture   = texture'Level';
	JuniorButton.OverTexture = texture'LevelOver';
	JuniorButton.DownTexture = texture'LevelDown';
	JuniorButton.bIgnoreLDoubleclick = True;
	ControlTop += LevelButtonHeight+5;	

	AmateurButton = NerfButtonControl(CreateControl(class'NerfButtonControl', ControlLeft, ControlTop+2, LevelButtonWidth, LevelButtonHeight));
	AmateurButton.UpTexture   = texture'Level';
	AmateurButton.OverTexture = texture'LevelOver';
	AmateurButton.DownTexture = texture'LevelDown';
	AmateurButton.bIgnoreLDoubleclick = True;
	ControlTop += LevelButtonHeight+5;	

	SuperButton = NerfButtonControl(CreateControl(class'NerfButtonControl', ControlLeft, ControlTop+2, LevelButtonWidth, LevelButtonHeight));
	SuperButton.UpTexture   = texture'Level';
	SuperButton.OverTexture = texture'LevelOver';
	SuperButton.DownTexture = texture'LevelDown';
	SuperButton.bIgnoreLDoubleclick = True;
	ControlTop += LevelButtonHeight+5;	

	MegaButton = NerfButtonControl(CreateControl(class'NerfButtonControl', ControlLeft, ControlTop+2, LevelButtonWidth, LevelButtonHeight));
	MegaButton.UpTexture   = texture'Level';
	MegaButton.OverTexture = texture'LevelOver';
	MegaButton.DownTexture = texture'LevelDown';
	MegaButton.bIgnoreLDoubleclick = True;
	ControlTop += LevelButtonHeight+5;	

	// Level Labels
	ControlTop = 87;
	for (i = 0; i < 4; i++)
	{
		LevelLabel[i] = UWindowLabelControl(CreateControl(class'UWindowLabelControl', 133, ControlTop, 100, 20));
		LevelLabel[i].SetTextColor(TextColor);
		LevelLabel[i].SetText(NerfRootWindow(Root).PDAMainWindow().LevelDescriptions[i]);
		LevelLabel[i].SetFont(F_Normal);
		ControlTop += LevelButtonHeight+5;	
	}

	// pre-select amateur button
	SelectedDifficulty = 1;
	AmateurButton.UpTexture   = texture'LevelOver';
}

function BeforePaint(Canvas C, float X, float Y)
{
	LevelLabel[SelectedDifficulty].SetTextColor(SelectedTextColor);
}

function byte GetDifficulty()
{
	if ((SelectedDifficulty < 0) || (SelectedDifficulty > 3))
		SelectedDifficulty = 1;

	return 	SelectedDifficulty;
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
		LevelLabel[0].SetTextColor(TextColor);
		LevelLabel[1].SetTextColor(TextColor);
		LevelLabel[2].SetTextColor(TextColor);
		LevelLabel[3].SetTextColor(TextColor);

		switch (C)
		{
		case JuniorButton:
			LevelLabel[0].SetTextColor(SelectedTextColor);
			JuniorButton.UpTexture = texture'LevelOver';
			AmateurButton.UpTexture = texture'Level';
			SuperButton.UpTexture = texture'Level';
			MegaButton.UpTexture = texture'Level';
			SelectedDifficulty = 0;
			break;

		case AmateurButton:
			LevelLabel[1].SetTextColor(SelectedTextColor);
			JuniorButton.UpTexture = texture'Level';
			AmateurButton.UpTexture = texture'LevelOver';
			SuperButton.UpTexture = texture'Level';
			MegaButton.UpTexture = texture'Level';
			SelectedDifficulty = 1;
			break;

		case SuperButton:
			LevelLabel[2].SetTextColor(SelectedTextColor);
			JuniorButton.UpTexture = texture'Level';
			AmateurButton.UpTexture = texture'Level';
			SuperButton.UpTexture = texture'LevelOver';
			MegaButton.UpTexture = texture'Level';
			SelectedDifficulty = 2;
			break;

		case MegaButton:
			LevelLabel[3].SetTextColor(SelectedTextColor);
			JuniorButton.UpTexture = texture'Level';
			AmateurButton.UpTexture = texture'Level';
			SuperButton.UpTexture = texture'Level';
			MegaButton.UpTexture = texture'LevelOver';
			SelectedDifficulty = 3;
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
	NerfRootWindow(Root).PDAMainWindow().CardLevelClosed();
	Super.Close(bByParent);
}

defaultproperties
{
     ControlLeft=113
     LevelButtonWidth=13
     LevelButtonHeight=8
     BackgroundSmooth=True
     Title=Choose Level of Difficulty
}
