//  ================================================================================================
//   * File Name:    DTMainMenuMovie
//   * Created By:   qht
//   * Time Stamp:     2014/5/11 17:48:03
//   * UDK Path:   D:\UDK\UDK-2013-07
//   * Unreal X-Editor v3.1.5.0
//   * © Copyright 2012 - 2014. All Rights Reserved.
//  ================================================================================================

class DTMainMenuMovie extends GFxMoviePlayer;

var GFxCLIKWidget NewGameBtn,LoadGameBtn,ExitGameBtn,HighScoresBtn;

function bool Start(optional bool StartPaused=false)
{
    super.Start();
    Advance(0);
    `log("==start");
    return true;
}

event bool WidgetInitialized(name WidgetName,name WidgetPath,GFxObject Widget)
{
	`log("===aaaaaa");
    switch(WidgetName)
    {
        case 'NewGameBtn':
            NewGameBtn=GFxCLIKWidget(Widget);
            NewGameBtn.AddEventListener('CLIK_click',OnNewGameButtonPressed);
            break;
        case 'LoadGameBtn': 
            LoadGameBtn=GFxCLIKWidget(Widget);
            LoadGameBtn.AddEventListener('CLIK_click',OnLoadGameButtonPressed);
            break;
        case 'ExitGameBtn':
            ExitGameBtn=GFxCLIKWidget(Widget);
            ExitGameBtn.AddEventListener('CLIK_click',OnExitGameButtonPressed);
            break;
        case 'HighScoresBtn': 
            HighScoresBtn=GFxCLIKWidget(Widget);
            HighScoresBtn.AddEventListener('CLIK_click',OnHighScoresButtonPressed);
            break;
        default:
            return Super.WidgetInitialized(Widgetname, WidgetPath, Widget);
    }
    return true;
}


function OnNewGameButtonPressed(EventData EV)
{
    `log("===aaaaaa");
    ConsoleCommand("open TrainingSession_Map.udk");
}
 
function OnLoadGameButtonPressed(EventData EV)
{
    ConsoleCommand("open TrainingSession_Map");
}

function OnHighScoresButtonPressed(EventData EV)
{
    ConsoleCommand("open TrainingSession_Map");
}

function OnExitGameButtonPressed(EventData EV)
{
    if(EV.mouseIndex == 0)
    {
        // Close the UI
        Close();
    }
}

defaultproperties
{
    MovieInfo=SwfMovie'DeathTrap_Flash.MainMenu_Flash.MainMenu'
    WidgetBindings.Add((WidgetName="NewGameBtn",WidgetClass=class'GFxCLIKWidget'))
    WidgetBindings.Add((WidgetName="LoadGameBtn",WidgetClass=class'GFxCLIKWidget'))
    WidgetBindings.Add((WidgetName="HighScoresBtn",WidgetClass=class'GFxCLIKWidget'))
    WidgetBindings.Add((WidgetName="ExitGameBtn",WidgetClass=class'GFxCLIKWidget'))
    bDisplayWithHudOff=true
    TimingMode=TM_Real
    bPauseGameWhileActive=true
    bCaptureInput=true
    //bAllowInput=true
    //bAllowFocus=true
    
    
}