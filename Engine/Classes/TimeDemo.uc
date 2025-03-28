//=============================================================================
// TimeDemo - calculate and display framerate
// This is a built-in Unreal class and it shouldn't be modified.
//=============================================================================
class TimeDemo extends Info
	native;

// Native
var int FileAr; // C++ FArchive*.

var float TimePassed;
var float TimeDilation;

var float StartTime;
var float LastSecTime;
var float LastCycleTime;
var float LastFrameTime;
var float SquareSum;

var int FrameNum;
var int FrameLastSecond;	// Frames in the last second
var int FrameLastCycle;		// Frames in the last cycle
var int CycleCount;
var int QuitAfterCycles;

var string CycleMessage;
var string CycleResult;

var bool bSaveToFile;
var bool bFirstFrame;

var float LastSec;
var float MinFPS;
var float MaxFPS;

var InterpolationPoint OldPoint;
var TimeDemoInterpolationPoint NewPoint;

var Console Console;

var font TimeDemoFont;

native final function OpenFile();
native final function WriteToFile( string Text );
native final function CloseFile();

function DoSetup( Console C, optional bool bSave, optional int QuitAfter )
{
	local InterpolationPoint	I;

	Console = C;
	bSaveToFile = bSave;
	QuitAfterCycles = QuitAfter;

	TimeDemoFont = font'Engine.MedFont';

	bFirstFrame = True;
	OldPoint = None;

	// Find the first interpolation point, and replace it with one of ours.
	foreach Console.ViewPort.Actor.AllActors( class 'InterpolationPoint', I, 'Path' )
	{
		if(I.Position == 0)
		{
			OldPoint = I;
			break;
		}
	}

	if(OldPoint != None)
	{

		Log("*************************");
		Console.Viewport.Actor.StartWalk();
		Console.Viewport.Actor.SetLocation(OldPoint.Location);

		// We've got a flyby sequence - break into it
		OldPoint.Tag = 'OldPath';

		NewPoint = Console.ViewPort.Actor.Spawn(class 'TimeDemoInterpolationPoint', OldPoint.Owner);
		NewPoint.SetLocation(OldPoint.Location);
		NewPoint.SetRotation(OldPoint.Rotation);
		NewPoint.Position = 0;
		NewPoint.RateModifier = OldPoint.RateModifier;
		NewPoint.bEndOfPath = OldPoint.bEndOfPath;
		NewPoint.Tag = 'Path';
		NewPoint.Next = OldPoint.Next;	
		NewPoint.Prev = OldPoint.Prev;	
		NewPoint.Prev.Next = NewPoint;	
		NewPoint.Next.Prev = NewPoint;	
		NewPoint.T = Self;
	}
}

function DoShutdown()
{
	local float Avg;
	local string AvgString;

	if(OldPoint != None)
	{
		NewPoint.Destroy();
		OldPoint.Tag = 'Path';
		OldPoint.Prev.Next = OldPoint;
		OldPoint.Next.Prev = OldPoint;
		OldPoint = None;
	}

	Avg = FrameNum / ((TimePassed - StartTime) / TimeDilation);
	AvgString = string(FrameNum)$" frames rendered in "$string((TimePassed - StartTime)/TimeDilation)$" seconds. "$string(Avg)$" FPS average.";
	Console.Viewport.Actor.ClientMessage(AvgString);
	Log(AvgString);
	Console.TimeDemo = None;
	Destroy();
}

function PostRender( canvas C )
{
	local float Avg, RMS;
	local float XL, YL;

	TimeDilation = Console.Viewport.Actor.Level.TimeDilation;

	if(bFirstFrame)
	{
		StartTime = TimePassed;
		LastSecTime = TimePassed;
		LastFrameTime = TimePassed;
		
		FrameNum = 0;
		FrameLastSecond = 0;
		FrameLastCycle = 0;
		CycleCount = 0;
	
		LastSec = 0;
		LastCycleTime = 0;
		CycleMessage = "";
		CycleResult = "";
	
		SquareSum = 0;

		MinFPS = 0;
		MaxFPS = 0;

		bFirstFrame = False;

		return;
	}

	FrameNum++;
	FrameLastSecond++;
	FrameLastCycle++;

	SquareSum = SquareSum + (LastFrameTime - TimePassed) * (LastFrameTime - TimePassed);
	RMS = 1 / sqrt(SquareSum / FrameNum);

	LastFrameTime = TimePassed;
	

	Avg = FrameNum / ((TimePassed - StartTime) / TimeDilation);
	
	if((TimePassed - LastSecTime) / TimeDilation > 1)
	{
		LastSec = FrameLastSecond / ((TimePassed - LastSecTime) / TimeDilation);
		FrameLastSecond = 0;
		LastSecTime = TimePassed;
	}

	if(LastSec < MinFPS || MinFPS == 0) MinFPS = LastSec;
	if(LastSec > MaxFPS) MaxFPS = LastSec;

	if(Console.ViewPort.Actor.bShowMenu) return;

	C.Font = TimeDemoFont;
	C.StrLen("TEST", XL, YL);
	C.SetPos(  0, 48 - YL);

	C.DrawText("Frame Rate Statistics");
	C.SetPos(  0, 48);

	C.DrawText("Average: ");
	C.SetPos(100, 48);

	C.DrawText(Avg$" FPS.");
	C.SetPos(  0, 48 + YL);

	C.DrawText("RMS: ");
	C.SetPos(100, 48 + YL);

	C.DrawText(RMS$" FPS.");
	C.SetPos(  0, 48 + YL*2);

	C.DrawText("Last Second:");
	C.SetPos(100, 48 + YL*2);

	C.DrawText(LastSec $ " FPS.");
	C.SetPos(  0, 48 + YL*3);

	C.DrawText("Lowest:");
	C.SetPos(100, 48 + YL*3);

	C.DrawText(MinFPS $ " FPS.");
	C.SetPos(  0, 48 + YL*4);

	C.DrawText("Highest:");
	C.SetPos(100, 48 + YL*4);

	C.DrawText(MaxFPS $ " FPS.");
	C.SetPos(  0, 48 + YL*5);

	C.DrawText(CycleMessage);
	C.SetPos(100, 48 + YL*5);

	C.DrawText(CycleResult);
}

function TickTimeDemo(float Delta)
{
	TimePassed = TimePassed + Delta;
}

function StartCycle()
{
	local string Temp;

	if(LastCycleTime == 0)
	{
		CycleMessage = "Cycle #1:";
		CycleResult = "Timing...";
	}
	else
	{
		CycleMessage = "Cycle #"$CycleCount$":";
		CycleResult = FrameLastCycle / ((TimePassed - LastCycleTime) / TimeDilation)
		                $" FPS ("$FrameLastCycle$" frames, "$
		                ((TimePassed - LastCycleTime) / TimeDilation)$" seconds)";

		Log("Cycle #"$CycleCount$": "
		                $FrameLastCycle / ((TimePassed - LastCycleTime) / TimeDilation)
		                $" FPS ("$FrameLastCycle$" frames, "$
		                ((TimePassed - LastCycleTime) / TimeDilation)$" seconds)");

		if(bSaveToFile)
		{
			OpenFile();
			Temp = string(int(100 * FrameLastCycle / ((TimePassed - LastCycleTime) / TimeDilation)));
			WriteToFile( Left(Temp, Len(Temp) - 2)$"."$Right(Temp, 2) $ " Unreal "$Console.Viewport.Actor.Level.EngineVersion);
			Temp = string(int(100 * MinFPS));
			WriteToFile(Left(Temp, Len(Temp) - 2)$"."$Right(Temp, 2) $ " Min");
			Temp = string(int(100 * MaxFPS));
			WriteToFile(Left(Temp, Len(Temp) - 2)$"."$Right(Temp, 2) $ " Max");
			CloseFile();
		}
		if( CycleCount == QuitAfterCycles )
			Console.Viewport.Actor.ConsoleCommand("exit");
	}
	LastCycleTime = TimePassed;
	FrameLastCycle = 0;
	CycleCount++;
}

defaultproperties
{
}
