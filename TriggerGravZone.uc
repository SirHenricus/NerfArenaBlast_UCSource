/////////////////////////////////////////////////////////////////////////
//	TriggerGravZone
//
//	Set the DesireGrav in the Editor. Normal zone value is -950 as default.
//
//  Trigger by GravZoneTrigger
// 
// Created by Wezo
/////////////////////////////////////////////////////////////////////////
class TriggerGravZone extends ZoneInfo;

var() float DesireGrav;

function Trigger( actor Other, pawn EventInstigator )
{
//	log(" ZoneTrigger " $ZoneGravity.Z);
	if (ZoneGravity.Z == -950)
		ZoneGravity.Z = DesireGrav;
	else 
		ZoneGravity.Z = -950;
}

defaultproperties
{
     DesireGrav=100.000000
}
