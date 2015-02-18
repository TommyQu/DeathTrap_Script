class DTEnemy_Monster1 extends DTActor
      placeable;

var Pawn Enemy;
var float FollowDistance;
var vector BalanceDistance;
var rotator BalanceRotation;
var float AttackDistance;
var AnimNodeBlendList Monster1_NBL;
var ParticleSystemComponent Monster1_PSC;
var SoundCue Monster1_AttackSC;
var SoundCue Monster1_DamageSC;
var SoundCue Monster1_DieSC;
var SoundCue Monster1_SC;
var bool SCIsPlayed;
var int DmgTime;
var int Monster1_State;
var int Monster1_Health;
var bool Monster1_IsAlive;
var float Monster1_MS;

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    Monster1_NBL.SetActiveChild(0, 0.25f);
}

simulated event PostInitAnimTree(SkeletalMeshComponent SMC_Monster1)
{
    Monster1_NBL=AnimNodeBlendList(SMC_Monster1.FindAnimNode('Monster1_NodeBlendList'));
}

function Tick(float DeltaTime)
{
    local DTPlayerController DTPC;
    local vector NewLocation;
    if(Monster1_State!=3)
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
           PlaySound(Monster1_SC);
           SCIsPlayed=true;
       }
        if(VSize(Location-Enemy.Location)<AttackDistance)
        {
            Enemy.Bump(self,CollisionComponent,vect(0,0,0));
            Monster1_State=2;
            Monster1_NBL.SetActiveChild(2, 0.25f);
            if((DmgTime%25)==0)  //XXÃëÔì³É10µãÉËº¦
            {
                Monster1_PSC.SetTranslation(vect(0.0f,40.0f,-100.0f));
                Monster1_PSC.SetRotation(rot(0,90,0));
                //Zombie1_PSC.Rotation=(Pitch=0,Yaw=90,Roll=0);
                Monster1_PSC.ActivateSystem();
                PlaySound(Monster1_AttackSC);
                Enemy.Health-=5;
                WorldInfo.Game.ScoreObjective(Enemy.Controller.PlayerReplicationInfo,-50);
            }
            DmgTime++;
           // Zombie1_Walk.PlayCustomAnim('Zombine1_Attack',1.0f, 0.1f, 0.1f, false, false);
           // `log("=="@Zombie1_Walk);
           //  `log("=="@Zombie1_Walk.bIsPlayingCustomAnim);
           // AnimSets(0)=AnimSet'DeathTrap.Role.Zombine1_Ani';
        }
        else
        {
            Monster1_State=1;
            Monster1_NBL.SetActiveChild(1, 0.25f);
            NewLocation=Location;
            NewLocation+=(Enemy.Location-Location)*DeltaTime*Monster1_MS;
            NewLocation+=BalanceDistance;
            SetLocation(NewLocation);
        }
    }
 }
 else//state=3,ËÀÍö
 {
     if(Monster1_IsAlive==true)
     {
         Monster1_NBL.SetActiveChild(3, 0.25f);
         Monster1_PSC.SetTranslation(vect(0.0f,-40.0f,100.0f));
         Monster1_PSC.SetRotation(rot(0,-90,0));
         Monster1_PSC.SetScale(2.0f);
         Monster1_IsAlive=false;
         Monster1_PSC.DeactivateSystem();
        // SetLocation(Location+vect(0.0f,0.0f,-10.0f));
		// SetRotation(Rotation+rot(0,0,60));
         PlaySound(Monster1_DieSC);
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
        // `log("=="@Monster1_Health);
        if(Monster1_Health>0)
        {
            Monster1_PSC.SetTranslation(vect(0.0f,40.0f,-80.0f));
            Monster1_PSC.SetRotation(rot(0,90,0));
            Monster1_PSC.ActivateSystem();
            Monster1_PSC.SetScale(2.0f);
            Monster1_Health-=DamageAmount;
            PlaySound(Monster1_DamageSC);
        }
        //if((Zombie1_Health<=0)&&bCanBeDamaged)
        else
        {
            Monster1_State=3;
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
    FollowDistance=2200.0
    AttackDistance=120.0
    BalanceDistance=(X=0,Y=0,Z=-3.0)
    BalanceRotation=(Pitch=0,Yaw=13000,Roll=0)
    DmgTime=0
    Monster1_MS=1.5
    Monster1_State=0
    Monster1_IsAlive=true
    Monster1_AttackSC=SoundCue'DeathTrap.Sound.Zombie2_AttackSC'
    Monster1_DamageSC=SoundCue'DeathTrap.Sound.Monster1_DamageSC'
    Monster1_DieSC=SoundCue'DeathTrap.Sound.Monster1_DieSC'
    Monster1_SC=SoundCue'DeathTrap.Sound.Monster1_SC'
  //  AnimSet_Zombie1='DeathTrap.Role.Zombine1_Ani'
    
    bBlockActors=true
    bCollideActors=true
    // GroundSpeed=80.0
    Monster1_Health=250
    
    Begin Object Class=DynamicLightEnvironmentComponent Name=DLEC_Monster1
        bEnabled=true
    End Object
    Components.Add(DLEC_Monster1)

    Begin Object Class=SkeletalMeshComponent Name=SMC_Monster1
        SkeletalMesh=SkeletalMesh'DeathTrap.Role.Monster1'
        Materials(0)=Material'DeathTrap.Materials.Monster1_Mat'
        AnimSets(0)=AnimSet'DeathTrap.Role.Monster1_Ani'
        AnimTreeTemplate=AnimTree'DeathTrap.Role.Monster1_Tree'
        PhysicsAsset=PhysicsAsset'DeathTrap.Role.Monster1_Physics'
        LightEnvironment=DLEC_Monster1
        Scale3D=(X=2.5,Y=2.5,Z=2.5)
    End Object
    Components.Add(SMC_Monster1)
    
    Begin Object Class=CylinderComponent Name=CC_Monster1
        CollisionRadius=32.0
        CollisionHeight=100.0
        BlockNonZeroExtent=true
        BlockZeroExtent=true
        BlockActors=true
        CollideActors=true
    End Object
    CollisionComponent=CC_Monster1
    Components.Add(CC_Monster1)
    
    Begin Object Class=ParticleSystemComponent Name=PSC_Monster1
        Template=ParticleSystem'KismetGame_Assets.Effects.P_BloodSplat_01';
        bAutoActivate=false
        bOwnerNoSee=true
        Scale=4.0f
        //Translation=(X=0.0f,Y=40.0f,Z=-100.0f)
        //Rotation=(Pitch=0,Yaw=90,Roll=0)
    End Object
    Monster1_PSC=PSC_Monster1
    Components.Add(PSC_Monster1)
        
    // ControllerClass=class'DeathTrap_Script.DTEnemy_Zombie1Controller'
}