class NerfPDAScreenControlsOther extends NerfWindow;

var bool Initialized;
var bool Changed;

//
// Controls
//

// Joystick Enable
var bool JoystickEnabled;
var UWindowLabelControl JoystickLabel;
var localized string JoystickLabelText;

var NerfButtonControl EnableJoystickButton;
var localized string EnableJoystickButtonText;
var localized string EnableJoystickButtonHelp;

var NerfButtonControl DisableJoystickButton;
var localized string DisableJoystickButtonText;
var localized string DisableJoystickButtonHelp;

// Mouse Sensitivity
var NerfSliderControl MouseSensitivitySlider;
var localized string MouseSensitivityText;
var localized string MouseSensitivityHelp;

// Invert Mouse
var bool InvertMouse;
var UWindowLabelControl InvertMouseLabel;
var localized string InvertMouseLabelText;

var NerfButtonControl InvertMouseOnButton;
var localized string InvertMouseOnButtonText;
var localized string InvertMouseOnButtonHelp;

var NerfButtonControl InvertMouseOffButton;
var localized string InvertMouseOffButtonText;
var localized string InvertMouseOffButtonHelp;

// Mouse Look
var bool MouseLook;
var UWindowLabelControl MouseLookLabel;
var localized string MouseLookLabelText;

var NerfButtonControl MouseLookOnButton;
var localized string MouseLookOnButtonText;
var localized string MouseLookOnButtonHelp;

var NerfButtonControl MouseLookOffButton;
var localized string MouseLookOffButtonText;
var localized string MouseLookOffButtonHelp;

// Auto Weapon Switch
var bool WeaponSwitch;
var UWindowLabelControl WeaponSwitchLabel;
var localized string WeaponSwitchLabelText;

var NerfButtonControl WeaponSwitchOnButton;
var localized string WeaponSwitchOnButtonText;
var localized string WeaponSwitchOnButtonHelp;

var NerfButtonControl WeaponSwitchOffButton;
var localized string WeaponSwitchOffButtonText;
var localized string WeaponSwitchOffButtonHelp;


function Created() 
{
	local int ControlWidth, ControlLeft;
	local int ControlTop;

	Initialized = False;

	Super.Created();

	if (NerfRootWindow(Root).bPDALowRes)
		ControlWidth = WinWidth - 20;
	else
		ControlWidth = WinWidth - 10;

	ControlLeft = 0;
	ControlTop = 50;

	//
	// Joystick Enable
	//

	// label
	JoystickLabel = UWindowLabelControl(CreateControl(class'UWindowLabelControl', ControlLeft, ControlTop + 5, ControlWidth/2, 20));
	JoystickLabel.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
	JoystickLabel.SetText(JoystickLabelText);
	JoystickLabel.SetFont(F_Normal);

	// Joystick Enable Button
	EnableJoystickButton = NerfButtonControl(CreateCONTROL(class'NerfButtonControl', WinWidth - 160, ControlTop, 71, 20));
	EnableJoystickButton.bIgnoreLDoubleclick = True;
	EnableJoystickButton.SetText(EnableJoystickButtonText);
	EnableJoystickButton.SetHelpText(EnableJoystickButtonHelp);
	EnableJoystickButton.SetFont(F_Normal);
	EnableJoystickButton.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);

	// Joystick Disable Button
	DisableJoystickButton = NerfButtonControl(CreateCONTROL(class'NerfButtonControl', WinWidth - 80, ControlTop, 71, 20));
	DisableJoystickButton.bIgnoreLDoubleclick = True;
	DisableJoystickButton.SetText(DisableJoystickButtonText);
	DisableJoystickButton.SetHelpText(DisableJoystickButtonHelp);
	DisableJoystickButton.SetFont(F_Normal);
	DisableJoystickButton.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
	SetEnableJoystick(bool(GetPlayerOwner().ConsoleCommand("get windrv.windowsclient usejoystick")));
	ControlTop += 25;

	//
	// Mouse Sensitivity
	//
	MouseSensitivitySlider = NerfSliderControl(CreateControl(class'NerfSliderControl', ControlLeft, ControlTop, ControlWidth, 1));
	MouseSensitivitySlider.bNoSlidingNotify = True;
	MouseSensitivitySlider.SetRange(1, 12, 1);
	MouseSensitivitySlider.SetValue(GetPlayerOwner().MouseSensitivity);
	MouseSensitivitySlider.SetText(MouseSensitivityText);
	MouseSensitivitySlider.SetHelpText(MouseSensitivityHelp);
	MouseSensitivitySlider.SetFont(F_Normal);
	MouseSensitivitySlider.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
	ControlTop += 20;
		
	//
	// Invert Mouse
	//

	// label
	InvertMouseLabel = UWindowLabelControl(CreateControl(class'UWindowLabelControl', ControlLeft, ControlTop + 5, ControlWidth/2, 20));
	InvertMouseLabel.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
	InvertMouseLabel.SetText(InvertMouseLabelText);
	InvertMouseLabel.SetFont(F_Normal);

	// Invert Mouse ON Button
	InvertMouseOnButton = NerfButtonControl(CreateCONTROL(class'NerfButtonControl', WinWidth - 160, ControlTop, 71, 20));
	InvertMouseOnButton.bIgnoreLDoubleclick = True;
	InvertMouseOnButton.SetText(InvertMouseOnButtonText);
	InvertMouseOnButton.SetHelpText(InvertMouseOnButtonHelp);
	InvertMouseOnButton.SetFont(F_Normal);
	InvertMouseOnButton.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);

	// Invert Mouse OFF Button
	InvertMouseOffButton = NerfButtonControl(CreateCONTROL(class'NerfButtonControl', WinWidth - 80, ControlTop, 71, 20));
	InvertMouseOffButton.bIgnoreLDoubleclick = True;
	InvertMouseOffButton.SetText(InvertMouseOffButtonText);
	InvertMouseOffButton.SetHelpText(InvertMouseOffButtonHelp);
	InvertMouseOffButton.SetFont(F_Normal);
	InvertMouseOffButton.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
	SetInvertMouse(GetPlayerOwner().bInvertMouse);
	ControlTop += 25;

	//
	// Always Mouse Look
	//

	// label
	MouseLookLabel = UWindowLabelControl(CreateControl(class'UWindowLabelControl', ControlLeft, ControlTop + 5, ControlWidth/2, 20));
	MouseLookLabel.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
	MouseLookLabel.SetText(MouseLookLabelText);
	MouseLookLabel.SetFont(F_Normal);

	// Mouse Look ON Button
	MouseLookOnButton = NerfButtonControl(CreateCONTROL(class'NerfButtonControl', WinWidth - 160, ControlTop, 71, 20));
	MouseLookOnButton.bIgnoreLDoubleclick = True;
	MouseLookOnButton.SetText(MouseLookOnButtonText);
	MouseLookOnButton.SetHelpText(MouseLookOnButtonHelp);
	MouseLookOnButton.SetFont(F_Normal);
	MouseLookOnButton.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);

	// Mouse Look OFF Button
	MouseLookOffButton = NerfButtonControl(CreateCONTROL(class'NerfButtonControl', WinWidth - 80, ControlTop, 71, 20));
	MouseLookOffButton.bIgnoreLDoubleclick = True;
	MouseLookOffButton.SetText(MouseLookOffButtonText);
	MouseLookOffButton.SetHelpText(MouseLookOffButtonHelp);
	MouseLookOffButton.SetFont(F_Normal);
	MouseLookOffButton.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
	SetMouseLook(GetPlayerOwner().bAlwaysMouseLook);
	ControlTop += 25;

	//
	// Auto Weapon Switch
	//

	// label
	WeaponSwitchLabel = UWindowLabelControl(CreateControl(class'UWindowLabelControl', ControlLeft, ControlTop + 5, ControlWidth/2, 20));
	WeaponSwitchLabel.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
	WeaponSwitchLabel.SetText(WeaponSwitchLabelText);
	WeaponSwitchLabel.SetFont(F_Normal);

	// Auto Weapon Switch ON Button
	WeaponSwitchOnButton = NerfButtonControl(CreateCONTROL(class'NerfButtonControl', WinWidth - 160, ControlTop, 71, 20));
	WeaponSwitchOnButton.bIgnoreLDoubleclick = True;
	WeaponSwitchOnButton.SetText(WeaponSwitchOnButtonText);
	WeaponSwitchOnButton.SetHelpText(WeaponSwitchOnButtonHelp);
	WeaponSwitchOnButton.SetFont(F_Normal);
	WeaponSwitchOnButton.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);

	// Auto Weapon Switch OFF Button
	WeaponSwitchOffButton = NerfButtonControl(CreateCONTROL(class'NerfButtonControl', WinWidth - 80, ControlTop, 71, 20));
	WeaponSwitchOffButton.bIgnoreLDoubleclick = True;
	WeaponSwitchOffButton.SetText(WeaponSwitchOffButtonText);
	WeaponSwitchOffButton.SetHelpText(WeaponSwitchOffButtonHelp);
	WeaponSwitchOffButton.SetFont(F_Normal);
	WeaponSwitchOffButton.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
	SetWeaponSwitch(!GetPlayerOwner().bNeverAutoSwitch);

	Initialized = True;
}


function Notify(UWindowDialogControl C, byte E)
{
	Super.Notify(C, E);

	switch (E)
	{
	case DE_Click:
		switch (C)
		{
		case EnableJoystickButton:
			SetEnableJoystick(True);
			break;
		case DisableJoystickButton:
			SetEnableJoystick(False);
			break;
		case InvertMouseOnButton:
			SetInvertMouse(True);
			break;
		case InvertMouseOffButton:
			SetInvertMouse(False);
			break;
		case MouseLookOnButton:
			SetMouseLook(True);
			break;
		case MouseLookOffButton:
			SetMouseLook(False);
			break;
		case WeaponSwitchOnButton:
			SetWeaponSwitch(True);
			break;
		case WeaponSwitchOffButton:
			SetWeaponSwitch(False);
			break;
		}
		break;
	case DE_Change:
		switch (C)
		{
		case MouseSensitivitySlider:
			GetPlayerOwner().UpdateSensitivity(MouseSensitivitySlider.Value);
			Changed = True;
			break;
		}
	}

	if (Initialized && Changed)
	{
		SaveConfig();
	}
}

function SetEnableJoystick(bool yn)
{
	if (Initialized && yn == JoystickEnabled)
		return;

	if (yn)
	{
		ButtonDown(EnableJoystickButton);
		ButtonUp(DisableJoystickButton);
	}
	else
	{
		ButtonDown(DisableJoystickButton);
		ButtonUp(EnableJoystickButton);
	}

	JoystickEnabled = yn;
	if (Initialized)
	{
		GetPlayerOwner().ConsoleCommand("set windrv.windowsclient usejoystick " $ JoystickEnabled);
		Changed = True;
	}
}

function SetInvertMouse(bool yn)
{
	if (Initialized && yn == InvertMouse)
		return;

	if (yn)
	{
		ButtonDown(InvertMouseOnButton);
		ButtonUp(InvertMouseOffButton);
	}
	else
	{
		ButtonDown(InvertMouseOffButton);
		ButtonUp(InvertMouseOnButton);
	}

	InvertMouse = yn;
	if (Initialized)
	{
		GetPlayerOwner().bInvertMouse = InvertMouse;
		Changed = True;
	}
}

function SetMouseLook(bool yn)
{
	if (Initialized && yn == MouseLook)
		return;

	if (yn)
	{
		ButtonDown(MouseLookOnButton);
		ButtonUp(MouseLookOffButton);
	}
	else
	{
		ButtonDown(MouseLookOffButton);
		ButtonUp(MouseLookOnButton);
	}

	MouseLook = yn;
	if (Initialized)
	{
		GetPlayerOwner().bAlwaysMouseLook = MouseLook;
		Changed = True;
	}
}

function SetWeaponSwitch(bool yn)
{
	if (Initialized && yn == WeaponSwitch)
		return;

	if (yn)
	{
		ButtonDown(WeaponSwitchOnButton);
		ButtonUp(WeaponSwitchOffButton);
	}
	else
	{
		ButtonDown(WeaponSwitchOffButton);
		ButtonUp(WeaponSwitchOnButton);
	}

	WeaponSwitch = yn;
	if (Initialized)
	{
		GetPlayerOwner().NeverSwitchOnPickup(!WeaponSwitch);
		Changed = True;
	}
}

defaultproperties
{
     JoystickLabelText=Joystick Enabled
     EnableJoystickButtonText=ENABLED
     EnableJoystickButtonHelp=Enable Joystick (Note: this reduces performance)
     DisableJoystickButtonText=DISABLED
     DisableJoystickButtonHelp=Disable Joysitck (increases performance)
     MouseSensitivityText=Mouse Sensitivity
     MouseSensitivityHelp=Adjust feel of mouse in the game
     InvertMouseLabelText=Invert Mouse
     InvertMouseOnButtonText=INVERTED
     InvertMouseOnButtonHelp=Turn on inverted mouse mode
     InvertMouseOffButtonText=NORMAL
     InvertMouseOffButtonHelp=Turn off inverted mouse mode
     MouseLookLabelText=Mouse Look
     MouseLookOnButtonText=ALWAYS
     MouseLookOnButtonHelp=Turn on always mouse look mode
     MouseLookOffButtonText=ON ACTIVATE
     MouseLookOffButtonHelp=Turn off always mouse look mode
     WeaponSwitchLabelText=Auto-Switch Blasters
     WeaponSwitchOnButtonText=AUTO
     WeaponSwitchOnButtonHelp=Automatically switch blaster when out of ammo or higher priority picked up
     WeaponSwitchOffButtonText=MANUAL
     WeaponSwitchOffButtonHelp=Always manually switch blaster
}
