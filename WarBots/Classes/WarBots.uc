//=============================================================================
// WarBots.
//=============================================================================
class WarBots expands NerfBots
	abstract;

var StartGun    sg;


auto state StartUp
{
	function BeginState()
	{
		SetMovementPhysics(); 
		SetPhysics(PHYS_Falling);
	}

Begin:
log( self$" auto startup begin" );    // 9999
    LoopAnim('WarmUp');
   foreach AllActors(class'StartGun', sg )
        break;
    if ( sg == None )               // no startgun to start us up?
    {
        bReadyToRun = true;
log( self$" didn't see a startgun" );
        Level.Game.EquipPlayer(self);
    }

WaitForGun:
    if ( !bReadyToRun )
    {
        Sleep(0.1);
        Goto('WaitForGun');
    }
    SetPhysics(PHYS_Walking);
    TweenToFighter(0.1);
	WhatToDoNext('','');
}

defaultproperties
{
     Aggressiveness=0.100000
     AirControl=0.150000
}
