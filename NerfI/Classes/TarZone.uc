// Integrated by Wezo
class TarZone extends ZoneInfo;

// When an actor enters this zone.
event ActorEntered( actor Other )
{
	Super.ActorEntered(Other);
	if ( Other.IsA('Pawn') && Pawn(Other).bIsPlayer )
		Pawn(Other).WaterSpeed *= 0.1;
}

// When an actor leaves this zone.
event ActorLeaving( actor Other )
{
	Super.ActorLeaving(Other);
	if ( Other.IsA('Pawn') && Pawn(Other).bIsPlayer )
		Pawn(Other).WaterSpeed *= 10;
}

defaultproperties
{
     ZoneFluidFriction=4.000000
     ZoneTerminalVelocity=250.000000
     bWaterZone=True
     ViewFlash=(X=-0.390000,Y=-0.390000,Z=-0.390000)
     ViewFog=(X=0.312500,Y=0.312500,Z=0.234375)
}
