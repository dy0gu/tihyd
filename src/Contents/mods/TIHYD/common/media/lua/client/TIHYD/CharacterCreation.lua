require("TIHYD/CharacterData")
require("OptionScreens/CharacterCreationMain")
require("ISUI/ISComboBox")
require("ISUI/ISLabel")

local function selectAge(screen, age)
    screen.TIHYDAgeCombo.selected = age - TIHYD.MIN_STARTING_AGE + 1
    TIHYD.pendingStartingAges[MainScreen.instance.desc] = age
    TIHYD.log("Age selected: descriptor=" .. tostring(MainScreen.instance.desc) .. ", age=" .. tostring(age))
end

local function syncDescriptor(screen)
    local descriptor = MainScreen.instance.desc
    if screen.TIHYDDescriptor ~= descriptor then
        screen.TIHYDDescriptor = descriptor
        selectAge(screen, TIHYD.randomStartingAge())
    end
end

local createNameAndGender = CharacterCreationMain.createNameAndGender
---@diagnostic disable-next-line: duplicate-set-field
function CharacterCreationMain:createNameAndGender(...)
    local result = createNameAndGender(self, ...)
    if self.TIHYDAgeCombo then
        return result
    end

    local panel = self.characterPanel
    local font = UIFont.Small
    ---@cast font UIFont
    local height = getTextManager():getFontHeight(font) + 6
    local label = ISLabel:new(0, self.yOffset, height, getText("UI_TIHYD_StartingAge", nil), 1, 1, 1, 1, font, false)
    label:initialise()
    panel:addChild(label)
    table.insert(panel.repos2Table, label)
    panel.columnWidth = math.max(panel.columnWidth, label:getWidth())
    self.columnWidth = math.max(self.columnWidth, panel.columnWidth)

    local combo = ISComboBox:new(0, self.yOffset, 100, height, self, function(screen, control)
        syncDescriptor(screen)
        selectAge(screen, control.selected + TIHYD.MIN_STARTING_AGE - 1)
    end)
    combo:initialise()
    local tooltip = getText("UI_TIHYD_StartingAgeTooltip", nil)
    for age = TIHYD.MIN_STARTING_AGE, TIHYD.MAX_STARTING_AGE do
        combo:addOptionWithData(tostring(age), nil, tooltip)
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
---@diagnostic disable-next-line: duplicate-set-field
function CharacterCreationMain:setVisible(visible, ...)
    local result = setVisible(self, visible, ...)
    if visible and self.TIHYDAgeCombo and MainScreen.instance.desc then
        syncDescriptor(self)
    end
    return result
end

local onRandomCharacter = CharacterCreationMain.onRandomCharacter
---@diagnostic disable-next-line: duplicate-set-field
function CharacterCreationMain:onRandomCharacter(...)
    local result = onRandomCharacter(self, ...)
    if self.TIHYDAgeCombo then
        self.TIHYDDescriptor = MainScreen.instance.desc
        selectAge(self, TIHYD.randomStartingAge())
    end
    return result
end

local loadJoypadButtons = CharacterCreationMainCharacterPanel.loadJoypadButtons
---@diagnostic disable-next-line: duplicate-set-field
function CharacterCreationMainCharacterPanel:loadJoypadButtons(...)
    local result = loadJoypadButtons(self, ...)
    local screen = self.parent
    ---@cast screen CharacterCreationMain
    local combo = screen.TIHYDAgeCombo
    if combo then
        -- Append instead of rebuilding vanilla or other mods' navigation rows.
        -- Joypad rows also support combo boxes, unlike the button-only typings.
        ---@diagnostic disable-next-line: param-type-mismatch
        self:insertNewLineOfButtons(combo)
    end
    return result
end
