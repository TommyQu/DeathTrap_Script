//  ================================================================================================
//   * File Name:    DTPlayerController
//   * Created By:   qht
//   * Time Stamp:     2014/5/7 11:27:11
//   * UDK Path:   D:\UDK\UDK-2013-07
//   * Unreal X-Editor v3.1.5.0
//   * © Copyright 2012 - 2014. All Rights Reserved.
//  ================================================================================================

class DTPlayerController extends UTPlayerController;
var class<UTFamilyInfo> CharacterClass;

function CreateStartMenu()
{
}

simulated event PostBeginPlay()
{
    //local string MapName;
    super.PostBeginPlay();
    //MapName=WorldInfo.GetMapName();
    //if(MapName=="MainMenu")
    //{
    //    CreateStartMenu();
    //}
    SetupPlayerCharacter();
}

function SetupPlayerCharacter()
{
  //Set character to our custom character
  ServerSetCharacterClass(CharacterClass);
}

reliable client function ClientSetHUD(class<HUD> newHUDType)
{
    if(myHUD!=none)
        myHUD.Destroy();
    myHUD=spawn(class'DTHUD',self);
}

defaultproperties
{
    CharacterClass=class'DeathTrap_Script.DTPlayer_Lurker'
}