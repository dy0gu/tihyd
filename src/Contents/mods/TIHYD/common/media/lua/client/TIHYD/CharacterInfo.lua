require("XpSystem/ISUI/ISCharacterScreen")

local redundantInfoModIds = {
    "ReorganizedInfoScreen",
    "twistbettercharacterinfo",
    "NeatUI_CharacterInfo",
}

local render = ISCharacterScreen.render
---@diagnostic disable-next-line: duplicate-set-field
function ISCharacterScreen:render(...)
    local mods = getActivatedMods()

    -- COMPATIBILITY PATCH: Spongie's Character Customisation
    -- Spongie moves the recipes button after vanilla positions the statistics.
    -- Report its expected bottom during layout so vanilla reserves enough space.
    local button = self.literatureButton
    local originalGetBottom = button and rawget(button, "getBottom")
    if mods:contains("SPNCC") and button then
        local getBottom = button.getBottom
        button.getBottom = function(literatureButton)
            local font = UIFont.Small
            ---@cast font UIFont
            local fontHeight = getTextManager():getFontHeight(font)
            local buttonHeight = fontHeight + 6
            local lastButton = self.char:isFemale() and self.hairButton or self.beardButton
            local recipesY = lastButton:getY() + (buttonHeight - fontHeight) / 2 + 3 * (buttonHeight + 10)
            return math.max(getBottom(literatureButton), recipesY + literatureButton:getHeight())
        end
    end

    -- Let the existing renderer lay out the screen, then restore the button method.
    local result = render(self, ...)
    if mods:contains("SPNCC") and button then
        button.getBottom = originalGetBottom
    end
    for _, id in ipairs(redundantInfoModIds) do
        if mods:contains(id) then
            return result
        end
    end

    -- Align the age row with the vanilla statistics and place it below them.
    local textManager = getTextManager()
    local font = UIFont.Small
    ---@cast font UIFont
    local label = getText("UI_TIHYD_StartingAge")
    local value = tostring(self.char:getAge())
    local labelWidth = textManager:MeasureStringX(font, label)
    for _, key in ipairs({ "IGUI_char_Favourite_Weapon", "IGUI_char_Zombies_Killed", "IGUI_char_Survived_For" }) do
        labelWidth = math.max(labelWidth, textManager:MeasureStringX(font, getText(key)))
    end
    local x = 20 + labelWidth
    local y = self:getHeight() - 10
    local rowHeight = textManager:getFontHeight(font) + 6

    -- Reserve space and draw the age row.
    self:setHeightAndParentHeight(y + rowHeight + 10)
    self:drawTextRight(label, x, y, 1, 1, 1, 1, font)
    self:drawText(value, x + 10, y, 1, 1, 1, 0.5, font)
    return result
end
