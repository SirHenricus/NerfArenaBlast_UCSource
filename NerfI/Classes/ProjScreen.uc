//=============================================================================
// ProjScreen
// geometry mappable screen for projected sprites
//
// Integrated by Wezo
//=============================================================================

class ProjScreen extends Effects;

function PreBeginPlay()
{
//##nerf WES FIXME
// It's just a test. Need to revisit.
	Mesh = mesh(DynamicLoadObject("NerfRes.M32Screen", class'Mesh'));
}

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Translucent
     bUnlit=True
}
