class UWindowConsoleTextAreaControl extends UWindowTextAreaControl;

function Created()
{
	bNoKeyboard = True;
	bCursor = True;
	Super.Created();
}

defaultproperties
{
}
