//=============================================================================
// Spawnpoint.
//Used by Creature Factories for spawning monsters
//=============================================================================
class SpawnPoint extends NavigationPoint;

//##nerf WES FIXME
// Need our own art. Will put in NerfRes later.
//#exec Texture Import File=Textures\SpwnAI.pcx Name=S_SpawnP Mips=Off Flags=2

var ThingFactory factory;

function bool Create()
{
	local pawn newcreature;
	local Actor pawnFactory;
	local pawn creature;
	local actor temp, A;
	local rotator newRot;

	if ( factory.bCovert && PlayerCanSeeMe() ) //make sure no player can see this
		return false;
	
	temp = Spawn(factory.prototype);
	if (temp == None)
		return false;
	newRot = rot(0,0,0);
	newRot.yaw = rotation.yaw;
	temp.SetRotation(newRot);
	temp.event = factory.tag;
	temp.tag = factory.itemtag;
	newcreature = pawn(temp);
	
	if( Event != '' )
		foreach AllActors( class 'Actor', A, Event )
			A.Trigger( Self, Instigator );
	if ( factory.bFalling )
		temp.SetPhysics(PHYS_Falling);
	if (newcreature == None)
		return true;

	pawnFactory = factory;
	if (pawnFactory == None)
	{
		log("Error - use creature factory to spawn pawns");
		return true;
	}
//##nerf WES FIXME
// Not spawning creatures.	
/*
	if (newcreature != None)
	{
		Actor(newcreature).Orders = pawnFactory.Orders;
		Actor(newcreature).OrderTag = pawnFactory.OrderTag;
		Actor(newcreature).SetEnemy(pawnFactory.enemy);
		Actor(newcreature).Alarmtag = pawnFactory.AlarmTag;
	}
	else 
		newcreature.enemy = pawnFactory.enemy;

	if (newcreature.enemy != None)
		newcreature.lastseenpos = newcreature.enemy.location;
	newcreature.SetMovementPhysics();
*/
	if ( newcreature.Physics == PHYS_Walking)
		newcreature.SetPhysics(PHYS_Falling);
	return true;
}

defaultproperties
{
     bDirectional=True
     SoundVolume=128
}
