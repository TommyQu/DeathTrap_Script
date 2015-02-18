class DTMainMenu extends GFxMoviePlayer;

var GFxObject menuTitle;

function bool Start(optional bool startPaused=false)
{
	super.Start();
	Advance(0);
	menuTitle=GetVariableObject("_root.menuTitle_txt");
	menuTitle.SetText("TrainingSession_Map");
	return true;
}

function flashToUDK(string dothis)
{
	ConsoleCommand(dothis);
}
