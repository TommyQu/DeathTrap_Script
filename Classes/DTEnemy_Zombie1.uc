//  ================================================================================================
//   * File Name:    DTEnemy_Zombie1
//   * Created By:   qht
//   * Time Stamp:     2014/5/7 13:25:55
//   * UDK Path:   D:\UDK\UDK-2013-07
//   * Unreal X-Editor v3.1.5.0
//   * © Copyright 2012 - 2014. All Rights Reserved.
//  ================================================================================================

class DTEnemy_Zombie1 extends DTActor
      placeable;

var Pawn Enemy;
var float FollowDistance;
var vector BalanceDistance;
var rotator BalanceRotation;
var float AttackDistance;
var AnimNodeBlendList Zombie1_NBL;
var ParticleSystemComponent Zombie1_PSC;
var SoundCue Zombie1_AttackSC;
var SoundCue Zombie1_DamageSC;
var SoundCue Zombie1_DieSC;
var SoundCue Zombie1_SC;
var bool SCIsPlayed;
//var vector PSC_AttackTranslation;
//var rotator PSC_AttackTranslation;
//var vector PSC_DieTranslation;
//var rotator PSC_DieTranslation;
var int DmgTime;
var int Zombie1_State;
var int Zombie1_Health;
var bool Zombie1_IsAlive;
//var int Zombie1_Rand;
var float Zombie1_MS;
//var array<AnimSet> AnimSet_Zombie1;

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    //SetPhysics(PHYS_Falling);
}

simulated event PostInitAnimTree(SkeletalMeshComponent SMC_Zombie1)
{
    Zombie1_NBL=AnimNodeBlendList(SMC_Zombie1.FindAnimNode('Zombine1_NodeBlend'));
   // Zombie1_Walk=AnimNodeSlot(SMC_Zombie1.FindAnimNode('Zombine1_NodeBlend'));
}

function Tick(float DeltaTime)
{
    local DTPlayerController DTPC;
    local vector NewLocation;
    if(Zombie1_State!=3)
    {
        SetRotation(Enemy.Rotation+BalanceRotation);
    if(Enemy==none)
    {
        foreach LocalPlayerControllers(class'DTPlayerController',DTPC)
        {
            if(DTPC.Pawn!=none)
            {
                Enemy=DTPC.Pawn;
                //`log("My Enemy is "@Enemy);
            }
        }
    }
    else if(VSize(Location-Enemy.Location)<FollowDistance)
    {
       // PlaySound(Zombie1_SC);
       if(SCIsPlayed!=true)
       {
           PlaySound(Zombie1_SC);
           SCIsPlayed=true;
       }
        if(VSize(Location-Enemy.Location)<AttackDistance)
        {
            Enemy.Bump(self,CollisionComponent,vect(0,0,0));
            Zombie1_State=2;
            Zombie1_NBL.SetActiveChild(2, 0.25f);
            if((DmgTime%30)==0)  //XX秒造成10点伤害
            {
                Zombie1_PSC.SetTranslation(vect(0.0f,40.0f,-100.0f));
                Zombie1_PSC.SetRotation(rot(0,90,0));
                //Zombie1_PSC.Rotation=(Pitch=0,Yaw=90,Roll=0);
                Zombie1_PSC.ActivateSystem();
                PlaySound(Zombie1_AttackSC);
                Enemy.Health-=10;
                WorldInfo.Game.ScoreObjective(Enemy.Controller.PlayerReplicationInfo,-10);
            }
            DmgTime++;
           // Zombie1_Walk.PlayCustomAnim('Zombine1_Attack',1.0f, 0.1f, 0.1f, false, false);
           // `log("=="@Zombie1_Walk);
           //  `log("=="@Zombie1_Walk.bIsPlayingCustomAnim);
           // AnimSets(0)=AnimSet'DeathTrap.Role.Zombine1_Ani';
        }
        else
        {
             Zombie1_State=1;
             Zombie1_NBL.SetActiveChild(1, 0.25f);
             NewLocation=Location;
             NewLocation+=(Enemy.Location-Location)*DeltaTime*Zombie1_MS;
             NewLocation+=BalanceDistance;
             SetLocation(NewLocation);
        }
    }
 }
 else
 {
     if(Zombie1_IsAlive==true)
     {
         Zombie1_NBL.SetActiveChild(3, 0.25f);
         Zombie1_PSC.SetTranslation(vect(0.0f,-40.0f,100.0f));
         Zombie1_PSC.SetRotation(rot(0,-90,0));
         Zombie1_PSC.SetScale(2.0f);
         Zombie1_IsAlive=false;
         Zombie1_PSC.DeactivateSystem();
         SetLocation(Location+vect(0.0f,0.0f,-10.0f));
         PlaySound(Zombie1_DieSC);
         SetCollisionSize(0,0);
         WorldInfo.Game.ScoreObjective(Enemy.Controller.PlayerReplicationInfo,300);
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
        if(Zombie1_Health>0)
        {
            Zombie1_PSC.SetTranslation(vect(0.0f,40.0f,-80.0f));
            Zombie1_PSC.SetRotation(rot(0,90,0));
            Zombie1_PSC.ActivateSystem();
            Zombie1_PSC.SetScale(2.0f);
            Zombie1_Health-=DamageAmount;
            PlaySound(Zombie1_DamageSC);
        }
        else
        {
            Zombie1_State=3;
            bCanBeDamaged=false;
        }
    }
}

defaultproperties
{
    FollowDistance=512.0
    AttackDistance=96.0
    BalanceDistance=(X=0,Y=0,Z=-1.4)
    BalanceRotation=(Pitch=0,Yaw=32768,Roll=0)
    DmgTime=0
 //   Zombie1_Rand=Rand(9)*100
    Zombie1_State=0
    Zombie1_IsAlive=true
    Zombie1_MS=0.5
    Zombie1_AttackSC=SoundCue'A_Character_BodyImpacts.BodyImpacts.A_Character_BodyImpact_Bullet_Cue'
    Zombie1_DamageSC=SoundCue'A_Weapon_BioRifle.Weapon.A_BioRifle_FireImpactFizzle_Cue'
    Zombie1_DieSC=SoundCue'DeathTrap.Sound.Zombine1_DieSC'
    Zombie1_SC=SoundCue'DeathTrap.Sound.Zombine1_SC'
    
    bBlockActors=true
    bCollideActors=true
    // GroundSpeed=80.0
    Zombie1_Health=100
    
    Begin Object Class=DynamicLightEnvironmentComponent Name=DLEC_Zombie1
        bEnabled=true
    End Object
    Components.Add(DLEC_Zombie1)
    
    Begin Object Class=SkeletalMeshComponent Name=SMC_Zombie1
        SkeletalMesh=SkeletalMesh'DeathTrap.Role.Zombine1'
        Materials(0)=Material'DeathTrap.Materials.Zombine1_1'
        AnimSets(0)=AnimSet'DeathTrap.Role.Zombine1_Ani'
        AnimTreeTemplate=AnimTree'DeathTrap.Role.Zombine1_Tree'
        PhysicsAsset=PhysicsAsset'DeathTrap.Role.Zombine1_Physics'
        LightEnvironment=DLEC_Zombie1
        Scale3D=(X=1.8,Y=1.8,Z=1.8)
    End Object
    Components.Add(SMC_Zombie1)
    
    Begin Object Class=CylinderComponent Name=CC_Zombie1
        CollisionRadius=32.0
        CollisionHeight=100.0
        BlockNonZeroExtent=true
        BlockZeroExtent=true
        BlockActors=true
        CollideActors=true
    End Object
    CollisionComponent=CC_Zombie1
    Components.Add(CC_Zombie1)
    
    Begin Object Class=ParticleSystemComponent Name=PSC_Zombie1 
        Template=ParticleSystem'KismetGame_Assets.Effects.P_BloodSplat_01';
        bAutoActivate=false
        bOwnerNoSee=true
        Scale=4.0f
        //Translation=(X=0.0f,Y=40.0f,Z=-100.0f)
        //Rotation=(Pitch=0,Yaw=90,Roll=0)
    End Object
    Zombie1_PSC=PSC_Zombie1
    Components.Add(PSC_Zombie1)
    //    
    //Begin Object Class=AudioComponent Name=AttackAC_Zombie1
    //    SoundCue=SoundCue'A_Character_BodyImpacts.BodyImpacts.A_Character_BodyImpact_Bullet_Cue'
    //End Object
    //Zombie1_AttackAC=AttackAC_Zombie1
    //Components.Add(AttackAC_Zombie1)
}