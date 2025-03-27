class NerfPDAScreenGeneral extends NerfWindow;

var bool Initialized;
var bool Changed;
var bool DontToggle;

//
// Components
//

// Video Driver
var UWindowLabelControl VideoLabel;
var localized string VideoLabelText;

/*
var NerfMessageBox ConfirmSettings;
var localized string ConfirmSettingsTitle;
var localized string ConfirmSettingsText;
var localized string ConfirmSettingsCancelTitle;
var localized string ConfirmSettingsCancelText;
var localized string ConfirmDriverTitle;
var localized string ConfirmDriverText;
var NerfMessageBox ConfirmDriver;
*/

var string OldSettings;

var NerfButtonControl VideoButton;
var UWindowLabelControl DriverDesc;
var localized string VideoButtonHelp;

// Brightness
var NerfSliderControl BrightnessSlider;
var localized string BrightnessText;
var localized string BrightnessHelp;

// Fullscreen Mode
var bool FullScreenMode;
var UWindowLabelControl FSLabel;
var localized string FSLabelText;

var NerfButtonControl FSOnButton;
var localized string FSOnButtonText;
var localized string FSOnButtonHelp;

var NerfButtonControl FSOffButton;
var localized string FSOffButtonText;
var localized string FSOffButtonHelp;

// Resolution
var NerfSelectorControl ResolutionSelector;
var localized string ResolutionText;
var localized string ResolutionHelp;
var bool bResReady;

// Texture Detail
var NerfSelectorControl TextureDetailSelector;
var localized string TextureDetailText;
var localized string TextureDetailHelp;
var localized string Details[3];

// Music Volume
var NerfSliderControl MusicVolumeSlider;
var localized string MusicVolumeText;
var localized string MusicVolumeHelp;

// Sound Volume
var NerfSliderControl SoundVolumeSlider;
var localized string SoundVolumeText;
var localized string SoundVolumeHelp;

// Sound Quality
var bool HighSoundQuality;
var UWindowLabelControl SoundQualityLabel;
var localized string SoundQualityLabelText;

var NerfButtonControl SoundQualityHighButton;
var localized string SoundQualityHighButtonText;
var localized string SoundQualityHighButtonHelp;

var NerfButtonControl SoundQualityLowButton;
var localized string SoundQualityLowButtonText;
var localized string SoundQualityLowButtonHelp;

// Advanced Button
var UWindowLabelControl AdvancedLabel;
var localized string AdvancedLabelText;

var NerfButtonControl AdvancedButton;
var localized string AdvancedButtonText;
var localized string AdvancedButtonHelp;

// Skin Detail
var NerfSelectorControl SkinDetailSelector;
var localized string SkinDetailText;
var localized string SkinDetailHelp;

// Mouse Speed
var NerfSliderControl MouseSlider;
var localized string MouseText;
var localized string MouseHelp;

var int ControlHeight;

function Created()
{
	local int ControlWidth, ControlLeft;
	local int ControlTop;

	local float Brightness;
	local int SoundVolume;
	local int MusicVolume;

	Initialized = False;
	DontToggle = False;

	Super.Created();

	ControlWidth = WinWidth - 20;
	ControlLeft = 10;
	ControlTop = 0;

	//
	// Create components.
	//

	//
	// Video
	//
	// label
	VideoLabel = UWindowLabelControl(CreateControl(class'UWindowLabelControl', ControlLeft, ControlTop + 4, ControlWidth/2, 20));
	VideoLabel.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
	VideoLabel.SetText(VideoLabelText);
	VideoLabel.SetFont(F_Normal);

	// Change Video Button
	VideoButton = NerfButtonControl(CreateCONTROL(class'NerfButtonControl', WinWidth - 155, ControlTop, 145, ControlHeight));
	VideoButton.UpTexture   = texture'ButtonOff';
	VideoButton.OverTexture = texture'ButtonOn';
	VideoButton.DownTexture = texture'ButtonDown';
	VideoButton.bIgnoreLDoubleclick = True;
	SetVideoDriver();
	VideoButton.SetHelpText(VideoButtonHelp);
	VideoButton.SetFont(F_Normal);
	VideoButton.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
	ControlTop += ControlHeight+4;

	// Brightness
	BrightnessSlider = NerfSliderControl(CreateControl(class'NerfSliderControl', ControlLeft, ControlTop, ControlWidth, 1));
	BrightnessSlider.bNoSlidingNotify = True;
	BrightnessSlider.SetRange(2, 10, 1);
	Brightness = int(float(GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.ViewportManager Brightness")) * 10);
	BrightnessSlider.SetValue(Brightness);
	BrightnessSlider.SetText(BrightnessText);
	BrightnessSlider.SetHelpText(BrightnessHelp);
	BrightnessSlider.SetFont(F_Normal);
	BrightnessSlider.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
	ControlTop += ControlHeight+2;
		
	//
	// Fullscreen mode
	//

	// label
	FSLabel = UWindowLabelControl(CreateControl(class'UWindowLabelControl', ControlLeft, ControlTop + 5, ControlWidth/2, 20));
	FSLabel.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
	FSLabel.SetText(FSLabelText);
	FSLabel.SetFont(F_Normal);

	// Fullscreen mode ON button
	FSOnButton = NerfButtonControl(CreateCONTROL(class'NerfButtonControl', WinWidth - 155, ControlTop, 70, ControlHeight));
	FSOnButton.bIgnoreLDoubleclick = True;
	FSOnButton.SetText(FSOnButtonText);
	FSOnButton.SetHelpText(FSOnButtonHelp);
	FSOnButton.SetFont(F_Normal);
	FSOnButton.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);

	// Fullscreen mode OFF button
	FSOffButton = NerfButtonControl(CreateCONTROL(class'NerfButtonControl', WinWidth - 80, ControlTop, 70, ControlHeight));
	FSOffButton.bIgnoreLDoubleclick = True;
	FSOffButton.SetText(FSOffButtonText);
	FSOffButton.SetHelpText(FSOffButtonHelp);
	FSOffButton.SetFont(F_Normal);
	FSOffButton.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
	SetFullScreenMode(!IsWindowedMode());
	ControlTop += ControlHeight+5;

	// Resolution
	ResolutionSelector = NerfSelectorControl(CreateControl(class'NerfSelectorControl', ControlLeft, ControlTop, ControlWidth, ControlHeight));
	ResolutionSelector.SetText(ResolutionText);
	ResolutionSelector.SetHelpText(ResolutionHelp);
	ResolutionSelector.SetFont(F_Normal);
	ResolutionSelector.SetEditable(False);
	ResolutionSelector.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
	ResolutionSelector.EditBox.WinWidth /= 2;
	SetAvailableResolutions();
	bResReady = True;
	ControlTop += ControlHeight+6;

	// Texture Detail
	TextureDetailSelector = NerfSelectorControl(CreateControl(class'NerfSelectorControl', ControlLeft, ControlTop, ControlWidth, ControlHeight));
	TextureDetailSelector.SetText(TextureDetailText);
	TextureDetailSelector.SetHelpText(TextureDetailHelp);
	TextureDetailSelector.SetFont(F_Normal);
	TextureDetailSelector.SetEditable(False);
	TextureDetailSelector.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
	ControlTop += ControlHeight+5;

	// The display names are localized.  These strings match the enums in UnCamMgr.cpp.
	TextureDetailSelector.AddItem(Details[0], "High");
	TextureDetailSelector.AddItem(Details[1], "Medium");
	TextureDetailSelector.AddItem(Details[2], "Low");
	TextureDetailSelector.SetSelectedIndex(Max(0, TextureDetailSelector.FindItemIndex2(GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.ViewportManager TextureDetail"))));

	// Music Volume
	MusicVolumeSlider = NerfSliderControl(CreateControl(class'NerfSliderControl', ControlLeft, ControlTop, ControlWidth, 1));
	MusicVolumeSlider.bNoSlidingNotify = False;
	MusicVolumeSlider.SetRange(0, 255, 1);
	MusicVolume = int(GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.AudioDevice MusicVolume"));
	MusicVolumeSlider.SetValue(MusicVolume);
	MusicVolumeSlider.SetText(MusicVolumeText);
	MusicVolumeSlider.SetHelpText(MusicVolumeHelp);
	MusicVolumeSlider.SetFont(F_Normal);
	MusicVolumeSlider.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
	ControlTop += ControlHeight;
		
	// Sound Volume
	SoundVolumeSlider = NerfSliderControl(CreateControl(class'NerfSliderControl', ControlLeft, ControlTop, ControlWidth, 1));
	SoundVolumeSlider.bNoSlidingNotify = False;
	SoundVolumeSlider.SetRange(0, 255, 1);
	SoundVolume = int(GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.AudioDevice SoundVolume"));
	SoundVolumeSlider.SetValue(SoundVolume);
	SoundVolumeSlider.SetText(SoundVolumeText);
	SoundVolumeSlider.SetHelpText(SoundVolumeHelp);
	SoundVolumeSlider.SetFont(F_Normal);
	SoundVolumeSlider.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
	ControlTop += ControlHeight;

	//
	// Sound Quality
	//

	// label
	SoundQualityLabel = UWindowLabelControl(CreateControl(class'UWindowLabelControl', ControlLeft, ControlTop + 5, ControlWidth/2, 20));
	SoundQualityLabel.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
	SoundQualityLabel.SetText(SoundQualityLabelText);
	SoundQualityLabel.SetFont(F_Normal);

	// Sound Quality HIGH Button
	SoundQualityHighButton = NerfButtonControl(CreateCONTROL(class'NerfButtonControl', WinWidth - 155, ControlTop, 70, ControlHeight));
	SoundQualityHighButton.UpTexture   = texture'ButtonOn';
	SoundQualityHighButton.OverTexture = texture'ButtonOn';
	SoundQualityHighButton.DownTexture = texture'ButtonDown';
	SoundQualityHighButton.bIgnoreLDoubleclick = True;
	SoundQualityHighButton.SetText(SoundQualityHighButtonText);
	SoundQualityHighButton.SetHelpText(SoundQualityHighButtonHelp);
	SoundQualityHighButton.SetFont(F_Normal);
	SoundQualityHighButton.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);

	// Sound Quality LOW Button
	SoundQualityLowButton = NerfButtonControl(CreateCONTROL(class'NerfButtonControl', WinWidth - 80, ControlTop, 70, ControlHeight));
	SoundQualityLowButton.UpTexture   = texture'ButtonOff';
	SoundQualityLowButton.OverTexture = texture'ButtonOver';
	SoundQualityLowButton.DownTexture = texture'ButtonDown';
	SoundQualityLowButton.bIgnoreLDoubleclick = True;
	SoundQualityLowButton.SetText(SoundQualityLowButtonText);
	SoundQualityLowButton.SetHelpText(SoundQualityLowButtonHelp);
	SoundQualityLowButton.SetFont(F_Normal);
	SoundQualityLowButton.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);

	SetHighSoundQuality(!bool(GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.AudioDevice LowSoundQuality")));
	ControlTop += ControlHeight+5;
		
	// Skin Detail
	SkinDetailSelector = NerfSelectorControl(CreateControl(class'NerfSelectorControl', ControlLeft, ControlTop, ControlWidth, 1));
	SkinDetailSelector.SetText(SkinDetailText);
	SkinDetailSelector.SetHelpText(SkinDetailHelp);
	SkinDetailSelector.SetFont(F_Normal);
	SkinDetailSelector.SetEditable(False);
	SkinDetailSelector.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
	SkinDetailSelector.SetEditable(False);
	SkinDetailSelector.AddItem(Details[0], "High");
	SkinDetailSelector.AddItem(Details[1], "Medium");
	SkinDetailSelector.AddItem(Details[2], "Low");
	SkinDetailSelector.SetSelectedIndex(Max(0, SkinDetailSelector.FindItemIndex2(GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.ViewportManager SkinDetail"))));
	ControlTop += ControlHeight+2;

	// Mouse sensitivity slider
	MouseSlider = NerfSliderControl(CreateControl(class'NerfSliderControl', ControlLeft, ControlTop, ControlWidth, 1));
	MouseSlider.bNoSlidingNotify = True;
	MouseSlider.SetRange(40, 150, 5);
	MouseSlider.SetValue(Root.Console.MouseScale * 100);
	MouseSlider.SetText(MouseText);
	MouseSlider.SetHelpText(MouseHelp);
	MouseSlider.SetFont(F_Normal);
	MouseSlider.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
	ControlTop += ControlHeight;

	//
	// Advanced Options
	//

	// label
	AdvancedLabel = UWindowLabelControl(CreateControl(class'UWindowLabelControl', ControlLeft, ControlTop + 5, ControlWidth/2, 20));
	AdvancedLabel.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
	AdvancedLabel.SetText(AdvancedLabelText);
	AdvancedLabel.SetFont(F_Normal);

	// Advanced options button
	AdvancedButton = NerfButtonControl(CreateCONTROL(class'NerfButtonControl', WinWidth - 115, ControlTop, 71, ControlHeight));
	AdvancedButton.UpTexture   = texture'ButtonOff';
	AdvancedButton.OverTexture = texture'ButtonOver';
	AdvancedButton.DownTexture = texture'ButtonDown';
	AdvancedButton.bIgnoreLDoubleclick = True;
	AdvancedButton.SetText(AdvancedButtonText);
	AdvancedButton.SetHelpText(AdvancedButtonHelp);
	AdvancedButton.SetFont(F_Normal);
	AdvancedButton.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
	ControlTop += ControlHeight;

	Initialized = True;
}

function Notify(UWindowDialogControl C, byte E)
{
	if (!Initialized)
		return;

	Super.Notify(C, E);

	switch (E)
	{
	case DE_Click:
		switch (C)
		{
		case VideoButton:
			DriverChange();
			break;

		case FSOnButton:
			SetFullScreenMode(True);
			break;

		case FSOffButton:
			SetFullScreenMode(False);
			break;

		case SoundQualityHighButton:
			SetHighSoundQuality(True);
			break;

		case SoundQualityLowButton:
			SetHighSoundQuality(False);
			break;

		case AdvancedButton:
			GetPlayerOwner().ConsoleCommand("PREFERENCES");
			break;
		}
		break;
	case DE_Change:
		switch (C)
		{
		case BrightnessSlider:
			GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.ViewportManager Brightness "$(BrightnessSlider.Value / 10));
			GetPlayerOwner().ConsoleCommand("FLUSH");
			break;

		case ResolutionSelector:
			if (bResReady) GetPlayerOwner().ConsoleCommand("SetRes "$ResolutionSelector.GetValue());
			SettingsChanged();
			break;

		case TextureDetailSelector:
			GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.ViewportManager TextureDetail " $ TextureDetailSelector.GetValue2());
			break;

		case MusicVolumeSlider:
			GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.AudioDevice MusicVolume " $ MusicVolumeSlider.Value);
			break;

		case SoundVolumeSlider:
			GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.AudioDevice SoundVolume " $ SoundVolumeSlider.Value);
			break;

		case SkinDetailSelector:
			GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.ViewportManager SkinDetail " $ SkinDetailSelector.GetValue2());
			break;

		case MouseSlider:
			MouseChanged();
			break;
		}
		break;
	}
}

function SetVideoDriver()
{
	local int i;
	local string VideoDriverClassName, ClassLeft, ClassRight, VideoDriverDesc;

	VideoDriverClassName = GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.GameRenderDevice Class");
	i = InStr(VideoDriverClassName, "'");
	// Get class name from class'...'
	if(i != -1)
	{
		VideoDriverClassName = Mid(VideoDriverClassName, i+1);
		i = InStr(VideoDriverClassName, "'");
		VideoDriverClassName = Left(VideoDriverClassName, i);
		ClassLeft = Left(VideoDriverClassName, InStr(VideoDriverClassName, "."));
		ClassRight = Mid(VideoDriverClassName, InStr(VideoDriverClassName, ".") + 1);
		VideoDriverDesc = Localize(ClassRight, "ClassCaption", ClassLeft);
	}
	else
		VideoDriverDesc = "(" $ VideoDriverClassName $ ")";

	VideoButton.SetText(VideoDriverDesc);
}

//
// Message handlers
//

function SetAvailableResolutions()
{
	local int ResNum, P;
	local string CurrentRes;
	local string AvailableRes;
	local string ParseString, ThisRes;

	AvailableRes = GetPlayerOwner().ConsoleCommand("GetRes");
	CurrentRes = GetPlayerOwner().ConsoleCommand("GetCurrentRes");	
	ResNum = 0;
	ParseString = AvailableRes;
	P = InStr(ParseString, " ");
	while (P != -1) 
	{
		ThisRes = Left(ParseString, P);
		if (ThisRes != "320x200")
		{
			ResolutionSelector.AddItem(ThisRes);
			if (ThisRes ~= CurrentRes)
				ResolutionSelector.SetSelectedIndex(ResNum);
			ResNum++;
		}
		ParseString = Right(ParseString, Len(ParseString) - P - 1);
		P = InStr(ParseString, " ");
	}
	ResolutionSelector.AddItem(ParseString);
	if (ParseString ~= CurrentRes)
		ResolutionSelector.SetSelectedIndex(ResNum);
}

function LoadAvailableSettings()
{
	local float Brightness;
	local int P;
	local string CurrentDepth;
	local string ParseString, ThisRes;

	// Load available video drivers and current video driver here.
	Initialized = False;

	ResolutionSelector.Clear();
	ParseString = GetPlayerOwner().ConsoleCommand("GetRes");
	P = InStr(ParseString, " ");
	while (P != -1) 
	{
		ThisRes = Left(ParseString, P);
		if (ThisRes != "320x200")
			ResolutionSelector.AddItem(ThisRes);
		ParseString = Mid(ParseString, P+1);
		P = InStr(ParseString, " ");
	}
	ResolutionSelector.AddItem(ParseString);
	ResolutionSelector.SetValue(GetPlayerOwner().ConsoleCommand("GetCurrentRes"));

/*
	ColorDepthCombo.Clear();
	ParseString = GetPlayerOwner().ConsoleCommand("GetColorDepths");
	P = InStr(ParseString, " ");
	while (P != -1) 
	{
		ColorDepthCombo.AddItem(Left(ParseString, P)@BitsText, Left(ParseString, P));
		ParseString = Mid(ParseString, P+1);
		P = InStr(ParseString, " ");
	}
	ColorDepthCombo.AddItem(ParseString@BitsText, ParseString);
	CurrentDepth = GetPlayerOwner().ConsoleCommand("GetCurrentColorDepth");
	ColorDepthCombo.SetValue(CurrentDepth@BitsText, CurrentDepth);
*/
	Initialized = True;
}

function SettingsChanged()
{
	local string NewSettings;

	if (Initialized)
	{
		OldSettings = GetPlayerOwner().ConsoleCommand("GetCurrentRes");
			//$"x"$GetPlayerOwner().ConsoleCommand("GetCurrentColorDepth");
		NewSettings = ResolutionSelector.GetValue();
			//$"x"$ColorDepthCombo.GetValue2();

		if (NewSettings != OldSettings)
		{
			GetPlayerOwner().ConsoleCommand("SetRes "$NewSettings);
			LoadAvailableSettings();
//			ConfirmSettings = NerfMessageBox(ConfirmSettingsTitle, ConfirmSettingsText, MB_YesNo, MR_No, MR_None, 10);
		}
	}
}

function DriverChange()
{
//	ConfirmDriver = NerfMessageBox(ConfirmDriverTitle, ConfirmDriverText, MB_YesNo, MR_No);
	GetParent(class'UWindowFramedWindow').Close();
	Root.Console.CloseUWindow();
	GetPlayerOwner().ConsoleCommand("RELAUNCH -changevideo");
}

/*
function NerfMessageBoxDone(NerfMessageBox W, MessageBoxResult Result)
{
	if (W == ConfirmSettings)
	{
		ConfirmSettings = None;
		if (Result != MR_Yes)
		{
			GetPlayerOwner().ConsoleCommand("SetRes "$OldSettings);
			LoadAvailableSettings();			
			//NerfMessageBox(ConfirmSettingsCancelTitle, ConfirmSettingsCancelText, MB_OK, MR_OK, MR_OK);
		}
	}
	else
	if (W == ConfirmDriver)
	{
		ConfirmDriver = None;
		if (Result == MR_Yes)
		{
			GetParent(class'UWindowFramedWindow').Close();
			Root.Console.CloseUWindow();
			GetPlayerOwner().ConsoleCommand("RELAUNCH -changevideo");
		}
	}
}
*/

function bool IsWindowedMode()
{
	return (GetPlayerOwner().ConsoleCommand("GetRes") ~= "320x240 400x300 512x384 640x480 800x600");
}

function ResolutionChanged(float W, float H)
{
	Super.ResolutionChanged(W, H);

	DontToggle = True;
	SetFullScreenMode(!IsWindowedMode());
	DontToggle = False;
}
	
function SetFullScreenMode(bool yn)
{
	if (Initialized && yn == FullScreenMode)
		return;

	if (yn)
	{
		ButtonDown(FSOnButton);
		ButtonUp(FSOffButton);
		GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.ViewportManager StartupFullscreen True");
	}
	else
	{
		ButtonDown(FSOffButton);
		ButtonUp(FSOnButton);
		GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.ViewportManager StartupFullscreen False");
	}

	FullScreenMode = yn;
	if (Initialized && !DontToggle)
	{
		GetPlayerOwner().ConsoleCommand("TOGGLEFULLSCREEN");
		Changed = True;
	}

	if (ResolutionSelector != None)
	{
		ResolutionSelector.Clear();
		SetAvailableResolutions();
	}

	SetVideoDriver();
}

function SetHighSoundQuality(bool yn)
{
	if (Initialized && yn == HighSoundQuality)
		return;

	if (yn)
	{
		ButtonDown(SoundQualityHighButton);
		ButtonUp(SoundQualityLowButton);
	}
	else
	{
		ButtonDown(SoundQualityLowButton);
		ButtonUp(SoundQualityHighButton);
	}

	HighSoundQuality = yn;
	if (Initialized)
	{
		GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.AudioDevice LowSoundQuality " $ int(!HighSoundQuality));
		Changed = True;
	}
}

function MouseChanged()
{
	Root.Console.MouseScale = (MouseSlider.Value / 100);
	Root.Console.SaveConfig();
}

function SaveConfigs()
{
	GetPlayerOwner().SaveConfig();
	Root.Console.SaveConfig();
	Super.SaveConfigs();
}

defaultproperties
{
     VideoLabelText=Video Driver
     VideoButtonHelp=Press this button to change your video driver.
     BrightnessText=Brightness
     BrightnessHelp=Adjust display brightness.
     FSLabelText=Screen Mode
     FSOnButtonText=FULLSCREEN
     FSOnButtonHelp=Play Nerf in Full-Screen mode.
     FSOffButtonText=WINDOWED
     FSOffButtonHelp=Turn off Full-Screen mode and play Nerf in a window.  NOT COMPATIBLE WITH GLIDE.
     ResolutionText=Resolution
     ResolutionHelp=Select a new screen color-depth.
     TextureDetailText=World Texture Detail
     TextureDetailHelp=Change the texture detail of world geometry.  Use a lower texture detail to improve game performance.
     Details(0)=High
     Details(1)=Medium
     Details(2)=Low
     MusicVolumeText=Music Volume
     MusicVolumeHelp=Adjust volume of music in the game
     SoundVolumeText=Sound Volume
     SoundVolumeHelp=Adjust volume of sound in the game
     SoundQualityLabelText=Sound Quality
     SoundQualityHighButtonText=HIGH
     SoundQualityHighButtonHelp=Enables high-quality sound.  MMX or better CPU recommended.
     SoundQualityLowButtonText=LOW
     SoundQualityLowButtonHelp=Sets sound quality to low.  Better for low-end machines.
     AdvancedLabelText=Advanced Options
     AdvancedButtonText=Advanced
     AdvancedButtonHelp=Display Advanced options.  Experts only!
     SkinDetailText=Skin Detail
     SkinDetailHelp=Change the detail of player skins.  Use a lower skin detail to improve game performance.
     MouseText=GUI Mouse Speed
     MouseHelp=Adjust the speed of the mouse in the User Interface.
     ControlHeight=15
}
