//=============================================================================
// VoxBox
//=============================================================================
class VoxBox expands Info;

#exec OBJ LOAD FILE=..\sounds\CharVO.uax
#exec OBJ LOAD FILE=..\sounds\PAFlag.uax
#exec OBJ LOAD FILE=..\sounds\PABall.uax

replication
{
   unreliable if( Role<ROLE_Authority )
       Speak, VJNewLeader, VJFlagEvent, VJBallEvent;
}

// DSL:
// implemented so far
// TAUNT_General        0
// TAUNT_GotYa          2
// TAUNT_Gloat          5   ( got ya good standing in for gloat )
//
// not implemented so far
// TAUNT_MissedMe,      1
// TAUNT_GotYaGood      3
// TAUNT_YouSlow        4
// TAUNT_GotMe          6

//=============data structs

struct TauntLine
{
    var Sound Line[4];          // room for up to four variations
};

struct TauntGroup
{
    var TauntLine Group[7];
};

// means of remembering what has been said recently so's we
// don't repeat ourselfs too often

struct TauntRecord
{
    var ETauntType  type;
    var bool	    gene;
    var int         ixline;
    var float       when;
};

//=============vars

var TauntGroup  MTwister;
var TauntGroup  FTwister;

var float       lastTaunt;
var TauntRecord tape[8];        // NOTE: should be tape[tapelen]
var int         tapeptr;
var int         tapelen;
//var string      TeamName[8];
var float       LastPATime;
var float       PADelay;
var sound       GenLead;
var sound       NLeader[32];
var string      NewLdrStr[32];
var EBotIndex   ixLastLeader;
// ballblast
var string      BallStr[4];
var sound       BallSnd[4];
// speedblast
var string      FlagStr[7];
var sound       FlagSnd[7];

//=============funcs

function PreBeginPlay()
{
    MTwister.Group[0].Line[0] = Sound'CharVO.tnttw01';
    MTwister.Group[0].Line[1] = Sound'CharVO.tnttw02';
    MTwister.Group[0].Line[2] = Sound'CharVO.tnttw03';
    MTwister.Group[0].Line[3] = Sound'CharVO.tnttw04';
    MTwister.Group[2].Line[0] = Sound'CharVO.tnttw05';
    MTwister.Group[2].Line[1] = Sound'CharVO.tnttw06';
    MTwister.Group[2].Line[2] = Sound'CharVO.tnttw07';
    MTwister.Group[2].Line[3] = Sound'CharVO.tnttw09';
    MTwister.Group[5].Line[0] = Sound'CharVO.tnttw10';
    MTwister.Group[5].Line[1] = Sound'CharVO.tnttw11';
    MTwister.Group[5].Line[2] = Sound'CharVO.tnttw12';
    MTwister.Group[5].Line[3] = Sound'CharVO.tnttw13';

    FTwister.Group[0].Line[0] = Sound'CharVO.tnttwf01';
    FTwister.Group[0].Line[1] = Sound'CharVO.tnttwf02';
    FTwister.Group[0].Line[2] = Sound'CharVO.tnttwf03';
    FTwister.Group[0].Line[3] = Sound'CharVO.tnttwf04';
    FTwister.Group[2].Line[0] = Sound'CharVO.tnttwf05';
    FTwister.Group[2].Line[1] = Sound'CharVO.tnttwf06';
    FTwister.Group[2].Line[2] = Sound'CharVO.tnttwf07';
    FTwister.Group[2].Line[3] = Sound'CharVO.tnttwf08';
    FTwister.Group[5].Line[0] = Sound'CharVO.tnttwf09';
    FTwister.Group[5].Line[1] = Sound'CharVO.tnttwf10';
    FTwister.Group[5].Line[2] = Sound'CharVO.tnttwf11';
    FTwister.Group[5].Line[3] = Sound'CharVO.tnttwf12';

    BallSnd[0] = Sound'PABall.paslmdnk';
    BallSnd[1] = Sound'PABall.pabull';
    BallSnd[2] = Sound'PABall.pagold';
    BallSnd[3] = Sound'PABall.paball7';

    FlagSnd[0] = Sound'PAFlag.paflag1';
    FlagSnd[1] = Sound'PAFlag.paflag2';
    FlagSnd[2] = Sound'PAFlag.paflag3';
    FlagSnd[3] = Sound'PAFlag.paflag4';
    FlagSnd[4] = Sound'PAFlag.paflag5';
    FlagSnd[5] = Sound'PAFlag.paflag6';
    FlagSnd[6] = Sound'PAFlag.paflag7';

    ixLastLeader = AKA_None;
}


// return FALSE if line has been recently used
// else TRUE = go ahead and say it
function bool CheckLog( ETauntType tt, int ix, bool g )
{
    local int j;
    for ( j = 0; j < tapelen; j++ )
    {
        if ( (tape[j].type == tt)
          && (tape[j].gene == g )
          && (tape[j].ixline == ix ) )
        return false;
    }

    return true;    
}


function Speak( Pawn P, ETauntType tt )
{
    local Sound         s;
    local ETeamType     t;
    local int           i;
    local EBotIndex     n;
    local bool       g;      

    local TauntGroup    tg;
    local bool          bGo;
    
    t = P.PlayerReplicationInfo.TeamType;
    n = P.PlayerReplicationInfo.BotIndex;
    g = P.PlayerReplicationInfo.bIsFemale;

//log( "DSL - About to Speak" );
// let's not get too chatty if we are a bot

    if ( P.IsA('NerfBots') )
    {
//log( "VOX: I'm a bot, so I might be censored" );
        if ( (Level.TimeSeconds - lastTaunt) < 24.0  )
            return;
    }

    i = Rand( 3 );                  // pick a line, any line

    tg = MTwister;                  // default to male voices
    if ( g )
        tg = FTwister;              // else female

    bGo = CheckLog( tt, i, g );     // are we about to repeat ourselves?
    if ( !bGo )                     // yes, try one more time
    {
        i = Rand( 3 );  
        if ( i > 3 ) i = 0;
    }
    bGo = CheckLog( tt, i, g );

    if ( bGo )
    {
        s = tg.Group[tt].Line[i];

        if ( s != None )
        {
//BroadcastMessage( "Now speaking: "$P.Name$" of the "$TeamName[t] );
            P.PlaySound( s, SLOT_None, 12.0, true );
            lastTaunt = Level.TimeSeconds;
// make a record of our recent voicings
            tape[tapeptr].when = Level.TimeSeconds;
            tape[tapeptr].type = tt;
            tape[tapeptr].ixline = i;
            tape[tapeptr].gene = g;
            tapeptr++;
            if ( tapeptr >= tapelen )      // wrap recordhead
                tapeptr = 0;
        }
    }
}


// PA announces who has just taken over the lead
//              a ball has just been scored by player
//              gold ball in play
//              flag reached
// skip if previous announcement within last PADelay seconds



simulated function VJNewLeader( EBotIndex ixLeader )
{
    local sound S;
    local string rsrc;

// assume we'll fall back to generic
    S = None;

// has enough time passed since our last announcement?
    if  ( Level.TimeSeconds > (LastPATime + PADelay) && (ixLeader != ixLastLeader) )
    {
// did we receive a valid index?
        if ( ixLeader < 32 && ixLeader > -1 )
        {
            S = NLeader[ixLeader];
// was the sound already loaded?
            if ( S == None )            // no, bring it on board
            {
                rsrc = "PALead."$NewLdrStr[ixLeader];
                S = Sound(DynamicLoadObject(rsrc,class'Sound'));
                NLeader[ixLeader] = S;
            }
        }
        
        if ( S == None ) S = GenLead;
        PlaySound( S, SLOT_None, 16, true, 1000000 );
        LastPATime = Level.TimeSeconds;
        ixLastLeader = ixLeader;
    }
}


function VJBallEvent( EBallEvent ixEvent )
{
    local sound         S;
    local string        rsrc;
    local ESoundSlot    slot;

    if  ( ixEvent == BE_Gold
        || ixEvent == BE_Ball7
        || Level.TimeSeconds > (LastPATime + PADelay) )
    {
// did we receive a valid index?
        if ( ixEvent < 4 && ixEvent > -1 )
        {
//log( "DSL - About to Announce Ball event" );
            S = BallSnd[ixEvent];
// was the sound already loaded?
            if ( S == None )            // no, bring it on board
            {
                rsrc = "PABall."$BallStr[ixEvent];
                S = Sound(DynamicLoadObject(rsrc,class'Sound'));
                BallSnd[ixEvent] = S;
            }
        
            slot = SLOT_None;           // lowest priority
            if ( ixEvent == BE_Gold || ixEvent == BE_Ball7 )
                slot = SLOT_Interface;  // highest priority

            if ( S != None )
            {
                PlaySound( S, slot, 16, true, 1000000 );
                LastPATime = Level.TimeSeconds;
            }
        }
    }
}


function VJFlagEvent( int ixFlag )
{
    local sound         S;
    local string        rsrc;

    if  ( ixFlag > 5
        || Level.TimeSeconds > (LastPATime + PADelay) )
    {
// did we receive a valid index?
        if ( ixFlag < 8 && ixFlag > -1 )
        {
//log( "DSL - About to Announce Flag event" );
            S = FlagSnd[ixFlag];
// was the sound already loaded?
            if ( S == None )            // no, bring it on board
            {
                rsrc = "PAFlag."$FlagStr[ixFlag];
                S = Sound(DynamicLoadObject(rsrc,class'Sound'));
                FlagSnd[ixFlag] = S;
            }
        
            if ( S != None )
            {
                PlaySound( S, SLOT_Talk, 16, true, 1000000 );
                LastPATime = Level.TimeSeconds;
            }
        }
    }
}


/*
intrinsic(264) final function PlaySound
(
	sound				Sound,
	optional ESoundSlot Slot,
	optional float		Volume,
	optional bool		bNoOverride,
	optional float		Radius,
	optional float		Pitch
);

     SLOT_None,
     SLOT_Misc,
     SLOT_Pain,
     SLOT_Interact,
     SLOT_Ambient,
     SLOT_Talk,
     SLOT_Interface,

*/

defaultproperties
{
     tapelen=6
     PADelay=7.000000
     NewLdrStr(0)=paldrted
     NewLdrStr(1)=paldrjmi
     NewLdrStr(2)=paldrryn
     NewLdrStr(3)=paldrsrg
     NewLdrStr(4)=paldrhop
     NewLdrStr(5)=paldrtod
     NewLdrStr(6)=paldrwlm
     NewLdrStr(7)=paldrjus
     NewLdrStr(8)=paldrjud
     NewLdrStr(9)=paldroma
     NewLdrStr(10)=paldrril
     NewLdrStr(11)=paldrsam
     NewLdrStr(12)=paldrtre
     NewLdrStr(13)=paldrwat
     NewLdrStr(14)=paldrgrn
     NewLdrStr(15)=paldrrab
     NewLdrStr(16)=paldrjam
     NewLdrStr(17)=paldrphe
     NewLdrStr(18)=paldrbri
     NewLdrStr(19)=paldrcal
     NewLdrStr(20)=paldrjon
     NewLdrStr(21)=paldrtry
     NewLdrStr(22)=paldrrog
     NewLdrStr(23)=paldrlri
     NewLdrStr(24)=paldrnwt
     NewLdrStr(25)=paldrfra
     NewLdrStr(26)=paldrmry
     NewLdrStr(27)=paldrgeo
     NewLdrStr(28)=paldrjan
     NewLdrStr(29)=paldrwes
     NewLdrStr(30)=paldrvin
     NewLdrStr(31)=paldrshr
     BallStr(0)=paslmdnk
     BallStr(1)=pabull
     BallStr(2)=pagold
     BallStr(3)=paball7
     FlagStr(0)=paflag1
     FlagStr(1)=paflag2
     FlagStr(2)=paflag3
     FlagStr(3)=paflag4
     FlagStr(4)=paflag5
     FlagStr(5)=paflag6
     FlagStr(6)=paflag7
}
