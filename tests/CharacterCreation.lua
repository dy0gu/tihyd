package.path = "src/Contents/mods/TIHYD/common/media/lua/client/?.lua;" .. package.path

package.preload["OptionScreens/CharacterCreationMain"] = function() end
package.preload["ISUI/ISComboBox"] = function() end
package.preload["ISUI/ISLabel"] = function() end

local calls = 0
rawset(_G, "CharacterCreationMain", {
    createNameAndGender = function()
        calls = calls + 1
        return "vanilla"
    end,
    setVisible = function() end,
    onRandomCharacter = function() end,
})
rawset(_G, "CharacterCreationMainCharacterPanel", { loadJoypadButtons = function() end })
rawset(_G, "UIFont", { Small = "small" })
rawset(_G, "getTextManager", function()
    return { getFontHeight = function()
        return 12
    end }
end)
rawset(_G, "getText", function(key)
    return key
end)
rawset(_G, "ISLabel", {
    new = function()
        return { initialise = function() end, getWidth = function()
            return 50
        end }
    end,
})
rawset(_G, "ISComboBox", {
    new = function(_, _, y, _, height, target, onChange)
        return {
            initialise = function() end,
            addOptionWithData = function() end,
            getBottom = function()
                return y + height
            end,
            target = target,
            onChange = onChange,
        }
    end,
})

local first, second = {}, {}
rawset(_G, "MainScreen", { instance = { desc = first } })
require("TIHYD/CharacterCreation")
rawset(TIHYD, "log", function() end)
local nextAge = 30
rawset(TIHYD, "randomStartingAge", function()
    return nextAge
end)

local panel = { repos2Table = {}, repos3Table = {}, comboResizeTable = {}, columnWidth = 0, children = {} }
function panel:addChild(child)
    table.insert(self.children, child)
end
local screen = { characterPanel = panel, yOffset = 0, columnWidth = 0 }
setmetatable(screen, { __index = CharacterCreationMain })

assert(screen:createNameAndGender() == "vanilla")
assert(TIHYD.startingAges[first] == 30 and screen.TIHYDAgeCombo.selected == 13)
assert(screen:createNameAndGender() == "vanilla")
assert(calls == 2 and #panel.children == 2, "Recreation must call vanilla without duplicating controls")

local combo = screen.TIHYDAgeCombo
combo.selected = 26
combo.onChange(combo.target, combo)
assert(TIHYD.startingAges[first] == 43, "Selection must be stored for the current descriptor")

MainScreen.instance.desc = second
nextAge = 55
screen:setVisible(true)
assert(combo.selected == 38 and TIHYD.startingAges[second] == 55)
assert(TIHYD.startingAges[first] == 43, "Switching descriptors must preserve the first selection")

local modData = {}
local player = {
    getModData = function()
        return modData
    end,
    getDescriptor = function()
        return second
    end,
    getHoursSurvived = function()
        return 0
    end,
}
assert(TIHYD.getCharacterData(player).startingAge == 55, "The selected age must transfer to player data")
assert(TIHYD.startingAges[second] == nil and TIHYD.startingAges[first] == 43)
