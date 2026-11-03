require("TIHYD/CharacterData")
require("TIHYD/Appearance")
require("TIHYD/Mortality")

function TIHYD.init(playerNum, player)
    if not player or player:isDead() then
        return
    end
    TIHYD.build()
    TIHYD.age(player, false)
    TIHYD.updateVisual(player, player:getAge())
    TIHYD.log(
        "OnCreatePlayer: player="
            .. tostring(playerNum)
            .. ", savedStartingAge="
            .. tostring(player:getModData().TIHYD.startingAge)
            .. ", currentAge="
            .. tostring(player:getAge())
    )
end

function TIHYD.main()
    for playerNum = 0, getNumActivePlayers() - 1 do
        local player = getSpecificPlayer(playerNum)
        if player and not player:isDead() then
            local age = TIHYD.age(player, true)
            if age then
                TIHYD.updateVisual(player, age)
                TIHYD.tryDeath(player, age)
            end
        end
    end
end

function TIHYD.age(player, init)
    -- ONLY FOR DEBUG
    -- player:setHoursSurvived(player:getHoursSurvived() + (24*364))
    -- ONLY FOR DEBUG

    local lifespan = player:getHoursSurvived()
    local previousAge = player:getAge()

    local newAge = TIHYD.getCharacterData(player).startingAge + math.floor(lifespan / 24 / TIHYD.daysPerYear)
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
