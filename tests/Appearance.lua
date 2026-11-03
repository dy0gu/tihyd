package.path = "src/Contents/mods/TIHYD/common/media/lua/client/?.lua;" .. package.path

require("TIHYD/Appearance")

rawset(TIHYD, "log", function() end)
TIHYD.grayHairAge = 45
TIHYD.isGrayHairEnabled = true

ImmutableColor = { gray = {} }

local hairColor = {}
local beardColor = {}
local originalHairColor = hairColor
local originalBeardColor = beardColor
local resets = 0
local visual = {
    setHairColor = function(_, color)
        hairColor = color
    end,
    setBeardColor = function(_, color)
        beardColor = color
    end,
}
local player = {
    getHumanVisual = function()
        return visual
    end,
    resetModel = function()
        resets = resets + 1
    end,
}

TIHYD.updateVisual(player, 44)
assert(hairColor == originalHairColor, "Hair must retain its color below the gray threshold")
assert(beardColor == originalBeardColor, "Beards must retain their color below the gray threshold")
assert(resets == 0, "Models must not reset below the gray threshold")

TIHYD.updateVisual(player, 45)
assert(hairColor == ImmutableColor.gray, "Hair must turn gray at the threshold")
assert(beardColor == ImmutableColor.gray, "Beards must turn gray at the threshold")
assert(resets == 1, "Applying gray hair must refresh the model")

TIHYD.updateVisual(player, 90)
assert(hairColor == ImmutableColor.gray, "Older characters must keep gray hair")
assert(beardColor == ImmutableColor.gray, "Older characters must keep gray beards")

TIHYD.isGrayHairEnabled = false
hairColor = originalHairColor
beardColor = originalBeardColor
local previousResets = resets

TIHYD.updateVisual(player, 90)
assert(hairColor == originalHairColor, "Disabled graying must preserve hair color")
assert(beardColor == originalBeardColor, "Disabled graying must preserve beard color")
assert(resets == previousResets, "Disabled graying must not reset the model")

print("Appearance tests passed")
