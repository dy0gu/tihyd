require("TIHYD/Config")

function TIHYD.updateVisual(player, age)
    TIHYD.log("Grey hair is set to appear when player is " .. TIHYD.grayHairAge .. " years old.")
    TIHYD.log("White hair is set to appear when player is " .. TIHYD.whiteHairAge .. " years old.")

    local gray = TIHYD.isGrayHairEnabled and age >= TIHYD.grayHairAge
    local white = TIHYD.isWhiteHairEnabled and age >= TIHYD.whiteHairAge

    -- The color with highest age requirement takes priority if both requirements are met.
    if white and gray then
        if TIHYD.whiteHairAge > TIHYD.grayHairAge then
            gray = false
        else
            white = false
        end
    end

    if white then
        TIHYD.setHairColor(player, ImmutableColor.white)
        TIHYD.log("Changed player hair to white!")
    elseif gray then
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
