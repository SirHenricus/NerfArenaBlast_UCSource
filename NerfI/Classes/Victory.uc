//=============================================================================
// Victory
//
//=============================================================================
class Victory extends Actor;

#exec Texture Import NAME=S_Victory File=g:\NerfRes\NerfMesh\Textures\Victory.pcx Mips=Off Flags=2

// these will be moved to NerfRes
#exec TEXTURE IMPORT NAME=podium_ama FILE=g:\NerfRes\NerfMesh\Textures\podium_ama.PCX GROUP=Skins FLAGS=2	//skin
#exec TEXTURE IMPORT NAME=podium_sky FILE=g:\NerfRes\NerfMesh\Textures\podium_sky.PCX GROUP=Skins FLAGS=2	//skin
#exec TEXTURE IMPORT NAME=podium_ast FILE=g:\NerfRes\NerfMesh\Textures\podium_ast.PCX GROUP=Skins FLAGS=2	//skin
#exec TEXTURE IMPORT NAME=podium_seq FILE=g:\NerfRes\NerfMesh\Textures\podium_seq.PCX GROUP=Skins FLAGS=2	//skin
#exec TEXTURE IMPORT NAME=podium_lna FILE=g:\NerfRes\NerfMesh\Textures\podium_lna.PCX GROUP=Skins FLAGS=2	//skin
#exec TEXTURE IMPORT NAME=podium_bar FILE=g:\NerfRes\NerfMesh\Textures\podium_bar.PCX GROUP=Skins FLAGS=2	//skin
#exec TEXTURE IMPORT NAME=podium_orb FILE=g:\NerfRes\NerfMesh\Textures\podium_orb.PCX GROUP=Skins FLAGS=2	//skin
#exec TEXTURE IMPORT NAME=podium_chm FILE=g:\NerfRes\NerfMesh\Textures\podium_chm.PCX GROUP=Skins FLAGS=2	//skin

#exec OBJ LOAD FILE=..\sounds\Victory.uax


// publics
var() name			    EndPathTag;
var() int               TimeToAdmire;
var() float				papos[3];
var() float				panam[3];

// privates
var class<podium01>     CP1;
var class<podium02>     CP2;
var podium01            P1;
var podium02            P2;
var Texture             PodSkin;    
var int                 ixSkin;     
var string              SkinName[8];
var InterpolationPoint	IP;
var	vector			    vPodiumA;
var	vector			    vPodiumB;
var vector              vPodSpot[3];
var Pawn				Candidate[16];
var Pawn                Puppet;
var Pawn                StandIn;
var int					Score[16];
var sound				PAPosition[3];
var string				StrName[32];
var sound				PAName[3];
var sound				Cheer;
var int					PAStep;

var float				offset;
											
function PostBeginPlay()
{
    local vector    v;
    local rotator   r;

    Super.PostBeginPlay();

	PAPosition[0] = Sound(DynamicLoadObject("Victory.pawn", class'Sound'));		// and the winner is...
	PAPosition[1] = Sound(DynamicLoadObject("Victory.pawn2", class'Sound'));	// 2nd place is...
	PAPosition[2] = Sound(DynamicLoadObject("Victory.pawn3", class'Sound'));	// 3rd place is...
	Cheer = Sound(DynamicLoadObject("Victory.wincheer", class'Sound'));

// all locations relative to V icon
	vPodiumA = Location;
	vPodiumB = Location;
    vPodSpot[0] = Location;
    vPodSpot[1] = Location;
    vPodSpot[2] = Location;

	vPodiumA.z += 100.0;
	vPodiumB.z += 56.0;
    vPodSpot[0].z += 260.0;
    vPodSpot[1].z += 150.0;
    vPodSpot[2].z += 150.0;

    r = Rotation;
    r.Yaw += 16384;     // quarter turn for unreal's 'max front'
    v = vector(r);
    vPodSpot[1] += ( v * offset );   // to the 'left'
    vPodSpot[2] += ( v * -offset );   // to the 'right'

	if ( EndPathTag != '' )
	{
		foreach AllActors( class'InterpolationPoint', IP, EndPathTag )
			if ( IP.Position == 0 )
				break;
	}
	if ( IP == None )
		log( self$": no EndPathTag with Position 0" );
}


function Swap( int L, int R )
{
    local Pawn tmpPawn;
    local int  tmpScore;

    tmpPawn = Candidate[L];
    tmpScore = Score[L];

    Candidate[L] = Candidate[R];
    Score[L] = Score[R];

    Candidate[R] = tmpPawn;
    Score[R] = tmpScore;
}


function SortScores(int N)
{
	local int I, J, Max;
	
	for ( I=0; I<N-1; I++ )
	{
		Max = I;
		for ( J=I+1; J<N; J++ )
			if (Score[J] > Score[Max])
				Max = J;
		Swap( Max, I );
	}
}


function Trigger( actor Other, pawn Instigator )
{
    local PlayerReplicationInfo PRI;
    local rotator   r;
    local Pawn      P;
	local int		ixCount;
    local int       i;
	local string	winstr;
    local string    CurrentLevel;

    Disable( 'Trigger' );

    if ( Level.NetMode != NM_Standalone )
    {
    	for ( P=Level.PawnList; P!=None; P=P.NextPawn )
    	{
            if ( P.IsA('PlayerPawn') )
                P.GotoState('GameEnded');
        }
        return;
    }

    CP1 = class<podium01>(DynamicLoadObject("NerfI.podium01", class'Class'));
    CP2 = class<podium02>(DynamicLoadObject("NerfI.podium02", class'Class'));

    P1 = spawn( CP1,,,vPodiumA );
    P2 = spawn( CP2,,,vPodiumB );

// podium faces same as V icon
    r.Pitch = 0;
    r.Roll = 0;
    r.Yaw = Rotation.Yaw+16384;
    P1.SetRotation(r);
    P2.SetRotation(r);

    P1.bBlockActors=true;
    P1.bBlockPlayers=true;
    P1.bCollideWorld=true;
    P1.SetCollision(true,true,true);
    P2.bBlockActors=true;
    P2.bBlockPlayers=true;
    P2.bCollideWorld=true;
    P2.SetCollision(true,true,true);

// decorate podium with crepe paper
    ixSkin = int(Level.BotTeam);

    CurrentLevel=Level.GetLocalURL();
    if ( CurrentLevel != "" )
        CurrentLevel = Left( CurrentLevel, InStr(CurrentLevel, "." ));
    if ( CurrentLevel ~= "PM_Champion" )
        ixSkin = 7;
    PodSkin = Texture(DynamicLoadObject(SkinName[ixSkin], class'Texture'));
    P1.Skin = PodSkin;
    P2.Skin = PodSkin;
    P1.AmbientGlow = 64;
    P2.AmbientGlow = 64;
 

	ixCount = 0;
    for ( i = 0; i < 16; i++ )
    {
        Candidate[i] = None;
        Score[i] = -500;   
    }


    foreach AllActors( class'PlayerReplicationInfo', PRI )
    {
        if ( !PRI.bIsSpectator )
        {
            Candidate[ixCount] = Pawn(PRI.Owner);
            Score[ixCount] = PRI.Score;
            ixCount++;
        }
    }
	SortScores( ixCount );


	for ( P=Level.PawnList; P!=None; P=P.NextPawn )
	{
		if ( !P.PlayerReplicationInfo.bIsSpectator )
		{
            if ( P.IsA('PlayerPawn') )
                PlayerPawn(P).bFixedCamera = true;
            P.PendingWeapon = None;
            P.Weapon = None;
//log( self$" sending "$P$" to GameEnded" );
            if ( Level.Game.IsA( 'DeathMatchGame') || Level.Game.IsA('ArenaRaceGame') )
                P.GotoState('GameEnded');
		}
	}


    for ( i = 0; i < 3; i++ )
    {
        if ( Candidate[i] != None )
        {
// build string to load candidates name
			winstr = "Victory."$StrName[int(Candidate[i].PlayerReplicationInfo.BotIndex)];
//log( self$" Winstr "$i$" is "$winstr);
			PAName[i] = Sound(DynamicLoadObject(winstr, class'Sound'));
            Candidate[i].Velocity = vect(0,0,0);
            Candidate[i].Acceleration = vect(0,0,0);
            Candidate[i].DesiredRotation = Rotation;
            Candidate[i].SetRotation(Rotation);
            Candidate[i].SetLocation(vPodSpot[i]);

            Candidate[i].SetCollision(true,true,true);
            Candidate[i].Style = Candidate[i].Default.Style;
            Candidate[i].bHidden = false;
            Candidate[i].SetPhysics(PHYS_Falling);

            Candidate[i].GotoState('TakeABow');
//log( self$" sending "$Candidate[i]$" to vPodSpot "$i );
        }
    }

    for ( i = 3; i < 16; i++ )
    {
        if ( Candidate[i] != None )
        {
            if ( Candidate[i].IsA('NerfBots') ) 
            {
//log( self$" Removing "$Candidate[i] );
                Candidate[i].bHidden = true;
            }
        }
    }


	if ( IP != None )
    {
        for ( Puppet=Level.PawnList; Puppet!=None; Puppet=Puppet.NextPawn )
        {
            if ( Puppet.IsA('NerfIPlayer') )
            {
                NerfIPlayer(Puppet).bFixedCamera = false;
                NerfIPlayer(Puppet).bFrozen = false;
                StandIn = spawn( class'NerfSpectator',,,Puppet.Location );
                 StandIn.GotoState('');
                 StandIn.SetCollision(True,false,false);
                 StandIn.bCollideWorld = False;
                 StandIn.Target = IP;
                 StandIn.SetPhysics(PHYS_Interpolating);
                 StandIn.PhysRate = 1.0;
                 StandIn.PhysAlpha = 0.0;
                 StandIn.bInterpolating = true;
                PlayerPawn(Puppet).ViewTarget = StandIn;
            }
        }
    }
    DeathMatchGame(Level.Game).RemainingTime = TimeToAdmire;
    DeathMatchGame(Level.Game).bGameEnded = false;
	SetTimer( 0.1, false );		// initiate PAStep
}


simulated function Timer()
{
	local Sound S1, S2;
	local float delay;
	local ESoundSlot slt;

    S1 = None;
	S2 = None;
    delay = 0;
	switch( PAStep )
	{
		case 0:                         // in first place...
			S1 = PAPosition[0];
			delay = papos[0];
			break;		
		case 1:
			S1 = PAName[0];
			S2 = Cheer;
			slt = SLOT_Interact;
			delay = panam[0];
			break;		
		case 2:                         // in second place....
            if ( PAName[1] != None )    // is there silver?
            {
    			S1 = PAPosition[1];
    			delay = papos[1];
            }
			break;		
		case 3:
			S1 = PAName[1];
			S2 = Cheer;
			slt = SLOT_Talk;
			delay = panam[1];
			break;		
		case 4:                         // in third place...
            if ( PAName[2] != None )    // is there bronze?
            {
    			S1 = PAPosition[2];
    			delay = papos[2];
            }
			break;		
		case 5:
			S1 = PAName[2];
			S2 = Cheer;
			slt = SLOT_Interact;
			delay = panam[2];
			break;
		default:
            DeathMatchGame(Level.Game).bGameEnded = true;
            DeathMatchGame(Level.Game).RemainingTime = -1;
			S1 = None;
			delay = 0;
			disable('Timer');
			break;
	}

	if ( (S1 != None) && (delay > 0) )
	{
		PlaySound(S1, SLOT_Interface, 16, true, 1000000 );
		if ( S2 != None )
		{
			PlaySound(S2, slt, 16, true, 1000000 );
		}
		SetTimer(delay,false);
	}
	PAStep++;
}

defaultproperties
{
     TimeToAdmire=40
     papos(0)=3.200000
     papos(1)=2.500000
     papos(2)=2.500000
     panam(0)=3.500000
     panam(1)=3.500000
     panam(2)=3.500000
     SkinName(0)=NerfI.podium_ama
     SkinName(1)=NerfI.podium_sky
     SkinName(2)=NerfI.podium_ast
     SkinName(3)=NerfI.podium_seq
     SkinName(4)=NerfI.podium_lna
     SkinName(5)=NerfI.podium_bar
     SkinName(6)=NerfI.podium_orb
     SkinName(7)=NerfI.podium_chm
     StrName(0)=pawnted
     StrName(1)=pawnjmi
     StrName(2)=pawnryn
     StrName(3)=pawnsrg
     StrName(4)=pawnhop
     StrName(5)=pawntod
     StrName(6)=pawnwlm
     StrName(7)=pawnjus
     StrName(8)=pawnjud
     StrName(9)=pawnoma
     StrName(10)=pawnrils
     StrName(11)=pawnsam
     StrName(12)=pawntre
     StrName(13)=pawnwat
     StrName(14)=pawngrn
     StrName(15)=pawnrab
     StrName(16)=pawnjam
     StrName(17)=pawnphe
     StrName(18)=pawnbri
     StrName(19)=pawncal
     StrName(20)=pawnjon
     StrName(21)=pawntry
     StrName(22)=pawnrog
     StrName(23)=pawnlori
     StrName(24)=pawnnwt
     StrName(25)=pawnfra
     StrName(26)=pawnmry
     StrName(27)=pawngeo
     StrName(28)=pawnjan
     StrName(29)=pawnwes
     StrName(30)=pawnvin
     StrName(31)=pawnshr
     Offset=135.000000
     bHidden=True
     Tag=EndGame
     bDirectional=True
     Texture=Texture'NerfI.S_Victory'
}
