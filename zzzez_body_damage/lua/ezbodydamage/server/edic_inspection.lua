-- ===============================
-- PARTE 3: ARCHIVO SERVER/medic_inspection.lua
-- ===============================

-- Network string para la inspección médica
util.AddNetworkString("ezbodydamage_medic_inspection")
util.AddNetworkString("ezbodydamage_medic_inspect_request")

-- Función para enviar datos de inspección al medic
function easzy.bodydamage.SendPatientDataToMedic(medic, patient)
    if not IsValid(medic) or not IsValid(patient) then return end
    if not medic:IsPlayer() or not patient:IsPlayer() then return end
    
    -- Verificar que el medic puede inspeccionar
    if not easzy.bodydamage.IsMedic(medic) then return end
    
    -- Verificar que el paciente tiene datos válidos
    if not easzy.bodydamage.IsBodyHealthValid(patient) then return end
    
    local bodyHealth = patient.easzy.bodydamage.bodyHealth
    
    net.Start("ezbodydamage_medic_inspection")
    net.WriteUInt(patient:EntIndex(), 8)
    
    -- Enviar datos de cada parte del cuerpo
    for bodyPart, bodyPartData in pairs(bodyHealth) do
        net.WriteString(bodyPart)
        net.WriteUInt(math.Clamp(bodyPartData.health, 0, 255), 8)
        net.WriteBool(bodyPartData.broken)
        net.WriteBool(bodyPartData.bleeding)
        net.WriteBool(bodyPartData.isBoneBeingRepaired)
    end
    
    net.Send(medic)
end

-- Manejar solicitudes de inspección
net.Receive("ezbodydamage_medic_inspect_request", function(_, medic)
    if not IsValid(medic) or not medic:IsPlayer() then return end
    
    -- Verificar que es medic
    if not easzy.bodydamage.IsMedic(medic) then
        DarkRP.notify(medic, 1, 4, "Solo los médicos pueden inspeccionar pacientes.")
        return
    end
    
    -- Obtener el jugador que está mirando
    local trace = medic:GetEyeTrace()
    local target = trace.Entity
    
    if not IsValid(target) or not target:IsPlayer() then
        DarkRP.notify(medic, 1, 4, "Debes mirar a un jugador para inspeccionarlo.")
        return
    end
    
    -- Verificar distancia
    if not easzy.bodydamage.GetInDistance(medic, target, 200) then
        DarkRP.notify(medic, 1, 4, "Debes estar más cerca del paciente.")
        return
    end
    
    -- Si el objetivo está muerto (ragdoll), obtener el propietario
    if target:IsRagdoll() and target.OwnerINT then
        target = player.GetAll()[target.OwnerINT]
        if not IsValid(target) then return end
    end
    
    -- Enviar datos del paciente al medic
    easzy.bodydamage.SendPatientDataToMedic(medic, target)
    
    DarkRP.notify(medic, 0, 4, "Inspeccionando a " .. target:Name())
end)
-- ===============================
-- CORRECCIONES PARA server/medic_inspection.lua
-- ===============================

-- Agregar al final de server/medic_inspection.lua:

-- Network para usar items médicos en pacientes
util.AddNetworkString("ezbodydamage_use_medic_item_on_patient")

-- Manejar uso de items médicos por medics en pacientes
net.Receive("ezbodydamage_use_medic_item_on_patient", function(_, medic)
    if not IsValid(medic) or not medic:IsPlayer() then return end
    
    local targetPlayer = net.ReadEntity()
    local bodyPart = net.ReadString()
    local itemClass = net.ReadString()
    
    -- Verificaciones de seguridad
    if not IsValid(targetPlayer) or not targetPlayer:IsPlayer() then return end
    if not easzy.bodydamage.IsMedic(medic) then return end
    if not easzy.bodydamage.GetInDistance(medic, targetPlayer, 200) then return end
    if not medic:HasWeapon(itemClass) then return end
    
    local weapon = medic:GetWeapon(itemClass)
    if not IsValid(weapon) then return end
    
    -- Usar el item en el paciente (simular secondary attack)
    local oldTarget = medic.medicInspectionTarget
    medic.medicInspectionTarget = targetPlayer
    
    -- Ejecutar el tratamiento
    weapon:SecondaryAttack()
    
    medic.medicInspectionTarget = oldTarget
    
    DarkRP.notify(medic, 0, 4, "Has tratado a " .. targetPlayer:Name())
    DarkRP.notify(targetPlayer, 0, 4, "Has sido tratado por " .. medic:Name())
end)

-- Modificar las funciones de tratamiento existentes para soportar ragdolls
-- Esto se debe agregar a las armas médicas, pero como ejemplo:

-- Función auxiliar para obtener el jugador objetivo (vivo o ragdoll)
function easzy.bodydamage.GetTargetPlayerFromTrace(medic)
    local trace = medic:GetEyeTrace()
    local target = trace.Entity
    
    if IsValid(target) and target:IsPlayer() and target:Alive() then
        return target
    elseif IsValid(target) and target:IsRagdoll() and target.OwnerINT then
        local ragdollOwner = player.GetAll()[target.OwnerINT]
        if IsValid(ragdollOwner) then
            return ragdollOwner
        end
    end
    
    return nil
end