//=============================================================================
// SetupDefinition: Definition of the current installation.
//=============================================================================
class SetupDefinition extends SetupProduct
	native
	perobjectconfig;

var localized string DefaultFolder;
var string        DefaultLanguage;
var string        License;
var string        ReadMe;
var string        Logo;
var localized string SetupWindowTitle, AutoplayWindowTitle;
var array<string> Requires;

defaultproperties
{
     DefaultFolder=C:\Folder
     DefaultLanguage=int
     License=..\Help\FullLicense.txt
     ReadMe=..\Help\ReadMe.txt
     Logo=..\Help\SetupLogo.bmp
     SetupWindowTitle=Setup
     AutoplayWindowTitle=Autoplay Options
}
