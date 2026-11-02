require "TIHYD"
require "OptionScreens/CharacterCreationMain"
require "ISUI/ISComboBox"
require "ISUI/ISLabel"

local function selectAge(screen, age)
    screen.TIHYDAgeCombo.selected = age - 18 + 1
    MainScreen.instance.desc:getMeta().TIHYDStartingAge = age
end

local function syncDescriptor(screen)
    local descriptor = MainScreen.instance.desc
    if screen.TIHYDDescriptor ~= descriptor then
        screen.TIHYDDescriptor = descriptor
        selectAge(screen, TIHYD.randomStartingAge())
    end
end

local createNameAndGender = CharacterCreationMain.createNameAndGender
function CharacterCreationMain:createNameAndGender(...)
    local result = createNameAndGender(self, ...)
    if self.TIHYDAgeCombo then return result end

    local panel = self.characterPanel
    local height = getTextManager():getFontHeight(UIFont.Small) + 6
    local label = ISLabel:new(0, self.yOffset, height, getText("UI_TIHYD_StartingAge"),
        1, 1, 1, 1, UIFont.Small, false)
    label:initialise()
    panel:addChild(label)
    table.insert(panel.repos2Table, label)
    panel.columnWidth = math.max(panel.columnWidth, label:getWidth())
    self.columnWidth = math.max(self.columnWidth, panel.columnWidth)

    local combo = ISComboBox:new(0, self.yOffset, 100, height, self, function(screen, control)
        syncDescriptor(screen)
        MainScreen.instance.desc:getMeta().TIHYDStartingAge = control.selected + 17
    end)
    combo:initialise()
    combo.tooltip = getText("UI_TIHYD_StartingAgeTooltip")
    for age = 18, 90 do
        combo:addOption(tostring(age))
    end
    panel:addChild(combo)
    table.insert(panel.repos3Table, combo)
    table.insert(panel.comboResizeTable, combo)
    self.TIHYDAgeCombo = combo
    syncDescriptor(self)
    self.yOffset = combo:getBottom() + 10
    return result
end

local setVisible = CharacterCreationMain.setVisible
function CharacterCreationMain:setVisible(visible, ...)
    local result = setVisible(self, visible, ...)
    if visible and self.TIHYDAgeCombo and MainScreen.instance.desc then
        syncDescriptor(self)
    end
    return result
end

local onRandomCharacter = CharacterCreationMain.onRandomCharacter
function CharacterCreationMain:onRandomCharacter(...)
    local result = onRandomCharacter(self, ...)
    if self.TIHYDAgeCombo then
        self.TIHYDDescriptor = MainScreen.instance.desc
        selectAge(self, TIHYD.randomStartingAge())
    end
    return result
end

local loadJoypadButtons = CharacterCreationMainCharacterPanel.loadJoypadButtons
function CharacterCreationMainCharacterPanel:loadJoypadButtons(...)
    local result = loadJoypadButtons(self, ...)
    local combo = self.parent.TIHYDAgeCombo
    if combo then
        -- Append instead of rebuilding vanilla or other mods' navigation rows.
        self:insertNewLineOfButtons(combo)
    end
    return result
end
