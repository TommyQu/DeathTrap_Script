class DTEnemy_Zombie7 extends DTActor
      placeable;

var Pawn Enemy;
var float FollowDistance;
var vector BalanceDistance;
var rotator BalanceRotation;
var float AttackDistance;
var AnimNodeBlendList Zombie7_NBL;
var ParticleSystemComponent Zombie7_PSC;
var SoundCue Zombie7_AttackSC;
var SoundCue Zombie7_DamageSC;
var SoundCue Zombie7_DieSC;
var SoundCue Zombie7_SC;
var bool SCIsPlayed;
var int DmgTime;
var int Zombie7_State;
var int Zombie7_Health;
var bool Zombie7_IsAlive;
var float Zombie7_MS;

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    Zombie7_NBL.SetActiveChild(0, 0.25f);
}

simulated event PostInitAnimTree(SkeletalMeshComponent SMC_Zombie7)
{
    Zombie7_NBL=AnimNodeBlendList(SMC_Zombie7.FindAnimNode('Zombie7_NodeBlendList'));
}

function Tick(float DeltaTime)
{
    local DTPlayerController DTPC;
    local vector NewLocation;
    if(Zombie7_State!=3)
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
           PlaySound(Zombie7_SC);
           SCIsPlayed=true;
       }
        if(VSize(Location-Enemy.Location)<AttackDistance)
        {
            Enemy.Bump(self,CollisionComponent,vect(0,0,0));
            Zombie7_State=2;
            Zombie7_NBL.SetActiveChild(2, 0.25f);
            if((DmgTime%25)==0)  //XXÃëÔì³É10µãÉËº¦
            {
                Zombie7_PSC.SetTranslation(vect(0.0f,40.0f,-100.0f));
                Zombie7_PSC.SetRotation(rot(0,90,0));
                //Zombie1_PSC.Rotation=(Pitch=0,Yaw=90,Roll=0);
                Zombie7_PSC.ActivateSystem();
                PlaySound(Zombie7_AttackSC);
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
            Zombie7_State=1;
            Zombie7_NBL.SetActiveChild(1, 0.25f);
            NewLocation=Location;
            NewLocation+=(Enemy.Location-Location)*DeltaTime*Zombie7_MS;
            NewLocation+=BalanceDistance;
            SetLocation(NewLocation);
        }
    }
 }
 else//state=3,ËÀÍö
 {
     if(Zombie7_IsAlive==true)
     {
         Zombie7_NBL.SetActiveChild(3, 0.25f);
         Zombie7_PSC.SetTranslation(vect(0.0f,-40.0f,-2.0f));
         Zombie7_PSC.SetRotation(rot(0,-90,0));
         Zombie7_PSC.SetScale(2.0f);
         Zombie7_IsAlive=false;
         Zombie7_PSC.DeactivateSystem();
        // SetLocation(Location+vect(0.0f,0.0f,-10.0f));
		// SetRotation(Rotation+rot(0,0,60));
         PlaySound(Zombie7_DieSC);
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
        // `log("=="@Zombie7_Health);
        if(Zombie7_Health>0)
        {
            Zombie7_PSC.SetTranslation(vect(0.0f,40.0f,-80.0f));
            Zombie7_PSC.SetRotation(rot(0,90,0));
            Zombie7_PSC.ActivateSystem();
            Zombie7_PSC.SetScale(2.0f);
            Zombie7_Health-=DamageAmount;
            PlaySound(Zombie7_DamageSC);
        }
        //if((Zombie1_Health<=0)&&bCanBeDamaged)
        else
        {
            Zombie7_State=3;
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
    FollowDistance=512.0
    AttackDistance=96.0
    BalanceDistance=(X=0,Y=0,Z=-1.5)
    BalanceRotation=(Pitch=0,Yaw=13000,Roll=0)
    DmgTime=0
    Zombie7_MS=0.6
    Zombie7_State=0
    Zombie7_IsAlive=true
    Zombie7_AttackSC=SoundCue'A_Character_BodyImpacts.BodyImpacts.A_Character_BodyImpact_Bullet_Cue'
    Zombie7_DamageSC=SoundCue'A_Weapon_BioRifle.Weapon.A_BioRifle_FireImpactFizzle_Cue'
    Zombie7_DieSC=SoundCue'DeathTrap.Sound.Zombine1_DieSC'
    Zombie7_SC=SoundCue'DeathTrap.Sound.Zombine1_SC'
  //  AnimSet_Zombie1='DeathTrap.Role.Zombine1_Ani'
    
    bBlockActors=true
    bCollideActors=true
    // GroundSpeed=80.0
    Zombie7_Health=50
    
    Begin Object Class=DynamicLightEnvironmentComponent Name=DLEC_Zombie7
        bEnabled=true
    End Object
    Components.Add(DLEC_Zombie7)

    Begin Object Class=SkeletalMeshComponent Name=SMC_Zombie7
        SkeletalMesh=SkeletalMesh'DeathTrap.Role.Zombie7'
        Materials(0)=Material'DeathTrap.Materials.Zombie7_Mat'
        AnimSets(0)=AnimSet'DeathTrap.Role.Zombie7_Ani'
        AnimTreeTemplate=AnimTree'DeathTrap.Role.Zombie7_Tree'
        PhysicsAsset=PhysicsAsset'DeathTrap.Role.Zombie7_Physics'
        LightEnvironment=DLEC_Zombie7
        Scale3D=(X=4,Y=4,Z=4)
    End Object
    Components.Add(SMC_Zombie7)
    
    Begin Object Class=CylinderComponent Name=CC_Zombie7
        CollisionRadius=32.0
        CollisionHeight=100.0
        BlockNonZeroExtent=true
        BlockZeroExtent=true
        BlockActors=true
        CollideActors=true
    End Object
    CollisionComponent=CC_Zombie7
    Components.Add(CC_Zombie7)
    
    Begin Object Class=ParticleSystemComponent Name=PSC_Zombie7
        Template=ParticleSystem'KismetGame_Assets.Effects.P_BloodSplat_01';
        bAutoActivate=false
        bOwnerNoSee=true
        Scale=4.0f
        //Translation=(X=0.0f,Y=40.0f,Z=-100.0f)
        //Rotation=(Pitch=0,Yaw=90,Roll=0)
    End Object
    Zombie7_PSC=PSC_Zombie7
    Components.Add(PSC_Zombie7)
        
    // ControllerClass=class'DeathTrap_Script.DTEnemy_Zombie1Controller'
}