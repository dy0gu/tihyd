require("TIHYD/Config")

TIHYD = TIHYD or {}

function TIHYD.applyDecline(player, age)
    if age < TIHYD.declineAge then
        return
    end

    local function loseXP(perk, percentage)
        if percentage > 0 then
            local xp = player:getXp()
            local loss = math.max(0, xp:getXP(perk)) * math.min(percentage, 3) / 100
            if loss > 0 then
                xp:AddXP(perk, -loss, true, false)
            end
        end
    end

    loseXP(Perks.Fitness, TIHYD.physicalDecline)
    loseXP(Perks.Strength, TIHYD.physicalDecline)
end
