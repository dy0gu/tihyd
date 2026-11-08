package.path = "src/Contents/mods/TIHYD/common/media/lua/client/?.lua;" .. package.path

require("TIHYD/Appearance")

rawset(TIHYD, "log", function() end)
TIHYD.config.grayHairAge = 45
TIHYD.config.isGrayHairEnabled = true

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
local modData = { TIHYD = { startingAge = 30 } }
local player = {
    getModData = function()
        return modData
    end,
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

assert(modData.TIHYD.grayHairApplied == true, "The transition must be saved on the character")
assert(modData.TIHYD.startingAge == 30, "Existing character data must be preserved")

-- Simulate a color change and a reload with the persisted character data.
hairColor = originalHairColor
beardColor = originalBeardColor
modData = { TIHYD = { startingAge = 30, grayHairApplied = modData.TIHYD.grayHairApplied } }
TIHYD.updateVisual(player, 90)
assert(hairColor == originalHairColor, "Later updates must preserve changed hair color")
assert(beardColor == originalBeardColor, "Later updates must preserve changed beard color")
assert(resets == 1, "The transition must not run again after reload")

TIHYD.config.isGrayHairEnabled = false
hairColor = originalHairColor
beardColor = originalBeardColor
local previousResets = resets

TIHYD.updateVisual(player, 90)
assert(hairColor == originalHairColor, "Disabled graying must preserve hair color")
assert(beardColor == originalBeardColor, "Disabled graying must preserve beard color")
assert(resets == previousResets, "Disabled graying must not reset the model")

-- Existing saves without a marker remain eligible, including when enabled later.
modData = { TIHYD = { startingAge = 30 } }
TIHYD.updateVisual(player, 90)
assert(modData.TIHYD.grayHairApplied == nil, "Disabled graying must not consume the transition")
TIHYD.config.isGrayHairEnabled = true
TIHYD.updateVisual(player, 90)
assert(hairColor == ImmutableColor.gray and beardColor == ImmutableColor.gray, "Eligible older saves must turn gray")
assert(modData.TIHYD.grayHairApplied == true, "Migrated characters must save the transition")

-- Characters without existing mod data get their own marker.
modData = {}
TIHYD.updateVisual(player, 45)
assert(modData.TIHYD.grayHairApplied == true, "Missing character data must be initialized")

print("Appearance tests passed")
