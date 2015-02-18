//  ================================================================================================
//   * File Name:    DTEnemy_Zombie3
//   * Created By:   qht
//   * Time Stamp:     2014/5/9 23:59:44
//   * UDK Path:   D:\UDK\UDK-2013-07
//   * Unreal X-Editor v3.1.5.0
//   * ? Copyright 2012 - 2014. All Rights Reserved.
//  ================================================================================================

class DTEnemy_Zombie3 extends DTActor
      placeable;

var Pawn Enemy;
var float FollowDistance;
var vector BalanceDistance;
var rotator BalanceRotation;
var float AttackDistance;
var AnimNodeBlendList Zombie3_NBL;
var ParticleSystemComponent Zombie3_PSC;
var SoundCue Zombie3_AttackSC;
var SoundCue Zombie3_DamageSC;
var SoundCue Zombie3_DieSC;
var SoundCue Zombie3_SC;
var bool SCIsPlayed;
var int DmgTime;
var int Zombie3_State;
var int Zombie3_Health;
var bool Zombie3_IsAlive;
var float Zombie3_MS;

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    Zombie3_NBL.SetActiveChild(0, 0.25f);
}

simulated event PostInitAnimTree(SkeletalMeshComponent SMC_Zombie3)
{
    Zombie3_NBL=AnimNodeBlendList(SMC_Zombie3.FindAnimNode('Zombie3_NodeBlendList'));
}

function Tick(float DeltaTime)
{
    local DTPlayerController DTPC;
    local vector NewLocation;
    if(Zombie3_State!=3)
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
           PlaySound(Zombie3_SC);
           SCIsPlayed=true;
       }
        if(VSize(Location-Enemy.Location)<AttackDistance)
        {
            Enemy.Bump(self,CollisionComponent,vect(0,0,0));
            Zombie3_State=2;
            Zombie3_NBL.SetActiveChild(2, 0.25f);
            if((DmgTime%20)==0)  //XXÃëÔì³É10µãÉËº¦
            {
                Zombie3_PSC.SetTranslation(vect(0.0f,40.0f,-100.0f));
                Zombie3_PSC.SetRotation(rot(0,90,0));
                //Zombie1_PSC.Rotation=(Pitch=0,Yaw=90,Roll=0);
                Zombie3_PSC.ActivateSystem();
                PlaySound(Zombie3_AttackSC);
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
            Zombie3_State=1;
            Zombie3_NBL.SetActiveChild(1, 0.25f);
            NewLocation=Location;
            NewLocation+=(Enemy.Location-Location)*DeltaTime*Zombie3_MS;
            NewLocation+=BalanceDistance;
            SetLocation(NewLocation);
        }
    }
 }
 else//state=3,ËÀÍö
 {
     if(Zombie3_IsAlive==true)
     {
         Zombie3_NBL.SetActiveChild(3, 0.25f);
         Zombie3_PSC.SetTranslation(vect(0.0f,-40.0f,100.0f));
         Zombie3_PSC.SetRotation(rot(0,-90,0));
         Zombie3_PSC.SetScale(2.0f);
         Zombie3_IsAlive=false;
         Zombie3_PSC.DeactivateSystem();
         SetLocation(Location+vect(0.0f,0.0f,-10.0f));
         PlaySound(Zombie3_DieSC);
         SetCollisionSize(0,0);
         WorldInfo.Game.ScoreObjective(Enemy.Controller.PlayerReplicationInfo,700);
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
        // `log("=="@Zombie3_Health);
        if(Zombie3_Health>0)
        {
            Zombie3_PSC.SetTranslation(vect(0.0f,40.0f,-80.0f));
            Zombie3_PSC.SetRotation(rot(0,90,0));
            Zombie3_PSC.ActivateSystem();
            Zombie3_PSC.SetScale(2.0f);
            Zombie3_Health-=DamageAmount;
            PlaySound(Zombie3_DamageSC);
        }
        //if((Zombie1_Health<=0)&&bCanBeDamaged)
        else
        {
            Zombie3_State=3;
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
    FollowDistance=500.0
    AttackDistance=120.0
    BalanceDistance=(X=0,Y=0,Z=-3.5)
    BalanceRotation=(Pitch=0,Yaw=13000,Roll=0)
    DmgTime=0
    Zombie3_MS=1.5
    Zombie3_State=0
    Zombie3_IsAlive=true
    Zombie3_AttackSC=SoundCue'DeathTrap.Sound.Zombie3_AttackSC'
    Zombie3_DamageSC=SoundCue'DeathTrap.Sound.Zombie3_DamageSC'
    Zombie3_DieSC=SoundCue'DeathTrap.Sound.Zombie3_DieSC'
    Zombie3_SC=SoundCue'DeathTrap.Sound.Zombie3_SC'
  //  AnimSet_Zombie1='DeathTrap.Role.Zombine1_Ani'
    
    bBlockActors=true
    bCollideActors=true
    // GroundSpeed=80.0
    Zombie3_Health=140
    
    Begin Object Class=DynamicLightEnvironmentComponent Name=DLEC_Zombie3
        bEnabled=true
    End Object
    Components.Add(DLEC_Zombie3)

    Begin Object Class=SkeletalMeshComponent Name=SMC_Zombie3
        SkeletalMesh=SkeletalMesh'DeathTrap.Role.Zombie3'
        Materials(0)=Material'DeathTrap.Materials.Zombie3_Mat'
        AnimSets(0)=AnimSet'DeathTrap.Role.Zombie3_Ani'
        AnimTreeTemplate=AnimTree'DeathTrap.Role.Zombie3_Tree'
        PhysicsAsset=PhysicsAsset'DeathTrap.Role.Zombie3_Physics'
        LightEnvironment=DLEC_Zombie3
        Scale3D=(X=2,Y=2,Z=2)
    End Object
    Components.Add(SMC_Zombie3)
    
    Begin Object Class=CylinderComponent Name=CC_Zombie3
        CollisionRadius=32.0
        CollisionHeight=100.0
        BlockNonZeroExtent=true
        BlockZeroExtent=true
        BlockActors=true
        CollideActors=true
    End Object
    CollisionComponent=CC_Zombie3
    Components.Add(CC_Zombie3)
    
    Begin Object Class=ParticleSystemComponent Name=PSC_Zombie3
        Template=ParticleSystem'KismetGame_Assets.Effects.P_BloodSplat_01';
        bAutoActivate=false
        bOwnerNoSee=true
        Scale=4.0f
        //Translation=(X=0.0f,Y=40.0f,Z=-100.0f)
        //Rotation=(Pitch=0,Yaw=90,Roll=0)
    End Object
    Zombie3_PSC=PSC_Zombie3
    Components.Add(PSC_Zombie3)
        
    // ControllerClass=class'DeathTrap_Script.DTEnemy_Zombie1Controller'
}