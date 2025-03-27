class NerfPDAScreenMultiplayerSetup extends NerfWindow
	config(user);

// Character Name
var NerfEditControl NameEdit;
var localized string NameText;
var localized string NameHelp;

// Character
var NerfSelectorControl CharacterSelector;
var localized string CharacterText;
var localized string CharacterHelp;
var globalconfig string CharacterClass;

var string CharClass[34];
var string CharTeam[34];


function Created() 
{
	local int ControlWidth, ControlLeft;
	local int ControlTop;

	local int i, j, Pos;
	local string NextChar;
	local class<NerfBotInfo> CharInfo;

	Super.Created();

	ControlWidth = WinWidth - 20;
	ControlLeft = 10;
	ControlTop = 10;

	//
	// Create components.
	//

	// Character Name
	NameEdit = NerfEditControl(CreateControl(class'NerfEditControl', ControlLeft, ControlTop, ControlWidth, 1));
	NameEdit.SetText(NameText);
	NameEdit.SetHelpText(NameHelp);
	NameEdit.SetFont(F_Normal);
	NameEdit.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
	NameEdit.SetNumericOnly(False);
	NameEdit.SetMaxLength(32);
	NameEdit.SetValue(GetPlayerOwner().PlayerReplicationInfo.PlayerName);
	ControlTop += 20;

	// Character (CharType)
	CharacterSelector = NerfSelectorControl(CreateControl(class'NerfSelectorControl', ControlLeft, ControlTop, ControlWidth, 1));
	CharacterSelector.SetText(CharacterText);
	CharacterSelector.SetHelpText(CharacterHelp);
	CharacterSelector.SetFont(F_Normal);
	CharacterSelector.SetEditable(False);
	CharacterSelector.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);

	// Compile a list of all Character types (NerfKids in NerfIPlayer)
	// to associate with character name
	i = 0; j = 0;
	NextChar = GetPlayerOwner().GetNextInt("NerfIPlayer", 0); 
	while (NextChar != "")
	{
		Pos = InStr(NextChar, ".");
		if (Left(NextChar, Pos) ~= "NerfKids")
		{
			CharClass[i] = NextChar;
			switch (i / 4)
			{
				case 0:		CharTeam[i] = "Twisters";		break;
				case 1:		CharTeam[i] = "Tycoons";		break;
				case 2:		CharTeam[i] = "Rockheads";		break;
				case 3:		CharTeam[i] = "Tribe";			break;
				case 4:		CharTeam[i] = "Lunas";			break;
				case 5:		CharTeam[i] = "Baracudas";		break;
				case 6:		CharTeam[i] = "Orbiteers";		break;
				case 7:		CharTeam[i] = "Gators";			break;
				default:	CharTeam[i] = "(Unknown)";		break;
			}
			i++;
			if(i == 34)
			{
				Log("More than 34 NerfKids listed in int files");
				break;
			}
		}
		j++;
		NextChar = GetPlayerOwner().GetNextInt("NerfIPlayer", j);
	}

	// create a nerfbot info object so we can grab some default properties
	CharInfo = Class<NerfBotInfo>(DynamicLoadObject("NerfI.NerfBotInfo", class'Class'));

	// fill the control
	for (i = 0; i < 32; i++)
		CharacterSelector.AddItem(CharTeam[i] $ ": " $ CharInfo.default.BotNames[i], CharClass[i]);

	// select an item
//	CharacterSelector.SetSelectedIndex(Max(CharacterSelector.FindItemIndex2(CharacterClass),0));	
	CharacterSelector.SetSelectedIndex(Max(CharacterSelector.FindItemIndex2(string(GetPlayerOwner().PlayerReplicationInfo.Class)),0));	
	ControlTop += 20;
}

function Notify(UWindowDialogControl C, byte E)
{
	local string CharName;

	Super.Notify(C, E);

	switch (E)
	{
	case DE_Change:
		switch (C)
		{
		case CharacterSelector:
			NerfRootWindow(Root).PDAMainWindow().bMustTravel = True;
			CharName = CharacterSelector.GetValue();
			CharName = right(CharName, Len(CharName) - instr(CharName, ":") - 2);
			NerfRootWindow(Root).PDAMainWindow().SetCharPicture(CharName);
			CharacterClass = CharacterSelector.GetValue2();
			GetPlayerOwner().UpdateURL("Class", CharacterClass, true);
			SaveConfig();
			break;

		case NameEdit:
			NerfRootWindow(Root).PDAMainWindow().bMustTravel = True;
			GetPlayerOwner().UpdateURL("Name",NameEdit.GetValue(), true);
			break;
		}
	}
}

defaultproperties
{
     NameText=Name
     NameHelp=The name of your character that others will see online
     CharacterText=Character
     CharacterHelp=Pick the body you would like to represent you in the game
}
