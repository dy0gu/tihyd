package.path = "src/Contents/mods/TIHYD/common/media/lua/client/?.lua;" .. package.path

require("TIHYD/Mortality")

rawset(TIHYD, "log", function() end)

local annualRisk = (1 / (100 * math.exp(75 * -0.091))) / 100

for _, days in ipairs({ 1, 7, 30, 365, 1000 }) do
    TIHYD.config.daysPerYear = days
    local dailyRisk = TIHYD.getDailyDeathRisk(75, 0)
    local cumulativeRisk = 1 - (1 - dailyRisk) ^ days

    assert(math.abs(cumulativeRisk - annualRisk) < 1e-12, "Daily risk must preserve annual risk")
end

assert(TIHYD.getDailyDeathRisk(75, 1000) == 0, "Mortality risk must not fall below zero")
assert(TIHYD.getDailyDeathRisk(75, -1000) == 1, "Mortality risk must not exceed one")

TIHYD.config.daysPerYear = 365
TIHYD.config.deathAge = 75

local deaths = 0
local rolls = 0
CharacterTrait = {}
for _, name in ipairs({
    "STRONG",
    "ATHLETIC",
    "RESILIENT",
    "STOUT",
    "FIT",
    "OBESE",
    "VERY_UNDERWEIGHT",
    "WEAK",
    "UNFIT",
    "SMOKER",
    "PRONE_TO_ILLNESS",
    "FEEBLE",
    "OUT_OF_SHAPE",
    "UNDERWEIGHT",
    "OVERWEIGHT",
}) do
    CharacterTrait[name] = {}
end

local selectedTraits = {}
local fitness, strength = 5, 5
local messages = 0
Perks = { Fitness = {}, Strength = {} }
getText = function(key)
    return key
end
local player = {
    Say = function(_, text)
        assert(text == "UI_TIHYD_OldAgeDeath")
        messages = messages + 1
    end,
    getPerkLevel = function(_, perk)
        return perk == Perks.Fitness and fitness or strength
    end,
    Kill = function()
        deaths = deaths + 1
    end,
    getCharacterTraits = function()
        return {
            get = function(_, trait)
                assert(type(trait) == "table", "Trait lookup must use a CharacterTrait constant")
                return selectedTraits[trait] or false
            end,
        }
    end,
}

ZombRand = function(min, max)
    assert(min == 0 and max == 1000000, "Mortality rolls must use the expected probability scale")
    rolls = rolls + 1
    return 0
end

TIHYD.config.isDeathEnabled = false
TIHYD.tryDeath(player, 75)
assert(rolls == 0, "Disabled mortality must not roll")

TIHYD.config.isDeathEnabled = true
TIHYD.tryDeath(player, 74)
assert(rolls == 0, "Characters below the minimum age must not roll")

TIHYD.tryDeath(player, 75)
assert(rolls == 1 and deaths == 1, "Eligible characters must roll for mortality")
assert(messages == 1, "Old-age deaths must display a message")

selectedTraits = {
    [CharacterTrait.STRONG] = true,
    [CharacterTrait.FIT] = true,
    [CharacterTrait.SMOKER] = true,
    [CharacterTrait.UNDERWEIGHT] = true,
}
assert(TIHYD.getHealthiness(player) == 0, "Positive and negative modifiers must combine")

for _, group in ipairs({
    { 5, CharacterTrait.STRONG, CharacterTrait.ATHLETIC, CharacterTrait.RESILIENT },
    { 2.5, CharacterTrait.STOUT, CharacterTrait.FIT },
    {
        -5,
        CharacterTrait.OBESE,
        CharacterTrait.VERY_UNDERWEIGHT,
        CharacterTrait.WEAK,
        CharacterTrait.UNFIT,
        CharacterTrait.SMOKER,
    },
    {
        -2.5,
        CharacterTrait.PRONE_TO_ILLNESS,
        CharacterTrait.FEEBLE,
        CharacterTrait.OUT_OF_SHAPE,
        CharacterTrait.UNDERWEIGHT,
        CharacterTrait.OVERWEIGHT,
    },
}) do
    for i = 2, #group do
        selectedTraits = { [group[i]] = true }
        assert(TIHYD.getHealthiness(player) == group[1], "Each trait must retain its mortality modifier")
    end
end

selectedTraits = { [CharacterTrait.STRONG] = true, [CharacterTrait.ATHLETIC] = true, [CharacterTrait.RESILIENT] = true }
assert(TIHYD.getHealthiness(player) == 15, "Beneficial traits must reduce mortality risk")

TIHYD.config.isTraitsConsidered = true
TIHYD.tryDeath(player, 75)
assert(deaths == 1, "A zero-risk character must survive even the lowest roll")

selectedTraits = { [CharacterTrait.SMOKER] = true }
assert(TIHYD.getHealthiness(player) == -5, "Harmful traits must increase mortality risk")

TIHYD.tryDeath(player, 75)
assert(deaths == 2, "Harmful traits must still allow mortality")

selectedTraits = { [CharacterTrait.STRONG] = true, [CharacterTrait.ATHLETIC] = true, [CharacterTrait.RESILIENT] = true }
TIHYD.config.isTraitsConsidered = false
TIHYD.tryDeath(player, 75)
assert(deaths == 3, "Disabling trait effects must ignore beneficial modifiers")

ZombRand = function()
    return 999999
end

TIHYD.tryDeath(player, 75)
assert(deaths == 3, "A roll above the mortality risk must survive")

ZombRand = function()
    return 250
end
fitness, strength = 0, 0
TIHYD.tryDeath(player, 75)
assert(deaths == 4, "Low physical skills must increase mortality risk")
fitness, strength = 10, 10
TIHYD.tryDeath(player, 75)
assert(deaths == 4, "High physical skills must reduce mortality risk")
assert(messages == deaths, "Only old-age deaths should produce a message")

print("Mortality tests passed")
