require("TIHYD/Config")

TIHYD.pendingStartingAges = TIHYD.pendingStartingAges or setmetatable({}, { __mode = "k" })

TIHYD.MIN_STARTING_AGE = 18
TIHYD.MAX_STARTING_AGE = 75

function TIHYD.randomStartingAge()
    return ZombRand(TIHYD.MIN_STARTING_AGE, TIHYD.MAX_STARTING_AGE + 1)
end

function TIHYD.getCharacterData(player)
    local modData = player:getModData()
    modData.TIHYD = modData.TIHYD or {}
    local data = modData.TIHYD
    if data.startingAge == nil then
        local hours = player:getHoursSurvived()
        local descriptor = player:getDescriptor()
        local selectedAge = descriptor and TIHYD.pendingStartingAges[descriptor]
        if selectedAge ~= nil then
            data.startingAge = selectedAge
        elseif hours == 0 then
            data.startingAge = TIHYD.randomStartingAge()
        else
            -- Preserve the current age when enabling the mod on an existing character.
            data.startingAge = player:getAge() - math.floor(hours / 24 / TIHYD.config.daysPerYear)
        end
        if descriptor then
            TIHYD.pendingStartingAges[descriptor] = nil
        end
    end
    return data
end
