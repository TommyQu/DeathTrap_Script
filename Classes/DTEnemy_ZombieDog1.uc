//  ================================================================================================
//   * File Name:    DTEnemy_ZombieDog1
//   * Created By:   qht
//   * Time Stamp:     2014/5/14 15:49:19
//   * UDK Path:   D:\UDK\UDK-2013-07
//   * Unreal X-Editor v3.1.5.0
//   * © Copyright 2012 - 2014. All Rights Reserved.
//  ================================================================================================

class DTEnemy_ZombieDog1 extends DTActor
      placeable;

var Pawn Enemy;
var float FollowDistance;
var vector BalanceDistance;
var rotator BalanceRotation;
var float AttackDistance;
var AnimNodeBlendList ZombieDog1_NBL;
var ParticleSystemComponent ZombieDog1_PSC;
var SoundCue ZombieDog1_AttackSC;
var SoundCue ZombieDog1_DamageSC;
var SoundCue ZombieDog1_DieSC;
var SoundCue ZombieDog1_SC;
var bool SCIsPlayed;
var int DmgTime;
var int ZombieDog1_State;
var int ZombieDog1_Health;
var bool ZombieDog1_IsAlive;
var float ZombieDog1_MS;

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    ZombieDog1_NBL.SetActiveChild(0, 0.25f);
}

simulated event PostInitAnimTree(SkeletalMeshComponent SMC_ZombieDog1)
{
    ZombieDog1_NBL=AnimNodeBlendList(SMC_ZombieDog1.FindAnimNode('ZombieDog1_NodeBlendList'));
}

function Tick(float DeltaTime)
{
    local DTPlayerController DTPC;
    local vector NewLocation;
    if(ZombieDog1_State!=3)
    {
        //`log("=="@Enemy.Rotation);
        SetRotation(Enemy.Rotation+BalanceRotation);
    if(Enemy==none)
    {
        foreach LocalPlayerControllers(class'DTPlayerController',DTPC)
        {
            if(DTPC.Pawn!=none)
            {
                Enemy=DTPC.Pawn;
                //  `log("My Enemy is "@Enemy);
            }
        }
    }
    else if(VSize(Location-Enemy.Location)<FollowDistance)
    {
       if(SCIsPlayed!=true)
       {
           PlaySound(ZombieDog1_SC);
           SCIsPlayed=true;
       }
        if(VSize(Location-Enemy.Location)<AttackDistance)
        {
            Enemy.Bump(self,CollisionComponent,vect(0,0,0));
            ZombieDog1_State=2;
            ZombieDog1_NBL.SetActiveChild(2, 0.25f);
            if((DmgTime%30)==0)  //XX秒造成10点伤害
            {
                ZombieDog1_PSC.SetTranslation(vect(0.0f,40.0f,-100.0f));
                ZombieDog1_PSC.SetRotation(rot(0,90,0));
                //Zombie1_PSC.Rotation=(Pitch=0,Yaw=90,Roll=0);
                ZombieDog1_PSC.ActivateSystem();
                PlaySound(ZombieDog1_AttackSC);
                Enemy.Health-=10;
                WorldInfo.Game.ScoreObjective(Enemy.Controller.PlayerReplicationInfo,-100);
            }
            DmgTime++;
           // Zombie1_Walk.PlayCustomAnim('Zombine1_Attack',1.0f, 0.1f, 0.1f, false, false);
           // `log("=="@Zombie1_Walk);
           //  `log("=="@Zombie1_Walk.bIsPlayingCustomAnim);
           // AnimSets(0)=AnimSet'DeathTrap.Role.Zombine1_Ani';
        }
        else
        {
            ZombieDog1_State=1;
            ZombieDog1_NBL.SetActiveChild(1, 0.25f);
             NewLocation=Location;
             NewLocation+=(Enemy.Location-Location)*DeltaTime*ZombieDog1_MS;
             NewLocation+=BalanceDistance;
             SetLocation(NewLocation);
        }
    }
 }
 else//state=3,死亡
 {
     if(ZombieDog1_IsAlive==true)
     {
         ZombieDog1_NBL.SetActiveChild(3, 0.25f);
         ZombieDog1_PSC.SetTranslation(vect(0.0f,-40.0f,100.0f));
         ZombieDog1_PSC.SetRotation(rot(0,-90,0));
         ZombieDog1_PSC.SetScale(2.0f);
         ZombieDog1_IsAlive=false;
         ZombieDog1_PSC.DeactivateSystem();
         SetLocation(Location+vect(0.0f,0.0f,-10.0f));
         PlaySound(ZombieDog1_DieSC);
         SetCollisionSize(0,0);
         WorldInfo.Game.ScoreObjective(Enemy.Controller.PlayerReplicationInfo,800);
         SetTimer(3.0,false,'Destroy');
     }
 }
}

event TakeDamage(int DamageAmount,Controller EventInstigator,vector HitLocation,
                 vector Momentum,class<DamageType> DamageType, optional TraceHitInfo HitInfo,
                 optional Actor DamageCauser)
{
    if(EventInstigator!=none&&EventInstigator.PlayerReplicationInfo!=none)
    {
        // `log("=="@ZombieDog1_Health);
        if(ZombieDog1_Health>0)
        {
            ZombieDog1_PSC.SetTranslation(vect(0.0f,40.0f,-80.0f));
            ZombieDog1_PSC.SetRotation(rot(0,90,0));
            ZombieDog1_PSC.ActivateSystem();
            ZombieDog1_PSC.SetScale(2.0f);
            ZombieDog1_Health-=DamageAmount;
            PlaySound(ZombieDog1_DamageSC);
        }
        //if((Zombie1_Health<=0)&&bCanBeDamaged)
        else
        {
            ZombieDog1_State=3;
            bCanBeDamaged=false;
            //if(bCanBeDamaged==true)
            //{
            //    bCanBeDamaged=false;
            //    //Zombie1_NBL.SetActiveChild(3, 0.25f);
            //    Zombie1_State=3;
            //    //SetTimer(10.0,false,'Destroy');
            //}
        }
    }
}

defaultproperties
{
    FollowDistance=400.0
    AttackDistance=100.0
    BalanceDistance=(X=0,Y=0,Z=-3)
    BalanceRotation=(Pitch=0,Yaw=13000,Roll=0)
    DmgTime=0
    ZombieDog1_MS=2.5
    ZombieDog1_State=0
    ZombieDog1_IsAlive=true
    ZombieDog1_AttackSC=SoundCue'DeathTrap.Sound.ZombieDog1_AttackSC'
    ZombieDog1_DamageSC=SoundCue'DeathTrap.Sound.ZombieDog1_DamageSC'
    ZombieDog1_DieSC=SoundCue'DeathTrap.Sound.ZombieDog1_DieSC'
    ZombieDog1_SC=SoundCue'DeathTrap.Sound.ZombieDog1_SC'
  //  AnimSet_Zombie1='DeathTrap.Role.Zombine1_Ani'
    
    bBlockActors=true
    bCollideActors=true
    // GroundSpeed=80.0
    ZombieDog1_Health=100
    
    Begin Object Class=DynamicLightEnvironmentComponent Name=DLEC_ZombieDog1
        bEnabled=true
    End Object
    Components.Add(DLEC_ZombieDog1)
    
    Begin Object Class=SkeletalMeshComponent Name=SMC_ZombieDog1
        SkeletalMesh=SkeletalMesh'DeathTrap.Role.ZombieDog1'
        Materials(0)=Material'DeathTrap.Materials.ZombieDog1_Mat'
        AnimSets(0)=AnimSet'DeathTrap.Role.ZombieDog1_Ani'
        AnimTreeTemplate=AnimTree'DeathTrap.Role.ZombieDog1_Tree'
        PhysicsAsset=PhysicsAsset'DeathTrap.Role.ZombieDog1_Physics'
        LightEnvironment=DLEC_ZombieDog1
        Scale3D=(X=3,Y=3,Z=3)
    End Object
    Components.Add(SMC_ZombieDog1)
    
    Begin Object Class=CylinderComponent Name=CC_ZombieDog1
        CollisionRadius=32.0
        CollisionHeight=100.0
        BlockNonZeroExtent=true
        BlockZeroExtent=true
        BlockActors=true
        CollideActors=true
    End Object
    CollisionComponent=CC_ZombieDog1
    Components.Add(CC_ZombieDog1)
    
    Begin Object Class=ParticleSystemComponent Name=PSC_ZombieDog1
        Template=ParticleSystem'KismetGame_Assets.Effects.P_BloodSplat_01';
        bAutoActivate=false
        bOwnerNoSee=true
        Scale=2.0f
        //Translation=(X=0.0f,Y=40.0f,Z=-100.0f)
        //Rotation=(Pitch=0,Yaw=90,Roll=0)
    End Object
    ZombieDog1_PSC=PSC_ZombieDog1
    Components.Add(PSC_ZombieDog1)
        
    // ControllerClass=class'DeathTrap_Script.DTEnemy_Zombie1Controller'
}