package.path = "src/Contents/mods/TIHYD/common/media/lua/client/?.lua;" .. package.path

require("TIHYD/Decline")

Perks = { Fitness = "fitness", Strength = "strength" }
local values = { fitness = 100, strength = 200 }
local calls = 0
local xp = {
    getXP = function(_, perk)
        return values[perk]
    end,
    AddXP = function(_, perk, amount, noMultiplier, haloText)
        assert(noMultiplier and haloText == false, "Decline must bypass XP multipliers and halo text")
        values[perk] = values[perk] + amount
        calls = calls + 1
    end,
}
local player = {
    getXp = function()
        return xp
    end,
}

TIHYD.declineAge = 60
TIHYD.physicalDecline = 1.2
TIHYD.applyDecline(player, 59)
assert(calls == 0, "Decline must not apply below the starting age")
TIHYD.applyDecline(player, 60)
assert(
    math.abs(values.fitness - 98.8) < 0.000001 and math.abs(values.strength - 197.6) < 0.000001,
    "Decline must remove the configured percentage of each total"
)
values.strength = 0
TIHYD.physicalDecline = 0
TIHYD.applyDecline(player, 80)
assert(calls == 2, "Disabled rates and empty XP must not apply loss")
TIHYD.physicalDecline = 1.2
TIHYD.applyDecline(player, 80)
assert(
    math.abs(values.fitness - 97.6144) < 0.000001 and values.strength == 0,
    "Daily decline must use the updated XP total"
)
TIHYD.physicalDecline = 0.5
TIHYD.applyDecline(player, 80)
assert(math.abs(values.fitness - 97.126328) < 0.000001, "Fractional percentages must be supported")
TIHYD.physicalDecline = 150
TIHYD.applyDecline(player, 80)
assert(math.abs(values.fitness - 94.21253816) < 0.000001, "Decline must cap out-of-range rates at 3 percent")

print("Decline tests passed")
