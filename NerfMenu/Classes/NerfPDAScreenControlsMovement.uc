class NerfPDAScreenControlsMovement extends NerfControlsBase;

var NerfPDAScreenControlsGeneral	OtherControlsWindow;

function Created()
{
	OtherControlsWindow = NerfPDAScreenControls(ParentWindow).GeneralControlsScreen;
	Super.Created();
}

function ProcessMenuKey( int KeyNo, string KeyName )
{
	if ( (KeyName == "") || (KeyName == "Escape")  
		|| ((KeyNo >= 0x70 ) && (KeyNo <= 0x79)) // function keys
		|| ((KeyNo >= 0x30 ) && (KeyNo <= 0x39))) // number keys
		return;

	// remove key from other window
	if (OtherControlsWindow != None)
		OtherControlsWindow.RemoveExistingKey(KeyNo, KeyName);
	Super.ProcessMenuKey(KeyNo, KeyName);
}

function Notify(UWindowDialogControl C, byte E)
{
	if (OtherControlsWindow != None && C == DefaultsButton && E == DE_Click)
	{
		OtherControlsWindow.GetPlayerOwner().ResetKeyboard();
		OtherControlsWindow.LoadExistingKeys();
	}

	Super.Notify(C, E);
}

defaultproperties
{
     LabelList(0)=Move Forward
     LabelList(1)=Move Backward
     LabelList(2)=Turn Left
     LabelList(3)=Turn Right
     LabelList(4)=Strafe Left
     LabelList(5)=Strafe Right
     LabelList(6)=Jump/Up
     LabelList(7)=Crouch/Down
     LabelList(8)=Walk
     LabelList(9)=Strafe
     AliasNames(0)=MoveForward
     AliasNames(1)=MoveBackward
     AliasNames(2)=TurnLeft
     AliasNames(3)=TurnRight
     AliasNames(4)=StrafeLeft
     AliasNames(5)=StrafeRight
     AliasNames(6)=Jump
     AliasNames(7)=Duck
     AliasNames(8)=Walking
     AliasNames(9)=Strafe
}
