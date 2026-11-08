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
    return {
        getFontHeight = function()
            return 12
        end,
    }
end)
rawset(_G, "getText", function(key)
    return key
end)
rawset(_G, "ISLabel", {
    new = function()
        return {
            initialise = function() end,
            getWidth = function()
                return 50
            end,
        }
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
TIHYD.config.daysPerYear = 100
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
assert(TIHYD.pendingStartingAges[first] == 30 and screen.TIHYDAgeCombo.selected == 13)
assert(screen:createNameAndGender() == "vanilla")
assert(calls == 2 and #panel.children == 2, "Recreation must call vanilla without duplicating controls")

local combo = screen.TIHYDAgeCombo
combo.selected = 26
combo.onChange(combo.target, combo)
assert(TIHYD.pendingStartingAges[first] == 43, "Selection must be stored for the current descriptor")

MainScreen.instance.desc = second
nextAge = 55
screen:setVisible(true)
assert(combo.selected == 38 and TIHYD.pendingStartingAges[second] == 55)
assert(TIHYD.pendingStartingAges[first] == 43, "Switching descriptors must preserve the first selection")

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
assert(TIHYD.pendingStartingAges[second] == nil and TIHYD.pendingStartingAges[first] == 43)

local function character(data, hours, age, descriptor)
    local storage = { TIHYD = data }
    return {
        getModData = function()
            return storage
        end,
        getHoursSurvived = function()
            return hours
        end,
        getAge = function()
            return age
        end,
        getDescriptor = function()
            return descriptor
        end,
    }
end

local pending = {}
TIHYD.pendingStartingAges[pending] = 40
local selected = TIHYD.getCharacterData(character({}, 1200, 20, pending))
assert(selected.startingAge == 40, "Pending selection must survive nonzero survival time")
assert(TIHYD.pendingStartingAges[pending] == nil, "Consumed selections must be cleared")

local legacyDescriptor = {}
TIHYD.pendingStartingAges[legacyDescriptor] = 60
local legacy = TIHYD.getCharacterData(character({ startingAge = 35 }, 1200, 20, legacyDescriptor))
assert(legacy.startingAge == 35, "Saved starting age must take precedence")

local existing = TIHYD.getCharacterData(character({}, 1200, 47))
assert(existing.startingAge == 47, "Existing characters without data must retain their current age")
local fresh = TIHYD.getCharacterData(character({}, 0, 20))
assert(fresh.startingAge == 55, "New characters without selections must get a random age")

print("Character creation tests passed")
