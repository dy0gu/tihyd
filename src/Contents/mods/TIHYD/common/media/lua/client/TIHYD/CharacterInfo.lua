require("XpSystem/ISUI/ISCharacterScreen")

local redundantInfoModIds = {
    "ReorganizedInfoScreen",
    "twistbettercharacterinfo",
    "NeatUI_CharacterInfo",
}


---@class TIHYDLiteratureButton : ISButton
---@field tihydMinimumY number
---@field tihydOriginalPrerender fun(self: ISButton, ...: any)?

local render = ISCharacterScreen.render
---@diagnostic disable-next-line: duplicate-set-field
function ISCharacterScreen:render(...)
    -- Let the existing renderer lay out the screen with other mods that already show age there.
    local result = render(self, ...)
    local mods = getActivatedMods()
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


    -- COMPATIBILITY PATCH: Spongie's Character Customisation
    -- SPNCC moves the recipes button after vanilla lays out the statistics.
    -- Reposition it at draw time so this works regardless of render-hook order.
    local height = y + rowHeight + 10
    local button = self.literatureButton
    if mods:contains("SPNCC") and button then
        ---@cast button TIHYDLiteratureButton
        button.tihydMinimumY = height
        if not button.tihydOriginalPrerender then
            button.tihydOriginalPrerender = button.prerender
            button.prerender = function(literatureButton, ...)
                ---@cast literatureButton TIHYDLiteratureButton
                literatureButton:setY(math.max(literatureButton:getY(), literatureButton.tihydMinimumY))
                local bottom = literatureButton:getY() + literatureButton:getHeight() + 10
                if bottom > self:getHeight() then
                    self:setHeightAndParentHeight(bottom)
                end
                return literatureButton.tihydOriginalPrerender(literatureButton, ...)
            end
        end
        height = height + button:getHeight() + 10
    end

    -- Reserve space and draw the age row.
    self:setHeightAndParentHeight(height)
    self:drawTextRight(label, x, y, 1, 1, 1, 1, font)
    self:drawText(value, x + 10, y, 1, 1, 1, 0.5, font)
    return result
end
