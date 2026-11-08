require("TIHYD/CharacterData")
require("TIHYD/Appearance")
require("TIHYD/Traits")
require("TIHYD/Decline")
require("TIHYD/Mortality")

function TIHYD.updatePlayerAge(player)
    local data = TIHYD.getCharacterData(player)
    local previousAge = player:getAge()
    local age = data.startingAge + math.floor(player:getHoursSurvived() / 24 / TIHYD.config.daysPerYear)
    player:setAge(age)
    return age, age > previousAge
end

function TIHYD.processAgeTransition(player, age)
    TIHYD.updateVisual(player, age)
    TIHYD.updateAgingTraits(player, age)
end

function TIHYD.initializePlayer(playerNum, player)
    if not player or player:isDead() then
        return
    end
    local age = TIHYD.updatePlayerAge(player)
    TIHYD.processAgeTransition(player, age)
    TIHYD.log("Initialized player " .. tostring(playerNum) .. " at age " .. tostring(age))
end

function TIHYD.processDailyAging(player)
    local age, ageIncreased = TIHYD.updatePlayerAge(player)
    if ageIncreased then
        TIHYD.processAgeTransition(player, age)
    end
    TIHYD.applyDecline(player, age)
    TIHYD.tryDeath(player, age)
end

function TIHYD.processAllPlayersDaily()
    for playerNum = 0, getNumActivePlayers() - 1 do
        local player = getSpecificPlayer(playerNum)
        if player and not player:isDead() then
            TIHYD.processDailyAging(player)
        end
    end
end
