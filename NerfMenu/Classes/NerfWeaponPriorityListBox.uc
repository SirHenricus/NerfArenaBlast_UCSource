class NerfWeaponPriorityListBox extends UWindowListBox;

var string WeaponClassParent;

var localized string WeaponPriorityHelp;

function Created()
{
	local name PriorityName;
	local string WeaponClassName, WeaponClassDesc;
	local int WeaponNum, i;
	local NerfWeaponPriorityList L;
	local PlayerPawn P;

	Super.Created();

	SetHelpText(WeaponPriorityHelp);

	P = GetPlayerOwner();

	// Load weapons into the list
	for (i = 0; i < 20; i++)
	{
		PriorityName = P.WeaponPriority[i];
		if (PriorityName == 'None')
			break;
		L = NerfWeaponPriorityList(Items.Insert(ListClass));
		L.PriorityName = PriorityName;
		L.WeaponName = "(unk) " $ PriorityName;
	}

	WeaponNum = 1;
	P.GetNextIntDesc(WeaponClassParent, 0, WeaponClassName, WeaponClassDesc);
	while (WeaponClassName != "" && WeaponNum < 50)
	{
		for (L = NerfWeaponPriorityList(Items.Next); L != None; L = NerfWeaponPriorityList(L.Next))
		{
			if (string(L.PriorityName) ~= P.GetItemName(WeaponClassName))
			{
				L.WeaponClassName = WeaponClassName;
				L.bFound = True;
				if (L.ShowThisItem())
				{
					L.WeaponClassName = WeaponClassName;
					L.WeaponName = WeaponClassDesc;
				}
				else
					L.bFound = False;
				break;
			}
		}

		P.GetNextIntDesc(WeaponClassParent, WeaponNum, WeaponClassName, WeaponClassDesc);
		WeaponNum++;
	}
}

function ReadWeapon(NerfWeaponPriorityList L)
{
	local class<NerfWeapon> WeaponClass;

	WeaponClass = class<NerfWeapon>(DynamicLoadObject(L.WeaponClassName, class'Class'));
	if (WeaponClass == None)
		log("Could not load weapon $ " $ L.WeaponClassName);

	if (WeaponClass.default.ItemName == "Weapon")
		L.WeaponName = WeaponClass.Name $ "*";		// could not load class
	else
		L.WeaponName = WeaponClass.default.ItemName;
		
	L.WeaponMesh = WeaponClass.default.PickupViewMesh;
	L.WeaponSkin = WeaponClass.default.Skin;
	L.WeaponDescription = WeaponClass.default.WeaponDescription;
}

function DrawItem(Canvas C, UWindowList Item, float X, float Y, float W, float H)
{
	local float TextW, TextH;

	if(NerfWeaponPriorityList(Item).bSelected)
	{
		C.DrawColor.r = 0;
		C.DrawColor.g = 0;
		C.DrawColor.b = 128;
		DrawStretchedTexture(C, X, Y, W, H-1, Texture'WhiteTexture');
		C.DrawColor.r = 255;
		C.DrawColor.g = 255;
		C.DrawColor.b = 255;
	}
	else
	{
		C.DrawColor.r = 248;
		C.DrawColor.g = 199;
		C.DrawColor.b = 104;
	}

	C.Font = Root.Fonts[F_Normal];

	// Center text
	TextSize(C, NerfWeaponPriorityList(Item).WeaponName, TextW, TextH);
	X = (W-TextW)/2;
	ClipText(C, X, Y, NerfWeaponPriorityList(Item).WeaponName);
}

function SaveConfigs()
{
	local int i;
	local NerfWeaponPriorityList L;
	local PlayerPawn P;

	P = GetPlayerOwner();
	
	for (L = NerfWeaponPriorityList(Items.Last); L != None && L != Items; L = NerfWeaponPriorityList(L.Prev))
	{
		P.WeaponPriority[i] = L.PriorityName;
		i++;
	}
	while (i < 20)
	{
		P.WeaponPriority[i] = 'None';
		i++;
	}
	P.UpdateWeaponPriorities();
	P.SaveConfig();
	Super.SaveConfigs();
}

function LMouseDown(float X, float Y)
{
	local NerfWeaponPriorityList I;

	Super.LMouseDown(X, Y);

	I = NerfWeaponPriorityList(SelectedItem);
	if (I != None)
	{
		ReadWeapon(I);
		NerfPDAScreenWeapon(ParentWindow).SelectWeapon(I, I.WeaponMesh, I.WeaponSkin, I.WeaponDescription);
	}
}

defaultproperties
{
     WeaponClassParent=Engine.Weapon
     WeaponPriorityHelp=Click and drag a weapon name in the list on the left to change its priority.  Weapons higher in the list have higher priority.
     ItemHeight=13.000000
     bCanDrag=True
     ListClass=Class'NerfMenu.NerfWeaponPriorityList'
}
