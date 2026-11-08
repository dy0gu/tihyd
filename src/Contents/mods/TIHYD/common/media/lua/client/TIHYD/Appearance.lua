require("TIHYD/Config")

function TIHYD.updateVisual(player, age)
    TIHYD.log("Grey hair is set to appear when player is " .. TIHYD.config.grayHairAge .. " years old.")

    if TIHYD.config.isGrayHairEnabled and age >= TIHYD.config.grayHairAge then
        local modData = player:getModData()
        modData.TIHYD = modData.TIHYD or {}
        if not modData.TIHYD.grayHairApplied then
            TIHYD.setHairColor(player, ImmutableColor.gray)
            modData.TIHYD.grayHairApplied = true
            TIHYD.log("Changed player hair to gray!")
        end
    end
end

function TIHYD.setHairColor(player, color)
    local visual = player:getHumanVisual()
    visual:setHairColor(color)
    visual:setBeardColor(color)
    player:resetModel()
end
