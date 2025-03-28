//=============================================================================
// SetupLink: Information about a Windows Shell link for the "Start" menu.
//=============================================================================
class SetupLink extends SetupObject
	native
	perobjectconfig;

var bool        Folder;
var string      Target;
var string      IconFile;
var string      StartPath;

defaultproperties
{
     Target=<DESTDIR>\System\Program.exe
     IconFile=<DESTDIR>\System\Program.exe
     startPath=<DESTDIR>
}
