-- ========================================
-- NETWORKING PARA MINIJUEGOS
-- ========================================

if SERVER then
    util.AddNetworkString("ezbodydamage_start_minigame")
    util.AddNetworkString("ezbodydamage_minigame_result")
	util.AddNetworkString("easzy.bodydamage.RequestMinigame")  -- ← AGREGAR
    util.AddNetworkString("easzy.bodydamage.MinigameResult")   -- ← AGREGAR
    
    -- Pedir al cliente que abra un minijuego
    function easzy.bodydamage.RequestMinigame(ply, minigameType, itemClass, bodyPart, targetPlayer)
        if not IsValid(ply) then return end
        
        net.Start("ezbodydamage_start_minigame")
        net.WriteString(minigameType)
        net.WriteString(itemClass)
        net.WriteString(bodyPart or "")
        net.WriteEntity(targetPlayer or Entity(0))
        net.Send(ply)
    end
    
    -- Recibir resultado del minijuego del cliente
    net.Receive("ezbodydamage_minigame_result", function(len, ply)
        if not IsValid(ply) then return end
        
        local success = net.ReadBool()
        if not success then return end
        
        local score = net.ReadFloat()
        local quality = net.ReadString()
        local itemClass = net.ReadString()
        local bodyPart = net.ReadString()
        local targetPlayer = net.ReadEntity()
        
        -- Validar que el jugador tenga el arma
        if not ply:HasWeapon(itemClass) then return end
        
        local weapon = ply:GetWeapon(itemClass)
        if not IsValid(weapon) then return end
        
        -- Guardar el score en el arma
        weapon.minigameScore = score
        weapon.minigameQuality = quality
        weapon.minigameBodyPart = bodyPart
        weapon.minigameTarget = targetPlayer
        
        print("[Minigame] " .. ply:Name() .. " scored " .. score .. " (" .. quality .. ") with " .. itemClass)
        
        -- Ejecutar la curación
        timer.Simple(0.1, function()
            if not IsValid(weapon) then return end
            
            if IsValid(targetPlayer) and targetPlayer != ply then
                -- Curando a otro
                weapon.isSecondaryAttack = true
                weapon:SecondaryAttack()
            else
                -- Curándose a sí mismo
                weapon:PrimaryAttack(bodyPart)
            end
        end)
    end)
    
else
    -- CLIENT
    
    -- Recibir solicitud del servidor para abrir minijuego
    net.Receive("ezbodydamage_start_minigame", function()
        local minigameType = net.ReadString()
        local itemClass = net.ReadString()
        local bodyPart = net.ReadString()
        local targetPlayer = net.ReadEntity()
        
        print("[Minigame] Starting " .. minigameType .. " for " .. itemClass)
        
        local ply = LocalPlayer()
        if not IsValid(ply) then return end
        
        -- Verificar si es médico
        local isMedic = false
        if easzy.bodydamage.IsMedic then
            isMedic = easzy.bodydamage.IsMedic(ply)
        end
        
        -- Callback cuando termine el minijuego
        local function OnMinigameComplete(score, quality)
            print("[Minigame] Completed with score: " .. score .. " (" .. quality .. ")")
            
            -- Enviar resultado al servidor
            net.Start("ezbodydamage_minigame_result")
            net.WriteBool(true) -- success
            net.WriteFloat(score)
            net.WriteString(quality)
            net.WriteString(itemClass)
            net.WriteString(bodyPart or "")
            net.WriteEntity(targetPlayer or Entity(0))
            net.SendToServer()
        end
        
        -- Iniciar el minijuego apropiado
        if minigameType == "bandage" then
            easzy.bodydamage.minigame.bandage:Start(OnMinigameComplete, isMedic)
        elseif minigameType == "splint" then
            easzy.bodydamage.minigame.splint:Start(OnMinigameComplete, isMedic)
        elseif minigameType == "firstaid" then
            easzy.bodydamage.minigame.firstaid:Start(OnMinigameComplete, isMedic)
        end
    end)
end

print("[EZ Body Damage] Minigame networking loaded")