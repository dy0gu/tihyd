package.path = "src/Contents/mods/TIHYD/common/media/lua/client/?.lua;" .. package.path

require("TIHYD/Aging")

local player = {
    isDead = function()
        return false
    end,
    getAge = function()
        return 75
    end,
}

getNumActivePlayers = function()
    return 1
end

getSpecificPlayer = function()
    return player
end

local realAge = TIHYD.age
rawset(TIHYD, "age", function()
    return 75, false
end)

rawset(TIHYD, "updateVisual", function()
    error("Appearance must not update between birthdays")
end)

rawset(TIHYD, "updateAgingTraits", function()
    error("Traits must not update between birthdays")
end)

local checks = 0
local declineChecks = 0
local expectedAge = 75
rawset(TIHYD, "applyDecline", function(_, age)
    assert(age == expectedAge, "Decline must use the character's current age")
    declineChecks = declineChecks + 1
end)

rawset(TIHYD, "tryDeath", function(_, age)
    assert(age == expectedAge, "Mortality must use the character's current age")
    checks = checks + 1
end)

TIHYD.main()
TIHYD.main()
assert(checks == 2, "Mortality must be checked daily, not just on birthdays")
assert(declineChecks == 2, "Decline must be applied daily, not just on birthdays")

local visualUpdates, traitUpdates = 0, 0
expectedAge = 76
rawset(TIHYD, "age", function()
    return 76, true
end)
rawset(TIHYD, "updateVisual", function(_, age)
    assert(age == 76)
    visualUpdates = visualUpdates + 1
end)
rawset(TIHYD, "updateAgingTraits", function(_, age)
    assert(age == 76)
    traitUpdates = traitUpdates + 1
end)
TIHYD.main()
assert(visualUpdates == 1 and traitUpdates == 1, "Birthday must update appearance and traits")

rawset(TIHYD, "age", function()
    return 75, false
end)
player.getModData = function()
    return { TIHYD = { startingAge = 75 } }
end
rawset(TIHYD, "build", function() end)
rawset(TIHYD, "log", function() end)
rawset(TIHYD, "updateVisual", function(_, age)
    assert(age == 75)
end)
rawset(TIHYD, "updateAgingTraits", function(_, age)
    assert(age == 75)
    traitUpdates = traitUpdates + 1
end)
TIHYD.init(0, player)
assert(traitUpdates == 2, "Character load must update traits")

player.isDead = function()
    return true
end

TIHYD.main()
assert(checks == 3, "Dead characters must not receive mortality checks")

getSpecificPlayer = function()
    return nil
end

TIHYD.main()
assert(checks == 3, "Missing players must be skipped")
assert(declineChecks == 3, "Dead and missing players must not receive decline")

local currentAge = 74
local agingPlayer = {
    getHoursSurvived = function()
        return 24 * 365
    end,
    getAge = function()
        return currentAge
    end,
    setAge = function(_, age)
        currentAge = age
    end,
}
TIHYD.daysPerYear = 365
rawset(TIHYD, "getCharacterData", function()
    return { startingAge = 74 }
end)
local age, hasAged = realAge(agingPlayer, false)
assert(age == 75 and not hasAged, "Initialization must return age without reporting a birthday")
age, hasAged = realAge(agingPlayer, true)
assert(age == 75 and not hasAged, "Unchanged age must still be returned")
currentAge = 74
age, hasAged = realAge(agingPlayer, true)
assert(age == 75 and hasAged, "Birthday must return age and report aging")

print("Aging tests passed")
