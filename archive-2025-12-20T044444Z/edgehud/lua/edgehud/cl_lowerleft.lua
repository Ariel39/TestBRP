if EdgeHUD.Configuration.GetConfigValue( "LowerLeft" ) then

	local ply = LocalPlayer()
	local COLORS = table.Copy(EdgeHUD.Colors)
	local VARS = table.Copy(EdgeHUD.Vars)

	local screenWidth = ScrW()
	local screenHeight = ScrH()

	local alwaysShowPercentage = EdgeHUD.Configuration.GetConfigValue( "LowerLeft_AlwaysShow" )

	-- Sistema de opacidad global (60% = 153 de 255)
	local baseBarAlpha = 153
	local currentBarAlpha = 153
	local targetBarAlpha = 153

	-- Sistema de detección de inactividad (igual que en topleft)
	local lastPos = Vector(0, 0, 0)
	local lastAng = Angle(0, 0, 0)
	local idleTime = 0
	local isIdle = false
	local IDLE_THRESHOLD = 5  -- 5 segundos sin movimiento

	local statusWidgets = {
		{
			Icon = Material("edgehud/icon_health.png", "smooth"),
			Color = Color(115,47,47),
			getData = function(  )
				return ply:Health()
			end,
			getMax = function(  )
				return ply:GetMaxHealth()
			end
		},
		{
			Icon = Material("edgehud/icon_armor.png", "smooth"),
			Color = Color(47,82,144),
			getData = function(  )
				return ply:Armor()
			end,
			getMax = function(  )
				return 100
			end
		},
	}

	if VARS.hungerMod then
		table.insert(statusWidgets,	{
			Icon = Material("edgehud/icon_hunger.png", "smooth"),
			Color = Color(131,90,38),
			getData = function(  )
				return ply:getDarkRPVar("Energy")
			end,
			getMax = function(  )
				return 100
			end
		})
	end

	local barWidth = 48
	local barHeight = 240
	local barSpacing = 8

	for i = 1,#statusWidgets do

		local x = VARS.ScreenMargin + (barSpacing + barWidth) * (i - 1)
		local y = screenHeight - VARS.ScreenMargin - barHeight - 10

		local curWidget = statusWidgets[i]

		local statusWidget = vgui.Create("EdgeHUD:WidgetBox")
		statusWidget:SetSize(barWidth, barHeight)
		statusWidget:SetPos(x + EdgeHUD.LeftOffset, y - EdgeHUD.BottomOffset)

		EdgeHUD.RegisterDerma("StatusWidget_" .. i, statusWidget)

		local Icon = vgui.Create("DImage",statusWidget)
		Icon:SetSize(20, 20)
		Icon:SetPos(statusWidget:GetWide() / 2 - 10, 5)
		Icon:SetMaterial(curWidget.Icon)

		local lerpedData = curWidget.getData()
		local lerpedAlpha = 255

		statusWidget.Paint = function( s, w, h )

			-- Usar la opacidad global actual que responde a inactividad
			local baseAlpha = currentBarAlpha

			surface.SetDrawColor(ColorAlpha(COLORS["Black_Transparent"], baseAlpha))
			surface.DrawRect(0, 0, w, h)

			local max = curWidget.getMax()
			local data = math.max(curWidget.getData() or 0, 0)

			local FT = FrameTime() * 5

			lerpedData = Lerp(FT or 0, lerpedData or 0, data or 0)

			local prop = math.Clamp(lerpedData / max, 0, 1)

			lerpedAlpha = Lerp(FT, lerpedAlpha, prop > 0.999 and alwaysShowPercentage == false and data <= max and 0 or baseAlpha)

			local barAreaHeight = h - 35
			local fillHeight = barAreaHeight * prop
			local barStartY = 30

			-- Color de la barra con opacidad dinámica
			local barColor = Color(curWidget.Color.r, curWidget.Color.g, curWidget.Color.b, lerpedAlpha)
			surface.SetDrawColor(barColor)
			surface.DrawRect(0, barStartY + barAreaHeight - fillHeight, w, fillHeight)

			-- Texto con opacidad dinámica
			draw.SimpleText(math.max(math.Round(lerpedData), 0) .. "%", "EdgeHUD:Small", w / 2, h - 8, ColorAlpha(COLORS["White"], lerpedAlpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)

			surface.SetDrawColor(ColorAlpha(COLORS["White_Outline"], baseAlpha * 0.5))
			surface.DrawOutlinedRect(0, 0, w, h)

			surface.SetDrawColor(ColorAlpha(COLORS["White_Corners"], baseAlpha * 0.6))
			EdgeHUD.DrawEdges(0, 0, w, h, 8)

		end

	end

	--[[-------------------------------------------------------------------------
	Sistema de detección de movimiento e inactividad para las barras
	---------------------------------------------------------------------------]]

	hook.Add("Think", "EdgeHUD:UpdateHealthBarsAlpha", function()
		if !IsValid(ply) then return end

		-- Obtener posición y ángulo actual
		local curPos = ply:GetPos()
		local curAng = ply:EyeAngles()
		local curVel = ply:GetVelocity():Length()

		-- Detectar movimiento (posición, ángulo o velocidad)
		local hasMoved = curPos:Distance(lastPos) > 1 or 
						 math.abs(curAng.y - lastAng.y) > 1 or 
						 math.abs(curAng.p - lastAng.p) > 1 or
						 curVel > 5

		if hasMoved then
			-- Hay movimiento, resetear el contador
			idleTime = CurTime()
			isIdle = false
		else
			-- Sin movimiento, verificar si ya pasaron 5 segundos
			if CurTime() - idleTime > IDLE_THRESHOLD then
				isIdle = true
			end
		end

		-- Actualizar posición y ángulo anteriores
		lastPos = curPos
		lastAng = curAng

		-- Determinar alpha objetivo para las barras
		if EdgeHUD and EdgeHUD.shouldDraw == false then
			-- Cámara activa
			targetBarAlpha = 0
		elseif isIdle then
			-- Jugador quieto por 5+ segundos
			targetBarAlpha = 0
		else
			-- Normal: 60% de opacidad
			targetBarAlpha = baseBarAlpha
		end

		-- Lerp suave (misma velocidad que los widgets)
		currentBarAlpha = Lerp(FrameTime() * 3, currentBarAlpha, targetBarAlpha)
	end)

	hook.Add("EdgeHUD:AddonReload","EdgeHUD:Unload_HealthBarsAlpha",function(  )
		hook.Remove("Think", "EdgeHUD:UpdateHealthBarsAlpha")
	end)

end