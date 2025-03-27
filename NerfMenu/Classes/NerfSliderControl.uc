// hook to nerf-ify slider control

class NerfSliderControl extends UWindowHSliderControl;


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
