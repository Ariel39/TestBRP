easzy = easzy or {}
easzy.bodydamage = {}

local path = "ezbodydamage"

local function NicePrint(txt)
	if SERVER then
		MsgC(easzy.bodydamage.colors.carrot, txt .. "\n")
	else
		MsgC(easzy.bodydamage.colors.belizeHole, txt .. "\n")
	end
end

local function LoadFile(fdir, afile, info, sv, cl)
	if info then
		local txt = "// [ Init ]: " .. afile .. string.rep(" ", 36 - afile:len()) .. "//"
		NicePrint(txt)
	end

	if (sv and SERVER) then
		include(fdir .. afile)
	end

	if cl then
		if SERVER then
			AddCSLuaFile(fdir .. afile)
		else
			include(fdir .. afile)
		end
	end
end

local IgnoreFileTable = {}
local function PreLoadFile(fdir, afile, info, sv, cl)
	IgnoreFileTable[afile] = true
	LoadFile(fdir, afile, info, sv, cl)
end

local function LoadAllFiles(fdir, sv, cl)
	local files, dirs = file.Find(fdir .. "*", "LUA")

	for _, afile in ipairs(files) do
		if (string.match(afile, ".lua") and not IgnoreFileTable[afile]) then
			LoadFile(fdir, afile, true, sv, cl)
		end
	end

	for _, dir in ipairs(dirs) do
		LoadAllFiles(fdir .. dir .. "/", sv, cl)
	end
end

local function Initialize()
	NicePrint(" ")
	NicePrint("////////////////// EZ BODY DAMAGE /////////////////")
	NicePrint("//                                               //")
	NicePrint("///////////////////// SHARED //////////////////////")
	NicePrint("//                                               //")
	LoadAllFiles(path .. "/languages/", true, true)
	LoadAllFiles(path .. "/shared/", true, true)

	if SERVER then
		NicePrint("//                                               //")
		NicePrint("//////////////////// SERVER ///////////////////////")
		NicePrint("//                                               //")
		LoadAllFiles(path .. "/server/", true)
	end

	NicePrint("//                                               //")
	NicePrint("//////////////////// CLIENT ///////////////////////")
	NicePrint("/                                                //")
	LoadAllFiles(path .. "/vgui/", false, true)
	LoadAllFiles(path .. "/client/", false, true)
	NicePrint("//                                               //")
	NicePrint("///////////////////////////////////////////////////")
end

PreLoadFile(path .. "/shared/", "colors.lua", false, true, true)
PreLoadFile(path .. "/shared/", "utility.lua", false, true, true)
PreLoadFile(path .. "/client/", "materials.lua", false, false, true)
PreLoadFile(path .. "/client/", "fonts.lua", false, false, true)
PreLoadFile(path .. "/client/", "hud_position_data.lua", false, false, true)
PreLoadFile("", "ezbodydamage_config.lua", false, true, true)

Initialize()
