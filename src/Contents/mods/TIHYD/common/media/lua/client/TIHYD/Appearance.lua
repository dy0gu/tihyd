require("TIHYD/Config")

function TIHYD.updateVisual(player, age)
    TIHYD.log("Grey hair is set to appear when player is " .. TIHYD.grayHairAge .. " years old.")

    if TIHYD.isGrayHairEnabled and age >= TIHYD.grayHairAge then
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
