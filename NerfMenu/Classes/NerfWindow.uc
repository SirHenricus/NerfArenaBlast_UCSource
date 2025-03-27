//
//	common base class for all nerf windows
//
class NerfWindow extends UWindowDialogClientWindow;

var bool WindowEnabled;


// override functions
function Close(optional bool bByParent)
{
	HideWindow();			// really only hide the window
}

function Texture GetLookAndFeelTexture()
{
	return LookAndFeel.Active;
}

function Notify(UWindowDialogControl C, byte E)
{
	Super.Notify(C, E);

	if (NerfRootWindow(Root) == None)
		return;

	if (E == DE_MouseMove)
	{
		if (NerfPDA(NerfRootWindow(Root).MainWindow.ClientArea).HelpWindow != None)
			NerfPDA(NerfRootWindow(Root).MainWindow.ClientArea).HelpWindow.SetHelp(C.HelpText);		
	}

	if (E == DE_HelpChanged && C.MouseIsOver())
	{
			if (NerfPDA(NerfRootWindow(Root).MainWindow.ClientArea).HelpWindow != None)
				NerfPDA(NerfRootWindow(Root).MainWindow.ClientArea).HelpWindow.SetHelp(C.HelpText);		
	}

	if (E == DE_MouseLeave)
	{
			if (NerfPDA(NerfRootWindow(Root).MainWindow.ClientArea).HelpWindow != None)
				NerfPDA(NerfRootWindow(Root).MainWindow.ClientArea).HelpWindow.SetHelp("");		
	}
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

// yes/no button functions
function ButtonDown(NerfButtonControl b)
{
	local Color BlackTextColor;

	b.UpTexture = texture'ButtonOn';
	b.OverTexture = texture'ButtonOn';
	b.DownTexture = texture'ButtonOn';
	BlackTextColor.R = 0;
	BlackTextColor.G = 0;
	BlackTextColor.B = 0;
	b.SetTextColor(BlackTextColor);
}

function ButtonUp(NerfButtonControl b)
{
	b.UpTexture = texture'ButtonOff';
	b.OverTexture = texture'ButtonOver';
	b.DownTexture = texture'ButtonDown';
	b.SetTextColor(NerfLookAndFeel(LookAndFeel).DefaultTextColor);
}

defaultproperties
{
     WindowEnabled=True
}
