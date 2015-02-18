//  ================================================================================================
//   * File Name:    DTEnemy_Zombie2
//   * Created By:   qht
//   * Time Stamp:     2014/5/9 23:59:44
//   * UDK Path:   D:\UDK\UDK-2013-07
//   * Unreal X-Editor v3.1.5.0
//   * © Copyright 2012 - 2014. All Rights Reserved.
//  ================================================================================================

class DTEnemy_Zombie2 extends DTActor
      placeable;

var Pawn Enemy;
var float FollowDistance;
var vector BalanceDistance;
var rotator BalanceRotation;
var float AttackDistance;
var AnimNodeBlendList Zombie2_NBL;
var ParticleSystemComponent Zombie2_PSC;
var SoundCue Zombie2_AttackSC;
var SoundCue Zombie2_DamageSC;
var SoundCue Zombie2_DieSC;
var SoundCue Zombie2_SC;
var bool SCIsPlayed;
var int DmgTime;
var int Zombie2_State;
var int Zombie2_Health;
var bool Zombie2_IsAlive;
var float Zombie2_MS;

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    Zombie2_NBL.SetActiveChild(0, 0.25f);
}

simulated event PostInitAnimTree(SkeletalMeshComponent SMC_Zombie2)
{
    Zombie2_NBL=AnimNodeBlendList(SMC_Zombie2.FindAnimNode('Zombie2_NodeBlend'));
}

function Tick(float DeltaTime)
{
    local DTPlayerController DTPC;
    local vector NewLocation;
    if(Zombie2_State!=3)
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
           PlaySound(Zombie2_SC);
           SCIsPlayed=true;
       }
        if(VSize(Location-Enemy.Location)<AttackDistance)
        {
            Enemy.Bump(self,CollisionComponent,vect(0,0,0));
            Zombie2_State=2;
            Zombie2_NBL.SetActiveChild(2, 0.25f);
            if((DmgTime%26)==0)  //XX秒造成10点伤害
            {
                Zombie2_PSC.SetTranslation(vect(0.0f,40.0f,-100.0f));
                Zombie2_PSC.SetRotation(rot(0,90,0));
                //Zombie1_PSC.Rotation=(Pitch=0,Yaw=90,Roll=0);
                Zombie2_PSC.ActivateSystem();
                PlaySound(Zombie2_AttackSC);
                Enemy.Health-=8;
                WorldInfo.Game.ScoreObjective(Enemy.Controller.PlayerReplicationInfo,-80);
            }
            DmgTime++;
           // Zombie1_Walk.PlayCustomAnim('Zombine1_Attack',1.0f, 0.1f, 0.1f, false, false);
           // `log("=="@Zombie1_Walk);
           //  `log("=="@Zombie1_Walk.bIsPlayingCustomAnim);
           // AnimSets(0)=AnimSet'DeathTrap.Role.Zombine1_Ani';
        }
        else
        {
            Zombie2_State=1;
            Zombie2_NBL.SetActiveChild(1, 0.25f);
             NewLocation=Location;
             NewLocation+=(Enemy.Location-Location)*DeltaTime*Zombie2_MS;
             NewLocation+=BalanceDistance;
             SetLocation(NewLocation);
        }
    }
 }
 else//state=3,死亡
 {
     if(Zombie2_IsAlive==true)
     {
         Zombie2_NBL.SetActiveChild(3, 0.25f);
         Zombie2_PSC.SetTranslation(vect(0.0f,-40.0f,100.0f));
         Zombie2_PSC.SetRotation(rot(0,-90,0));
         Zombie2_PSC.SetScale(2.0f);
         Zombie2_IsAlive=false;
         Zombie2_PSC.DeactivateSystem();
         SetLocation(Location+vect(0.0f,0.0f,-10.0f));
         PlaySound(Zombie2_DieSC);
         SetCollisionSize(0,0);
         WorldInfo.Game.ScoreObjective(Enemy.Controller.PlayerReplicationInfo,500);
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
        // `log("=="@Zombie2_Health);
        if(Zombie2_Health>0)
        {
            Zombie2_PSC.SetTranslation(vect(0.0f,40.0f,-80.0f));
            Zombie2_PSC.SetRotation(rot(0,90,0));
            Zombie2_PSC.ActivateSystem();
            Zombie2_PSC.SetScale(2.0f);
            Zombie2_Health-=DamageAmount;
            PlaySound(Zombie2_DamageSC);
        }
        //if((Zombie1_Health<=0)&&bCanBeDamaged)
        else
        {
            Zombie2_State=3;
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
    FollowDistance=420.0
    AttackDistance=80.0
    BalanceDistance=(X=0,Y=0,Z=-3.0)
    BalanceRotation=(Pitch=0,Yaw=13000,Roll=0)
    DmgTime=0
    Zombie2_MS=1.0
    Zombie2_State=0
    Zombie2_IsAlive=true
    Zombie2_AttackSC=SoundCue'DeathTrap.Sound.Zombie2_AttackSC'
    Zombie2_DamageSC=SoundCue'DeathTrap.Sound.Zombie2_DamageSC'
    Zombie2_DieSC=SoundCue'DeathTrap.Sound.Zombie2_DieSC'
    Zombie2_SC=SoundCue'DeathTrap.Sound.Zombie2_SC'
  //  AnimSet_Zombie1='DeathTrap.Role.Zombine1_Ani'
    
    bBlockActors=true
    bCollideActors=true
    // GroundSpeed=80.0
    Zombie2_Health=120
    
    Begin Object Class=DynamicLightEnvironmentComponent Name=DLEC_Zombie2
        bEnabled=true
    End Object
    Components.Add(DLEC_Zombie2)
    
    Begin Object Class=SkeletalMeshComponent Name=SMC_Zombie2
        SkeletalMesh=SkeletalMesh'DeathTrap.Role.Zombie2'
        Materials(0)=Material'DeathTrap.Materials.Zombie2_1'
        AnimSets(0)=AnimSet'DeathTrap.Role.Zombie2_Ani'
        AnimTreeTemplate=AnimTree'DeathTrap.Role.Zombie2_Tree'
        PhysicsAsset=PhysicsAsset'DeathTrap.Role.Zombie2_Physics'
        LightEnvironment=DLEC_Zombie2
        Scale3D=(X=3.2,Y=3.2,Z=3.2)
    End Object
    Components.Add(SMC_Zombie2)
    
    Begin Object Class=CylinderComponent Name=CC_Zombie2
        CollisionRadius=32.0
        CollisionHeight=100.0
        BlockNonZeroExtent=true
        BlockZeroExtent=true
        BlockActors=true
        CollideActors=true
    End Object
    CollisionComponent=CC_Zombie2
    Components.Add(CC_Zombie2)
    
    Begin Object Class=ParticleSystemComponent Name=PSC_Zombie2
        Template=ParticleSystem'KismetGame_Assets.Effects.P_BloodSplat_01';
        bAutoActivate=false
        bOwnerNoSee=true
        Scale=4.0f
        //Translation=(X=0.0f,Y=40.0f,Z=-100.0f)
        //Rotation=(Pitch=0,Yaw=90,Roll=0)
    End Object
    Zombie2_PSC=PSC_Zombie2
    Components.Add(PSC_Zombie2)
        
    // ControllerClass=class'DeathTrap_Script.DTEnemy_Zombie1Controller'
}