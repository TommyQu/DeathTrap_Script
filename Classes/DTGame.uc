//  ================================================================================================
//   * File Name:    DTGame
//   * Created By:   qht
//   * Time Stamp:     2014/5/7 11:25:54
//   * UDK Path:   D:\UDK\UDK-2013-07
//   * Unreal X-Editor v3.1.5.0
//   * © Copyright 2012 - 2014. All Rights Reserved.
//  ================================================================================================

class DTGame extends UTDeathMatch;

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    GoalScore=0;
}

defaultproperties
{
    DefaultPawnClass=class'DeathTrap_Script.DTPawn'
    PlayerControllerClass=class'DeathTrap_Script.DTPlayerController'
}