package.path = "src/Contents/mods/TIHYD/common/media/lua/client/?.lua;" .. package.path

package.preload["XpSystem/ISUI/ISCharacterScreen"] = function() end
rawset(_G, "UIFont", { Small = "small" })
local activeMods = {}
getActivatedMods = function()
    return {
        contains = function(_, id)
            return activeMods[id] == true
        end,
    }
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

---@class TIHYDTestCharacterScreen : ISCharacterScreen
---@field statsY number

local originalCalls = 0
ISCharacterScreen = {
    render = function(self, argument)
        ---@cast self TIHYDTestCharacterScreen
        assert(argument == "argument")
        originalCalls = originalCalls + 1
        self.height = 200
        if self.literatureButton then
            self.statsY = math.max(150, self.literatureButton:getBottom() + 10)
            self.height = self.statsY + 50
        end
        return "original result"
    end,
}
require("TIHYD/CharacterInfo")

local draws = {}
local screen = {
    char = {
        getAge = function()
            return 42
        end,
    },
    width = 300,
    getHeight = function(self)
        return self.height
    end,

    setHeightAndParentHeight = function(self, height)
        self.height = height
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
assert(draws[1][3] == 190 and screen.height == 218 and screen.width == 300)
ISCharacterScreen.render(screen, "argument")
assert(screen.height == 218, "The added row must not grow on each render")

activeMods.ReorganizedInfoScreen = true
draws = {}
ISCharacterScreen.render(screen, "argument")
assert(#draws == 0 and screen.height == 200, "An incompatible mod must suppress the age row")
assert(originalCalls == 3, "The original renderer must always be called")

activeMods.ReorganizedInfoScreen = nil
activeMods.SPNCC = true

screen.char.isFemale = function()
    return false
end
screen.beardButton = {
    getY = function()
        return 100
    end,
}
local getBottom = function()
    return 130
end
screen.literatureButton = {
    getBottom = getBottom,
    getHeight = function()
        return 20
    end,
}
ISCharacterScreen.render(screen, "argument")
assert(screen.statsY == 217 and screen.height == 285)
assert(screen.literatureButton.getBottom == getBottom, "The original button method must be restored")
ISCharacterScreen.render(screen, "argument")
assert(screen.statsY == 217 and screen.height == 285, "The layout must not grow on each render")
