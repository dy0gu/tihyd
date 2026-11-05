package.path = "src/Contents/mods/TIHYD/common/media/lua/client/?.lua;" .. package.path

package.preload["XpSystem/ISUI/ISCharacterScreen"] = function() end
rawset(_G, "UIFont", { Small = "small" })
local activeMods = {}
getActivatedMods = function()
    return { contains = function(_, id)
        return activeMods[id] == true
    end }
end
getText = function(key)
    return key
end
getTextManager = function()
    return {
        MeasureStringX = function(_, _, text)
            return #text
        end,
        getFontHeight = function()
            return 12
        end,
    }
end

local originalCalls = 0
ISCharacterScreen = {
    render = function(self, argument)
        assert(argument == "argument")
        originalCalls = originalCalls + 1
        self.height = 200
        return "original result"
    end,
}
require("TIHYD/CharacterInfo")

local draws = {}
local screen = {
    char = { getAge = function()
        return 42
    end },
    width = 300,
    getHeight = function(self)
        return self.height
    end,
    getWidth = function(self)
        return self.width
    end,
    setHeightAndParentHeight = function(self, height)
        self.height = height
    end,
    setWidthAndParentWidth = function(self, width)
        self.width = width
    end,
    drawTextRight = function(_, text, x, y)
        table.insert(draws, { text, x, y })
    end,
    drawText = function(_, text, x, y)
        table.insert(draws, { text, x, y })
    end,
}

assert(ISCharacterScreen.render(screen, "argument") == "original result")
assert(originalCalls == 1 and #draws == 2)
assert(draws[1][1] == "UI_TIHYD_StartingAge" and draws[2][1] == "42")
assert(draws[1][3] == 190 and screen.height == 218)
ISCharacterScreen.render(screen, "argument")
assert(screen.height == 218, "The added row must not grow on each render")

for _, id in ipairs({ "ReorganizedInfoScreen", "twistbettercharacterinfo" }) do
    activeMods[id] = true
    draws = {}
    ISCharacterScreen.render(screen, "argument")
    assert(#draws == 0 and screen.height == 200, id .. " must suppress the age row")
    activeMods[id] = nil
end
assert(originalCalls == 4, "The original renderer must always be called")
