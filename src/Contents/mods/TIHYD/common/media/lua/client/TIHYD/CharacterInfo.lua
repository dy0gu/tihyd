require("XpSystem/ISUI/ISCharacterScreen")

local render = ISCharacterScreen.render
---@diagnostic disable-next-line: duplicate-set-field
function ISCharacterScreen:render(...)
    local result = render(self, ...)
    local mods = getActivatedMods()
    if mods:contains("ReorganizedInfoScreen") or mods:contains("twistbettercharacterinfo") then
        return result
    end

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
    self:setWidthAndParentWidth(math.max(self:getWidth(), x + 20 + textManager:MeasureStringX(font, value)))
    self:setHeightAndParentHeight(y + rowHeight + 10)
    self:drawTextRight(label, x, y, 1, 1, 1, 1, font)
    self:drawText(value, x + 10, y, 1, 1, 1, 0.5, font)
    return result
end
