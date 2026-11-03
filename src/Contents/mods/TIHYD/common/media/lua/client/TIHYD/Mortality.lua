require("TIHYD/Config")

function TIHYD.getDailyDeathRisk(age, healthiness)
    local annualRisk = TIHYD.clamp((1 / (100 * math.exp(age * -0.091))) - healthiness, 0, 100) / 100
    return 1 - (1 - annualRisk) ^ (1 / TIHYD.daysPerYear)
end

function TIHYD.tryDeath(player, age)
    TIHYD.log("Minimum age for death by old age is set to " .. TIHYD.deathAge .. " years.")

    if not TIHYD.isDeathEnabled or age < TIHYD.deathAge then
        return
    end

    local healthiness = 0

    if TIHYD.isTraitsConsidered then
        healthiness = TIHYD.getHealthiness(player)
    end

    local chance = TIHYD.getDailyDeathRisk(age, healthiness) * 100
    local random = ZombRand(0, 1000000) / 10000
    local isDead = random < chance

    TIHYD.log("Player can die at his current age.")
    TIHYD.log("Player has a " .. string.format("%.4f", chance) .. "% chance of dying of old age today!")
    TIHYD.log(
        "Player rolled a "
            .. math.floor(random)
            .. "%, which is "
            .. (isDead and "less, so they died." or "more, so they lived.")
    )

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
    for _, trait in ipairs(very_good_traits) do
        if traits:contains(trait) then
            healthiness = healthiness + 5
        end
    end
    -- Traits that slightly lower the chance of death
    local good_traits = { "Stout", "Fit", "Lucky" }
    for _, trait in ipairs(good_traits) do
        if traits:contains(trait) then
            healthiness = healthiness + 2.5
        end
    end

    ------------------------------------------------
    -- Bad traits
    ------------------------------------------------

    -- Traits that greatly raise the chance of death
    local very_bad_traits = { "Obese", "VeryUnderweight", "Weak", "Unfit", "Smoker" }
    for _, trait in ipairs(very_bad_traits) do
        if traits:contains(trait) then
            healthiness = healthiness - 5
        end
    end
    -- Traits that slightly raise the chance of death
    local bad_traits = { "ProneToIllness", "Feeble", "Unlucky", "OutOfShape", "Underweight", "Overweight" }
    for _, trait in ipairs(bad_traits) do
        if traits:contains(trait) then
            healthiness = healthiness - 2.5
        end
    end

    return healthiness
end
