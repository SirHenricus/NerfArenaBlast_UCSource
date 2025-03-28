//=============================================================================
// PointEvent: Generate flowing point bonus in the air.
// 
// Usage:	1) In properties, set Object->initialstate to TargetPoints
//			2) Set the Event->tag to link with a trigger
//			3) Set the amount of bonus point under PointEvent in property
//			4) Make sure bPointTarget is true and Hitscore is NerfI.Hitpoint
//			5) PointTexture could be change but it's default as none. Use the
//			   200pt texture for now.	
//=============================================================================
class PointEvent extends SpecialEvent;

//-----------------------------------------------------------------------------
// Variables.

var() bool       bPointTarget; // Bonus Points target?
var() class<Hitpoint> Hitscore;    // Bonus points
var() int		 bonuspoints;
var() texture	 PointTexture;		// Point texture

//-----------------------------------------------------------------------------
// States.

// Play a sound.
state() TargetPoints
{
	function Trigger( actor Other, pawn EventInstigator )
	{
		local vector SLoc;
		local HitPoint bonus;

		if (EventInstigator  == None)
			return;						// DWG: FIXME: instant-hit weapons dont get score

		Global.Trigger( Self, EventInstigator );
		SLoc = Location;
		SLoc.Z += 50;
		
		bonus = spawn(Hitscore,Pawn(Other),'', SLoc);

		if (bonus != None)
		{

//##nerf WES FIXME
// We can set the skin or the sprite for the point display.
// Just use the following command if we have the art.
			bonus.texture=PointTexture;

			EventInstigator.PlayerReplicationInfo.score += bonusPoints;
			bonus.gotostate('Flowing');
		}
	}
}

defaultproperties
{
     bPointTarget=True
     Hitscore=Class'Engine.HitPoint'
}
