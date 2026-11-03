require("TIHYD/Config")

function TIHYD.tryDeath(player, age)
    TIHYD.log("Minimum age for death by old age is set to " .. TIHYD.deathAge .. " years.")

    if not TIHYD.isDeathEnabled or age < TIHYD.deathAge then
        return
    end

    local healthiness = 0

    if TIHYD.IsTraitsConsidered then
        healthiness = TIHYD.getHealthiness(player)
    end

    local chance = TIHYD.clamp(((1 / (100 * math.exp(age * -0.091))) - healthiness), 0, 100)
    local random = ZombRand(0, 10001) / 100
    local isDead = random < chance

    TIHYD.log("Player can die at his current age.")
    TIHYD.log("Player has a " .. math.floor(chance) .. "% chance of dying of old age today!")
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
