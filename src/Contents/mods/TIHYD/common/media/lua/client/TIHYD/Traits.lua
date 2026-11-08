require("TIHYD/Config")

TIHYD = TIHYD or {}

function TIHYD.updateAgingTraits(player, age)
    local traits = player:getCharacterTraits()

    if
        TIHYD.config.isShortSightedEnabled
        and age >= TIHYD.config.shortSightedAge
        and not traits:get(CharacterTrait.SHORT_SIGHTED)
        and not traits:get(CharacterTrait.EAGLE_EYED)
    then
        traits:add(CharacterTrait.SHORT_SIGHTED)
        TIHYD.log("Player developed short-sightedness.")
    end

    if
        TIHYD.config.isHardOfHearingEnabled
        and age >= TIHYD.config.hardOfHearingAge
        and not traits:get(CharacterTrait.HARD_OF_HEARING)
        and not traits:get(CharacterTrait.KEEN_HEARING)
        and not traits:get(CharacterTrait.DEAF)
    then
        traits:add(CharacterTrait.HARD_OF_HEARING)
        TIHYD.log("Player developed hearing loss.")
    end
end
