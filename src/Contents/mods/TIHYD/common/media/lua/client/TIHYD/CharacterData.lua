require("TIHYD/Config")

-- Pending selections belong to descriptors, not a single shared local-player slot.
TIHYD.startingAges = TIHYD.startingAges or setmetatable({}, { __mode = "k" })

function TIHYD.randomStartingAge()
    return ZombRand(18, 91)
end

function TIHYD.getCharacterData(player)
    local modData = player:getModData()
    modData.TIHYD = modData.TIHYD or {}
    local data = modData.TIHYD
    if data.startingAge == nil then
        local descriptor = player:getDescriptor()
        local selectedAge = descriptor and TIHYD.startingAges[descriptor]
        TIHYD.log(
            "Age handoff: descriptor="
                .. tostring(descriptor)
                .. ", selectedAge="
                .. tostring(selectedAge)
                .. ", hoursSurvived="
                .. tostring(player:getHoursSurvived())
        )
        if player:getHoursSurvived() == 0 then
            data.startingAge = selectedAge or TIHYD.randomStartingAge()
            if selectedAge == nil then
                TIHYD.log("No pending selection found; using random starting age=" .. tostring(data.startingAge))
            end
        else
            -- Preserve current age when migrating a character without per-character data.
            data.startingAge = player:getAge() - math.floor(player:getHoursSurvived() / 24 / TIHYD.daysPerYear)
        end
        if descriptor then
            TIHYD.startingAges[descriptor] = nil
        end
    end
    return data
end
