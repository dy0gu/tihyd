TIHYD = TIHYD or {}

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

function TIHYD.build()
    TIHYD.daysPerYear = TIHYD.getSandboxValue("TIHYD.daysPerYear", "number")
    TIHYD.isDeathEnabled = TIHYD.getSandboxValue("TIHYD.isDeathEnabled", "boolean")
    TIHYD.isTraitsConsidered = TIHYD.getSandboxValue("TIHYD.isTraitsConsidered", "boolean")
    TIHYD.deathAge = TIHYD.getSandboxValue("TIHYD.deathAge", "number")
    TIHYD.isGrayHairEnabled = TIHYD.getSandboxValue("TIHYD.isGrayHairEnabled", "boolean")
    TIHYD.grayHairAge = TIHYD.getSandboxValue("TIHYD.grayHairAge", "number")
    TIHYD.isShortSightedEnabled = TIHYD.getSandboxValue("TIHYD.isShortSightedEnabled", "boolean")
    TIHYD.shortSightedAge = TIHYD.getSandboxValue("TIHYD.shortSightedAge", "number")
    TIHYD.isHardOfHearingEnabled = TIHYD.getSandboxValue("TIHYD.isHardOfHearingEnabled", "boolean")
    TIHYD.hardOfHearingAge = TIHYD.getSandboxValue("TIHYD.hardOfHearingAge", "number")
end
