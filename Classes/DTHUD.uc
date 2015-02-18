//  ================================================================================================
//   * File Name:    DTHUD
//   * Created By:   qht
//   * Time Stamp:     2014/5/7 20:59:16
//   * UDK Path:   D:\UDK\UDK-2013-07
//   * Unreal X-Editor v3.1.5.0
//   * © Copyright 2012 - 2014. All Rights Reserved.
//  ================================================================================================

class DTHUD extends UTGFxHUDWrapper;

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
}

event DrawHUD()
{
    super.DrawHUD();
    
    if(PlayerOwner.Pawn!=none&&PlayerOwner.Pawn.Weapon!=none)
    {
        Canvas.DrawColor=WhiteColor;
        Canvas.Font=class'Engine'.Static.GetLargeFont();
        Canvas.SetPos(Canvas.ClipX*0.02,Canvas.ClipY*0.03);
        Canvas.DrawText("Hero Name:"@PlayerOwner.Pawn.Controller.PlayerReplicationInfo.PlayerName);
    }
    if(WorldInfo.Game!=none)
    {
        Canvas.SetPos(Canvas.ClipX*0.02,Canvas.ClipY*0.08);
        Canvas.DrawText("Game Score:"@PlayerOwner.Pawn.Controller.PlayerReplicationInfo.Score);
    }
	`log("=="@WorldInfo.GetMapName());
}

defaultproperties
{
    
}