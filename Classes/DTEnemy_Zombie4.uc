class DTEnemy_Zombie4 extends DTActor
      placeable;

var Pawn Enemy;
var float FollowDistance;
var vector BalanceDistance;
var rotator BalanceRotation;
var float AttackDistance;
var AnimNodeBlendList Zombie4_NBL;
var ParticleSystemComponent Zombie4_PSC;
var SoundCue Zombie4_AttackSC;
var SoundCue Zombie4_DamageSC;
var SoundCue Zombie4_DieSC;
var SoundCue Zombie4_SC;
var bool SCIsPlayed;
var int DmgTime;
var int Zombie4_State;
var int Zombie4_Health;
var bool Zombie4_IsAlive;
var float Zombie4_MS;

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    Zombie4_NBL.SetActiveChild(0, 0.25f);
}

simulated event PostInitAnimTree(SkeletalMeshComponent SMC_Zombie4)
{
    Zombie4_NBL=AnimNodeBlendList(SMC_Zombie4.FindAnimNode('Zombie4_NodeBlendList'));
}

function Tick(float DeltaTime)
{
    local DTPlayerController DTPC;
    local vector NewLocation;
    if(Zombie4_State!=3)
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
           PlaySound(Zombie4_SC);
           SCIsPlayed=true;
       }
        if(VSize(Location-Enemy.Location)<AttackDistance)
        {
            Enemy.Bump(self,CollisionComponent,vect(0,0,0));
            Zombie4_State=2;
            Zombie4_NBL.SetActiveChild(2, 0.25f);
            if((DmgTime%25)==0)  //XXÃëÔì³É10µãÉËº¦
            {
                Zombie4_PSC.SetTranslation(vect(0.0f,40.0f,-100.0f));
                Zombie4_PSC.SetRotation(rot(0,90,0));
                //Zombie1_PSC.Rotation=(Pitch=0,Yaw=90,Roll=0);
                Zombie4_PSC.ActivateSystem();
                PlaySound(Zombie4_AttackSC);
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
            Zombie4_State=1;
            Zombie4_NBL.SetActiveChild(1, 0.25f);
            NewLocation=Location;
            NewLocation+=(Enemy.Location-Location)*DeltaTime*Zombie4_MS;
            NewLocation+=BalanceDistance;
            SetLocation(NewLocation);
        }
    }
 }
 else//state=3,ËÀÍö
 {
     if(Zombie4_IsAlive==true)
     {
         Zombie4_NBL.SetActiveChild(3, 0.25f);
         Zombie4_PSC.SetTranslation(vect(0.0f,-40.0f,100.0f));
         Zombie4_PSC.SetRotation(rot(0,-90,0));
         Zombie4_PSC.SetScale(2.0f);
         Zombie4_IsAlive=false;
         Zombie4_PSC.DeactivateSystem();
        // SetLocation(Location+vect(0.0f,0.0f,-10.0f));
		// SetRotation(Rotation+rot(0,0,60));
         PlaySound(Zombie4_DieSC);
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
        // `log("=="@Zombie4_Health);
        if(Zombie4_Health>0)
        {
            Zombie4_PSC.SetTranslation(vect(0.0f,40.0f,-80.0f));
            Zombie4_PSC.SetRotation(rot(0,90,0));
            Zombie4_PSC.ActivateSystem();
            Zombie4_PSC.SetScale(2.0f);
            Zombie4_Health-=DamageAmount;
            PlaySound(Zombie4_DamageSC);
        }
        //if((Zombie1_Health<=0)&&bCanBeDamaged)
        else
        {
            Zombie4_State=3;
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
    AttackDistance=120.0
    BalanceDistance=(X=0,Y=0,Z=-3.0)
    BalanceRotation=(Pitch=0,Yaw=13000,Roll=0)
    DmgTime=0
    Zombie4_MS=1.3
    Zombie4_State=0
    Zombie4_IsAlive=true
    Zombie4_AttackSC=SoundCue'DeathTrap.Sound.Zombie2_AttackSC'
    Zombie4_DamageSC=SoundCue'DeathTrap.Sound.Zombie4_DamageSC'
    Zombie4_DieSC=SoundCue'DeathTrap.Sound.Zombie4_DieSC'
    Zombie4_SC=SoundCue'DeathTrap.Sound.Zombie4_SC'
  //  AnimSet_Zombie1='DeathTrap.Role.Zombine1_Ani'
    
    bBlockActors=true
    bCollideActors=true
    // GroundSpeed=80.0
    Zombie4_Health=80
    
    Begin Object Class=DynamicLightEnvironmentComponent Name=DLEC_Zombie4
        bEnabled=true
    End Object
    Components.Add(DLEC_Zombie4)

    Begin Object Class=SkeletalMeshComponent Name=SMC_Zombie4
        SkeletalMesh=SkeletalMesh'DeathTrap.Role.Zombie4'
        Materials(0)=Material'DeathTrap.Materials.Zombie4_Mat'
        AnimSets(0)=AnimSet'DeathTrap.Role.Zombie4_Ani'
        AnimTreeTemplate=AnimTree'DeathTrap.Role.Zombie4_Tree'
        PhysicsAsset=PhysicsAsset'DeathTrap.Role.Zombie4_Physics'
        LightEnvironment=DLEC_Zombie4
        Scale3D=(X=2,Y=2,Z=2)
    End Object
    Components.Add(SMC_Zombie4)
    
    Begin Object Class=CylinderComponent Name=CC_Zombie4
        CollisionRadius=32.0
        CollisionHeight=100.0
        BlockNonZeroExtent=true
        BlockZeroExtent=true
        BlockActors=true
        CollideActors=true
    End Object
    CollisionComponent=CC_Zombie4
    Components.Add(CC_Zombie4)
    
    Begin Object Class=ParticleSystemComponent Name=PSC_Zombie4
        Template=ParticleSystem'KismetGame_Assets.Effects.P_BloodSplat_01';
        bAutoActivate=false
        bOwnerNoSee=true
        Scale=4.0f
        //Translation=(X=0.0f,Y=40.0f,Z=-100.0f)
        //Rotation=(Pitch=0,Yaw=90,Roll=0)
    End Object
    Zombie4_PSC=PSC_Zombie4
    Components.Add(PSC_Zombie4)
        
    // ControllerClass=class'DeathTrap_Script.DTEnemy_Zombie1Controller'
}