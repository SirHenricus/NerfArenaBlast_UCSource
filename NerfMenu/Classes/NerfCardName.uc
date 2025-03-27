class NerfCardName extends NerfCard;

//
// Components
//

// Character name edit control
var NerfEditControl CharacterNameEdit;
var localized string CharacterNameText;
var localized string CharacterNameHelp;

function string GetName()
{
	return CharacterNameEdit.GetValue();
}

function Created() 
{
	Super.Created();

	//
	// Create components.
	//

	// Character Name
	CharacterNameEdit = NerfEditControl(CreateControl(class'NerfEditControl', 30, 80, 150, 17));
	CharacterNameEdit.SetText(CharacterNameText);
	CharacterNameEdit.SetHelpText(CharacterNameHelp);
	CharacterNameEdit.SetFont(F_Normal);
	CharacterNameEdit.SetNumericOnly(False);
	CharacterNameEdit.SetMaxLength(32);
	CharacterNameEdit.SetDelayedNotify(True);
	CharacterNameEdit.SetValue("Player");
}

function BeforePaint(Canvas C, float X, float Y)
{
	Super.BeforePaint(C, X, Y);

	CharacterNameEdit.SetSize(150, 17);
	CharacterNameEdit.EditBoxWidth = 150;
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
	NerfRootWindow(Root).PDAMainWindow().CardNameClosed();
	Super.Close(bByParent);
}

defaultproperties
{
     CharacterNameHelp=Enter the name for your new character
     Title=Enter Your Name
}
