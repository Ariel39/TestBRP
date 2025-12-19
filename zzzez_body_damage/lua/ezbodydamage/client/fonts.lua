local ratio = ScrW()/640
local sizes = {16, 20, 30, 60}

function easzy.bodydamage.CreateFont(name, font, size, options)
    local name = (name or "NewFont") .. size
    local options = options or {}
    options.size = ScreenScale(size/ratio)
    options.font = font

    surface.CreateFont(name, options)
    return name
end

function easzy.bodydamage.CreateFonts(name, font, sizes, options)
    local names = {}
    for _, size in ipairs(sizes) do
        table.insert(names, easzy.bodydamage.CreateFont(name, font, size, options))
    end
    return names
end

easzy.bodydamage.CreateFonts("EZFont", "Gidole", sizes)

hook.Add("OnScreenSizeChanged", "ezbodydamage_fonts_OnScreenSizeChanged", function()
	ratio = ScrW()/640
    easzy.bodydamage.CreateFonts("EZFont", "Gidole", sizes)
end)
