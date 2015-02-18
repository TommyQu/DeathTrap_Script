class DTEnemy_Zombie6 extends DTActor
      placeable;

var Pawn Enemy;
var float FollowDistance;
var vector BalanceDistance;
var rotator BalanceRotation;
var float AttackDistance;
var AnimNodeBlendList Zombie6_NBL;
var ParticleSystemComponent Zombie6_PSC;
var SoundCue Zombie6_AttackSC;
var SoundCue Zombie6_DamageSC;
var SoundCue Zombie6_DieSC;
var SoundCue Zombie6_SC;
var bool SCIsPlayed;
var int DmgTime;
var int Zombie6_State;
var int Zombie6_Health;
var bool Zombie6_IsAlive;
var float Zombie6_MS;

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    Zombie6_NBL.SetActiveChild(0, 0.25f);
}

simulated event PostInitAnimTree(SkeletalMeshComponent SMC_Zombie6)
{
    Zombie6_NBL=AnimNodeBlendList(SMC_Zombie6.FindAnimNode('Zombie6_NodeBlendList'));
}

function Tick(float DeltaTime)
{
    local DTPlayerController DTPC;
    local vector NewLocation;
    if(Zombie6_State!=3)
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
           PlaySound(Zombie6_SC);
           SCIsPlayed=true;
       }
        if(VSize(Location-Enemy.Location)<AttackDistance)
        {
            Enemy.Bump(self,CollisionComponent,vect(0,0,0));
            Zombie6_State=2;
            Zombie6_NBL.SetActiveChild(2, 0.25f);
            if((DmgTime%25)==0)  //XXÃëÔì³É10µãÉËº¦
            {
                Zombie6_PSC.SetTranslation(vect(0.0f,40.0f,-100.0f));
                Zombie6_PSC.SetRotation(rot(0,90,0));
                //Zombie1_PSC.Rotation=(Pitch=0,Yaw=90,Roll=0);
                Zombie6_PSC.ActivateSystem();
                PlaySound(Zombie6_AttackSC);
                Enemy.Health-=7;
                WorldInfo.Game.ScoreObjective(Enemy.Controller.PlayerReplicationInfo,-70);
            }
            DmgTime++;
           // Zombie1_Walk.PlayCustomAnim('Zombine1_Attack',1.0f, 0.1f, 0.1f, false, false);
           // `log("=="@Zombie1_Walk);
           //  `log("=="@Zombie1_Walk.bIsPlayingCustomAnim);
           // AnimSets(0)=AnimSet'DeathTrap.Role.Zombine1_Ani';
        }
        else
        {
            Zombie6_State=1;
            Zombie6_NBL.SetActiveChild(1, 0.25f);
            NewLocation=Location;
            NewLocation+=(Enemy.Location-Location)*DeltaTime*Zombie6_MS;
            NewLocation+=BalanceDistance;
            SetLocation(NewLocation);
        }
    }
 }
 else//state=3,ËÀÍö
 {
     if(Zombie6_IsAlive==true)
     {
         Zombie6_NBL.SetActiveChild(3, 0.25f);
         Zombie6_PSC.SetTranslation(vect(0.0f,-40.0f,-2.5f));
         Zombie6_PSC.SetRotation(rot(0,-90,0));
         Zombie6_PSC.SetScale(2.0f);
         Zombie6_IsAlive=false;
         Zombie6_PSC.DeactivateSystem();
        // SetLocation(Location+vect(0.0f,0.0f,-10.0f));
		// SetRotation(Rotation+rot(0,0,60));
         PlaySound(Zombie6_DieSC);
         SetCollisionSize(0,0);
         WorldInfo.Game.ScoreObjective(Enemy.Controller.PlayerReplicationInfo,550);
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
        // `log("=="@Zombie6_Health);
        if(Zombie6_Health>0)
        {
            Zombie6_PSC.SetTranslation(vect(0.0f,40.0f,-80.0f));
            Zombie6_PSC.SetRotation(rot(0,90,0));
            Zombie6_PSC.ActivateSystem();
            Zombie6_PSC.SetScale(2.0f);
            Zombie6_Health-=DamageAmount;
            PlaySound(Zombie6_DamageSC);
        }
        //if((Zombie1_Health<=0)&&bCanBeDamaged)
        else
        {
            Zombie6_State=3;
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
    BalanceDistance=(X=0,Y=0,Z=-2.6)
    BalanceRotation=(Pitch=0,Yaw=13000,Roll=0)
    DmgTime=0
    Zombie6_MS=1.3
    Zombie6_State=0
    Zombie6_IsAlive=true
    Zombie6_AttackSC=SoundCue'DeathTrap.Sound.Zombie2_AttackSC'
    Zombie6_DamageSC=SoundCue'DeathTrap.Sound.Zombie6_DamageSC'
    Zombie6_DieSC=SoundCue'DeathTrap.Sound.Zombie6_DieSC'
    Zombie6_SC=SoundCue'DeathTrap.Sound.Zombie6_SC'
  //  AnimSet_Zombie1='DeathTrap.Role.Zombine1_Ani'
    
    bBlockActors=true
    bCollideActors=true
    // GroundSpeed=80.0
    Zombie6_Health=80
    
    Begin Object Class=DynamicLightEnvironmentComponent Name=DLEC_Zombie6
        bEnabled=true
    End Object
    Components.Add(DLEC_Zombie6)

    Begin Object Class=SkeletalMeshComponent Name=SMC_Zombie6
        SkeletalMesh=SkeletalMesh'DeathTrap.Role.Zombie6'
        Materials(0)=Material'DeathTrap.Materials.Zombie6_Mat'
        AnimSets(0)=AnimSet'DeathTrap.Role.Zombie6_Ani'
        AnimTreeTemplate=AnimTree'DeathTrap.Role.Zombie6_Tree'
        PhysicsAsset=PhysicsAsset'DeathTrap.Role.Zombie6_Physics'
        LightEnvironment=DLEC_Zombie6
        Scale3D=(X=2.3,Y=2.3,Z=2.3)
    End Object
    Components.Add(SMC_Zombie6)
    
    Begin Object Class=CylinderComponent Name=CC_Zombie6
        CollisionRadius=32.0
        CollisionHeight=100.0
        BlockNonZeroExtent=true
        BlockZeroExtent=true
        BlockActors=true
        CollideActors=true
    End Object
    CollisionComponent=CC_Zombie6
    Components.Add(CC_Zombie6)
    
    Begin Object Class=ParticleSystemComponent Name=PSC_Zombie6
        Template=ParticleSystem'KismetGame_Assets.Effects.P_BloodSplat_01';
        bAutoActivate=false
        bOwnerNoSee=true
        Scale=4.0f
        //Translation=(X=0.0f,Y=40.0f,Z=-100.0f)
        //Rotation=(Pitch=0,Yaw=90,Roll=0)
    End Object
    Zombie6_PSC=PSC_Zombie6
    Components.Add(PSC_Zombie6)
        
    // ControllerClass=class'DeathTrap_Script.DTEnemy_Zombie1Controller'
}