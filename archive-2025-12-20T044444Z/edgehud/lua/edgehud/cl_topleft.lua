if EdgeHUD.Configuration.GetConfigValue( "TopLeft" ) then

	--Create a variable for the local player.
	local ply = LocalPlayer()

	--Create a copy of the colors and vars table.
	local COLORS = table.Copy(EdgeHUD.Colors)
	local VARS = table.Copy(EdgeHUD.Vars)

	local screenWidth = ScrW()
	local screenHeight = ScrH()

	-- Configuración para widgets
	local widgetWidth = 280
	local widgetHeight = 45
	local widgetSpacing = 10

	-- Sistema de opacidad (60% = 153 de 255)
	local currentAlpha = 153
	local targetAlpha = 153
	local chatOpen = false

	-- Sistema de detección de inactividad
	local lastPos = Vector(0, 0, 0)
	local lastAng = Angle(0, 0, 0)
	local idleTime = 0
	local isIdle = false
	local IDLE_THRESHOLD = 5  -- 5 segundos sin movimiento

	-- Detectar cuando se abre el chat
	hook.Add("ChatTextChanged", "EdgeHUD:DetectChatOpen", function(text)
		chatOpen = text != ""
	end)

	hook.Add("FinishChat", "EdgeHUD:DetectChatClose", function()
		chatOpen = false
	end)

	-- Calcular posición a la DERECHA de las barras
	local barsWidth = (48 * 3) + (8 * 2)
	local startX = VARS.ScreenMargin + barsWidth + 15

	local ingameName = EdgeHUD.Configuration.GetConfigValue( "Lowerleft_IdentityType" ) == "Ingame Name"

	--[[-------------------------------------------------------------------------
	TRABAJO
	---------------------------------------------------------------------------]]

	local jobWidget = vgui.Create("EdgeHUD:WidgetBox")
	jobWidget:SetSize(widgetWidth, widgetHeight)
	jobWidget:SetPos(startX + EdgeHUD.LeftOffset, screenHeight - VARS.ScreenMargin - (widgetHeight * 3 + widgetSpacing * 2) - 10 - EdgeHUD.BottomOffset)

	EdgeHUD.RegisterDerma("InfoWidget_Job", jobWidget)

	local jobIcon = vgui.Create("DImage", jobWidget)
	jobIcon:SetSize(22, 22)
	jobIcon:SetPos(10, widgetHeight / 2 - 11)
	jobIcon:SetMaterial(Material("edgehud/icon_job.png", "smooth"))

	local jobLabel = vgui.Create("DLabel", jobWidget)
	jobLabel:SetFont("EdgeHUD:Small_2")
	jobLabel:SetTextColor(COLORS["White"])
	jobLabel:SetText(ply:getDarkRPVar("job") or "")
	jobLabel:SetSize(widgetWidth - 45, widgetHeight)
	jobLabel:SetPos(38, 0)
	jobLabel:SetContentAlignment(4)

	jobWidget.UpdateInfo = function()
		local newJob = ply:getDarkRPVar("job") or ""
		if jobLabel:GetText() != newJob then
			jobLabel:SetText(newJob)
		end
	end

	jobWidget.Think = function()
		jobWidget:SetAlpha(currentAlpha)
	end

	--[[-------------------------------------------------------------------------
	IDENTIDAD
	---------------------------------------------------------------------------]]

	local identityWidget = vgui.Create("EdgeHUD:WidgetBox")
	identityWidget:SetSize(widgetWidth, widgetHeight)
	identityWidget:SetPos(startX + EdgeHUD.LeftOffset, screenHeight - VARS.ScreenMargin - (widgetHeight * 2 + widgetSpacing) - 10 - EdgeHUD.BottomOffset)

	EdgeHUD.RegisterDerma("InfoWidget_Identity", identityWidget)

	local identityIcon = vgui.Create("DImage", identityWidget)
	identityIcon:SetSize(22, 22)
	identityIcon:SetPos(10, widgetHeight / 2 - 11)
	identityIcon:SetMaterial(Material("edgehud/icon_user.png", "smooth"))

	local identityLabel = vgui.Create("DLabel", identityWidget)
	identityLabel:SetFont("EdgeHUD:Small_2")
	identityLabel:SetTextColor(COLORS["White"])
	identityLabel:SetSize(widgetWidth - 45, widgetHeight)
	identityLabel:SetPos(38, 0)
	identityLabel:SetContentAlignment(4)

	identityWidget.UpdateInfo = function()
		local name = ingameName and ply:Name() or ply:SteamName()
		if EdgeScoreboard and EdgeScoreboard.GetConfigValue and EdgeScoreboard.GetConfigValue("FAKEONHUD") and EdgeScoreboard.GetFakeIdentity("Name") then
			name = EdgeScoreboard.GetFakeIdentity("Name") .. " (" .. name .. ")"
		end
		if identityLabel:GetText() != name then
			identityLabel:SetText(name)
		end
	end

	identityWidget.UpdateInfo()

	identityWidget.Think = function()
		identityWidget:SetAlpha(currentAlpha)
	end

	--[[-------------------------------------------------------------------------
	SALARIO
	---------------------------------------------------------------------------]]

	local miniSalaryWidth = 130

	local salaryWidget = vgui.Create("EdgeHUD:WidgetBox")
	salaryWidget:SetPos(startX + EdgeHUD.LeftOffset, screenHeight - VARS.ScreenMargin - widgetHeight - 10 - EdgeHUD.BottomOffset)
	salaryWidget:SetSize(miniSalaryWidth, widgetHeight)

	EdgeHUD.RegisterDerma("InfoWidget_Salary", salaryWidget)

	local salaryIcon = vgui.Create("DImage", salaryWidget)
	salaryIcon:SetSize(20, 20)
	salaryIcon:SetMaterial(Material("edgehud/icon_salary.png","smooth"))

	local salaryLabel = vgui.Create("DLabel", salaryWidget)
	salaryLabel:SetFont("EdgeHUD:Small_2")
	salaryLabel:SetTextColor(COLORS["White"])
	salaryLabel:SetText("+" .. DarkRP.formatMoney(ply:getDarkRPVar("salary") or 0))
	salaryLabel:SizeToContents()

	salaryWidget.UpdateInfo = function()
		if "+" .. DarkRP.formatMoney(ply:getDarkRPVar("salary") or 0) != salaryLabel:GetText() then
			salaryLabel:SetText("+" .. DarkRP.formatMoney(ply:getDarkRPVar("salary") or 0))
			salaryLabel:SizeToContents()
			local iconPos = 8
			salaryIcon:SetPos(iconPos, salaryWidget:GetTall() / 2 - salaryIcon:GetTall() / 2)
			salaryLabel:SetPos(iconPos + salaryIcon:GetWide() + 6, salaryWidget:GetTall() / 2 - salaryLabel:GetTall() / 2)
		end
	end

	local iconPos = 8
	salaryIcon:SetPos(iconPos, salaryWidget:GetTall() / 2 - salaryIcon:GetTall() / 2)
	salaryLabel:SetPos(iconPos + salaryIcon:GetWide() + 6, salaryWidget:GetTall() / 2 - salaryLabel:GetTall() / 2)

	salaryWidget.Think = function()
		salaryWidget:SetAlpha(currentAlpha)
	end

	--[[-------------------------------------------------------------------------
	DINERO
	---------------------------------------------------------------------------]]

	local miniMoneyWidth = widgetWidth - miniSalaryWidth - widgetSpacing

	local moneyWidget = vgui.Create("EdgeHUD:WidgetBox")
	moneyWidget:SetPos(startX + miniSalaryWidth + widgetSpacing + EdgeHUD.LeftOffset, screenHeight - VARS.ScreenMargin - widgetHeight - 10 - EdgeHUD.BottomOffset)
	moneyWidget:SetSize(miniMoneyWidth, widgetHeight)

	EdgeHUD.RegisterDerma("InfoWidget_Money", moneyWidget)

	local moneyIcon = vgui.Create("DImage", moneyWidget)
	moneyIcon:SetSize(20, 20)
	moneyIcon:SetPos(8, widgetHeight / 2 - 10)
	moneyIcon:SetMaterial(Material("edgehud/icon_money.png","smooth"))

	local lerpedMoney = ply:getDarkRPVar("money") or 0

	local moneyLabel = vgui.Create("DLabel", moneyWidget)
	moneyLabel:SetFont("EdgeHUD:Small_2")
	moneyLabel:SetTextColor(COLORS["White"])
	moneyLabel:SetText(DarkRP.formatMoney(lerpedMoney))
	moneyLabel:SizeToContents()

	moneyLabel.Think = function()
		local curMoney = ply:getDarkRPVar("money") or 0
		if math.Round(lerpedMoney) != curMoney then
			lerpedMoney = Lerp(FrameTime() * 8, lerpedMoney, curMoney)
			moneyLabel:SetText(DarkRP.formatMoney(math.Round(lerpedMoney)))
			moneyLabel:SizeToContents()
			iconPos = 8
			moneyIcon:SetPos(iconPos, moneyWidget:GetTall() / 2 - moneyIcon:GetTall() / 2)
			moneyLabel:SetPos(iconPos + moneyIcon:GetWide() + 6, moneyWidget:GetTall() / 2 - moneyLabel:GetTall() / 2)
		end
	end

	iconPos = 8
	moneyIcon:SetPos(iconPos, moneyWidget:GetTall() / 2 - moneyIcon:GetTall() / 2)
	moneyLabel:SetPos(iconPos + moneyIcon:GetWide() + 6, moneyWidget:GetTall() / 2 - moneyLabel:GetTall() / 2)

	moneyWidget.Think = function()
		moneyWidget:SetAlpha(currentAlpha)
	end

	--[[-------------------------------------------------------------------------
	Sistema de detección de movimiento e inactividad
	---------------------------------------------------------------------------]]

	hook.Add("Think", "EdgeHUD:UpdateInfoWidgetsAlpha", function()
		-- Actualizar información
		if IsValid(jobWidget) then jobWidget.UpdateInfo() end
		if IsValid(identityWidget) then identityWidget.UpdateInfo() end
		if IsValid(salaryWidget) then salaryWidget.UpdateInfo() end

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

		-- Determinar alpha objetivo
		if EdgeHUD and EdgeHUD.shouldDraw == false then
			-- Cámara activa
			targetAlpha = 0
		elseif isIdle then
			-- Jugador quieto por 5+ segundos
			targetAlpha = 0
		elseif chatOpen then
			-- Chat abierto
			targetAlpha = 153
		else
			-- Normal: 60% de opacidad
			targetAlpha = 153
		end

		-- Lerp suave
		currentAlpha = Lerp(FrameTime() * 3, currentAlpha, targetAlpha)
	end)

	--[[-------------------------------------------------------------------------
	Misc
	---------------------------------------------------------------------------]]

	local visibility = true

	hook.Add("PlayerSwitchWeapon","EdgeHUD:HideTopLeft",function( _, _, newWeapon )
		visibility = true
		if IsValid(newWeapon) and newWeapon:GetClass() == "gmod_tool" then
			visibility = false
		end
		jobWidget:SetVisible(visibility)
		identityWidget:SetVisible(visibility)
		salaryWidget:SetVisible(visibility)
		moneyWidget:SetVisible(visibility)
	end)

	local old_spawnmenuActivateTool = spawnmenu.ActivateTool

	function spawnmenu.ActivateTool( ... )
		local weapon = LocalPlayer():GetActiveWeapon()
		if IsValid(weapon) and weapon:GetClass() == "gmod_tool" then
			visibility = false
			jobWidget:SetVisible(false)
			identityWidget:SetVisible(false)
			salaryWidget:SetVisible(false)
			moneyWidget:SetVisible(false)
		end
		return old_spawnmenuActivateTool(...)
	end

	timer.Create("EdgeHUD:FixTopLeft",0.5,0,function(  )
		local curWeapon = ply:GetActiveWeapon()
		if IsValid(curWeapon) and curWeapon:GetClass() == "gmod_tool" then
			visibility = false
		else
			visibility = true
		end
		jobWidget:SetVisible(visibility)
		identityWidget:SetVisible(visibility)
		salaryWidget:SetVisible(visibility)
		moneyWidget:SetVisible(visibility)
	end)

	hook.Add("EdgeHUD:AddonReload","EdgeHUD:Unload_HideTopLeft",function(  )
		hook.Remove("PlayerSwitchWeapon","EdgeHUD:HideTopLeft")
		hook.Remove("Think", "EdgeHUD:UpdateInfoWidgetsAlpha")
		hook.Remove("ChatTextChanged", "EdgeHUD:DetectChatOpen")
		hook.Remove("FinishChat", "EdgeHUD:DetectChatClose")
		timer.Remove("EdgeHUD:FixTopLeft")
	end)

end