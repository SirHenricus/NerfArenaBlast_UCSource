//=============================================================================
// ShockWave.
//=============================================================================
class ShockWave extends Effects;

#exec MESH IMPORT MESH=ShockExp ANIVFILE=g:\NerfRes\WeaponEffects\ExpMesh\SExp_a.3D DATAFILE=g:\NerfRes\WeaponEffects\ExpMesh\SExp_d.3D X=0 Y=0 Z=0 
#exec MESH ORIGIN MESH=ShockExp X=0 Y=0 Z=0 YAW=0 PITCH=64
#exec MESH SEQUENCE MESH=ShockExp SEQ=All       STARTFRAME=0   NUMFRAMES=2
#exec MESH SEQUENCE MESH=ShockExp SEQ=Explosion STARTFRAME=0   NUMFRAMES=2
#exec MESH SEQUENCE MESH=ShockExp SEQ=Implode   STARTFRAME=0   NUMFRAMES=1
#exec MESHMAP SCALE MESHMAP=ShockExp X=1.0 Y=1.0 Z=2.0 
#exec MESHMAP SETTEXTURE MESHMAP=ShockExp NUM=0 TEXTURE=NerfWeapon.WhomProj1

var float OldShockDistance, ShockSize;
var int ExpRadius, MaxScale;

simulated function Tick( float DeltaTime )
{
	if ( Level.NetMode != NM_DedicatedServer )
	{
		ShockSize =  13 * (Default.LifeSpan - LifeSpan) + 3.5/(LifeSpan/Default.LifeSpan+0.05);
		ScaleGlow = Lifespan;
		AmbientGlow = ScaleGlow * 255;
		DrawScale = ShockSize;
//		log(class$ " WES: DrawScale" @DrawScale);
		if (DrawScale > MaxScale)
			Disable('Tick');
	}
}

simulated function Timer()
{

	local actor Victims;
	local float damageScale, dist, MoScale;
	local vector dir;

	ShockSize =  13 * (Default.LifeSpan - LifeSpan) + 3.5/(LifeSpan/Default.LifeSpan+0.05);
	if ( Level.NetMode != NM_DedicatedServer )
	{
		if ( Level.NetMode == NM_Client )
		{
//			foreach VisibleCollidingActors( class 'Actor', Victims, ShockSize*29, Location )
			foreach VisibleCollidingActors( class 'Actor', Victims, ExpRadius, Location )
				if ( Victims.Role == ROLE_Authority )
				{
					dir = Victims.Location - Location;
					dist = FMax(1,VSize(dir));
					dir = dir/dist +vect(0,0,0.3); 
					if ( (dist> OldShockDistance) || (dir dot Victims.Velocity <= 0))
					{
						MoScale = FMax(0, 1100 - 1.1 * Dist);
						Victims.Velocity = Victims.Velocity + dir * (MoScale + 20);	
						Victims.TakeDamage
						(
							MoScale,
							Instigator, 
							Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir,
							(1000 * dir),
							'vaporized'
						);
					}
				}	
			return;
		}
	}

//	foreach VisibleCollidingActors( class 'Actor', Victims, ShockSize*29, Location )
	foreach VisibleCollidingActors( class 'Actor', Victims, ExpRadius, Location )
	{
		dir = Victims.Location - Location;
		dist = FMax(1,VSize(dir));
		dir = dir/dist + vect(0,0,0.3); 
		if (dist> OldShockDistance || (dir dot Victims.Velocity < 0))
		{
			MoScale = FMax(0, 1100 - 1.1 * Dist);
			if ( Victims.bIsPawn )
				Pawn(Victims).AddVelocity(dir * (MoScale + 20));
			else
				Victims.Velocity = Victims.Velocity + dir * (MoScale + 20);	
			Victims.TakeDamage
			(
				MoScale,
				Instigator, 
				Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir,
				(300 * dir),
				'vaporized'
			);
		}
	}	
	OldShockDistance = ExpRadius;	
}

simulated function PostBeginPlay()
{
	local Pawn P;

	if ( Role == ROLE_Authority ) 
	{
		for ( P=Level.PawnList; P!=None; P=P.NextPawn )
			if ( P.IsA('PlayerPawn') && (VSize(P.Location - Location) < ExpRadius) )
				PlayerPawn(P).ShakeView(0.5, 6000.0/VSize(P.Location - Location), 10);

		if ( Instigator != None )
			MakeNoise(10.0);
	}

	SetTimer(0.1, True);
}

defaultproperties
{
     ExpRadius=250
     MaxScale=5
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=0.500000
     DrawType=DT_Mesh
     Style=STY_Translucent
     Mesh=LodMesh'NerfWeapon.ShockExp'
     AmbientGlow=255
     bUnlit=True
}
