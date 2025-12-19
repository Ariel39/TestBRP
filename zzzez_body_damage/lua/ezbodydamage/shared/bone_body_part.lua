easzy.bodydamage.boneBodyPart = easzy.bodydamage.boneBodyPart or {
    ["ValveBiped.Bip01_Neck1"] = "Head",
    ["ValveBiped.Bip01_Head1"] = "Head",
    ["ValveBiped.forward"] = "Head",

    ["ValveBiped.Bip01_Spine"] = "Body",
    ["ValveBiped.Bip01_Spine1"] = "Body",
    ["ValveBiped.Bip01_Spine2"] = "Body",
    ["ValveBiped.Bip01_Spine4"] = "Body",
    ["ValveBiped.Bip01_L_Clavicle"] = "Body",
    ["ValveBiped.Bip01_R_Clavicle"] = "Body",
    ["ValveBiped.Bip01_L_Latt"] = "Body",
    ["ValveBiped.Bip01_R_Latt"] = "Body",
    ["ValveBiped.Bip01_L_Trapezius"] = "Body",
    ["ValveBiped.Bip01_R_Trapezius"] = "Body",
    ["ValveBiped.Bip01_L_Pectoral"] = "Body",
    ["ValveBiped.Bip01_R_Pectoral"] = "Body",
    ["ValveBiped.Bip01_Pelvis"] = "Body",

    ["ValveBiped.Bip01_L_UpperArm"] = "LeftArm",
    ["ValveBiped.Bip01_L_Shoulder"] = "LeftArm",
    ["ValveBiped.Bip01_L_Bicep"] = "LeftArm",
    ["ValveBiped.Bip01_L_Forearm"] = "LeftArm",
    ["ValveBiped.Bip01_L_Elbow"] = "LeftArm",
    ["ValveBiped.Bip01_L_Ulna"] = "LeftArm",
    ["ValveBiped.Bip01_L_Hand"] = "LeftArm",
    ["ValveBiped.Bip01_L_Wrist"] = "LeftArm",
    ["ValveBiped.Bip01_L_Finger0"] = "LeftArm",
    ["ValveBiped.Bip01_L_Finger01"] = "LeftArm",
    ["ValveBiped.Bip01_L_Finger02"] = "LeftArm",
    ["ValveBiped.Bip01_L_Finger1"] = "LeftArm",
    ["ValveBiped.Bip01_L_Finger11"] = "LeftArm",
    ["ValveBiped.Bip01_L_Finger12"] = "LeftArm",
    ["ValveBiped.Bip01_L_Finger2"] = "LeftArm",
    ["ValveBiped.Bip01_L_Finger21"] = "LeftArm",
    ["ValveBiped.Bip01_L_Finger22"] = "LeftArm",
    ["ValveBiped.Bip01_L_Finger3"] = "LeftArm",
    ["ValveBiped.Bip01_L_Finger31"] = "LeftArm",
    ["ValveBiped.Bip01_L_Finger32"] = "LeftArm",
    ["ValveBiped.Bip01_L_Finger4"] = "LeftArm",
    ["ValveBiped.Bip01_L_Finger41"] = "LeftArm",
    ["ValveBiped.Bip01_L_Finger42"] = "LeftArm",
    ["ValveBiped.Anim_Attachment_LH"] = "LeftArm",

    ["ValveBiped.Bip01_R_UpperArm"] = "RightArm",
    ["ValveBiped.Bip01_R_Shoulder"] = "RightArm",
    ["ValveBiped.Bip01_R_Bicep"] = "RightArm",
    ["ValveBiped.Bip01_R_Forearm"] = "RightArm",
    ["ValveBiped.Bip01_R_Ulna"] = "RightArm",
    ["ValveBiped.Bip01_R_Elbow"] = "RightArm",
    ["ValveBiped.Bip01_R_Hand"] = "RightArm",
    ["ValveBiped.Bip01_R_Wrist"] = "RightArm",
    ["ValveBiped.Bip01_R_Finger0"] = "RightArm",
    ["ValveBiped.Bip01_R_Finger01"] = "RightArm",
    ["ValveBiped.Bip01_R_Finger02"] = "RightArm",
    ["ValveBiped.Bip01_R_Finger1"] = "RightArm",
    ["ValveBiped.Bip01_R_Finger11"] = "RightArm",
    ["ValveBiped.Bip01_R_Finger12"] = "RightArm",
    ["ValveBiped.Bip01_R_Finger2"] = "RightArm",
    ["ValveBiped.Bip01_R_Finger21"] = "RightArm",
    ["ValveBiped.Bip01_R_Finger22"] = "RightArm",
    ["ValveBiped.Bip01_R_Finger3"] = "RightArm",
    ["ValveBiped.Bip01_R_Finger31"] = "RightArm",
    ["ValveBiped.Bip01_R_Finger32"] = "RightArm",
    ["ValveBiped.Bip01_R_Finger4"] = "RightArm",
    ["ValveBiped.Bip01_R_Finger41"] = "RightArm",
    ["ValveBiped.Bip01_R_Finger42"] = "RightArm",
    ["ValveBiped.Anim_Attachment_RH"] = "RightArm",

    ["ValveBiped.Bip01_L_Thigh"] = "LeftLeg",
    ["ValveBiped.Bip01_L_Calf"] = "LeftLeg",
    ["ValveBiped.Bip01_L_Foot"] = "LeftLeg",
    ["ValveBiped.Bip01_L_Toe0"] = "LeftLeg",

    ["ValveBiped.Bip01_R_Thigh"] = "RightLeg",
    ["ValveBiped.Bip01_R_Calf"] = "RightLeg",
    ["ValveBiped.Bip01_R_Foot"] = "RightLeg",
    ["ValveBiped.Bip01_R_Toe0"] = "RightLeg"
}

easzy.bodydamage.bodyPartsHierarchy = easzy.bodydamage.bodyPartsHierarchy or {
    ["Head"] = {
        ["parent"] = "Body"
    },
    ["Body"] = {
        ["children"] = {
            "Head",
            "LeftArm",
            "RightArm",
            "LeftLeg",
            "RightLeg"
        }
    },
    ["LeftArm"] = {
        ["parent"] = "Body"
    },
    ["RightArm"] = {
        ["parent"] = "Body"
    },
    ["LeftLeg"] = {
        ["parent"] = "Body"
    },
    ["RightLeg"] = {
        ["parent"] = "Body"
    },
}
