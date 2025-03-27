class NerfPDAScreenWeapon extends NerfWindow;

// Weapon List
var NerfWeaponPriorityListBox PriorityList;

// Weapon Mesh Viewport
var NerfWeaponPriorityMesh MeshWindow;

//  Weapon Description
var UWindowHTMLTextArea Description;
var localized string DescriptionText;


function Created() 
{
	local Color LinkColor, ALinkColor;

	Super.Created();

	LinkColor.R = 255;
	LinkColor.G = 0;
	LinkColor.B = 0;

	ALinkColor.R = 255;
	ALinkColor.G = 255;
	ALinkColor.B = 0;
	//
	// Create components.
	//

	// Weapon priority list
	PriorityList = NerfWeaponPriorityListBox(CreateControl(class'NerfWeaponPriorityListBox', 0, 0, 100, 130));
	PriorityList.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
	PriorityList.VertSB.Close();


	// Weapon description
	Description = UWindowHTMLTextArea(CreateControl(class'UWindowHTMLTextArea', 0, 130, WinWidth-10, WinHeight-130));
	Description.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
	Description.AddText(DescriptionText);
	Description.bTopCentric = True;
	Description.bVCenter = True;
	Description.bAutoScrollbar = True;
	Description.SetFont(F_Normal);
	Description.TextColor = NerfLookAndFeel(LookAndFeel).DefaultTextColor;
	Description.LinkColor = LinkColor;
	Description.ALinkColor = ALinkColor;

	// NOTE - Mesh window is automatically created when a weapon has been selected...
}

function SelectWeapon(NerfWeaponPriorityList SelectedItem, Mesh WeaponMesh, Texture WeaponSkin, String WeaponDescription)
{
	if (MeshWindow == None)
		if (NerfRootWindow(Root).bPDALowRes)
			MeshWindow = NerfWeaponPriorityMesh(CreateWindow(class'NerfWeaponPriorityMesh', 100, 20, WinWidth-100, WinHeight-100));
		else
			MeshWindow = NerfWeaponPriorityMesh(CreateWindow(class'NerfWeaponPriorityMesh', 100, 0, WinWidth-100, WinHeight-130));

	// update mesh window
	MeshWindow.MeshActor.Mesh = WeaponMesh;
	MeshWindow.MeshActor.Skin = WeaponSkin;

	// update description
	Description.Clear();
	Description.AddText(WeaponDescription);
}


function Notify(UWindowDialogControl C, byte E)
{
	Super.Notify(C, E);

	if (E == DE_Change && C == PriorityList)
		PriorityList.SaveConfigs();
}

defaultproperties
{
     DescriptionText=Click on a blaster to see it and adjust it's prioritiy.
}
