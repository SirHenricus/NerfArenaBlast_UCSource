//=============================================================================
// Transporter.
//
// Integrated by Wezo
//=============================================================================
class Transporter extends NavigationPoint;

var() Vector Offset;

function Trigger( Actor Other, Pawn EventInstigator )
{
	local NerfIPlayer tempPlayer;

	// Move the player instantaneously by the Offset vector
	
	// Find the players
	foreach AllActors( class 'NerfIPlayer', tempPlayer )
	{	
		if( !tempPlayer.SetLocation( tempPlayer.Location + Offset ) )
		{
			// The player could not be moved, probably destination is inside a wall
		}
	}

	Disable( 'Trigger' );
}

defaultproperties
{
}
