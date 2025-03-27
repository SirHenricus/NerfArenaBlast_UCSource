class NerfWeaponPriorityList extends UWindowListBoxItem;

var string		WeaponClassName;
var string		WeaponName;
var string		WeaponDescription;
var name		PriorityName;
var bool		bFound;
var Mesh		WeaponMesh;
var Texture		WeaponSkin;


function bool ShowThisItem()
{
	return bFound && (Left(WeaponClassName, 6) ~= "NerfI." || Left(WeaponClassName, 11) ~= "NerfWeapon.");
}

defaultproperties
{
}
