package.path = "src/Contents/mods/TIHYD/common/media/lua/client/?.lua;" .. package.path

require("TIHYD/Traits")

rawset(TIHYD, "log", function() end)
CharacterTrait = {
    SHORT_SIGHTED = "short",
    EAGLE_EYED = "eagle",
    HARD_OF_HEARING = "hard",
    KEEN_HEARING = "keen",
    DEAF = "deaf",
}
TIHYD.config.isShortSightedEnabled = true
TIHYD.config.shortSightedAge = 60
TIHYD.config.isHardOfHearingEnabled = true
TIHYD.config.hardOfHearingAge = 70

local present = {}
local additions = 0
local traits = {
    get = function(_, trait)
        return present[trait] or false
    end,
    add = function(_, trait)
        assert(not present[trait], "Traits must not be added twice")
        present[trait] = true
        additions = additions + 1
    end,
}
local player = {
    getCharacterTraits = function()
        return traits
    end,
}

TIHYD.updateAgingTraits(player, 59)
assert(additions == 0, "No trait should be added below its threshold")
TIHYD.updateAgingTraits(player, 60)
assert(present.short and not present.hard, "Short Sighted should be added at its threshold")
TIHYD.updateAgingTraits(player, 70)
assert(present.hard and additions == 2, "Hard of Hearing should be added at its threshold")
TIHYD.updateAgingTraits(player, 90)
assert(additions == 2, "Repeated checks must be idempotent")

present = {}
TIHYD.config.isShortSightedEnabled = false
TIHYD.config.isHardOfHearingEnabled = false
TIHYD.updateAgingTraits(player, 90)
assert(not present.short and not present.hard, "Disabled traits must not be added")
TIHYD.config.isShortSightedEnabled = true
TIHYD.config.isHardOfHearingEnabled = true
present = { eagle = true, keen = true }
TIHYD.updateAgingTraits(player, 90)
assert(not present.short and not present.hard, "Positive sensory traits must be preserved")
present = { deaf = true }
TIHYD.updateAgingTraits(player, 90)
assert(present.short and not present.hard, "Deaf characters must not become hard of hearing")

print("Trait aging tests passed")
