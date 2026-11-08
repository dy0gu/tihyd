TIHYD = TIHYD or {}
TIHYD.config = TIHYD.config or {}

function TIHYD.log(message)
    DebugLog.log(DebugType.Mod, "TIHYD: " .. message)
end

function TIHYD.clamp(value, min, max)
    if min and value < min then
        return min
    elseif max and value > max then
        return max
    else
        return value
    end
end

function TIHYD.getSandboxValue(option, vartype)
    ---@diagnostic disable-next-line
    local value = getSandboxOptions():getOptionByName(option):getValue()
    ---@diagnostic disable-next-line
    local default = getSandboxOptions():getOptionByName(option):getDefaultValue()

    if type(value) ~= vartype then
        return default
    else
        return value
    end
end

function TIHYD.loadConfig()
    TIHYD.config.daysPerYear = TIHYD.getSandboxValue("TIHYD.daysPerYear", "number")
    TIHYD.config.declineAge = TIHYD.getSandboxValue("TIHYD.declineAge", "number")
    TIHYD.config.physicalDeclinePercentPerDay = TIHYD.getSandboxValue("TIHYD.physicalDecline", "number")
    TIHYD.config.isDeathEnabled = TIHYD.getSandboxValue("TIHYD.isDeathEnabled", "boolean")
    TIHYD.config.isTraitsConsidered = TIHYD.getSandboxValue("TIHYD.isTraitsConsidered", "boolean")
    TIHYD.config.deathAge = TIHYD.getSandboxValue("TIHYD.deathAge", "number")
    TIHYD.config.isGrayHairEnabled = TIHYD.getSandboxValue("TIHYD.isGrayHairEnabled", "boolean")
    TIHYD.config.grayHairAge = TIHYD.getSandboxValue("TIHYD.grayHairAge", "number")
    TIHYD.config.isShortSightedEnabled = TIHYD.getSandboxValue("TIHYD.isShortSightedEnabled", "boolean")
    TIHYD.config.shortSightedAge = TIHYD.getSandboxValue("TIHYD.shortSightedAge", "number")
    TIHYD.config.isHardOfHearingEnabled = TIHYD.getSandboxValue("TIHYD.isHardOfHearingEnabled", "boolean")
    TIHYD.config.hardOfHearingAge = TIHYD.getSandboxValue("TIHYD.hardOfHearingAge", "number")
end
