itemstore.Version = "3.0"
itemstore.About = string.format( [[ItemStore v%s

Authored solely by UselessGhost
http://steamcommunity.com/id/uselessghost
]], itemstore.Version )

MsgC( color_white, "ItemStore", Color( 100, 200, 255 ), " ", itemstore.Version, " ", Color( 200, 200, 200 ), "coded by ", Color( 255, 150, 150 ), "UselessGhost", "\n" )

concommand.Add( "itemstore_about", function()
	MsgC( color_white, itemstore.About )
end )

function itemstore.Log( msg, ... )
	local original = msg
	local params = { ... }

	for k, v in ipairs( params ) do
		local value = tostring( v )

		if IsEntity( v ) then
			if IsValid( v ) then
				if v:IsPlayer() then
					value = v:Name() .. " (" .. v:SteamID() ..")"
				else
					value = v:GetClass()
				end
			else
				value = "(NULL entity)"
			end
		elseif isvector( v ) then
			value = string.format( "{%f, %f, %f}", v.x, v.y, v.z )
		elseif istable( v ) and v.ItemStore then
			value = v:GetName() .. " (" .. v:GetClass() .. ")"
		end

		msg = string.Replace( msg, "{" .. k .. "}", value )
	end

	if itemstore.config.PrintLog then print( msg ) end
	hook.Call( "ItemStoreLog", GAMEMODE, msg, original, ... )
end

itemstore.config = {}

function itemstore.config.Verify( setting, correct_type )
	if type( itemstore.config[ setting ] ) ~= correct_type then
		error( string.format( "[ItemStore] Configuration error: %s is %s, should be %s.", setting, var_type, correct_type ) )
		return false
	end

	return true
end

local status, err = pcall( function()
	include( "itemstore/config.lua" )

	itemstore.config.Verify( "Skin", "string" )
	itemstore.config.Verify( "PickupsGotoBank", "boolean" )
	itemstore.config.Verify( "InvholsterTakesAmmo", "boolean" )
	itemstore.config.Verify( "MaxStack", "number" )
	itemstore.config.Verify( "GamemodeProvider", "string" )
	itemstore.config.Verify( "LimitToJobs", "table" )
	itemstore.config.Verify( "HighlightColours", "table" )
	itemstore.config.Verify( "TradeDistance", "number" )
	itemstore.config.Verify( "MigrateOldData", "boolean" )
	itemstore.config.Verify( "DeathLoot", "boolean" )
	itemstore.config.Verify( "SplitWeaponAmmo", "boolean" )
	itemstore.config.Verify( "TradingEnabled", "boolean" )
	itemstore.config.Verify( "PickupDistance", "number" )
	itemstore.config.Verify( "InventorySizes", "table" )
	itemstore.config.Verify( "BankSizes", "table" )
	itemstore.config.Verify( "AntiDupe", "boolean" )
	itemstore.config.Verify( "SaveOnWrite", "boolean" )
	itemstore.config.Verify( "ContextInventoryPosition", "string" )
	itemstore.config.Verify( "EnableInvholster", "boolean" )
	itemstore.config.Verify( "SaveInterval", "number" )
	itemstore.config.Verify( "ContextInventory", "boolean" )
	itemstore.config.Verify( "DropDistance", "number" )
	itemstore.config.Verify( "TradeCooldown", "number" )
	itemstore.config.Verify( "Colours", "table" )
	itemstore.config.Verify( "DeathLootTimeout", "number" )
	itemstore.config.Verify( "DisabledItems", "table" )
	itemstore.config.Verify( "InvholsterDisabled", "table" )
	itemstore.config.Verify( "HighlightStyle", "string" )
	itemstore.config.Verify( "DataProvider", "string" )
	itemstore.config.Verify( "CustomItems", "table" )
	itemstore.config.Verify( "Verify", "function" )
	itemstore.config.Verify( "IgnoreOwner", "boolean" )
	itemstore.config.Verify( "ChatCommandPrefix", "string" )
	itemstore.config.Verify( "PickupKey", "number" )
	itemstore.config.Verify( "BoxBreakable", "boolean" )
	itemstore.config.Verify( "BoxHealth", "number" )
	itemstore.config.Verify( "Language", "string" )
	itemstore.config.Verify( "UseNewUI", "boolean" )
	itemstore.config.Verify( "LoadDelay", "number" )
	itemstore.config.Verify( "PrintLog", "boolean" )
	itemstore.config.Verify( "VerboseLogging", "boolean" )
	itemstore.config.Verify( "bLogs", "boolean" )
end )

-- remove this if it's here since the player probably is fiddling with the config
hook.Remove( "HUDPaint", "ItemStoreError" )

if not status then
	local str = "ITEMSTORE CONFIGURATION ERROR:\n"
	str = str .. err .. "\n"
	str = str .. "ITEMSTORE WILL NOT RUN AND MANY THINGS WILL BE BROKEN.\n"
	str = str .. "THIS IS NOT A PROBLEM WITH ITEMSTORE, YOUR CONFIG FILE HAS AN ERROR IN IT.\n"
	str = str .. "PLEASE INSTALL A FRESH COPY OF ITEMSTORE OR FIX THE ERROR IN YOUR CONFIG.\n"
	str = str .. "SEE YOUR SERVER CONSOLE FOR MORE DETAILS."

	MsgC( Color( 255, 0, 0 ), str, "\n" )

	if CLIENT then
		hook.Add( "HUDPaint", "ItemStoreError", function()
			for k, v in ipairs( string.Explode( "\n", str ) ) do
				draw.SimpleText( v, "Trebuchet24", ScrW() / 2, ScrH() / 2 + ( k * 24 ), Color( 255, 0, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
		end )
	end
end

include( "language.lua" )
include( "gamemodes.lua" )
include( "items.lua" )
include( "containers.lua" )
include( "trading.lua" )
include( "admin.lua" )

local _, dirs = file.Find( "itemstore/modules/*", "LUA" )
for _, mod in ipairs( dirs ) do
	MsgC( color_white, string.format( "Loading ItemStore module: %s\n", mod ) )

	local path = "itemstore/modules/" .. mod

	for _, filename in ipairs( file.Find( path .. "/*.lua", "LUA" ) ) do
		if not string.match( filename, "^sv_.+%.lua$" ) then
			AddCSLuaFile( path .. "/" .. filename )
		end
	end

	local sv_init = path .. "/sv_init.lua"
	local cl_init = path .. "/cl_init.lua"
	local shared = path .. "/shared.lua"

	if file.Exists( shared, "LUA" ) then
		include( shared )
	end

	if SERVER and file.Exists( sv_init, "LUA" ) then
		include( sv_init )
	end

	if CLIENT and file.Exists( cl_init, "LUA" ) then
		include( cl_init )
	end
end

local teams = nil
local meta = FindMetaTable( "Player" )

function meta:CanUseInventory()
	if SERVER and ( not self.Inventory or not self.Bank ) then return end
	
	if self:IsAdmin() then return true end -- always allow admins to access their inventories
	if not self:Alive() then return false end -- using your inventory while dead can be a bit exploitable

	if #itemstore.config.LimitToJobs > 0 then
		-- process this into an associative table for faster lookups
		if not teams then
			teams = {}

			for k, v in ipairs( itemstore.config.LimitToJobs ) do
				teams[ v ] = true
			end
		end

		if teams[ self:Team() ] ~= true then
			return false
		end
	end

	return true
end