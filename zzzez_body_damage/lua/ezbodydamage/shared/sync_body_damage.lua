if CLIENT then
    net.Receive("ezbodydamage_sync_body_damage", function()
        local localPlayer = LocalPlayer() -- LocalPlayer() not valid at the first spawn
        if not IsValid(localPlayer) then return end

        localPlayer.easzy = localPlayer.easzy or {}
        localPlayer.easzy.bodydamage = localPlayer.easzy.bodydamage or {}

        localPlayer.easzy.bodydamage.treatmentCost = net.ReadUInt(32)
        localPlayer.easzy.bodydamage.treatmentTime = net.ReadUInt(32)
        localPlayer.easzy.bodydamage.isBeingTreated = net.ReadBool()
        localPlayer.easzy.bodydamage.dead = net.ReadBool()
        localPlayer.easzy.bodydamage.pain = net.ReadBool()
        localPlayer.easzy.bodydamage.painkillers = net.ReadBool()

        localPlayer.easzy.bodydamage.bodyHealth = {
            ["Head"] = {},
            ["Body"] = {},
            ["LeftArm"] = {},
            ["RightArm"] = {},
            ["LeftLeg"] = {},
            ["RightLeg"] = {}
        }

        local bodyHealth = localPlayer.easzy.bodydamage.bodyHealth
        for i = 1, table.Count(bodyHealth) do
            local bodyPart = net.ReadString()
            local bodyPartHealth = net.ReadUInt(32)
            local bodyPartBroken = net.ReadBool()
            local bodyPartBoneIsBeingRepaired = net.ReadBool()
            local bodyPartBleeding = net.ReadBool()

            localPlayer.easzy.bodydamage.bodyHealth[bodyPart] = {
                health = bodyPartHealth,
                broken = bodyPartBroken,
                isBoneBeingRepaired = bodyPartBoneIsBeingRepaired,
                bleeding = bodyPartBleeding
            }
        end
    end)
else
    util.AddNetworkString("ezbodydamage_sync_body_damage")

    function easzy.bodydamage.SyncBodyDamage(ply)
        if not easzy.bodydamage.IsBodyHealthValid(ply) then return end
        local bodyHealth = ply.easzy.bodydamage.bodyHealth

        net.Start("ezbodydamage_sync_body_damage")
        net.WriteUInt(ply.easzy.bodydamage.treatmentCost, 32)
        net.WriteUInt(ply.easzy.bodydamage.treatmentTime, 32)
        net.WriteBool(ply.easzy.bodydamage.isBeingTreated)
        net.WriteBool(ply.easzy.bodydamage.dead)
        net.WriteBool(ply.easzy.bodydamage.pain)
        net.WriteBool(ply.easzy.bodydamage.painkillers)
        for bodyPart, bodyPartData in pairs(bodyHealth) do
            net.WriteString(bodyPart)
            net.WriteUInt(bodyPartData.health, 32)
            net.WriteBool(bodyPartData.broken)
            net.WriteBool(bodyPartData.isBoneBeingRepaired)
            net.WriteBool(bodyPartData.bleeding)
        end
        net.Send(ply)
    end
end
