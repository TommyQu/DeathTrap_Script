//  ================================================================================================
//   * File Name:    Zombie1Controller
//   * Created By:   qht
//   * Time Stamp:     2014/5/1 21:45:42
//   * UDK Path:   D:\UDK\UDK-2013-07
//   * Unreal X-Editor v3.1.5.0
//   * 漏 Copyright 2012 - 2014. All Rights Reserved.
//  ================================================================================================

class DTEnemy_Zombie1Controller extends AIController;

var Pawn thePlayer; //variable to hold the target pawn
var vector BalanceLocation2;
var vector PlayerLocation;

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    // SetPhysics(PHYS_Falling);
}

 event SeePlayer(Pawn SeenPlayer) //bot sees player
{
          if (thePlayer ==none) //if we didnt already see a player
          {
        thePlayer = SeenPlayer; //make the pawn the target
        GoToState('Follow'); // trigger the movement code
          }
}

state Follow
{
Begin:
        if (thePlayer != None)  // If we seen a player
        {
            PlayerLocation=thePlayer.Location+BalanceLocation2;
            //            `log("==TPL"@thePlayer.Location);
            //`log("==PL"@PlayerLocation);
            //`log("=="@self.Location);
            MoveTo(PlayerLocation); // Move directly to the players location
            GoToState('Looking'); //when we get there
        }

}

state Looking
{
Begin:
  if (thePlayer != None)  // If we seen a player
        {
            PlayerLocation=thePlayer.Location+BalanceLocation2;
                    MoveTo(PlayerLocation); // Move directly to the players location
               GoToState('Follow');  // when we get there
        }

}

defaultproperties
{
    BalanceLocation2=(X=,Y=0,Z=-600.0)
}