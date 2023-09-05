TIHYD = TIHYD or {}

TIHYD.NAME = "TIHYD"
TIHYD.VERSION = "1.0.0"

------------------------------------------------
-- Utilities
------------------------------------------------

function TIHYD.log(string)
    DebugLog.log(DebugType.Mod, TIHYD.NAME .. ": " .. string)
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

------------------------------------------------
-- Mod
------------------------------------------------

function TIHYD.build()
    TIHYD.startingAge = TIHYD.getSandboxValue("TIHYD.startingAge", "number")
    TIHYD.isDeathEnabled = TIHYD.getSandboxValue("TIHYD.isDeathEnabled", "boolean")
    TIHYD.deathAge = TIHYD.getSandboxValue("TIHYD.deathAge", "number")
    TIHYD.isGrayHairEnabled = TIHYD.getSandboxValue("TIHYD.isGrayHairEnabled", "boolean")
    TIHYD.grayHairAge = TIHYD.getSandboxValue("TIHYD.grayHairAge", "number")
    TIHYD.isWhiteHairEnabled = TIHYD.getSandboxValue("TIHYD.isWhiteHairEnabled", "boolean")
    TIHYD.whiteHairAge = TIHYD.getSandboxValue("TIHYD.whiteHairAge", "number")
end

function TIHYD.init()
    local player = getPlayer()

    TIHYD.age(player, false)
end

function TIHYD.main()
    local player = getPlayer()

    local age = TIHYD.age(player, true)
    if not age then return end

    TIHYD.updateVisual(player, age)
    TIHYD.tryDeath(player, age)
end

function TIHYD.age(player, init)
    -- ONLY FOR DEBUG
    -- player:setHoursSurvived(player:getHoursSurvived() + (24*364))
    -- ONLY FOR DEBUG

    local lifespan = player:getHoursSurvived()
    local previousAge = player:getAge()

    local newAge = TIHYD.startingAge + math.floor(lifespan / 24 / 365)
    player:setAge(newAge)

    local hasAged = newAge > previousAge

    if not init then
        TIHYD.log("Initializing player age!")
        TIHYD.log("Player age (" .. newAge .. ") loaded.")
        -- Ignore first iteration because setting the age would count as aging
        return false
    end

    TIHYD.log("Updating player age!")
    TIHYD.log("Player has survived for " .. math.floor(lifespan) .. " hours, making him " .. newAge .. " years old.")

    if not hasAged then
        return false
    else
        TIHYD.log("Player aged up since the last iteration! Hair color change and death will be checked...")
        -- Only return age if player aged this iteration, else return false
        return newAge
    end
end

function TIHYD.updateVisual(player, age)
    TIHYD.log("Grey hair is set to appear when player is " .. TIHYD.grayHairAge .. " years old.")
    TIHYD.log("White hair is set to appear when player is " .. TIHYD.whiteHairAge .. " years old.")

    local gray = TIHYD.isGrayHairEnabled and age >= TIHYD.grayHairAge
    local white = TIHYD.isWhiteHairEnabled and age >= TIHYD.whiteHairAge

    -- The color with highest age requirement takes priority if both requirements are met
    if white and gray and TIHYD.whiteHairAge > TIHYD.grayHairAge then
        gray = false
    else
        white = false
    end

    if white then
        TIHYD.setHairColor(player, ImmutableColor.white)
        TIHYD.log("Changed player hair to white!")
    elseif gray then
        TIHYD.setHairColor(player, ImmutableColor.gray)
        TIHYD.log("Changed player hair to gray!")
    end
end

function TIHYD.setHairColor(player, color)
    local visual = player:getHumanVisual()
    visual:setHairColor(color)
    visual:setBeardColor(color)
    player:resetModel()
end

function TIHYD.tryDeath(player, age)
    TIHYD.log("Minimum age for death by old age is set to " .. TIHYD.deathAge .. " years.")

    if not TIHYD.isDeathEnabled or age < TIHYD.deathAge then return end

    local healthiness = 0

    if (TIHYD.IsTraitsConsidered) then
        healthiness = TIHYD.getHealthiness(player)
    end

    local chance = TIHYD.clamp(((1 / (100 * math.exp(age * -0.091))) - healthiness), 0, 100)
    local random = ZombRand(0, 10001) / 100
    local isDead = random < chance

    TIHYD.log("Player can die at his current age.")
    TIHYD.log("Player has a " .. math.floor(chance) .. "% chance of dying of old age today!")
    TIHYD.log("Player rolled a " ..
        math.floor(random) .. "%, which is " .. (isDead and "less, so they died." or "more, so they lived."))

    if isDead then
        player:Kill(player)
    end
end

function TIHYD.getHealthiness(player)
    local traits = player:getTraits()
    local healthiness = 0

    ------------------------------------------------
    -- Good traits
    ------------------------------------------------

    -- Traits that greatly lower the chance of death
    local very_good_traits = { "Strong", "Athletic", "Resilient" }
    for trait in very_good_traits do
        if traits:contains(trait) then
            healthiness = healthiness + 5
        end
    end
    -- Traits that slightly lower the chance of death
    local good_traits = { "Stout", "Fit", "Lucky" }
    for trait in good_traits do
        if traits:contains(trait) then
            healthiness = healthiness + 2.5
        end
    end

    ------------------------------------------------
    -- Bad traits
    ------------------------------------------------

    -- Traits that greatly raise the chance of death
    local very_bad_traits = { "Obese", "VeryUnderweight", "Weak", "Unfit", "Smoker" }
    for trait in very_bad_traits do
        if traits:contains(trait) then
            healthiness = healthiness - 5
        end
    end
    -- Traits that slightly raise the chance of death
    local bad_traits = { "ProneToIllness", "Feeble", "Unlucky", "OutOfShape", "Underweight", "Overweight" }
    for trait in bad_traits do
        if traits:contains(trait) then
            healthiness = healthiness - 2.5
        end
    end

    return healthiness
end

Events.OnInitGlobalModData.Add(TIHYD.build)
Events.OnGameStart.Add(TIHYD.init)
Events.EveryDays.Add(TIHYD.main)
