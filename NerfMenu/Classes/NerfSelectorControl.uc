class NerfSelectorControl extends UWindowComboControl;


function Created()
{
	Super.Created();
	SetButtons(false);
	Button.Close();
}

simulated function MouseEnter()
{
	Super.MouseEnter();
	if (NerfLookAndFeel(LookAndFeel).OverSound != None)
		GetPlayerOwner().PlaySound(NerfLookAndFeel(LookAndFeel).OverSound, SLOT_Interface);
}

simulated function Click(float X, float Y) 
{
	Notify(DE_Click);
	if (NerfLookAndFeel(LookAndFeel).DownSound != None)
		GetPlayerOwner().PlaySound(NerfLookAndFeel(LookAndFeel).DownSound, SLOT_Interact);
}

defaultproperties
{
}
