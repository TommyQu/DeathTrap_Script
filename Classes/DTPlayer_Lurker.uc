//  ================================================================================================
//   * File Name:    DTPlayerLurker
//   * Created By:   qht
//   * Time Stamp:     2014/5/11 11:27:21
//   * UDK Path:   D:\UDK\UDK-2013-07
//   * Unreal X-Editor v3.1.5.0
//   * © Copyright 2012 - 2014. All Rights Reserved.
//  ================================================================================================

class DTPlayer_Lurker extends UTFamilyInfo_Liandri_Male
      abstract;


defaultproperties
{
    FamilyID="LIAM"

    CharacterMesh=SkeletalMesh'CH_LIAM_Cathode.Mesh.SK_CH_LIAM_Cathode'

    ArmMeshPackageName="CH_Corrupt_Arms"
    ArmMesh=CH_Corrupt_Arms.Mesh.SK_CH_Corrupt_Arms_MaleA_1P
    ArmSkinPackageName="CH_Corrupt_Arms"
    RedArmMaterial=CH_Corrupt_Arms.Materials.MI_CH_Corrupt_FirstPersonArms_VRed
    BlueArmMaterial=CH_Corrupt_Arms.Materials.MI_CH_Corrupt_FirstPersonArms_VBlue

    CharacterTeamHeadMaterials[0]=MaterialInterface'CH_Corrupt_Male.Materials.MI_CH_Corrupt_MBody01_VRed'
    CharacterTeamBodyMaterials[0]=MaterialInterface'CH_Corrupt_Male.Materials.MI_CH_Corrupt_MHead01_VRed'
    CharacterTeamHeadMaterials[1]=MaterialInterface'CH_Corrupt_Male.Materials.MI_CH_Corrupt_MBody01_VBlue'
    CharacterTeamBodyMaterials[1]=MaterialInterface'CH_Corrupt_Male.Materials.MI_CH_Corrupt_MHead01_VBlue'

    PhysAsset=PhysicsAsset'CH_AnimCorrupt.Mesh.SK_CH_Corrupt_Male_Physics'
    AnimSets(0)=AnimSet'CH_AnimHuman.Anims.K_AnimHuman_BaseMale'

    BaseMICParent=MaterialInstanceConstant'CH_All.Materials.MI_CH_ALL_Corrupt_Base'
    BioDeathMICParent=MaterialInstanceConstant'CH_All.Materials.MI_CH_ALL_Corrupt_BioDeath'
    
}