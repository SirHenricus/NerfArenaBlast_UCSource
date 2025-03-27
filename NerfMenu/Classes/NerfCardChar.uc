class NerfCardChar extends NerfCard;

//
// Components
//
var NerfPlayerProfile pp;


// Previous Button
var NerfButtonControl PrevButton;
var localized string PrevButtonText;
var localized string PrevButtonHelp;

// Next Button
var NerfButtonControl NextButton;
var localized string NextButtonText;
var localized string NextButtonHelp;

var int SelectedChar;

function Created() 
{
	Super.Created();

	//
	// Load the Character Picture
	//
	SetCharPicture(NerfRootWindow(Root).PDAMainWindow().CharPicName[SelectedChar]);
	pp = NerfRootWindow(Root).PDAMainWindow().PlayerProfile;

	//
	// Create components.
	//

	// Previous Character Button
	PrevButton = NerfButtonControl(CreateControl(class'NerfButtonControl', 1, 150, 32, 24));
	PrevButton.UpTexture   = texture'Previous';
	PrevButton.OverTexture = texture'PreviousOver';
	PrevButton.DownTexture = texture'PreviousDown';
	PrevButton.bIgnoreLDoubleclick = True;
//	PrevButton.SetText(PrevButtonText);
//	PrevButton.SetHelpText(PrevButtonHelp);
//	PrevButton.SetFont(F_Normal);
//	PrevButton.SetTextColor(NerfRootWindow(Root).DefaultTextColor);

	// Next Character Button
	NextButton = NerfButtonControl(CreateControl(class'NerfButtonControl', 200, 150, 32, 24));
	NextButton.UpTexture   = texture'Next';
	NextButton.OverTexture = texture'NextOver';
	NextButton.DownTexture = texture'NextDown';
	NextButton.bIgnoreLDoubleclick = True;
//	NextButton.SetText(NextButtonText);
//	NextButton.SetHelpText(NextButtonHelp);
//	NextButton.SetFont(F_Normal);
//	NextButton.SetTextColor(NerfRootWindow(Root).DefaultTextColor);
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
			SelectedChar--;
			if (SelectedChar < 0)
				SelectedChar = 3;
			SetCharPicIndex(SelectedChar);
			break;

		case NextButton:
			SelectedChar++;
			if (SelectedChar > 3)
				SelectedChar = 0;
			SetCharPicIndex(SelectedChar);
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
	pp.CurrentProfile = SelectedChar + 1;
	pp.ReadProfile(pp.CurrentProfile);
	pp.ReadProfileInfo();
	NerfRootWindow(Root).PDAMainWindow().CardCharClosed();
	Super.Close(bByParent);
}

function int GetChar()
{
	return SelectedChar;
}

function string GetClass()
{
	return NerfRootWindow(Root).PDAMainWindow().CharClass[SelectedChar];
}

defaultproperties
{
     PrevButtonHelp=Previous Character
     NextButtonHelp=Next Character
     BackgroundSmooth=True
     Title=Choose Your Character
}
