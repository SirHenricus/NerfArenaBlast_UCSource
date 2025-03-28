//=============================================================================
// RockingSkyZoneInfo.
//
// Integrated by Wezo
//=============================================================================
class RockingSkyZoneInfo extends SkyZoneInfo;

function Tick(float DeltaTime)
{
	local rotator NewRot;

	Super.Tick(DeltaTime);

	NewRot.Pitch = Rotation.Pitch + 1024 * DeltaTime;
	NewRot.Roll  = Rotation.Roll;
	NewRot.Yaw   = Rotation.Yaw;

	SetRotation(NewRot);
}

defaultproperties
{
}
