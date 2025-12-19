-- EZ Body Damage: Sistema de Caché de Datos de Pacientes para Médicos

local patientCache = {}
patientCache.data = {}
patientCache.lastRequest = {}
patientCache.updateInterval = 0.5 -- Actualizar cada 0.5 segundos

-- Obtener datos de un paciente
function patientCache:GetPatientData(target)
    if not IsValid(target) then return nil end
    
    local entIndex = target:EntIndex()
    
    -- Si es el jugador local, usar datos directos
    if target == LocalPlayer() then
        if easzy.bodydamage.IsBodyHealthValid(target) then
            return target.easzy.bodydamage.bodyHealth
        end
        return nil
    end
    
    -- Solicitar actualización si es necesario
    local lastReq = self.lastRequest[entIndex] or 0
    if CurTime() - lastReq > self.updateInterval then
        self:RequestPatientData(target)
        self.lastRequest[entIndex] = CurTime()
    end
    
    -- Retornar datos cacheados
    return self.data[entIndex]
end

-- Solicitar datos al servidor
function patientCache:RequestPatientData(target)
    if not IsValid(target) then return end
    
    net.Start("ezbodydamage_request_patient_data")
        net.WriteEntity(target)
    net.SendToServer()
end

-- Recibir datos del servidor
net.Receive("ezbodydamage_patient_data", function()
    local entIndex = net.ReadUInt(16)
    
    local bodyHealth = {
        Head = {},
        Body = {},
        LeftArm = {},
        RightArm = {},
        LeftLeg = {},
        RightLeg = {}
    }
    
    for partID, _ in pairs(bodyHealth) do
        bodyHealth[partID] = {
            health = net.ReadUInt(8),
            broken = net.ReadBool(),
            bleeding = net.ReadBool(),
            isBoneBeingRepaired = net.ReadBool()
        }
    end
    
    patientCache.data[entIndex] = bodyHealth
end)

-- Limpiar caché de jugadores desconectados
hook.Add("EntityRemoved", "ezbodydamage_patient_cache_cleanup", function(ent)
    if ent:IsPlayer() then
        local entIndex = ent:EntIndex()
        patientCache.data[entIndex] = nil
        patientCache.lastRequest[entIndex] = nil
    end
end)

-- Exponer globalmente
easzy.bodydamage.patientCache = patientCache