//=============================================================================
// ScoreBoard
//=============================================================================
class ScoreBoard extends Info;

var font RegFont;
var HUD OwnerHUD;

function ShowScores( canvas Canvas );
function ShowMiniScores( Canvas Canvas );
function ShowIcons( canvas Canvas, bool LowRes );		// NERF:WES
function ShowTeamScores( canvas Canvas);

function PreBeginPlay()
{
}

defaultproperties
{
}
