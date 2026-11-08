package.path = "src/Contents/mods/TIHYD/common/media/lua/client/?.lua;" .. package.path

require("TIHYD/Aging")


TIHYD.config.daysPerYear = 100
local hours, currentAge, modData = 0, 74, { TIHYD = { startingAge = 74 } }
local player = {
    isDead = function() return false end,
    getAge = function() return currentAge end,
    setAge = function(_, age) currentAge = age end,
    getHoursSurvived = function() return hours end,
    getModData = function() return modData end,
    getDescriptor = function() return nil end,
}

local age, increased = TIHYD.updatePlayerAge(player)
assert(age == 74 and not increased)
hours = 24 * 50
age, increased = TIHYD.updatePlayerAge(player)
assert(age == 74 and not increased)
hours = 24 * 200
age, increased = TIHYD.updatePlayerAge(player)
assert(age == 76 and increased)
TIHYD.config.daysPerYear = 200
age, increased = TIHYD.updatePlayerAge(player)
assert(age == 75 and not increased, "A longer year must recalculate all survived hours")
TIHYD.config.daysPerYear = 100
age, increased = TIHYD.updatePlayerAge(player)
assert(age == 76 and increased, "A shorter year must recalculate all survived hours")
TIHYD.config.daysPerYear = 200
age, increased = TIHYD.updatePlayerAge(player)
assert(age == 75 and not increased)

local visualUpdates, traitUpdates, declineChecks, deathChecks, configLoads = 0, 0, 0, 0, 0
rawset(TIHYD, "loadConfig", function() configLoads = configLoads + 1 end)
rawset(TIHYD, "log", function() end)
rawset(TIHYD, "updateVisual", function(_, value)
    assert(value == 75)
    visualUpdates = visualUpdates + 1
end)
rawset(TIHYD, "updateAgingTraits", function(_, value)
    assert(value == 75)
    traitUpdates = traitUpdates + 1
end)
rawset(TIHYD, "applyDecline", function(_, value)
    assert(value == 75)
    declineChecks = declineChecks + 1
end)
rawset(TIHYD, "tryDeath", function(_, value)
    assert(value == 75)
    deathChecks = deathChecks + 1
end)

TIHYD.initializePlayer(0, player)
assert(configLoads == 0 and visualUpdates == 1 and traitUpdates == 1, "Initialization must use loaded configuration and apply transitions")
getNumActivePlayers = function() return 1 end
getSpecificPlayer = function() return player end
TIHYD.processAllPlayersDaily()
TIHYD.processAllPlayersDaily()
assert(declineChecks == 2 and deathChecks == 2, "Decline and mortality must run daily")
assert(visualUpdates == 1 and traitUpdates == 1, "Transitions must not run between birthdays")
currentAge = 74
TIHYD.processAllPlayersDaily()
assert(visualUpdates == 2 and traitUpdates == 2, "An age increase must trigger transitions")
player.isDead = function() return true end
TIHYD.initializePlayer(0, player)
TIHYD.processAllPlayersDaily()
getSpecificPlayer = function() return nil end
TIHYD.initializePlayer(0, nil)
TIHYD.processAllPlayersDaily()
assert(configLoads == 0 and declineChecks == 3 and deathChecks == 3, "Dead and missing players must be skipped")

print("Aging tests passed")
