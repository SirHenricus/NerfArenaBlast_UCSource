class NerfMessageBox extends NerfWindow;

var float TimeOutTime;
var int TimeOut;
var int FrameCount;

var MessageBoxButtons Buttons;
var MessageBoxResult Result;
var MessageBoxResult EnterResult;

// Background
var() bool BackgroundSmooth;
var() string BackgroundName;
var texture Background;

//
// Components
//

// Window Title
var UWindowLabelControl TitleLabel;

// Yes Button
var NerfButtonControl YesButton;
var localized string YesButtonText;
var localized string YesButtonHelp;

// No Button
var NerfButtonControl NoButton;
var localized string NoButtonText;
var localized string NoButtonHelp;

// Ok Button
var NerfButtonControl OkButton;
var localized string OkButtonText;
var localized string OkButtonHelp;

// Cancel Button
var NerfButtonControl CancelButton;
var localized string CancelButtonText;
var localized string CancelButtonHelp;

var UWindowHTMLTextArea MessageTextArea;

function Created() 
{
	local Color TitleColor, TextColor, LinkColor, ALinkColor;

	Super.Created();

	TitleColor.R = 200;
	TitleColor.G = 200;
	TitleColor.B = 200;

	TextColor.R = 0;
	TextColor.G = 0;
	TextColor.B = 0;

	LinkColor.R = 255;
	LinkColor.G = 0;
	LinkColor.B = 0;

	ALinkColor.R = 255;
	ALinkColor.G = 255;
	ALinkColor.B = 0;

	WinWidth = 242;
	WinHeight = 125;

	// Center Window
	CenterWindow();

	//
	// Load the background.
	//

	Background = Texture(DynamicLoadObject(BackgroundName, Class'Texture'));

	//
	// Create components.
	//

	// Card Title
	TitleLabel = UWindowLabelControl(CreateControl(class'UWindowLabelControl', 25, 12, 130, 20));
	TitleLabel.SetTextColor(TitleColor);

	// Message Text
	MessageTextArea = UWindowHTMLTextArea(CreateControl(class'UWindowHTMLTextArea', 20, 35, WinWidth-50, WinHeight-70));
	MessageTextArea.SetTextColor(TextColor);
	MessageTextArea.bTopCentric = True;
	MessageTextArea.bVCenter = True;
	MessageTextArea.bAutoScrollbar = True;
	MessageTextArea.SetFont(F_Normal);
	MessageTextArea.TextColor = TextColor;
	MessageTextArea.LinkColor = LinkColor;
	MessageTextArea.ALinkColor = ALinkColor;

	bAcceptsFocus = True;			// allow key input for return key detection

	NerfRootWindow(Root).PDAMainWindow().EnablePDA(False);
}

function SetupMessageBox(string Title, string Message, MessageBoxButtons InButtons, MessageBoxResult InESCResult, optional MessageBoxResult InEnterResult, optional int InTimeOut)
{
	if (len(Title) > 25)
	{
		TitleLabel.WinLeft = 15;
		TitleLabel.WinWidth = WinWidth - 30;
		TitleLabel.SetFont(F_Normal);
	}
	else
	{
		TitleLabel.WinLeft = 20;
		TitleLabel.WinWidth = WinWidth - 50;
		TitleLabel.SetFont(F_Bold);
	}
		
	TitleLabel.SetText(Title);
	Buttons = InButtons;
	EnterResult = InEnterResult;
	MessageTextArea.Clear();
	MessageTextArea.AddText(Message);

	// Create buttons
	switch(Buttons)
	{
	case MB_YesNo:
		// Yes Button
		YesButton = NerfButtonControl(CreateCONTROL(class'NerfButtonControl', 28, 90, 58, 28));
		YesButton.UpTexture   = texture'Yes';
		YesButton.OverTexture = texture'YesOver';
		YesButton.DownTexture = texture'YesDown';
		YesButton.bIgnoreLDoubleclick = True;
//		YesButton.SetText(YesButtonText);
//		YesButton.SetHelpText(YesButtonHelp);
//		YesButton.SetFont(F_Normal);
//		YesButton.SetTextColor(TextColor);

		// No Button
		NoButton = NerfButtonControl(CreateCONTROL(class'NerfButtonControl', 127, 90, 58, 28));
		NoButton.UpTexture   = texture'No';
		NoButton.OverTexture = texture'NoOver';
		NoButton.DownTexture = texture'NoDown';
		NoButton.bIgnoreLDoubleclick = True;
//		NoButton.SetText(NoButtonText);
//		NoButton.SetHelpText(NoButtonHelp);
//		NoButton.SetFont(F_Normal);
//		NoButton.SetTextColor(TextColor);
		
//		if (EnterResult == MR_Yes)
//			YesButton.SetFont(F_Bold);
//		else
//			YesButton.SetFont(F_Normal);
		break;

	case MB_OKCancel:
		// Cancel Button
		CancelButton = NerfButtonControl(CreateCONTROL(class'NerfButtonControl', 127, 90, 58, 28));
		CancelButton.UpTexture   = texture'Cancel';
		CancelButton.OverTexture = texture'CancelOver';
		CancelButton.DownTexture = texture'CancelDown';
		CancelButton.bIgnoreLDoubleclick = True;
//		CancelButton.SetText(NoButtonText);
//		CancelButton.SetHelpText(NoButtonHelp);
//		CancelButton.SetFont(F_Normal);
//		CancelButton.SetTextColor(TextColor);
		// (note: no break)

	case MB_OK:
		// Ok Button
		OkButton = NerfButtonControl(CreateCONTROL(class'NerfButtonControl', 28, 90, 58, 28));
		OkButton.UpTexture   = texture'Okay';
		OkButton.OverTexture = texture'OkayOver';
		OkButton.DownTexture = texture'OkayDown';
		OkButton.bIgnoreLDoubleclick = True;
//		OkButton.SetText(YesButtonText);
//		OkButton.SetHelpText(YesButtonHelp);
//		OkButton.SetFont(F_Normal);
//		OkButton.SetTextColor(TextColor);
		
//		if (EnterResult == MR_Yes)
//			YesButton.SetFont(F_Bold);
//		else
//			YesButton.SetFont(F_Normal);
		break;

		// not supported
		break;
	}
	Result = InESCResult;
	TimeOutTime = 0;
	TimeOut = InTimeOut;
	FrameCount = 0;
}

function Notify(UWindowDialogControl C, byte E)
{
	Super.Notify(C, E);

	switch (E)
	{
	case DE_Click:
		switch (C)
		{
		case YesButton:
			Result = MR_Yes;
			Close();
			break;

		case NoButton:
			Result = MR_No;
			Close();
			break;

		case OKButton:
			Result = MR_OK;
			Close();
			break;

		case CancelButton:
			Result = MR_Cancel;
			Close();
			break;
		}
		break;
	}
}

function Close(optional bool bByParent)
{
	NerfRootWindow(Root).PDAMainWindow().EnablePDA(True);
	Super.Close(bByParent);
	NerfWindow(OwnerWindow).NerfMessageBoxDone(Self, Result);
}

function AfterPaint(Canvas C, float X, float Y)
{
	Super.AfterPaint(C, X, Y);

	if (TimeOut != 0)
	{
		FrameCount++;
		
		if (FrameCount >= 5)
		{
			TimeOutTime = GetEntryLevel().TimeSeconds + TimeOut;
			TimeOut = 0;
		}
	}

	if (TimeOutTime != 0 && GetEntryLevel().TimeSeconds > TimeOutTime)
	{
		TimeOutTime = 0;
		Close();
	}
}

function CenterWindow()
{
	WinTop = (ParentWindow.WinHeight-WinHeight)/2;
	WinLeft = (ParentWindow.WinWidth-WinWidth)/2;
}

function KeyDown(int Key, float X, float Y)
{
	if(Key == 0x0D) 
		Close();
	else
		Super.KeyDown(Key, X, Y);
}

function Paint(Canvas C, float X, float Y)
{
	C.bNoSmooth = !BackgroundSmooth;			// note: false causes tiling artifacts (gaps)

	// Draw background
	C.SetPos(0, 0);
	C.DrawIcon(Background, 1.0);
}

defaultproperties
{
     BackgroundName=NerfRes.NerfMessageBoxBack
     YesButtonText=No
     YesButtonHelp=Click here to incicate negative
}
