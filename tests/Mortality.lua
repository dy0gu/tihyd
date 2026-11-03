package.path = "src/Contents/mods/TIHYD/common/media/lua/client/?.lua;" .. package.path

require("TIHYD/Mortality")

rawset(TIHYD, "log", function() end)

local annualRisk = (1 / (100 * math.exp(75 * -0.091))) / 100

for _, days in ipairs({ 1, 7, 30, 365, 1000 }) do
    TIHYD.daysPerYear = days
    local dailyRisk = TIHYD.getDailyDeathRisk(75, 0)
    local cumulativeRisk = 1 - (1 - dailyRisk) ^ days

    assert(math.abs(cumulativeRisk - annualRisk) < 1e-12, "Daily risk must preserve annual risk")
end

assert(TIHYD.getDailyDeathRisk(75, 1000) == 0, "Mortality risk must not fall below zero")
assert(TIHYD.getDailyDeathRisk(75, -1000) == 1, "Mortality risk must not exceed one")

TIHYD.daysPerYear = 365
TIHYD.deathAge = 75

local deaths = 0
local rolls = 0
local selectedTraits = {}
local player = {
    Kill = function()
        deaths = deaths + 1
    end,
    getTraits = function()
        return {
            contains = function(_, trait)
                return selectedTraits[trait]
            end,
        }
    end,
}

ZombRand = function(min, max)
    assert(min == 0 and max == 1000000, "Mortality rolls must use the expected probability scale")
    rolls = rolls + 1
    return 0
end

TIHYD.isDeathEnabled = false
TIHYD.tryDeath(player, 75)
assert(rolls == 0, "Disabled mortality must not roll")

TIHYD.isDeathEnabled = true
TIHYD.tryDeath(player, 74)
assert(rolls == 0, "Characters below the minimum age must not roll")

TIHYD.tryDeath(player, 75)
assert(rolls == 1 and deaths == 1, "Eligible characters must roll for mortality")

selectedTraits = { Strong = true, Fit = true, Smoker = true, Underweight = true }
assert(TIHYD.getHealthiness(player) == 0, "Positive and negative modifiers must combine")

selectedTraits = { Strong = true, Athletic = true, Resilient = true }
assert(TIHYD.getHealthiness(player) == 15, "Beneficial traits must reduce mortality risk")

TIHYD.isTraitsConsidered = true
TIHYD.tryDeath(player, 75)
assert(deaths == 1, "A zero-risk character must survive even the lowest roll")

selectedTraits = { Smoker = true }
assert(TIHYD.getHealthiness(player) == -5, "Harmful traits must increase mortality risk")

TIHYD.tryDeath(player, 75)
assert(deaths == 2, "Harmful traits must still allow mortality")

selectedTraits = { Strong = true, Athletic = true, Resilient = true }
TIHYD.isTraitsConsidered = false
TIHYD.tryDeath(player, 75)
assert(deaths == 3, "Disabling trait effects must ignore beneficial modifiers")

ZombRand = function()
    return 999999
end

TIHYD.tryDeath(player, 75)
assert(deaths == 3, "A roll above the mortality risk must survive")

print("Mortality tests passed")
