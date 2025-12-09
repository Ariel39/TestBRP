-- ===============================
-- PARTE 5: ARCHIVO CLIENT/medic_inspection_keybind.lua  
-- ===============================

-- Función para obtener la tecla de inspección
local function GetInspectionKey()
    local keyString = easzy.bodydamage.config.medicInspectionKey or "I"
    local keyStringLowered = string.lower(keyString)
    local keyNumber = input.GetKeyCode(keyStringLowered)
    return keyNumber
end

-- Hook para manejar la tecla de inspección médica
local lastInspectionClick = 0
hook.Add("PlayerButtonDown", "ezbodydamage_medic_inspection_PlayerButtonDown", function(ply, key)
    if key != GetInspectionKey() then return end
    if CurTime() - lastInspectionClick < 0.5 then return end
    lastInspectionClick = CurTime()
    
    -- Verificar que el jugador es medic
    if not easzy.bodydamage.PlayerCanInspect(ply) then return end
    
    -- Enviar solicitud de inspección al servidor
    net.Start("ezbodydamage_medic_inspect_request")
    net.SendToServer()
end)

-- Mostrar ayuda en pantalla para medics
hook.Add("HUDPaint", "ezbodydamage_medic_inspection_help", function()
    local localPlayer = LocalPlayer()
    if not IsValid(localPlayer) then return end
    
    -- Solo mostrar a medics
    if not easzy.bodydamage.PlayerCanInspect(localPlayer) then return end
    
    -- No mostrar si hay menús activos
    if easzy.bodydamage.isMenuActive or easzy.bodydamage.isInspectionMenuActive then return end
    
    local trace = localPlayer:GetEyeTrace()
    local target = trace.Entity
    
    -- Verificar si está mirando a un jugador o ragdoll
    local isValidTarget = false
    if IsValid(target) and target:IsPlayer() and target:Alive() then
        isValidTarget = true
    elseif IsValid(target) and target:IsRagdoll() and target.OwnerINT then
        isValidTarget = true
    end
    
    if isValidTarget and easzy.bodydamage.GetInDistance(localPlayer, target, 200) then
        local keyText = easzy.bodydamage.config.medicInspectionKey or "I"
        local helpText = "Presiona [" .. keyText .. "] para inspeccionar paciente"
        
        draw.SimpleText(helpText, "EZFont20", ScrW()/2, ScrH()/2 + 100, easzy.bodydamage.colors.white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end)

-- Cerrar menú de inspección con ESC
hook.Add("PlayerButtonDown", "ezbodydamage_close_inspection_menu", function(ply, key)
    if key == KEY_ESCAPE and easzy.bodydamage.isInspectionMenuActive then
        easzy.bodydamage.RemoveMedicInspectionMenu()
    end
end)