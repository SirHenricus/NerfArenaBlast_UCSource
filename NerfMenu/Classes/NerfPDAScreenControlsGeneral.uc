class NerfPDAScreenControlsGeneral extends NerfControlsBase;

var NerfPDAScreenControlsMovement	OtherControlsWindow;

function Created()
{
	OtherControlsWindow = NerfPDAScreenControls(ParentWindow).MovementControlsScreen;
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
     LabelList(0)=Fire
     LabelList(1)=Alternate Fire
     LabelList(2)=Mouse Look
     LabelList(3)=Look Up
     LabelList(4)=Look Down
     LabelList(5)=Center View
     LabelList(6)=Next Weapon
     LabelList(7)=Previous Weapon
     LabelList(8)=Throw Weapon
     LabelList(9)=Gesture Victory
     LabelList(10)=Gesture Join-Me!
     LabelList(11)=Gesture Taunt
     LabelList(12)=Gesture Wave
     AliasNames(0)=Fire
     AliasNames(1)=AltFire
     AliasNames(2)=Look
     AliasNames(3)=LookUp
     AliasNames(4)=LookDown
     AliasNames(5)=CenterView
     AliasNames(6)=NextWeapon
     AliasNames(7)=PrevWeapon
     AliasNames(8)=ThrowWeapon
     AliasNames(9)=Taunt Victory1
     AliasNames(10)=Taunt JoinMe
     AliasNames(11)=Taunt Taunt1
     AliasNames(12)=Taunt Wave
}
