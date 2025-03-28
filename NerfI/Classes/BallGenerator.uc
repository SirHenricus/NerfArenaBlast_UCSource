//=============================================================================
// BallGenerator
//
// Created by Wezo
//=============================================================================
class BallGenerator extends Decoration;

function SpawnColorBall(int BallColor)
{
    local SHBallproj sb;
    local rotator r;
    local float dir;

	switch(BallColor)
	{
		case 1:	sb=Spawn(class'SHBBall');  		break;
		case 2:	sb=Spawn(class'SHGBall');		break;
		case 3:	sb=Spawn(class'SHYBall');		break;
		case 4:	sb=Spawn(class'SHOBall');		break;
		case 5:	sb=Spawn(class'SHRBall');		break;
		case 6:	sb=Spawn(class'SHPBall');		break;
		case 7:	sb=Spawn(class'SHGOBall');		break;
	}
// DSL minor adjustment of expulsion angle each time
    sb.SetRotation(Rotation);
    dir = 1000.0 + (FRand() * 500.0);   // somewhere between 1000 and 1500
    r = Rotation;
    r.Yaw = (r.Yaw + dir) % 65535;
    SetRotation(r);
}

defaultproperties
{
     bStatic=False
     bHidden=True
     DrawType=DT_Mesh
     Mesh=LodMesh'NerfI.SHBalls'
}
