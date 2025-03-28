//=============================================================================
// RotatingMover.
//
// Intergrated by Wezo at 7-7-99
//=============================================================================
class RotatingMover extends Mover;

var() rotator RotateRate;

function BeginPlay()
{
	Disable( 'Tick' );
}

function Tick( float DeltaTime )
{
	SetRotation( Rotation + (RotateRate*DeltaTime) );
}

function Trigger( Actor other, Pawn EventInstigator )
{
	Enable('Tick');
}

function UnTrigger( Actor other, Pawn EventInstigator )
{
	Disable('Tick');
}

defaultproperties
{
}
