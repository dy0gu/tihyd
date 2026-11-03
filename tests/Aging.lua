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

TIHYD.age = function()
    return false
end

TIHYD.updateVisual = function()
    error("Appearance must not update between birthdays")
end

local checks = 0

TIHYD.tryDeath = function(_, age)
    assert(age == 75, "Mortality must use the character's current age")
    checks = checks + 1
end

TIHYD.main()
TIHYD.main()
assert(checks == 2, "Mortality must be checked daily, not just on birthdays")

player.isDead = function()
    return true
end

TIHYD.main()
assert(checks == 2, "Dead characters must not receive mortality checks")

getSpecificPlayer = function()
    return nil
end

TIHYD.main()
assert(checks == 2, "Missing players must be skipped")

print("Aging tests passed")
