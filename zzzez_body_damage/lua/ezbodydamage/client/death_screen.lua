-- Pantalla de muerte con efecto de parpadeo rojo
if CLIENT then
    local deathScreenActive = false
    local deathStartTime = 0
    
    -- Activar pantalla de muerte
    net.Receive("easzy.bodydamage.PlayerDied", function()
        deathScreenActive = true
        deathStartTime = CurTime()
    end)
    
    -- Desactivar cuando revives
    hook.Add("PlayerSpawn", "easzy.bodydamage.DeathScreen.Deactivate", function(ply)
        if ply == LocalPlayer() then
            deathScreenActive = false
        end
    end)
    
    -- Dibujar efecto de parpadeo rojo
    hook.Add("HUDPaint", "easzy.bodydamage.DeathScreen", function()
        if not deathScreenActive then return end
        
        local ply = LocalPlayer()
        if not IsValid(ply) or ply:Alive() then
            deathScreenActive = false
            return
        end
        
        -- Calcular opacidad con parpadeo
        local elapsed = CurTime() - deathStartTime
        local pulse = math.sin(elapsed * 3) * 0.5 + 0.5  -- Oscila entre 0 y 1
        local alpha = math.Clamp(100 + pulse * 100, 50, 200)  -- Entre 50 y 200
        
        -- Dibujar overlay rojo
        surface.SetDrawColor(150, 0, 0, alpha)
        surface.DrawRect(0, 0, ScrW(), ScrH())
        
        -- Texto de muerte
        draw.SimpleText(
            "ESTÁS MUERTO",
            "DermaLarge",
            ScrW() / 2,
            ScrH() / 2 - 50,
            Color(255, 255, 255, 255),
            TEXT_ALIGN_CENTER,
            TEXT_ALIGN_CENTER
        )
        
        draw.SimpleText(
            "Esperando reanimación...",
            "DermaDefault",
            ScrW() / 2,
            ScrH() / 2,
            Color(255, 255, 255, 200),
            TEXT_ALIGN_CENTER,
            TEXT_ALIGN_CENTER
        )
    end)
end

if SERVER then
    util.AddNetworkString("easzy.bodydamage.PlayerDied")
    
    -- Detectar muerte y enviar señal al cliente
    hook.Add("PlayerDeath", "easzy.bodydamage.DeathScreen.Activate", function(victim, inflictor, attacker)
        if IsValid(victim) and victim:IsPlayer() then
            net.Start("easzy.bodydamage.PlayerDied")
            net.Send(victim)
        end
    end)
end

print("[zzzez_body_damage] Death screen con parpadeo rojo cargado")
