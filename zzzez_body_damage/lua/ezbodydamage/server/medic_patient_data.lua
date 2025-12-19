-- EZ Body Damage: Sistema de Envío de Datos de Pacientes

util.AddNetworkString("ezbodydamage_request_patient_data")
util.AddNetworkString("ezbodydamage_patient_data")

-- Manejar solicitud de datos
net.Receive("ezbodydamage_request_patient_data", function(_, medic)
    if not IsValid(medic) or not medic:IsPlayer() then return end
    
    -- Verificar que es médico
    if not easzy.bodydamage.IsMedic(medic) then return end
    
    local target = net.ReadEntity()
    
    if not IsValid(target) or not target:IsPlayer() then return end
    
    -- Verificar distancia
    if not easzy.bodydamage.GetInDistance(medic, target, 350) then return end
    
    -- Verificar que el target tiene datos válidos
    if not easzy.bodydamage.IsBodyHealthValid(target) then return end
    
    local bodyHealth = target.easzy.bodydamage.bodyHealth
    
    -- Enviar datos
    net.Start("ezbodydamage_patient_data")
        net.WriteUInt(target:EntIndex(), 16)
        
        -- Enviar en orden específico
        local order = {"Head", "Body", "LeftArm", "RightArm", "LeftLeg", "RightLeg"}
        for _, partID in ipairs(order) do
            local partData = bodyHealth[partID]
            net.WriteUInt(math.Clamp(partData.health, 0, 255), 8)
            net.WriteBool(partData.broken)
            net.WriteBool(partData.bleeding)
            net.WriteBool(partData.isBoneBeingRepaired)
        end
    net.Send(medic)
end)