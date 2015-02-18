//  ================================================================================================
//   * File Name:    DTEnemy_CZ
//   * Created By:   qht
//   * Time Stamp:     2014/5/12 8:43:27
//   * UDK Path:   D:\UDK\UDK-2013-07
//   * Unreal X-Editor v3.1.5.0
//   * © Copyright 2012 - 2014. All Rights Reserved.
//  ================================================================================================

class DTEnemy_CZ extends DTActor
      placeable;

var Pawn Enemy;
var float FollowDistance;
var vector BalanceDistance;
var rotator BalanceRotation;
var float AttackDistance;
var AnimNodeBlendList CZ_NBL;
var ParticleSystemComponent CZ_PSC;
var SoundCue CZ_AttackSC;
var SoundCue CZ_DamageSC;
var SoundCue CZ_SC;
var SoundCue CZ_DieSC;
var bool SCIsPlayed;
var int DmgTime;
var int CZ_State;
var int CZ_Health;
var bool CZ_IsAlive;
var float CZ_MS;

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    CZ_NBL.SetActiveChild(0, 0.25f);
}

simulated event PostInitAnimTree(SkeletalMeshComponent SMC_CZ)
{
    CZ_NBL=AnimNodeBlendList(SMC_CZ.FindAnimNode('CZ_NodeBlendList'));
}

function Tick(float DeltaTime)
{
    local DTPlayerController DTPC;
    local vector NewLocation;
    if(CZ_State!=3)
    {
        // `log("=="@Enemy.Rotation);
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
           PlaySound(CZ_SC);
           SCIsPlayed=true;
       }
        if(VSize(Location-Enemy.Location)<AttackDistance)
        {
            Enemy.Bump(self,CollisionComponent,vect(0,0,0));
            CZ_State=2;
            // CZ_NBL.SetActiveChild(2, 0.25f);
            CZ_PSC.SetTranslation(vect(0.0f,40.0f,-100.0f));
            CZ_PSC.SetRotation(rot(0,90,0));
           // ParticleSystemComponent(class'DeathTrap_Script.DTPawn'.PawnCZ_PSC).ActivateSystem();
            //CZ_PSC.SetScale(10.0f);
            PlaySound(CZ_AttackSC);
            Enemy.Health-=15;
            WorldInfo.Game.ScoreObjective(Enemy.Controller.PlayerReplicationInfo,-150);
            Destroy();
            `log("==CZ_PSC"@CZ_PSC);
        }
        else
        {
            CZ_State=1;
            CZ_NBL.SetActiveChild(1, 0.25f);
             NewLocation=Location;
             NewLocation+=(Enemy.Location-Location)*DeltaTime*CZ_MS;
             NewLocation+=BalanceDistance;
             SetLocation(NewLocation);
        }
    }
 }
  else//state=3,死亡
 {
     if(CZ_IsAlive==true)
     {
         CZ_NBL.SetActiveChild(3, 0.25f);
         CZ_PSC.SetTranslation(vect(0.0f,-40.0f,100.0f));
         CZ_PSC.SetRotation(rot(0,-90,0));
         CZ_PSC.SetScale(2.0f);
         CZ_IsAlive=false;
         CZ_PSC.ActivateSystem();
         //   SetLocation(Location+vect(0.0f,0.0f,-10.0f));
         PlaySound(CZ_DieSC);
         WorldInfo.Game.ScoreObjective(Enemy.Controller.PlayerReplicationInfo,450);
         Destroy();
         //  SetCollisionSize(0,0);
         //  SetTimer(3.0,false,'Destroy');
     }
 }
}

event TakeDamage(int DamageAmount,Controller EventInstigator,vector HitLocation,
                 vector Momentum,class<DamageType> DamageType, optional TraceHitInfo HitInfo,
                 optional Actor DamageCauser)
{
    if(EventInstigator!=none&&EventInstigator.PlayerReplicationInfo!=none)
    {
        // `log("=="@CZ_Health);
        if(CZ_Health>0)
        {
            CZ_PSC.SetTranslation(vect(0.0f,40.0f,-100.0f));
            CZ_PSC.SetRotation(rot(0,90,0));
            CZ_PSC.ActivateSystem();
            CZ_PSC.SetScale(2.0f);
            CZ_Health-=DamageAmount;
            PlaySound(CZ_DamageSC);
        }
        //if((Zombie1_Health<=0)&&bCanBeDamaged)
        else
        {
            CZ_State=3;
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
    AttackDistance=60.0
    BalanceDistance=(X=0,Y=0,Z=-5.0)
    BalanceRotation=(Pitch=0,Yaw=13000,Roll=0)
    DmgTime=0
    SCIsPlayed=false
    CZ_MS=2
    CZ_State=0
    CZ_IsAlive=true
    CZ_AttackSC=SoundCue'DeathTrap.Sound.CZ_AttackSC'
    CZ_DamageSC=SoundCue'DeathTrap.Sound.CZ_DamageSC'
    CZ_SC=SoundCue'DeathTrap.Sound.CZ_SC'
    CZ_DieSC=SoundCue'DeathTrap.Sound.CZ_DieSC'
    
    bBlockActors=true
    bCollideActors=true
    // GroundSpeed=80.0
    CZ_Health=60
    
    Begin Object Class=DynamicLightEnvironmentComponent Name=DLEC_CZ
        bEnabled=true
    End Object
    Components.Add(DLEC_CZ)
    
    Begin Object Class=SkeletalMeshComponent Name=SMC_CZ
        SkeletalMesh=SkeletalMesh'DeathTrap.Role.CZ'
        Materials(0)=Material'DeathTrap.Materials.CZ_Mat'
        AnimSets(0)=AnimSet'DeathTrap.Role.CZ_Ani'
        AnimTreeTemplate=AnimTree'DeathTrap.Role.CZ_Tree'
        PhysicsAsset=PhysicsAsset'DeathTrap.Role.CZ_Physics'
        LightEnvironment=DLEC_CZ
        Scale3D=(X=0.6,Y=0.6,Z=0.6)
    End Object
    Components.Add(SMC_CZ)
    
    Begin Object Class=CylinderComponent Name=CC_CZ
        CollisionRadius=32.0
        CollisionHeight=100.0
        BlockNonZeroExtent=true
        BlockZeroExtent=true
        BlockActors=true
        CollideActors=true
    End Object
    CollisionComponent=CC_CZ
    Components.Add(CC_CZ)
    
    Begin Object Class=ParticleSystemComponent Name=PSC_CZ
        Template=ParticleSystem'FX_VehicleExplosions.Effects.P_FX_VehicleDeathExplosion';
        //FX_VehicleExplosions.Effects.P_FX_VehicleDeathExplosion
        bAutoActivate=false
        bOwnerNoSee=true
        Scale=4.0f
        //Translation=(X=0.0f,Y=40.0f,Z=-100.0f)
        //Rotation=(Pitch=0,Yaw=90,Roll=0)
    End Object
    CZ_PSC=PSC_CZ
    Components.Add(PSC_CZ)
        
}