-- ========================================
-- SISTEMA DE MINIJUEGOS PARA CURACIÓN
-- ========================================

easzy.bodydamage.minigame = easzy.bodydamage.minigame or {}
local minigame = easzy.bodydamage.minigame

-- Variables globales del minijuego activo
minigame.active = false
minigame.type = nil
minigame.callback = nil
minigame.startTime = 0
minigame.isMedic = false

-- Configuración de dificultad
minigame.config = {
    -- Bandage (barra móvil)
    bandage = {
        speed = 1,                -- Velocidad de la barra
        greenZoneSize = 0.10,     -- Tamaño zona verde (10%)
        medicGreenZoneSize = 0.20, -- Tamaño para médicos (20%)
        yellowPadding = 0.12,     -- Zona amarilla más grande (12%)
        barHeight = 50,
        barWidth = 500,
    },
    
    -- Splint (círculos concéntricos)
    splint = {
        clickCount = 3,
        shrinkSpeed = 300,        -- Velocidad de encogimiento (píxeles por segundo)
        medicShrinkSpeed = 150,   -- Más lento para médicos (más fácil)
        targetRadius = 85,        -- Radio del círculo objetivo (mediano)
        startRadius = 250,        -- Radio inicial del círculo grande
    },
    
    -- First Aid Kit (precisión)
    firstaid = {
        startRadius = 105,          -- Radio inicial de cada círculo
        medicStartRadius = 150,    -- Radio inicial para médicos (más fácil)
        shrinkSpeed = 25,          -- Velocidad de encogimiento (píxeles/segundo)
        medicShrinkSpeed = 15,     -- Más lento para médicos
    }
}

-- ========================================
-- MINIJUEGO 1: BANDAGE (Barra Móvil)
-- ========================================

minigame.bandage = {
    barPosition = 0,
    direction = 1,
    greenZoneStart = 0.4,
    pressed = false,
}

function minigame.bandage:Start(callback, isMedic)
    minigame.active = true
    minigame.type = "bandage"
    minigame.callback = callback
    minigame.startTime = CurTime()
    minigame.isMedic = isMedic
    
    self.barPosition = 0
    self.direction = 1
    self.pressed = false
    self.greenZoneStart = math.random(20, 60) / 100
    
    surface.PlaySound("buttons/button17.wav")
end

function minigame.bandage:Think()
    if not minigame.active or minigame.type != "bandage" then return end
    
    local speed = minigame.config.bandage.speed
    self.barPosition = self.barPosition + (FrameTime() * speed * self.direction)
    
    if self.barPosition >= 1 then
        self.barPosition = 1
        self.direction = -1
    elseif self.barPosition <= 0 then
        self.barPosition = 0
        self.direction = 1
    end
end

function minigame.bandage:Draw()
    if not minigame.active or minigame.type != "bandage" then return end
    
    local scrW, scrH = ScrW(), ScrH()
    local cfg = minigame.config.bandage
    
    local barX = (scrW - cfg.barWidth) / 2
    local barY = scrH * 0.4
    
    draw.RoundedBox(8, barX - 20, barY - 80, cfg.barWidth + 40, cfg.barHeight + 120, Color(0, 0, 0, 220))
    
    draw.SimpleText("APLICANDO VENDAJE", "EZFont40", scrW / 2, barY - 50, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    
    draw.RoundedBox(4, barX, barY, cfg.barWidth, cfg.barHeight, Color(40, 40, 40, 255))
    
    local greenSize = minigame.isMedic and cfg.medicGreenZoneSize or cfg.greenZoneSize
    local greenStart = self.greenZoneStart
    local greenX = barX + (cfg.barWidth * greenStart)
    local greenWidth = cfg.barWidth * greenSize
    
    draw.RoundedBox(4, greenX, barY, greenWidth, cfg.barHeight, Color(50, 200, 50, 200))
    
    local yellowPadding = cfg.barWidth * (cfg.yellowPadding or 0.12)
    draw.RoundedBox(4, greenX - yellowPadding, barY, yellowPadding, cfg.barHeight, Color(255, 200, 0, 150))
    draw.RoundedBox(4, greenX + greenWidth, barY, yellowPadding, cfg.barHeight, Color(255, 200, 0, 150))
    
    local barPos = barX + (cfg.barWidth * self.barPosition)
    draw.RoundedBox(2, barPos - 3, barY - 5, 6, cfg.barHeight + 10, Color(255, 255, 255, 255))
    
    draw.SimpleText("Presiona [ESPACIO] o [CLICK] cuando la barra esté en verde", "EZFont20", scrW / 2, barY + cfg.barHeight + 30, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function minigame.bandage:Submit()
    if self.pressed then return end
    self.pressed = true
    
    local cfg = minigame.config.bandage
    local greenSize = minigame.isMedic and cfg.medicGreenZoneSize or cfg.greenZoneSize
    local greenStart = self.greenZoneStart
    local greenEnd = greenStart + greenSize
    
    local score = 0
    local quality = "malo"
    
    if self.barPosition >= greenStart and self.barPosition <= greenEnd then
        score = 1.0
        quality = "perfecto"
        surface.PlaySound("buttons/button14.wav")
    elseif self.barPosition >= (greenStart - 0.05) and self.barPosition <= (greenEnd + 0.05) then
        score = 0.75
        quality = "bueno"
        surface.PlaySound("buttons/button15.wav")
    elseif math.abs(self.barPosition - greenStart) < 0.15 or math.abs(self.barPosition - greenEnd) < 0.15 then
        score = 0.5
        quality = "regular"
        surface.PlaySound("buttons/button10.wav")
    else
        score = 0.25
        quality = "malo"
        surface.PlaySound("buttons/button8.wav")
    end
    
    if minigame.isMedic then
        score = math.min(score + 0.1, 1.0)
    end
    
    minigame:Finish(score, quality)
end

-- ========================================
-- MINIJUEGO 2: SPLINT (Círculos Concéntricos)
-- ========================================

minigame.splint = {
    clicksRemaining = 3,
    currentRadius = 250,
    clickHistory = {},
    shrinking = false,
}

function minigame.splint:Start(callback, isMedic)
    minigame.active = true
    minigame.type = "splint"
    minigame.callback = callback
    minigame.startTime = CurTime()
    minigame.isMedic = isMedic
    
    local cfg = minigame.config.splint
    self.clicksRemaining = cfg.clickCount
    self.currentRadius = cfg.startRadius
    self.clickHistory = {}
    self.shrinking = true
    
    surface.PlaySound("buttons/button17.wav")
end

function minigame.splint:Think()
    if not minigame.active or minigame.type != "splint" then return end
    
    if not self.shrinking then return end
    
    local cfg = minigame.config.splint
    local speed = minigame.isMedic and cfg.medicShrinkSpeed or cfg.shrinkSpeed
    
    self.currentRadius = self.currentRadius - (speed * FrameTime())
    
    if self.currentRadius <= 0 then
        self:Submit(true)
    end
end

function minigame.splint:Draw()
    if not minigame.active or minigame.type != "splint" then return end
    
    local scrW, scrH = ScrW(), ScrH()
    local cfg = minigame.config.splint
    
    surface.SetDrawColor(0, 0, 0, 200)
    surface.DrawRect(0, 0, scrW, scrH)
    
    draw.SimpleText("APLICANDO FÉRULA", "EZFont40", scrW / 2, scrH * 0.15, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    
    local clickText = string.format("Rondas: %d/%d", cfg.clickCount - self.clicksRemaining + 1, cfg.clickCount)
    draw.SimpleText(clickText, "EZFont26", scrW / 2, scrH * 0.22, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    
    local centerX = scrW / 2
    local centerY = scrH / 2
    
    surface.SetDrawColor(50, 255, 50, 100)
    draw.NoTexture()
    for i = 0, 360, 10 do
        local rad = math.rad(i)
        local nextRad = math.rad(i + 10)
        surface.DrawPoly({
            {x = centerX, y = centerY},
            {x = centerX + math.cos(rad) * cfg.targetRadius, y = centerY + math.sin(rad) * cfg.targetRadius},
            {x = centerX + math.cos(nextRad) * cfg.targetRadius, y = centerY + math.sin(nextRad) * cfg.targetRadius},
        })
    end
    
    surface.SetDrawColor(50, 255, 50, 255)
    for i = 0, 360, 5 do
        local rad = math.rad(i)
        local nextRad = math.rad(i + 5)
        surface.DrawLine(
            centerX + math.cos(rad) * cfg.targetRadius, 
            centerY + math.sin(rad) * cfg.targetRadius,
            centerX + math.cos(nextRad) * cfg.targetRadius, 
            centerY + math.sin(nextRad) * cfg.targetRadius
        )
    end
    
    local distance = math.abs(self.currentRadius - cfg.targetRadius)
    local maxDistance = cfg.startRadius - cfg.targetRadius
    local colorProgress = 1 - (distance / maxDistance)
    
    local r = 255 * (1 - colorProgress) + 50 * colorProgress
    local g = 50 * (1 - colorProgress) + 255 * colorProgress
    local b = 50
    
    surface.SetDrawColor(r, g, b, 150)
    for i = 0, 360, 10 do
        local rad = math.rad(i)
        local nextRad = math.rad(i + 10)
        surface.DrawPoly({
            {x = centerX, y = centerY},
            {x = centerX + math.cos(rad) * self.currentRadius, y = centerY + math.sin(rad) * self.currentRadius},
            {x = centerX + math.cos(nextRad) * self.currentRadius, y = centerY + math.sin(nextRad) * self.currentRadius},
        })
    end
    
    surface.SetDrawColor(r, g, b, 255)
    for i = 0, 360, 3 do
        local rad = math.rad(i)
        local nextRad = math.rad(i + 3)
        surface.DrawLine(
            centerX + math.cos(rad) * self.currentRadius, 
            centerY + math.sin(rad) * self.currentRadius,
            centerX + math.cos(nextRad) * self.currentRadius, 
            centerY + math.sin(nextRad) * self.currentRadius
        )
    end
    
    draw.RoundedBox(0, centerX - 5, centerY - 5, 10, 10, Color(255, 255, 255, 255))
    
    local historyY = scrH * 0.75
    local historyText = "Resultados: "
    for i, result in ipairs(self.clickHistory) do
        if result.perfect then
            historyText = historyText .. "✓ "
        elseif result.good then
            historyText = historyText .. "○ "
        else
            historyText = historyText .. "✗ "
        end
    end
    draw.SimpleText(historyText, "EZFont26", scrW / 2, historyY, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    
    if self.shrinking then
        draw.SimpleText("¡Presiona [ESPACIO] o [CLICK] cuando el círculo esté sobre el verde!", "EZFont20", scrW / 2, scrH * 0.85, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    else
        draw.SimpleText("Espera la siguiente ronda...", "EZFont20", scrW / 2, scrH * 0.85, Color(255, 200, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end

function minigame.splint:Submit(autoFail)
    if not self.shrinking and not autoFail then return end
    
    local cfg = minigame.config.splint
    
    self.shrinking = false
    
    if autoFail then
        table.insert(self.clickHistory, {perfect = false, good = false})
        self.clicksRemaining = self.clicksRemaining - 1
        surface.PlaySound("buttons/button8.wav")
    else
        local distance = math.abs(self.currentRadius - cfg.targetRadius)
        local targetRadius = cfg.targetRadius
        
        local perfectZone = targetRadius * 0.15
        local goodZone = targetRadius * 0.35
        
        local perfect = distance <= perfectZone
        local good = distance <= goodZone
        
        table.insert(self.clickHistory, {perfect = perfect, good = good})
        self.clicksRemaining = self.clicksRemaining - 1
        
        if perfect then
            surface.PlaySound("buttons/button14.wav")
        elseif good then
            surface.PlaySound("buttons/button15.wav")
        else
            surface.PlaySound("buttons/button10.wav")
        end
    end
    
    if self.clicksRemaining <= 0 then
        local perfectCount = 0
        local goodCount = 0
        
        for _, result in ipairs(self.clickHistory) do
            if result.perfect then 
                perfectCount = perfectCount + 1
            elseif result.good then
                goodCount = goodCount + 1
            end
        end
        
        local score = 0
        local quality = "malo"
        
        if perfectCount == cfg.clickCount then
            score = 1.0
            quality = "perfecto"
        elseif perfectCount >= cfg.clickCount - 1 then
            score = 0.85
            quality = "perfecto"
        elseif perfectCount + goodCount >= cfg.clickCount then
            score = 0.75
            quality = "bueno"
        elseif perfectCount + goodCount >= cfg.clickCount - 1 then
            score = 0.6
            quality = "bueno"
        elseif perfectCount + goodCount >= 1 then
            score = 0.5
            quality = "regular"
        else
            score = 0.25
            quality = "malo"
        end
        
        if minigame.isMedic then
            score = math.min(score + 0.1, 1.0)
        end
        
        minigame:Finish(score, quality)
    else
        timer.Simple(0.8, function()
            if minigame.type == "splint" and minigame.active then
                self.currentRadius = cfg.startRadius
                self.shrinking = true
            end
        end)
    end
end

-- ========================================
-- MINIJUEGO 3: FIRST AID KIT (Múltiples Objetivos)
-- ========================================

minigame.firstaid = {
    circles = {},
    clickedCount = 0,
    totalCircles = 3,
}

function minigame.firstaid:Start(callback, isMedic)
    minigame.active = true
    minigame.type = "firstaid"
    minigame.callback = callback
    minigame.startTime = CurTime()
    minigame.isMedic = isMedic
    
    local cfg = minigame.config.firstaid
    
    -- Crear 5 círculos en posiciones aleatorias
    self.circles = {}
    self.clickedCount = 0
    
    local scrW, scrH = ScrW(), ScrH()
    local margin = 100
    
    for i = 1, self.totalCircles do
        local circle = {
            x = math.random(margin, scrW - margin),
            y = math.random(scrH * 0.3, scrH * 0.7),
            radius = minigame.isMedic and cfg.medicStartRadius or cfg.startRadius,
            maxRadius = minigame.isMedic and cfg.medicStartRadius or cfg.startRadius,
            shrinkSpeed = minigame.isMedic and cfg.medicShrinkSpeed or cfg.shrinkSpeed,
            clicked = false,
            alive = true,
            id = i
        }
        table.insert(self.circles, circle)
    end
    
    -- DESBLOQUEAR CURSOR
    gui.EnableScreenClicker(true)
    
    surface.PlaySound("buttons/button17.wav")
end

function minigame.firstaid:Think()
    if not minigame.active or minigame.type != "firstaid" then return end
    
    local cfg = minigame.config.firstaid
    local allDead = true
    
    -- Actualizar cada círculo
    for _, circle in ipairs(self.circles) do
        if not circle.clicked and circle.alive then
            -- Encoger el círculo
            circle.radius = circle.radius - (circle.shrinkSpeed * FrameTime())
            
            -- Si llega a muy pequeño, muere
            if circle.radius <= 5 then
                circle.alive = false
                circle.clicked = true -- Marcar como "perdido"
                surface.PlaySound("buttons/button8.wav")
            else
                allDead = false
            end
        end
    end
    
    -- Si todos están muertos o clickeados, terminar
    if allDead or self.clickedCount >= self.totalCircles then
        timer.Simple(0.3, function()
            self:CalculateScore()
        end)
    end
end

function minigame.firstaid:Draw()
    if not minigame.active or minigame.type != "firstaid" then return end
    
    local scrW, scrH = ScrW(), ScrH()
    
    -- Fondo oscuro
    surface.SetDrawColor(0, 0, 0, 180)
    surface.DrawRect(0, 0, scrW, scrH)
    
    -- Título
    draw.SimpleText("APLICANDO BOTIQUÍN", "EZFont40", scrW / 2, 50, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    
    -- Contador
    local counterText = string.format("Curados: %d/%d", self.clickedCount, self.totalCircles)
    draw.SimpleText(counterText, "EZFont26", scrW / 2, 100, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    
    -- Dibujar cada círculo
    for _, circle in ipairs(self.circles) do
        if not circle.clicked and circle.alive then
            local radius = circle.radius
            
            -- Color basado en qué tan pequeño está (rojo = casi muerto, verde = grande)
            local progress = radius / circle.maxRadius
            local r = 255 * (1 - progress) + 50 * progress
            local g = 50 * (1 - progress) + 255 * progress
            local b = 50
            
            -- Círculo exterior (zona regular)
            surface.SetDrawColor(r, g, b, 60)
            draw.NoTexture()
            for i = 0, 360, 10 do
                local rad = math.rad(i)
                local nextRad = math.rad(i + 10)
                surface.DrawPoly({
                    {x = circle.x, y = circle.y},
                    {x = circle.x + math.cos(rad) * radius, y = circle.y + math.sin(rad) * radius},
                    {x = circle.x + math.cos(nextRad) * radius, y = circle.y + math.sin(nextRad) * radius},
                })
            end
            
            -- Círculo medio (zona buena)
            surface.SetDrawColor(r, g, b, 120)
            for i = 0, 360, 10 do
                local rad = math.rad(i)
                local nextRad = math.rad(i + 10)
                surface.DrawPoly({
                    {x = circle.x, y = circle.y},
                    {x = circle.x + math.cos(rad) * radius * 0.7, y = circle.y + math.sin(rad) * radius * 0.7},
                    {x = circle.x + math.cos(nextRad) * radius * 0.7, y = circle.y + math.sin(nextRad) * radius * 0.7},
                })
            end
            
            -- Círculo interno (zona perfecta)
            surface.SetDrawColor(r, g, b, 180)
            for i = 0, 360, 10 do
                local rad = math.rad(i)
                local nextRad = math.rad(i + 10)
                surface.DrawPoly({
                    {x = circle.x, y = circle.y},
                    {x = circle.x + math.cos(rad) * radius * 0.4, y = circle.y + math.sin(rad) * radius * 0.4},
                    {x = circle.x + math.cos(nextRad) * radius * 0.4, y = circle.y + math.sin(nextRad) * radius * 0.4},
                })
            end
            
            -- Borde brillante
            surface.SetDrawColor(r, g, b, 255)
            for i = 0, 360, 5 do
                local rad = math.rad(i)
                local nextRad = math.rad(i + 5)
                surface.DrawLine(
                    circle.x + math.cos(rad) * radius, 
                    circle.y + math.sin(rad) * radius,
                    circle.x + math.cos(nextRad) * radius, 
                    circle.y + math.sin(nextRad) * radius
                )
            end
            
            -- Centro
            draw.RoundedBox(0, circle.x - 5, circle.y - 5, 10, 10, Color(255, 255, 255, 255))
        elseif circle.clicked and circle.alive then
            -- Círculo ya clickeado (checkmark)
            draw.SimpleText("✓", "EZFont40", circle.x, circle.y, Color(50, 255, 50), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end
    
    -- Cursor personalizado
    local mouseX, mouseY = gui.MousePos()
    
    -- Círculo exterior del cursor
    surface.SetDrawColor(255, 255, 255, 100)
    draw.NoTexture()
    for i = 0, 360, 10 do
        local rad = math.rad(i)
        local nextRad = math.rad(i + 10)
        surface.DrawPoly({
            {x = mouseX, y = mouseY},
            {x = mouseX + math.cos(rad) * 15, y = mouseY + math.sin(rad) * 15},
            {x = mouseX + math.cos(nextRad) * 15, y = mouseY + math.sin(nextRad) * 15},
        })
    end
    
    -- Cruz central
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawLine(mouseX - 12, mouseY, mouseX + 12, mouseY)
    surface.DrawLine(mouseX, mouseY - 12, mouseX, mouseY + 12)
    
    -- Punto central rojo
    draw.RoundedBox(0, mouseX - 2, mouseY - 2, 4, 4, Color(255, 50, 50, 255))
    
    -- Instrucciones
    draw.SimpleText("¡Haz CLICK en todos los círculos antes de que desaparezcan!", "EZFont20", scrW / 2, scrH - 60, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function minigame.firstaid:OnCircleClick(mouseX, mouseY)
    -- Buscar qué círculo fue clickeado
    for _, circle in ipairs(self.circles) do
        if not circle.clicked and circle.alive then
            local dx = mouseX - circle.x
            local dy = mouseY - circle.y
            local distance = math.sqrt(dx * dx + dy * dy)
            
            -- Si está dentro del círculo
            if distance <= circle.radius then
                circle.clicked = true
                self.clickedCount = self.clickedCount + 1
                
                -- Sonido basado en qué tan grande estaba
                local sizePercent = circle.radius / circle.maxRadius
                if sizePercent > 0.7 then
                    surface.PlaySound("buttons/button14.wav") -- Perfecto
                elseif sizePercent > 0.4 then
                    surface.PlaySound("buttons/button15.wav") -- Bueno
                else
                    surface.PlaySound("buttons/button10.wav") -- Regular
                end
                
                return true -- Click exitoso
            end
        end
    end
    
    -- Click fallido (fuera de círculos)
    surface.PlaySound("buttons/button8.wav")
    return false
end

function minigame.firstaid:CalculateScore()
    if not minigame.active or minigame.type != "firstaid" then return end
    
    local totalScore = 0
    local clickedAlive = 0
    
    -- Calcular score basado en círculos clickeados
    for _, circle in ipairs(self.circles) do
        if circle.clicked and circle.alive then
            clickedAlive = clickedAlive + 1
            -- Score basado en qué tan grande estaba cuando lo clickeaste
            local sizePercent = circle.radius / circle.maxRadius
            totalScore = totalScore + sizePercent
        end
    end
    
    -- Score final es el promedio
    local finalScore = 0
    local quality = "malo"
    
    if clickedAlive == 0 then
        finalScore = 0.25
        quality = "malo"
    else
        local avgScore = totalScore / self.totalCircles
        
        -- Penalización por círculos perdidos
        local completionBonus = clickedAlive / self.totalCircles
        finalScore = avgScore * completionBonus
        
        -- Determinar calidad
        if finalScore >= 0.8 then
            quality = "perfecto"
        elseif finalScore >= 0.6 then
            quality = "bueno"
        elseif finalScore >= 0.4 then
            quality = "regular"
        else
            quality = "malo"
        end
    end
    
    -- Bonus médicos
    if minigame.isMedic then
        finalScore = math.min(finalScore + 0.1, 1.0)
    end
    
    minigame:Finish(finalScore, quality)
end
-- ========================================
-- FUNCIONES GENERALES
-- ========================================

function minigame:Finish(score, quality)
    minigame.active = false
    
    -- BLOQUEAR CURSOR DE NUEVO
    gui.EnableScreenClicker(false)
    
    local col = Color(255, 50, 50)
    if quality == "perfecto" then col = Color(50, 255, 50)
    elseif quality == "bueno" then col = Color(255, 200, 0)
    elseif quality == "regular" then col = Color(255, 150, 0)
    end
    
    timer.Simple(0, function()
        local resultText = string.upper(quality) .. " (" .. math.Round(score * 100) .. "%)"
        local scrW, scrH = ScrW(), ScrH()
        
        hook.Add("HUDPaint", "ezbodydamage_minigame_result", function()
            draw.SimpleText(resultText, "EZFont80", scrW / 2, scrH / 2, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end)
        
        timer.Simple(1.5, function()
            hook.Remove("HUDPaint", "ezbodydamage_minigame_result")
        end)
    end)
    
    if minigame.callback then
        minigame.callback(score, quality)
    end
    
    minigame.type = nil
    minigame.callback = nil
end

function minigame:Cancel()
    minigame.active = false
    minigame.type = nil
    minigame.callback = nil
    
    -- BLOQUEAR CURSOR DE NUEVO
    gui.EnableScreenClicker(false)
    
    surface.PlaySound("buttons/button8.wav")
end

-- ========================================
-- HOOKS
-- ========================================

hook.Add("Think", "ezbodydamage_minigame_think", function()
    if not minigame.active then return end
    
    if minigame.type == "bandage" then
        minigame.bandage:Think()
    elseif minigame.type == "splint" then
        minigame.splint:Think()
    elseif minigame.type == "firstaid" then
        minigame.firstaid:Think()
    end
end)

hook.Add("HUDPaint", "ezbodydamage_minigame_draw", function()
    if not minigame.active then return end
    
    if minigame.type == "bandage" then
        minigame.bandage:Draw()
    elseif minigame.type == "splint" then
        minigame.splint:Draw()
    elseif minigame.type == "firstaid" then
        minigame.firstaid:Draw()
    end
end)

hook.Add("PlayerBindPress", "ezbodydamage_minigame_input", function(ply, bind, pressed)
    if not minigame.active or not pressed then return end
    
    -- Espacio O Click para submit (Bandage y Splint)
    if bind == "+jump" or bind == "+attack" then
        if minigame.type == "bandage" then
            minigame.bandage:Submit()
            return true
        elseif minigame.type == "splint" then
            minigame.splint:Submit()
            return true
        end
    end
    
    -- ESC para cancelar
    if bind == "cancelselect" then
        minigame:Cancel()
        return true
    end
end)

-- Hook especial para clicks con cursor desbloqueado (First Aid)
hook.Add("GUIMousePressed", "ezbodydamage_minigame_firstaid_click", function(mouseCode)
    if not minigame.active or minigame.type != "firstaid" then return end
    
    if mouseCode == MOUSE_LEFT then
        local mouseX, mouseY = gui.MousePos()
        minigame.firstaid:OnCircleClick(mouseX, mouseY)
        return true
    end
end)

-- Bloquear movimiento durante minijuego
hook.Add("StartCommand", "ezbodydamage_minigame_freeze", function(ply, cmd)
    if minigame.active and ply == LocalPlayer() then
        cmd:ClearMovement()
        cmd:ClearButtons()
    end
end)

-- Hook de seguridad para rebloquear cursor si algo falla
hook.Add("HUDShouldDraw", "ezbodydamage_minigame_cursor_safety", function(name)
    if not minigame.active and gui.IsGameUIVisible() then
        gui.EnableScreenClicker(false)
    end
end)

-- Cleanup al morir o cambiar de arma
hook.Add("PlayerDeath", "ezbodydamage_minigame_cleanup_death", function()
    if minigame.active then
        minigame:Cancel()
    end
end)

print("[EZ Body Damage] Minigame system loaded")