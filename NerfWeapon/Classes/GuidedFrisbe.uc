//=============================================================================
// GuidedFrisbe.
//=============================================================================
class GuidedFrisbe expands side_cd;

var Pawn Guider;
var rotator OldGuiderRotation, GuidedRotation;
var float CurrentTimeStamp, LastUpdateTime,ClientBuffer;
var bool bUpdatePosition;
var bool bDestroyed;

var SavedMove SavedMoves;
var SavedMove FreeMoves;

var vector RealLocation, RealVelocity;
var bool bCanHitOwner;


replication
{
	// Things the server should send to the client.
	unreliable if( Role==ROLE_Authority )
		ClientAdjustPosition, bDestroyed;
	unreliable if ( Role==ROLE_Authority && bNetOwner && bNetInitial )
		GuidedRotation, OldGuiderRotation;
	unreliable if( Role==ROLE_Authority && !bNetOwner )
		RealLocation, RealVelocity;
	unreliable if( Role==ROLE_AutonomousProxy )
		ServerMove;
}

simulated function Destroyed()
{
	local sidewind W;

	bDestroyed = true;
	if ( (PlayerPawn(Guider) != None) )
		PlayerPawn(Guider).ViewTarget = None;

	While ( FreeMoves != None )
	{
		FreeMoves.Destroy();
		FreeMoves = FreeMoves.NextMove;
	}

	While ( SavedMoves != None )
	{
		SavedMoves.Destroy();
		SavedMoves = SavedMoves.NextMove;
	}

	if ( (Guider != None) && (Level.NetMode != NM_Client) )
	{
		W = sidewind(Guider.FindInventoryType(class'sidewind'));
		if ( W != None )
		{
			W.GFrisbe = None;
			W.GotoState('Finishing');
		}
	}
	Super.Destroyed();
}

simulated function Tick(float DeltaTime)
{
	local int DeltaYaw, DeltaPitch;
	local int YawDiff, PitchDiff;
	local SavedMove NewMove;

	Super.Tick(DeltaTime);
	if ( Level.NetMode == NM_Client )
	{
		if ( (PlayerPawn(Instigator) != None) && (ViewPort(PlayerPawn(Instigator).Player) != None) )
		{
			Guider = Instigator;
			if ( bDestroyed || (Instigator.health < 0) )
			{
				PlayerPawn(Instigator).ViewTarget = None;
				Destroy();
				if ( Instigator.Weapon.IsA('sidewind') )
					sidewind(Instigator.Weapon).bGuiding = false;
				return;
			}
			PlayerPawn(Instigator).ViewTarget = self;
			if ( Instigator.Weapon.IsA('sidewind') )
			{
				sidewind(Instigator.Weapon).GFrisbe = self;
				sidewind(Instigator.Weapon).bGuiding = true;
			}
		}
		else
		{
			if ( RealLocation != vect(0,0,0) )
			{
				SetLocation(RealLocation);
				RealLocation = vect(0,0,0);
			}
			if ( RealVelocity != vect(0,0,0) )
			{
				Velocity = RealVelocity;
				SetRotation(rotator(Velocity));
				RealVelocity = vect(0,0,0);
			}
			return;
		}
	}
	else if ( (Level.NetMode != NM_Standalone) && (RemoteRole == ROLE_AutonomousProxy) ) 
			return;
	// if server updated client position, client needs to replay moves after the update
	if ( bUpdatePosition )
		ClientUpdatePosition();

	DeltaYaw = (Guider.ViewRotation.Yaw & 65535) - (OldGuiderRotation.Yaw & 65535);
	DeltaPitch = (Guider.ViewRotation.Pitch & 65535) - (OldGuiderRotation.Pitch & 65535);
	if ( DeltaPitch < -32768 )
		DeltaPitch += 65536;
	else if ( DeltaPitch > 32768 )
		DeltaPitch -= 65536;
	if ( DeltaYaw < -32768 )
		DeltaYaw += 65536;
	else if ( DeltaYaw > 32768 )
		DeltaYaw -= 65536;

	YawDiff = (Rotation.Yaw & 65535) - (GuidedRotation.Yaw & 65535) - DeltaYaw;
	if ( DeltaYaw < 0 )
	{
		if ( ((YawDiff > 0) && (YawDiff < 16384)) || (YawDiff < -49152) )
			GuidedRotation.Yaw += DeltaYaw;
	}	
	else if ( ((YawDiff < 0) && (YawDiff > -16384)) || (YawDiff > 49152) )
		GuidedRotation.Yaw += DeltaYaw;

	GuidedRotation.Pitch += DeltaPitch;
	OldGuiderRotation = Guider.ViewRotation;
	if ( Role == ROLE_AutonomousProxy )
	{
		// Send the move to the server
		// skip move if too soon
		if ( ClientBuffer < 0 )
		{
			ClientBuffer += DeltaTime;
			MoveDisc(DeltaTime, Velocity, GuidedRotation);
			return;
		}
		else
			ClientBuffer = ClientBuffer + DeltaTime - 80.0/PlayerPawn(Instigator).Player.CurrentNetSpeed;

		// I'm  a client, so I'll save my moves in case I need to replay them
		// Get a SavedMove actor to store the movement in.
		if ( SavedMoves == None )
		{
			SavedMoves = GetFreeMove();
			NewMove = SavedMoves;
		}
		else
		{
			NewMove = SavedMoves;
			while ( NewMove.NextMove != None )
				NewMove = NewMove.NextMove;
			NewMove.NextMove = GetFreeMove();
			NewMove = NewMove.NextMove;
		}

		NewMove.TimeStamp = Level.TimeSeconds;
		NewMove.Delta = DeltaTime;
		NewMove.Velocity = Velocity;
		NewMove.SetRotation(GuidedRotation);

		MoveDisc(DeltaTime, Velocity, GuidedRotation);
		ServerMove(Level.TimeSeconds, Location, NewMove.Rotation.Pitch, NewMove.Rotation.Yaw);
		return;
	}
	MoveDisc(DeltaTime, Velocity, GuidedRotation);
}

// Server sends ClientAdjustPosition to the client to adjust the warhead position on the client side when the error
// is excessive
simulated function ClientAdjustPosition
(
	float TimeStamp, 
	float NewLocX, 
	float NewLocY, 
	float NewLocZ, 
	float NewVelX, 
	float NewVelY, 
	float NewVelZ
)
{
	local vector NewLocation;

	if ( CurrentTimeStamp > TimeStamp )
		return;
	CurrentTimeStamp = TimeStamp;

	NewLocation.X = NewLocX;
	NewLocation.Y = NewLocY;
	NewLocation.Z = NewLocZ;
	Velocity.X = NewVelX;
	Velocity.Y = NewVelY;
	Velocity.Z = NewVelZ;

	SetLocation(NewLocation);

	bUpdatePosition = true;
}

// Client calls this to replay moves after getting its position updated by the server
simulated function ClientUpdatePosition()
{
	local SavedMove CurrentMove;
	local int realbRun, realbDuck;
	local bool bRealJump;

	bUpdatePosition = false;
	CurrentMove = SavedMoves;
	while ( CurrentMove != None )
	{
		if ( CurrentMove.TimeStamp <= CurrentTimeStamp )
		{
			SavedMoves = CurrentMove.NextMove;
			CurrentMove.NextMove = FreeMoves;
			FreeMoves = CurrentMove;
			FreeMoves.Clear();
			CurrentMove = SavedMoves;
		}
		else
		{
			MoveDisc(CurrentMove.Delta, CurrentMove.Velocity, CurrentMove.Rotation);
			CurrentMove = CurrentMove.NextMove;
		}
	}
}
	
// server moves the rocket based on clients input, and compares the resultant location to the client's view of the location
function ServerMove(float TimeStamp, vector ClientLoc, int Pitch, int Yaw)
{
	local float ClientErr, DeltaTime;
	local vector LocDiff;

	if ( CurrentTimeStamp >= TimeStamp )
		return;

	if ( CurrentTimeStamp > 0 )
		DeltaTime = TimeStamp - CurrentTimeStamp;
	CurrentTimeStamp = TimeStamp;
	GuidedRotation.Pitch = Pitch;
	GuidedRotation.Yaw = Yaw;
	if ( DeltaTime > 0 )	
		MoveDisc(DeltaTime, Velocity, GuidedRotation);
	if ( Level.TimeSeconds - LastUpdateTime > 0.3 )
	{
		ClientErr = 10000;
	}
	else if ( Level.TimeSeconds - LastUpdateTime > 0.07 )
	{
		LocDiff = Location - ClientLoc;
		ClientErr = LocDiff Dot LocDiff;
	}

	// If client has accumulated a noticeable positional error, correct him.
	if ( ClientErr > 3 )
	{
		LastUpdateTime = Level.TimeSeconds;
		ClientAdjustPosition(TimeStamp, Location.X, Location.Y, Location.Z, Velocity.X, Velocity.Y, Velocity.Z);
	}

	RealLocation = Location;
	RealVelocity = Velocity;
}

simulated function MoveDisc(float DeltaTime, vector CurrentVelocity, rotator GuideRotation )
{
	local int OldRoll, RollMag;
	local rotator NewRot;
	local float SmoothRoll;
	local vector OldVelocity, X,Y,Z;

	if ( (Role == ROLE_Authority) && (Guider.Health <= 0) )
	{
		Explode(Location,Vect(0,0,1));
		return;
	}

	OldRoll = Rotation.Roll & 65535;
	OldVelocity = CurrentVelocity;
	Velocity = CurrentVelocity + Vector(GuideRotation) * 1500 * DeltaTime;
	Velocity = Normal(Velocity) * 550;
	NewRot = Rotator(Velocity);

	// Roll Warhead based on acceleration
	GetAxes(NewRot, X,Y,Z);
	RollMag = int(10 * (Y Dot (Velocity - OldVelocity))/DeltaTime);
	if ( RollMag > 0 ) 
		NewRot.Roll = Min(12000, RollMag); 
	else
		NewRot.Roll = Max(53535, 65536 + RollMag);

	//smoothly change rotation
	if (NewRot.Roll > 32768)
	{
		if (OldRoll < 32768)
			OldRoll += 65536;
	}
	else if (OldRoll > 32768)
		OldRoll -= 65536;

	SmoothRoll = FMin(1.0, 5.0 * deltaTime);
	NewRot.Roll = NewRot.Roll * SmoothRoll + OldRoll * (1 - SmoothRoll);
	SetRotation(NewRot);

	if ( (Level.NetMode != NM_Standalone)
		&& ((Level.NetMode != NM_ListenServer) || (Instigator == None) 
			|| (Instigator.IsA('PlayerPawn') && (PlayerPawn(Instigator).Player != None)
				&& (ViewPort(PlayerPawn(Instigator).Player) == None))) )
		AutonomousPhysics(DeltaTime);
}

simulated function PostRender( canvas Canvas )
{
	local float Dist;
	local Pawn A;
	local int XPos, YPos;
	local Vector X,Y,Z, Dir;

	GetAxes(Rotation, X,Y,Z);
	Canvas.Font = Font(DynamicLoadObject("NerfRes.TinyRedFont", class'Font'));
	Canvas.Style = 2;
	foreach VisibleActors(class'Pawn', A, 1500)
	{
		Dir = A.Location - Location;
		Dist = VSize(Dir);
		Dir = Dir/Dist;
		if ( (Dir Dot X) > 0.7 )
		{
			XPos = 0.5 * Canvas.ClipX * (1 + 1.4 * (Dir Dot Y));
			YPos = 0.5 * Canvas.ClipY * (1 - 1.4 * (Dir Dot Z));
			Canvas.SetPos(XPos - 8, YPos - 8);
			Canvas.DrawIcon(texture'CrossHair6', 1.0);
			Canvas.SetPos(Xpos - 12, YPos + 8);
			Canvas.DrawText(Dist, true);
		}
	}	
	Canvas.Style = 1;
}		


simulated function SavedMove GetFreeMove()
{
	local SavedMove s;

	if ( FreeMoves == None )
		return Spawn(class'SavedMove');
	else
	{
		s = FreeMoves;
		FreeMoves = FreeMoves.NextMove;
		s.NextMove = None;
		return s;
	}	
}

auto state Flying
{

	simulated function HitWall (vector HitNormal, actor Wall)
	{
		if ( bCanHitInstigator || (Wall != Instigator) ) 
			Explode(Location,Normal(Location-Wall.Location));
	}

	simulated function ProcessTouch (Actor Other, Vector HitLocation)
	{
		if ((Other != instigator) || bCanHitOwner) 
			Explode(HitLocation,Normal(HitLocation-Other.Location));
	}

	function Timer()
	{
		bCanHitOwner = True;
	}

	function BeginState()
	{
		bCanHitOwner = False;
		GuidedRotation = Rotation;
		OldGuiderRotation = Rotation;
		Velocity = speed*vector(Rotation);
		Acceleration = vect(0,0,0);
		SetTimer(1.0, false);
		if ( (Level.NetMode != NM_Standalone) && (Role == ROLE_Authority) )
		{
			if ( (PlayerPawn(Instigator) != None) 
				&& (ViewPort(PlayerPawn(Instigator).Player) != None) )
				RemoteRole = ROLE_SimulatedProxy;
			else
				RemoteRole = ROLE_AutonomousProxy;
		}
	}
}

defaultproperties
{
     speed=600.000000
     MaxSpeed=800.000000
     Damage=100.000000
     RemoteRole=ROLE_DumbProxy
     LifeSpan=0.000000
     bBounce=False
     NetPriority=3.000000
}
