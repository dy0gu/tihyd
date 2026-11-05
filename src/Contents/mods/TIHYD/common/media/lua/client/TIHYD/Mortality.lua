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

    -- Each skill contributes -2.5 to +2.5 percentage points of annual risk.
    healthiness = healthiness + (player:getPerkLevel(Perks.Fitness) - 5) * 0.5
    healthiness = healthiness + (player:getPerkLevel(Perks.Strength) - 5) * 0.5

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
        player:Say(getText("UI_TIHYD_OldAgeDeath"))
        player:Kill(player)
    end
end

function TIHYD.getHealthiness(player)
    local traits = player:getCharacterTraits()
    local healthiness = 0

    ------------------------------------------------
    -- Good traits
    ------------------------------------------------

    -- Traits that greatly lower the chance of death
    local very_good_traits = { CharacterTrait.STRONG, CharacterTrait.ATHLETIC, CharacterTrait.RESILIENT }
    for _, trait in ipairs(very_good_traits) do
        if traits:get(trait) then
            healthiness = healthiness + 5
        end
    end
    -- Traits that slightly lower the chance of death
    local good_traits = { CharacterTrait.STOUT, CharacterTrait.FIT }
    for _, trait in ipairs(good_traits) do
        if traits:get(trait) then
            healthiness = healthiness + 2.5
        end
    end

    ------------------------------------------------
    -- Bad traits
    ------------------------------------------------

    -- Traits that greatly raise the chance of death
    local very_bad_traits = {
        CharacterTrait.OBESE,
        CharacterTrait.VERY_UNDERWEIGHT,
        CharacterTrait.WEAK,
        CharacterTrait.UNFIT,
        CharacterTrait.SMOKER,
    }
    for _, trait in ipairs(very_bad_traits) do
        if traits:get(trait) then
            healthiness = healthiness - 5
        end
    end
    -- Traits that slightly raise the chance of death
    local bad_traits = {
        CharacterTrait.PRONE_TO_ILLNESS,
        CharacterTrait.FEEBLE,
        CharacterTrait.OUT_OF_SHAPE,
        CharacterTrait.UNDERWEIGHT,
        CharacterTrait.OVERWEIGHT,
    }
    for _, trait in ipairs(bad_traits) do
        if traits:get(trait) then
            healthiness = healthiness - 2.5
        end
    end

    return healthiness
end
