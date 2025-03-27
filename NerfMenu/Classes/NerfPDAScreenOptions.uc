class NerfPDAScreenOptions extends NerfWindow;

var int ButtonLeft[3], ButtonTop, ButtonWidth, ButtonHeight;
var int ScreenTop;

//
// Controls
//

// General Options button
var NerfButtonControl GeneralButton;
var localized string GeneralButtonText;
var localized string GeneralButtonHelp;

// Weapon Options button
var NerfButtonControl WeaponButton;
var localized string WeaponButtonText;
var localized string WeaponButtonHelp;

//
// Screens
//
var NerfPDAScreenWeapon WeaponScreen;
var NerfPDAScreenGeneral GeneralScreen;

function Created() 
{
	local Color TextColor;

	Super.Created();

	TextColor.R = 255;
	TextColor.G = 255;
	TextColor.B = 255;

	//
	// Create components.
	//
	if (NerfRootWindow(Root).bPDALowRes)
	{
		// low-res version
		ButtonLeft[0]	= 44;
		ButtonLeft[1]	= 130;
		ButtonTop		= 10;
		ButtonWidth		= 54;
		ButtonHeight	= 16;
		ScreenTop		= 30;
	}
	else
	{
		// high-res version
		ButtonLeft[0]	= 64;
		ButtonLeft[1]	= 150;
		ButtonTop		= 1;
		ButtonWidth		= 74;
		ButtonHeight	= 24;
		ScreenTop		= 44;
	}

	GeneralButton = NerfButtonControl(CreateCONTROL(class'NerfButtonControl', ButtonLeft[0], ButtonTop, ButtonWidth, ButtonHeight));
	GeneralButton.UpTexture   = texture'Oval2';
	GeneralButton.OverTexture = texture'Oval2Over';
	GeneralButton.DownTexture = texture'Oval2Down';
	GeneralButton.bIgnoreLDoubleclick = True;
	GeneralButton.SetText(GeneralButtonText);
	GeneralButton.SetHelpText(GeneralButtonHelp);
	GeneralButton.SetFont(F_Normal);
	GeneralButton.SetTextColor(TextColor);
	GeneralButton.bStretched = True;

	WeaponButton = NerfButtonControl(CreateCONTROL(class'NerfButtonControl', ButtonLeft[1], ButtonTop, ButtonWidth, ButtonHeight));
	WeaponButton.UpTexture   = texture'Oval2';
	WeaponButton.OverTexture = texture'Oval2Over';
	WeaponButton.DownTexture = texture'Oval2Down';
	WeaponButton.bIgnoreLDoubleclick = True;
	WeaponButton.SetText(WeaponButtonText);
	WeaponButton.SetHelpText(WeaponButtonHelp);
	WeaponButton.SetFont(F_Normal);
	WeaponButton.SetTextColor(TextColor);
	WeaponButton.bStretched = True;

	// General Options screen
	GeneralScreen = NerfPDAScreenGeneral(CreateWindow(class'NerfPDAScreenGeneral', 1, ScreenTop, WinWidth, WinHeight - 44, self));
}

function ShowGeneralScreen()
{
	NerfRootWindow(Root).PDAMainWindow().SetScreenTitle(NerfRootWindow(Root).PDAMainWindow().OptionsButtonText $ " - " $ GeneralButtonText);

	GeneralButton.UpTexture = texture'Oval2Over';
	WeaponButton.UpTexture = texture'Oval2';

	if (WeaponScreen != None)
		HideChildWindow(WeaponScreen);

	ShowChildWindow(GeneralScreen);
}

function ShowWeaponScreen()
{
	NerfRootWindow(Root).PDAMainWindow().SetScreenTitle(NerfRootWindow(Root).PDAMainWindow().OptionsButtonText $ " - " $ WeaponButtonText);

	WeaponButton.UpTexture = texture'Oval2Over';
	GeneralButton.UpTexture = texture'Oval2';

	HideChildWindow(GeneralScreen);

	if (WeaponScreen == None)
		WeaponScreen = NerfPDAScreenWeapon(CreateWindow(class'NerfPDAScreenWeapon', 1, ScreenTop, WinWidth, WinHeight - 44, self));

	ShowChildWindow(WeaponScreen);
}

function Notify(UWindowDialogControl C, byte E)
{
	Super.Notify(C, E);

	switch (E)
	{
	case DE_Click:
		switch (C)
		{
		case GeneralButton:
			ShowGeneralScreen();
			break;

		case WeaponButton:
			ShowWeaponScreen();
			break;
		}
		break;
	}
}

defaultproperties
{
     GeneralButtonText=General
     GeneralButtonHelp=Display the general options screen
     WeaponButtonText=Blasters
     WeaponButtonHelp=Display the Blaster configuration screen
}
