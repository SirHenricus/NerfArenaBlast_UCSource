class NerfQuitBox extends NerfMessageBox;

var float ByeTimeOutTime;
var int ByeTimeOut;
var int ByeFrameCount;

var NerfButtonControl CreditsButton;
var localized string CreditsButtonText;
var localized string CreditsButtonHelp;

var bool bPlayCredits;
var sound ByeSound;

function Created() 
{
	Super.Created();

	// Credit Button
	CreditsButton = NerfButtonControl(CreateControl(class'NerfButtonControl', 197, 56, 39, 46));
	CreditsButton.UpTexture   = texture'Credits';
	CreditsButton.OverTexture = texture'CreditsOver';
	CreditsButton.DownTexture = texture'CreditsDown';
	CreditsButton.bIgnoreLDoubleclick = True;
//	CreditsButton.SetText(CreditsButtonText);
//	CreditsButton.SetHelpText(CreditsButtonHelp);
//	CreditsButton.SetFont(F_Normal);
//	CreditsButton.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
	bPlayCredits = False;
}

function Notify(UWindowDialogControl C, byte E)
{
	switch (E)
	{
	case DE_Click:
		switch (C)
		{
		case CreditsButton:
			bPlayCredits = True;
		case YesButton:
			GetPlayerOwner().PlaySound(ByeSound, SLOT_Interface);
			Result = MR_Yes;
//			Bye();
			Close();
			return;
		}
	}

	Super.Notify(C, E);
}

function Bye()
{
	ByeTimeOutTime = 0;
	ByeTimeOut = 1;
	ByeFrameCount = 0;
}

function AfterPaint(Canvas C, float X, float Y)
{
	Super.AfterPaint(C, X, Y);

	if (ByeTimeOut != 0)
	{
		ByeFrameCount++;
		
		ByeTimeOutTime = GetEntryLevel().TimeSeconds + ByeTimeOut;
		ByeTimeOut = 0;
	}

	if (ByeTimeOutTime != 0 && GetEntryLevel().TimeSeconds > ByeTimeOutTime)
	{
		ByeTimeOutTime = 0;
		Close();
	}
}

defaultproperties
{
     CreditsButtonText=Credits
     CreditsButtonHelp=Display Credits roll
}
