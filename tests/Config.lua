package.path = "src/Contents/mods/TIHYD/common/media/lua/client/?.lua;" .. package.path

require("TIHYD/Config")

local values = {
    daysPerYear = 180,
    declineAge = 61,
    physicalDecline = 0.5,
    isDeathEnabled = false,
    isTraitsConsidered = true,
    deathAge = 80,
    isGrayHairEnabled = true,
    grayHairAge = 50,
    isShortSightedEnabled = false,
    shortSightedAge = 55,
    isHardOfHearingEnabled = true,
    hardOfHearingAge = 65,
}

getSandboxOptions = function()
    return {
        getOptionByName = function(_, name)
            local key = name:match("^TIHYD%.(.+)$")
            assert(key and values[key] ~= nil, "Unexpected sandbox option: " .. name)
            return {
                getValue = function()
                    return values[key]
                end,
                getDefaultValue = function()
                    return 365
                end,
            }
        end,
    }
end

local config = TIHYD.config
TIHYD.loadConfig()
for key, value in pairs(values) do
    local configKey = key == "physicalDecline" and "physicalDeclinePercentPerDay" or key
    assert(config[configKey] == value, "Incorrect configuration value: " .. key)
end
values.daysPerYear = "invalid"
TIHYD.loadConfig()
assert(TIHYD.config == config, "Rebuilding must retain the configuration table")
assert(config.daysPerYear == 365, "Invalid values must fall back to defaults")

print("Config tests passed")
