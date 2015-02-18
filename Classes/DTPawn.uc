//  ================================================================================================
//   * File Name:    DTPawn
//   * Created By:   qht
//   * Time Stamp:     2014/5/8 18:29:14
//   * UDK Path:   D:\UDK\UDK-2013-07
//   * Unreal X-Editor v3.1.5.0
//   * © Copyright 2012 - 2014. All Rights Reserved.
//  ================================================================================================

class DTPawn extends UTPawn;
var float ElapsedRegenTime;
var float RegenAmount;
var float RegenTime;
var ParticleSystemComponent PawnCZ_PSC;

simulated function PostBeginPlay()
{
   // SetLocation(SaveSettings(Location,true));
    super.PostBeginPlay();
}

event Tick(float DeltaTime)
{
  //calculate elapsed time
  ElapsedRegenTime += DeltaTime;
   
  //has enough time elapsed?
  if(ElapsedRegenTime >= RegenTime)
  {
    //heal the Pawn and reset elapsed time
    HealDamage(RegenAmount, Controller, class'DamageType');
    ElapsedRegenTime = 0.0f;
  }
  if(Health<=0)
  {
	WorldInfo.Game.ScoreObjective(Controller.PlayerReplicationInfo,-1000);
	Destroy();
  }
}

exec function DTSave()
{
    //
    local DTGameState DTGS;
    DTGS=new class'DTGameState';
    DTGS.PlayerName=Controller.PlayerReplicationInfo.PlayerName;
    DTGS.PlayerScore=Controller.PlayerReplicationInfo.Score;
    DTGS.PlayerLocation=Location;
    DTGS.PlayerRotation=Rotation;
    DTGS.PlayerMapName=WorldInfo.GetMapName();
    DTGS.PlayerHealth=Health;
    //    DTGS.PlayerAmmoCount=Weapon.AmmoCount;
    DTGS.PlayerWeapon=Weapon;
    class'Engine'.static.BasicSaveObject(DTGS, "GameState.bin", true, 0);
}

exec function DTLoad()
{
    //
    local DTGameState DTGS;
    DTGS=new class'DTGameState';
    if(class'Engine'.static.BasicLoadObject(DTGS, "GameState.bin", true, 0))
    {
        //if(DTGS.PlayerMapName==WorldInfo.GetMapName())
        //{
            //  ConsoleCommand("open "@DTGS.PlayerMapName);
            SetLocation(DTGS.PlayerLocation);
            SetRotation(DTGS.PlayerRotation);
            Health=DTGS.PlayerHealth;
            Weapon=DTGS.PlayerWeapon;
            Weapon.AddAmmo(100);
            Controller.PlayerReplicationInfo.Score=DTGS.PlayerScore;
            Controller.PlayerReplicationInfo.PlayerName=DTGS.PlayerName;
            `log("PlayerName="@DTGS.PlayerName);
            `log("PlayerScore="@DTGS.PlayerScore);
            `log("PlayerLocation="@DTGS.PlayerLocation);
            `log("PlayerRotation="@DTGS.PlayerRotation);
            `log("PlayerMapName="@DTGS.PlayerMapName);
            `log("PlayerHealth="@DTGS.PlayerHealth);
            `log("PlayerWeapon="@DTGS.PlayerWeapon);
    // `log("PlayerAmmoCount="@DTGS.PlayerAmmoCount);

        //    WorldInfo.Game.Broadcast(self,"Save Game Completed");  
        //}
        //else
        //{
        //}
    }
}

simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	SetCollisionType(COLLIDE_NoCollision);
	FullBodyAnimSlot.SetActorAnimEndNotification(true);
	FullBodyAnimSlot.PlayCustomAnim('Death_Stinger', 1.0, 0.05, -1.0, false, false);
	LifeSpan=1.0;
}

defaultproperties
{
  //set defaults for regeneration properties
  RegenAmount=0 //自动回血
  RegenTime=1
  
  Begin Object Class=ParticleSystemComponent Name=PSC_PawnCZ
        Template=ParticleSystem'FX_VehicleExplosions.Effects.P_FX_VehicleDeathExplosion';
        //FX_VehicleExplosions.Effects.P_FX_VehicleDeathExplosion
        bAutoActivate=false
        bOwnerNoSee=true
        Scale=4.0f
        //Translation=(X=0.0f,Y=40.0f,Z=-100.0f)
        //Rotation=(Pitch=0,Yaw=90,Roll=0)
    End Object
    PawnCZ_PSC=PSC_PawnCZ
    Components.Add(PSC_PawnCZ)
}