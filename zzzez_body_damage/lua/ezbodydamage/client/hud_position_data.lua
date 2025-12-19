easzy.bodydamage.hudConfig = easzy.bodydamage.hudConfig or {}

local hudConfig = {}

hudConfig.playerBodyWidth = easzy.bodydamage.RespX(285)
hudConfig.playerBodyHeight = easzy.bodydamage.RespY(800)

hudConfig.size = 0.3

hudConfig.x = easzy.bodydamage.RespX(50)
hudConfig.y = easzy.bodydamage.RespY(50)

hudConfig.iconSize = easzy.bodydamage.RespY(30)
hudConfig.indicatorsVerticalAlign = "top"
hudConfig.indicatorsHorizontalAlign = "left"
hudConfig.spaceBetweenPlayerBodyAndIndicators = easzy.bodydamage.RespX(20) + hudConfig.iconSize
hudConfig.indicatorsVerticalMargin = easzy.bodydamage.RespY(5)

hudConfig.positioningModeArrowsMargin = easzy.bodydamage.RespY(50)

local ip = game.GetIPAddress()

-- Because ips contains "." and ":" which are not allowed in file names
local fileName = string.Replace(ip, ".", "_")
fileName = string.Replace(ip, ":", "_")

local path = "easzy/ez_body_damage/" .. fileName .. ".json"

function easzy.bodydamage.LoadHUDPositionData()
    if file.Exists(path, "DATA") then
        local data = util.JSONToTable(file.Read(path, "DATA"))
        easzy.bodydamage.hudConfig = data
        return
    end
    easzy.bodydamage.hudConfig = table.Copy(hudConfig)
end

function easzy.bodydamage.SaveHUDPositionData()
    file.Write(path, util.TableToJSON(easzy.bodydamage.hudConfig))
end

hook.Add("Initialize", "ezbodydamage_hud_position_data_Initialize", function()
    file.CreateDir("easzy")
    file.CreateDir("easzy/ez_body_damage")
    easzy.bodydamage.LoadHUDPositionData()
end)

easzy.bodydamage.LoadHUDPositionData()
