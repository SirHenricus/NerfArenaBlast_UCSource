class NerfCard extends UWindowDialogClientWindow
	abstract;

var bool bEscapeClose;

// Background
var() bool BackgroundSmooth;
var() string BackgroundName;
var texture Background;

// Character Picture
var texture CharacterPicture;

//
// Components
//

// Card Title
var UWindowLabelControl TitleLabel;
var localized string Title;

// Go Button
var UWindowButton GoButton;


function WindowShown()
{
	bEscapeClose = True;
	Super.WindowShown();
}

function Created() 
{
	bAcceptsFocus = True;			// allow key input for return key detection

	Super.Created();

	WinWidth = 256;
	WinHeight = 178;
	CenterWindow();

	// Load the background.
	Background = Texture(DynamicLoadObject(BackgroundName, Class'Texture'));

	//
	// Create components.
	//

	// Card Title
	TitleLabel = UWindowLabelControl(CreateControl(class'UWindowLabelControl', 25, 10, 130, 20));
	TitleLabel.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
	TitleLabel.SetText(Title);
	TitleLabel.SetFont(F_Normal);

	// Go Button
	GoButton = NerfButtonControl(CreateCONTROL(class'NerfButtonControl', 93, 145, 58, 28));
	GoButton.UpTexture   = texture'Go';
	GoButton.OverTexture = texture'GoOver';
	GoButton.DownTexture = texture'GoDown';
	GoButton.bIgnoreLDoubleclick = True;
}

function CenterWindow()
{
	WinTop = (Root.WinHeight-WinHeight)/2;
	WinLeft = (Root.WinWidth-WinWidth)/2;
}

function SetCharPicIndex(int Index)
{
	CharacterPicture = Texture(DynamicLoadObject(NerfRootWindow(Root).PDAMainWindow().CharPicName[Index], Class'Texture'));
}

function SetCharPicture(string Name)
{
	CharacterPicture = Texture(DynamicLoadObject(Name, Class'Texture'));
}

function Paint(Canvas C, float X, float Y)
{
	C.bNoSmooth = !BackgroundSmooth;			// note: false causes tiling artifacts (gaps)

	// Draw background
	C.SetPos(0, 0);
	C.DrawIcon(Background, 1.0);

	// Draw character picture, if exists
	if (CharacterPicture == None)
		return;
	C.SetPos(0, 35);
	C.DrawIcon(CharacterPicture, 1.0);
}

function KeyDown(int Key, float X, float Y)
{
	if (Key == 0x0D)		// enter key
	{
		bEscapeClose = False; 
		Close();
	}
	else
		Super.KeyDown(Key, X, Y);
}

function Close(optional bool bByParent)
{
	// bypass the UClientWindow trying to close the parent window thingy
	Super(UWindowWindow).Close(bByParent);
}

// Nerf Message Box
function NerfMessageBox NerfMessageBox(string Title, string Message, MessageBoxButtons Buttons, MessageBoxResult ESCResult, optional MessageBoxResult EnterResult, optional int TimeOut)
{
	local NerfMessageBox W;
	local UWindowFramedWindow F;
	
	W = NerfMessageBox(Root.CreateWindow(class'NerfMessageBox', 100, 100, 100, 100, Self));
	W.SetupMessageBox(Title, Message, Buttons, ESCResult, EnterResult, TimeOut);
	F = UWindowFramedWindow(GetParent(class'UWindowFramedWindow'));

	if (F != None)
		F.ShowModal(W);
	else
		Root.ShowModal(W);

	return W;
}

function NerfMessageBoxDone(NerfMessageBox W, MessageBoxResult Result)
{
}

defaultproperties
{
     BackgroundName=NerfRes.CardBack
     Title=(No Title)
}
