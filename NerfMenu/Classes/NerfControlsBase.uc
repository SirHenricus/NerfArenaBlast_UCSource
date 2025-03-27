class NerfControlsBase extends NerfWindow;

var string MenuValues1[70];
var string MenuValues2[70];
var UWindowLabelControl KeyNames[70];
var NerfButtonControl KeyButtons[70];
var NerfButtonControl SelectedButton;
var localized string LabelList[70];
var string AliasNames[70];
var int Selection;
var bool bPolling;
var localized string OrString;
var localized string CustomizeHelp;

var NerfButtonControl DefaultsButton;
var localized string DefaultsText;
var localized string DefaultsHelp;

var int AliasCount;

var int ButtonWidth, ButtonLeft;
var int LabelWidth, LabelLeft;


function Created() 
{
	local int ButtonTop, I, J, pos;
	local UWindowLabelControl Heading;
	local bool bTop;

	bIgnoreLDoubleClick = True;
	bIgnoreMDoubleClick = True;
	bIgnoreRDoubleClick = True;

	Super.Created();

	SetAcceptsFocus();

	bTop = True;
	if (NerfRootWindow(Root).bPDALowRes)
	{
		ButtonTop = 16;
		ButtonWidth = WinWidth/2;
		ButtonLeft = (WinWidth/2)-20;
		LabelWidth = WinWidth/2;
		DefaultsButton = NerfButtonControl(CreateControl(class'NerfButtonControl', ButtonLeft+(ButtonWidth/4), 2, ButtonWidth/2, 12));
		DefaultsButton.UpTexture   = texture'Oval2';
		DefaultsButton.OverTexture = texture'Oval2Over';
		DefaultsButton.DownTexture = texture'Oval2Down';
		DefaultsButton.bStretched = True;
		for (I = 0; I < ArrayCount(AliasNames); I++)
		{
			if(AliasNames[I] == "")
				break;

			j = InStr(LabelList[I], ",");
			if(j != -1)
			{
				if(!bTop)
					ButtonTop += 10;
				Heading = UWindowLabelControl(CreateControl(class'UWindowLabelControl', LabelLeft-10, ButtonTop+1, WinWidth, 16));
				Heading.SetText(Left(LabelList[I], j));
				Heading.SetFont(F_Normal);
				Heading.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
				LabelList[I] = Mid(LabelList[I], j+1);
				ButtonTop += 14;
			}
			bTop = False;

			KeyNames[I] = UWindowLabelControl(CreateControl(class'UWindowLabelControl', LabelLeft, ButtonTop+1, LabelWidth, 16));
			KeyNames[I].SetText(LabelList[I]);
			KeyNames[I].SetHelpText(CustomizeHelp);
			KeyNames[I].SetFont(F_Normal);
			KeyNames[I].SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
			KeyButtons[I] = NerfButtonControl(CreateControl(class'NerfButtonControl', ButtonLeft, ButtonTop, ButtonWidth, 12));
			KeyButtons[I].UpTexture   = texture'ButtonOff';
			KeyButtons[I].OverTexture = texture'ButtonOver';
			KeyButtons[I].DownTexture = texture'ButtonDown';
			KeyButtons[I].DisabledTexture = texture'ButtonOn';
			KeyButtons[I].SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
			KeyButtons[I].SetHelpText(CustomizeHelp);
			KeyButtons[I].bAcceptsFocus = False;
			KeyButtons[I].bIgnoreLDoubleClick = True;
			KeyButtons[I].bIgnoreMDoubleClick = True;
			KeyButtons[I].bIgnoreRDoubleClick = True;
			ButtonTop += 14;
		}
	}
	else
	{
		ButtonTop = 16;
		ButtonWidth = WinWidth - 160;
		ButtonLeft = WinWidth - ButtonWidth - 60;
		LabelWidth = WinWidth - 100;
		DefaultsButton = NerfButtonControl(CreateControl(class'NerfButtonControl', 260, 5, 54, 38));
		DefaultsButton.UpTexture   = texture'Round';
		DefaultsButton.OverTexture = texture'RoundOver';
		DefaultsButton.DownTexture = texture'RoundDown';
		DefaultsButton.bStretched = False;
		for (I = 0; I < ArrayCount(AliasNames); I++)
		{
			if(AliasNames[I] == "")
				break;

			j = InStr(LabelList[I], ",");
			if(j != -1)
			{
				if(!bTop)
					ButtonTop += 10;
				Heading = UWindowLabelControl(CreateControl(class'UWindowLabelControl', LabelLeft-10, ButtonTop+3, WinWidth, 18));
				Heading.SetText(Left(LabelList[I], j));
				Heading.SetFont(F_Normal);
				Heading.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
				LabelList[I] = Mid(LabelList[I], j+1);
				ButtonTop += 16;
			}
			bTop = False;

			KeyNames[I] = UWindowLabelControl(CreateControl(class'UWindowLabelControl', LabelLeft, ButtonTop+3, LabelWidth, 18));
			KeyNames[I].SetText(LabelList[I]);
			KeyNames[I].SetHelpText(CustomizeHelp);
			KeyNames[I].SetFont(F_Normal);
			KeyNames[I].SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
			KeyButtons[I] = NerfButtonControl(CreateControl(class'NerfButtonControl', ButtonLeft, ButtonTop, ButtonWidth, 14));
			KeyButtons[I].UpTexture   = texture'ButtonOff';
			KeyButtons[I].OverTexture = texture'ButtonOver';
			KeyButtons[I].DownTexture = texture'ButtonDown';
			KeyButtons[I].DisabledTexture = texture'ButtonOn';
			KeyButtons[I].SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
			KeyButtons[I].SetHelpText(CustomizeHelp);
			KeyButtons[I].bAcceptsFocus = False;
			KeyButtons[I].bIgnoreLDoubleClick = True;
			KeyButtons[I].bIgnoreMDoubleClick = True;
			KeyButtons[I].bIgnoreRDoubleClick = True;
			ButtonTop += 16;
		}
	}
	LabelLeft = 0;
	DefaultsButton.SetText(DefaultsText);
	DefaultsButton.SetFont(F_Normal);
	DefaultsButton.SetHelpText(DefaultsHelp);
	DefaultsButton.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
	
	AliasCount = I;

	LoadExistingKeys();
}

function LoadExistingKeys()
{
	local int I, J, pos;
	local string KeyName;
	local string Alias;

	for (I=0; I<AliasCount; I++)
	{
		MenuValues1[I] = "";
		MenuValues2[I] = "";
	}

	for (I=0; I<255; I++)
	{
		KeyName = GetPlayerOwner().ConsoleCommand( "KEYNAME "$i );
		if ( KeyName != "" )
		{
			Alias = GetPlayerOwner().ConsoleCommand( "KEYBINDING "$KeyName );
			if ( Alias != "" )
			{
				pos = InStr(Alias, " ");
				if ( pos != -1 )
				{
					if( !(Left(Alias, pos) ~= "taunt") &&
						!(Left(Alias, pos) ~= "getweapon") &&
						!(Left(Alias, pos) ~= "viewplayernum"))
						Alias = Left(Alias, pos);
				}
				for (J=0; J<AliasCount; J++)
				{
					if ( AliasNames[J] ~= Alias && AliasNames[J] != "None" )
					{
						if ( MenuValues1[J] == "" )
							MenuValues1[J] = KeyName;
						else if ( MenuValues2[J] == "" )
							MenuValues2[J] = KeyName;
					}
				}
			}
		}
	}
}

function BeforePaint(Canvas C, float X, float Y)
{
	local int I;

	for (I=0; I<AliasCount; I++)
	{
		KeyButtons[I].WinLeft = ButtonLeft;
		KeyNames[I].WinLeft = LabelLeft;
	}

	for (I=0; I<AliasCount; I++ )
	{
		if ( MenuValues2[I] == "" )
			KeyButtons[I].SetText(MenuValues1[I]);
		else
			KeyButtons[I].SetText(MenuValues1[I]$OrString$MenuValues2[I]);
	}
}

function KeyDown( int Key, float X, float Y )
{
	if (bPolling)
	{
		ProcessMenuKey( Key, mid(string(GetEnum(enum'EInputKey',Key)),3) );
		bPolling = False;
		SelectedButton.bDisabled = False;
	}
}

function RemoveExistingKey(int KeyNo, string KeyName)
{
	local int I;

	// Remove this key from any existing binding display
	for ( I=0; I<AliasCount; I++ )
	{
		if(I != Selection)
		{
			if ( MenuValues2[I] ~= KeyName )
				MenuValues2[I] = "";

			if ( MenuValues1[I] ~= KeyName )
			{
				MenuValues1[I] = MenuValues2[I];
				MenuValues2[I] = "";
			}
		}
	}
}

function SetKey(int KeyNo, string KeyName)
{
	if ( MenuValues1[Selection] != "" )
	{

		// if this key is already chosen, just clear out other slot
		if(KeyName == MenuValues1[Selection])
		{
			// if 2 exists, remove it it.
			if(MenuValues2[Selection] != "")
			{
				GetPlayerOwner().ConsoleCommand("SET Input "$MenuValues2[Selection]);
				MenuValues2[Selection] = "";
			}
		}
		else 
		if(KeyName == MenuValues2[Selection])
		{
			// Remove slot 1
			GetPlayerOwner().ConsoleCommand("SET Input "$MenuValues1[Selection]);
			MenuValues1[Selection] = MenuValues2[Selection];
			MenuValues2[Selection] = "";
		}
		else
		{
			// Clear out old slot 2 if it exists
			if(MenuValues2[Selection] != "")
			{
				GetPlayerOwner().ConsoleCommand("SET Input "$MenuValues2[Selection]);
				MenuValues2[Selection] = "";
			}

			// move key 1 to key 2, and set ourselves in 1.
			MenuValues2[Selection] = MenuValues1[Selection];
			MenuValues1[Selection] = KeyName;
			GetPlayerOwner().ConsoleCommand("SET Input"@KeyName@AliasNames[Selection]);		
		}
	}
	else
	{
		MenuValues1[Selection] = KeyName;
		GetPlayerOwner().ConsoleCommand("SET Input"@KeyName@AliasNames[Selection]);		
	}
}

function ProcessMenuKey( int KeyNo, string KeyName )
{
	if ( (KeyName == "") || (KeyName == "Escape")  
		|| ((KeyNo >= 0x70 ) && (KeyNo <= 0x79)) // function keys
		|| ((KeyNo >= 0x30 ) && (KeyNo <= 0x39))) // number keys
		return;

	RemoveExistingKey(KeyNo, KeyName);
	SetKey(KeyNo, KeyName);
}

function Notify(UWindowDialogControl C, byte E)
{
	local int I;

	Super.Notify(C, E);

	if(C == DefaultsButton && E == DE_Click)
	{
		GetPlayerOwner().ResetKeyboard();
		LoadExistingKeys();
		return;
	} 

	switch(E)
	{
	case DE_Click:
		if (bPolling)
		{
			bPolling = False;
			SelectedButton.bDisabled = False;

			if(C == SelectedButton)
			{
				ProcessMenuKey( 1, mid(string(GetEnum(enum'EInputKey', 1)),3) );
				return;
			}
		}

		if (NerfButtonControl(C) != None)
		{
			SelectedButton = NerfButtonControl(C);
			for (I = 0; I < AliasCount; I++)
			{
				if (KeyButtons[I] == C)
					Selection = I;
			}
			bPolling = True;
			SelectedButton.bDisabled = True;
		}
		break;
	case DE_RClick:
		if (bPolling)
			{
				bPolling = False;
				SelectedButton.bDisabled = False;

				if(C == SelectedButton)
				{
					ProcessMenuKey( 2, mid(string(GetEnum(enum'EInputKey', 2)),3) );
					return;
				}
			}
		break;
	case DE_MClick:
		if (bPolling)
			{
				bPolling = False;
				SelectedButton.bDisabled = False;

				if(C == SelectedButton)
				{
					ProcessMenuKey( 4, mid(string(GetEnum(enum'EInputKey', 4)),3) );
					return;
				}			
			}
		break;
	}
}

function GetDesiredDimensions(out float W, out float H)
{	
	Super.GetDesiredDimensions(W, H);
	H = 200;
}

defaultproperties
{
     OrString= or 
     CustomizeHelp=Click the blue rectangle and then press the key to bind to this control.
     DefaultsText=Reset
     DefaultsHelp=Reset all controls to their default settings.
}
