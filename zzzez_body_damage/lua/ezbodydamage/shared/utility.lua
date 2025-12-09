easzy.bodydamage.bodyDamageItems = {
    ["ez_body_damage_splint"] = true,
    ["ez_body_damage_bandage"] = true,
    ["ez_body_damage_first_aid_kit"] = true,
    ["ez_body_damage_painkillers"] = true
}

-- Get the distance between the given entities
function easzy.bodydamage.GetDistance(ent1, ent2)
	return ent1:GetPos():DistToSqr(ent2:GetPos())
end

-- Verify if the given entities are in the given distance
function easzy.bodydamage.GetInDistance(ent1, ent2, distance)
	return easzy.bodydamage.GetDistance(ent1, ent2) < distance^2
end

-- Verify if the bodyHealth table exists
function easzy.bodydamage.IsBodyHealthValid(ply)
	if not IsValid(ply) then return end
	if not ply.easzy or not ply.easzy.bodydamage or not ply.easzy.bodydamage.bodyHealth then return end
	return true
end

-- Format currency
function easzy.bodydamage.FormatCurrency(amount)
	local amountString
	if GAMEMODE.Config.currency == "€" then
		amountString = tostring(amount) .. " " .. GAMEMODE.Config.currency
	else
		amountString = GAMEMODE.Config.currency .. tostring(amount)
	end
	return amountString
end

-- Get player job name
function easzy.bodydamage.PlayerJobName(ply)
	return team.GetName(ply:Team()) or nil
end

function easzy.bodydamage.IsThereMedicOnline()
	for _, ply in ipairs(player.GetAll()) do
		if easzy.bodydamage.IsMedic(ply) then
			return true
		end
	end
	return false
end

function easzy.bodydamage.IsMedic(ply)
	return easzy.bodydamage.config.medics[easzy.bodydamage.PlayerJobName(ply)]
end

function easzy.bodydamage.PlayerCanTreat(ply)
	return not easzy.bodydamage.config.onlyMedicCanTreat or easzy.bodydamage.IsMedic(ply) or (easzy.bodydamage.config.allPlayersCanTreatIfNoMedicOnline and not easzy.bodydamage.IsThereMedicOnline())
end

function easzy.bodydamage.PlayerCanRevive(ply)
	return easzy.bodydamage.config.firstAidKitCanRevive and (not easzy.bodydamage.config.onlyMedicCanRevive or easzy.bodydamage.IsMedic(ply) or (easzy.bodydamage.config.allPlayersCanReviveIfNoMedicOnline and not easzy.bodydamage.IsThereMedicOnline()))
end

if CLIENT then
	function easzy.bodydamage.RespX(px)
		local respX = math.ceil((px/1920) * ScrW(), 0)
		return respX
	end

	function easzy.bodydamage.RespY(px)
		local respY = math.ceil((px/1080) * ScrH(), 0)
		return respY
	end

	function easzy.bodydamage.GetTextSize(text, font)
		surface.SetFont(font)
		local w, h = surface.GetTextSize(text)
		w = w + easzy.bodydamage.RespX(20)
		h = h + easzy.bodydamage.RespY(10)

		return w, h
	end
end

-- Verificar si un jugador puede inspeccionar (solo medics)
function easzy.bodydamage.PlayerCanInspect(ply)
    return easzy.bodydamage.IsMedic(ply)
end
