class NerfWeaponPriorityMesh expands UWindowDialogClientWindow;

var NerfMeshActor MeshActor;
var Rotator R;

function Created()
{
	Super.Created();

	MeshActor = GetPlayerOwner().Spawn(class'NerfMeshActor', GetPlayerOwner());
	MeshActor.Mesh = None;
	MeshActor.Skin = None;
	MeshActor.DrawScale=0.07;
	MeshActor.AmbientGlow=255;
	MeshActor.ScaleGlow=3;
}

function Paint(Canvas C, float X, float Y) 
{
	local float OldFov;

	C.Style = GetPlayerOwner().ERenderStyle.STY_Modulated;
	C.Style = GetPlayerOwner().ERenderStyle.STY_Normal;

	if (MeshActor != None && MeshActor.Mesh != None)
	{
		OldFov = GetPlayerOwner().FOVAngle;
		GetPlayerOwner().SetFOVAngle(30);
		DrawClippedActor(C, WinWidth/2, WinHeight/2, MeshActor, False, R, vect(0, 0, 0));
		GetPlayerOwner().SetFOVAngle(OldFov);
	}
}

function Tick(float DeltaTime)
{
	R.Yaw = (R.Yaw + DeltaTime * 16384) & 65535;
}


function Close(optional bool bByParent)
{
	Super.Close(bByParent);
	if(MeshActor != None)
	{
		MeshActor.Destroy();
		MeshActor = None;
	}
}

defaultproperties
{
}
