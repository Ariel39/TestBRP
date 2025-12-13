if not itemstore.config.bLogs then return end

-- thanks to billy for providing blogs to me for free <3
local MODULE = GAS.Logging:MODULE()

MODULE.Category = "ItemStore"
MODULE.Name = "ItemStore"
MODULE.Colour = Color( 50, 150, 255 )

MODULE:Setup( function()
	MODULE:Hook( "ItemStoreLog", "ItemStoreLog", function( formatted, original, ... )
        local params = { ... }

        local message = original
        local real_params = {}

        -- blogs quite annoyingly does not support strings so we do some hacks to get it to support itemstore's log format
        for k, v in ipairs( params ) do
            if IsEntity( v ) then
                table.insert( real_params, GAS.Logging:FormatEntity( v ) )
                message = string.Replace( message, "{" .. k .. "}", "{" .. #real_params .. "}" )
            else
                local value = v

                if isvector( v ) then
                    value = string.format( "{%f, %f, %f}", v.x, v.y, v.z )
                elseif istable( v ) and v.ItemStore then
                    value = v:GetName() .. " (" .. v:GetClass() .. ")"
                end

                message = string.Replace( message, "{" .. k .. "}", tostring( value ) )
            end
        end

		MODULE:Log( message, unpack( params ) )
	end )
end )

GAS.Logging:AddModule( MODULE )