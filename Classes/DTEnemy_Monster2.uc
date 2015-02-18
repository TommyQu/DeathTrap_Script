class DTEnemy_Monster2 extends DTActor
      placeable;

var Pawn Enemy;
var float FollowDistance;
var vector BalanceDistance;
var rotator BalanceRotation;
var float AttackDistance;
var AnimNodeBlendList Zombie5_NBL;
var ParticleSystemComponent Zombie5_PSC;
var SoundCue Zombie5_AttackSC;
var SoundCue Zombie5_DamageSC;
var SoundCue Zombie5_DieSC;
var SoundCue Zombie5_SC;
var bool SCIsPlayed;
var int DmgTime;
var int Zombie5_State;
var int Zombie5_Health;
var bool Zombie5_IsAlive;
var float Zombie5_MS;

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    Zombie5_NBL.SetActiveChild(0, 0.25f);
}

simulated event PostInitAnimTree(SkeletalMeshComponent SMC_Zombie5)
{
    Zombie5_NBL=AnimNodeBlendList(SMC_Zombie5.FindAnimNode('Zombie5_NodeBlendList'));
}

function Tick(float DeltaTime)
{
    local DTPlayerController DTPC;
    local vector NewLocation;
    if(Zombie5_State!=3)
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
           PlaySound(Zombie5_SC);
           SCIsPlayed=true;
       }
        if(VSize(Location-Enemy.Location)<AttackDistance)
        {
            Enemy.Bump(self,CollisionComponent,vect(0,0,0));
            Zombie5_State=2;
            Zombie5_NBL.SetActiveChild(2, 0.25f);
            if((DmgTime%25)==0)  //XXÃëÔì³É10µãÉËº¦
            {
                Zombie5_PSC.SetTranslation(vect(0.0f,40.0f,-100.0f));
                Zombie5_PSC.SetRotation(rot(0,90,0));
                //Zombie1_PSC.Rotation=(Pitch=0,Yaw=90,Roll=0);
                Zombie5_PSC.ActivateSystem();
                PlaySound(Zombie5_AttackSC);
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
            Zombie5_State=1;
            Zombie5_NBL.SetActiveChild(1, 0.25f);
            NewLocation=Location;
            NewLocation+=(Enemy.Location-Location)*DeltaTime*Zombie5_MS;
            NewLocation+=BalanceDistance;
            SetLocation(NewLocation);
        }
    }
 }
 else//state=3,ËÀÍö
 {
     if(Zombie5_IsAlive==true)
     {
         Zombie5_NBL.SetActiveChild(3, 0.25f);
         Zombie5_PSC.SetTranslation(vect(0.0f,-40.0f,-20.0f));
         Zombie5_PSC.SetRotation(rot(0,-90,0));
         Zombie5_PSC.SetScale(2.0f);
         Zombie5_IsAlive=false;
         Zombie5_PSC.DeactivateSystem();
        // SetLocation(Location+vect(0.0f,0.0f,-10.0f));
		// SetRotation(Rotation+rot(0,0,60));
         PlaySound(Zombie5_DieSC);
         SetCollisionSize(0,0);
         WorldInfo.Game.ScoreObjective(Enemy.Controller.PlayerReplicationInfo,600);
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
        // `log("=="@Zombie5_Health);
        if(Zombie5_Health>0)
        {
            Zombie5_PSC.SetTranslation(vect(0.0f,40.0f,-80.0f));
            Zombie5_PSC.SetRotation(rot(0,90,0));
            Zombie5_PSC.ActivateSystem();
            Zombie5_PSC.SetScale(2.0f);
            Zombie5_Health-=DamageAmount;
            PlaySound(Zombie5_DamageSC);
        }
        //if((Zombie1_Health<=0)&&bCanBeDamaged)
        else
        {
            Zombie5_State=3;
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
    FollowDistance=2500.0
    AttackDistance=120.0
    BalanceDistance=(X=0,Y=0,Z=-3.0)
    BalanceRotation=(Pitch=0,Yaw=13000,Roll=0)
    DmgTime=0
    Zombie5_MS=1.1
    Zombie5_State=0
    Zombie5_IsAlive=true
    Zombie5_AttackSC=SoundCue'DeathTrap.Sound.Zombie2_AttackSC'
    Zombie5_DamageSC=SoundCue'DeathTrap.Sound.Zombie5_DamageSC'
    Zombie5_DieSC=SoundCue'DeathTrap.Sound.Zombie5_DieSC'
    Zombie5_SC=SoundCue'DeathTrap.Sound.Zombie5_SC'
  //  AnimSet_Zombie1='DeathTrap.Role.Zombine1_Ani'
    
    bBlockActors=true
    bCollideActors=true
    // GroundSpeed=80.0
    Zombie5_Health=80
    
    Begin Object Class=DynamicLightEnvironmentComponent Name=DLEC_Zombie5
        bEnabled=true
    End Object
    Components.Add(DLEC_Zombie5)

    Begin Object Class=SkeletalMeshComponent Name=SMC_Zombie5
        SkeletalMesh=SkeletalMesh'DeathTrap.Role.Zombie5'
        Materials(0)=Material'DeathTrap.Materials.Zombie5_Mat'
        AnimSets(0)=AnimSet'DeathTrap.Role.Zombie5_Ani'
        AnimTreeTemplate=AnimTree'DeathTrap.Role.Zombie5_Tree'
        PhysicsAsset=PhysicsAsset'DeathTrap.Role.Zombie5_Physics'
        LightEnvironment=DLEC_Zombie5
        Scale3D=(X=4,Y=4,Z=4)
    End Object
    Components.Add(SMC_Zombie5)
    
    Begin Object Class=CylinderComponent Name=CC_Zombie5
        CollisionRadius=32.0
        CollisionHeight=100.0
        BlockNonZeroExtent=true
        BlockZeroExtent=true
        BlockActors=true
        CollideActors=true
    End Object
    CollisionComponent=CC_Zombie5
    Components.Add(CC_Zombie5)
    
    Begin Object Class=ParticleSystemComponent Name=PSC_Zombie5
        Template=ParticleSystem'KismetGame_Assets.Effects.P_BloodSplat_01';
        bAutoActivate=false
        bOwnerNoSee=true
        Scale=4.0f
        //Translation=(X=0.0f,Y=40.0f,Z=-100.0f)
        //Rotation=(Pitch=0,Yaw=90,Roll=0)
    End Object
    Zombie5_PSC=PSC_Zombie5
    Components.Add(PSC_Zombie5)
        
    // ControllerClass=class'DeathTrap_Script.DTEnemy_Zombie1Controller'
}