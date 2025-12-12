-- LUNA GUI LIBRARY v2.0 - COMPLETE VERSION
-- Part 1/3: Core Functions, Window Creation, Toggle Logo
-- Author: Luna Dev Team

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Library = {}
Library.__index = Library

-- Default Icons
local DefaultIcons = {
    Logo = "rbxassetid://107371206137546",
    Home = "rbxassetid://10723407389",
    Settings = "rbxassetid://10734950309",
    Shop = "rbxassetid://10734949856",
    Folder = "rbxassetid://10723407389"
}

-- ============================================
-- UTILITY FUNCTIONS
-- ============================================

local function MakeDraggable(frame)
    local dragging = false
    local dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

local function Tween(object, properties, duration)
    duration = duration or 0.2
    TweenService:Create(object, TweenInfo.new(duration, Enum.EasingStyle.Quad), properties):Play()
end

-- ============================================
-- MAIN LIBRARY CONSTRUCTOR
-- ============================================

function Library.new(options)
    local self = setmetatable({}, Library)
    
    options = options or {}
    self.Title = options.title or "Luna Hub"
    self.Logo = options.logo or DefaultIcons.Logo
    self.MainColor = options.main_color or Color3.fromRGB(0, 150, 255)
    self.Size = options.size or Vector2.new(600, 400)
    self.ToggleKey = options.toggle_key or Enum.KeyCode.RightShift
    
    self.Tabs = {}
    self.CurrentTab = nil
    
    self:CreateGUI()
    self:CreateToggleLogo()
    
    return self
end

-- ============================================
-- TOGGLE LOGO CREATION
-- ============================================

function Library:CreateToggleLogo()
    -- Floating Logo Button (appears when GUI is hidden)
    self.ToggleLogo = Instance.new("ImageButton")
    self.ToggleLogo.Name = "ToggleLogo"
    self.ToggleLogo.Size = UDim2.new(0, 60, 0, 60)
    self.ToggleLogo.Position = UDim2.new(0.5, -30, 0, 20)
    self.ToggleLogo.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    self.ToggleLogo.BorderSizePixel = 0
    self.ToggleLogo.Image = self.Logo
    self.ToggleLogo.ScaleType = Enum.ScaleType.Fit
    self.ToggleLogo.Visible = false
    self.ToggleLogo.Parent = self.ScreenGui
    self.ToggleLogo.ZIndex = 100
    
    local logoCorner = Instance.new("UICorner", self.ToggleLogo)
    logoCorner.CornerRadius = UDim.new(1, 0)
    
    local logoStroke = Instance.new("UIStroke", self.ToggleLogo)
    logoStroke.Color = self.MainColor
    logoStroke.Thickness = 3
    
    -- Make logo draggable
    MakeDraggable(self.ToggleLogo)
    
    -- Toggle GUI on logo click
    self.ToggleLogo.MouseButton1Click:Connect(function()
        self.MainFrame.Visible = true
        self.ToggleLogo.Visible = false
    end)
    
    -- Hover effects for logo
    self.ToggleLogo.MouseEnter:Connect(function()
        Tween(self.ToggleLogo, {Size = UDim2.new(0, 70, 0, 70)}, 0.2)
        Tween(logoStroke, {Thickness = 4})
    end)
    
    self.ToggleLogo.MouseLeave:Connect(function()
        Tween(self.ToggleLogo, {Size = UDim2.new(0, 60, 0, 60)}, 0.2)
        Tween(logoStroke, {Thickness = 3})
    end)
end

-- ============================================
-- MAIN GUI CREATION
-- ============================================

function Library:CreateGUI()
    -- ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "LunaGUI"
    self.ScreenGui.Parent = game:GetService("CoreGui")
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Main Frame
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = UDim2.new(0, self.Size.X, 0, self.Size.Y)
    self.MainFrame.Position = UDim2.new(0.5, -self.Size.X/2, 0.5, -self.Size.Y/2)
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Active = true
    self.MainFrame.Parent = self.ScreenGui
    Instance.new("UICorner", self.MainFrame).CornerRadius = UDim.new(0, 10)
    
    local mainStroke = Instance.new("UIStroke", self.MainFrame)
    mainStroke.Color = self.MainColor
    mainStroke.Thickness = 2
    
    MakeDraggable(self.MainFrame)
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 45)
    titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = self.MainFrame
    Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 10)
    
    -- Logo in Title Bar
    local logoImage = Instance.new("ImageLabel")
    logoImage.Name = "Logo"
    logoImage.Size = UDim2.new(0, 30, 0, 30)
    logoImage.Position = UDim2.new(0, 10, 0.5, 0)
    logoImage.AnchorPoint = Vector2.new(0, 0.5)
    logoImage.BackgroundTransparency = 1
    logoImage.Image = self.Logo
    logoImage.ScaleType = Enum.ScaleType.Fit
    logoImage.Parent = titleBar
    
    -- Title Text
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(0, 300, 1, 0)
    titleLabel.Position = UDim2.new(0, 50, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = self.Title
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 18
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar
    
    local gradient = Instance.new("UIGradient", titleLabel)
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, self.MainColor),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, self.MainColor)
    }
    
    -- Animate gradient
    task.spawn(function()
        while titleLabel.Parent do
            for i = 0, 360 do
                if not titleLabel.Parent then break end
                gradient.Rotation = i
                task.wait(0.02)
            end
        end
    end)
    
    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseButton"
    closeBtn.Size = UDim2.new(0, 35, 0, 35)
    closeBtn.Position = UDim2.new(1, -40, 0.5, 0)
    closeBtn.AnchorPoint = Vector2.new(0, 0.5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeBtn.Text = "×"
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 20
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Parent = titleBar
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)
    
    closeBtn.MouseButton1Click:Connect(function()
        self.ScreenGui:Destroy()
    end)
    
    closeBtn.MouseEnter:Connect(function()
        Tween(closeBtn, {BackgroundColor3 = Color3.fromRGB(255, 60, 60)})
    end)
    
    closeBtn.MouseLeave:Connect(function()
        Tween(closeBtn, {BackgroundColor3 = Color3.fromRGB(200, 50, 50)})
    end)
    
    -- Minimize Button (Shows Logo)
    local minBtn = Instance.new("TextButton")
    minBtn.Name = "MinimizeButton"
    minBtn.Size = UDim2.new(0, 35, 0, 35)
    minBtn.Position = UDim2.new(1, -80, 0.5, 0)
    minBtn.AnchorPoint = Vector2.new(0, 0.5)
    minBtn.BackgroundColor3 = Color3.fromRGB(255, 170, 50)
    minBtn.Text = "-"
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextSize = 20
    minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minBtn.Parent = titleBar
    Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 8)
    
    minBtn.MouseButton1Click:Connect(function()
        self.MainFrame.Visible = false
        self.ToggleLogo.Visible = true
    end)
    
    minBtn.MouseEnter:Connect(function()
        Tween(minBtn, {BackgroundColor3 = Color3.fromRGB(255, 200, 80)})
    end)
    
    minBtn.MouseLeave:Connect(function()
        Tween(minBtn, {BackgroundColor3 = Color3.fromRGB(255, 170, 50)})
    end)
    
    -- Tab Container
    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Name = "TabContainer"
    self.TabContainer.Size = UDim2.new(0, 150, 1, -55)
    self.TabContainer.Position = UDim2.new(0, 5, 0, 50)
    self.TabContainer.BackgroundTransparency = 1
    self.TabContainer.Parent = self.MainFrame
    
    local tabLayout = Instance.new("UIListLayout", self.TabContainer)
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 5)
    
    -- Content Container
    self.ContentContainer = Instance.new("Frame")
    self.ContentContainer.Name = "ContentContainer"
    self.ContentContainer.Size = UDim2.new(1, -165, 1, -55)
    self.ContentContainer.Position = UDim2.new(0, 160, 0, 50)
    self.ContentContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    self.ContentContainer.BorderSizePixel = 0
    self.ContentContainer.Parent = self.MainFrame
    Instance.new("UICorner", self.ContentContainer).CornerRadius = UDim.new(0, 8)
    
    -- Toggle Key Handler
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == self.ToggleKey then
            self.MainFrame.Visible = not self.MainFrame.Visible
            if not self.MainFrame.Visible then
                self.ToggleLogo.Visible = true
            else
                self.ToggleLogo.Visible = false
            end
        end
    end)
end

-- LUNA GUI LIBRARY v2.0 - COMPLETE VERSION
-- Part 2/3: Tab Creation & Section Management
-- Paste this after Part 1

-- ============================================
-- TAB CREATION
-- ============================================

function Library:AddTab(name, icon)
    icon = icon or DefaultIcons.Home
    
    local Tab = {}
    Tab.Name = name
    Tab.Icon = icon
    Tab.Sections = {}
    
    -- Tab Button
    local tabButton = Instance.new("TextButton")
    tabButton.Name = name
    tabButton.Size = UDim2.new(1, 0, 0, 40)
    tabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    tabButton.BorderSizePixel = 0
    tabButton.Text = ""
    tabButton.Parent = self.TabContainer
    Instance.new("UICorner", tabButton).CornerRadius = UDim.new(0, 8)
    
    local tabStroke = Instance.new("UIStroke", tabButton)
    tabStroke.Color = Color3.fromRGB(50, 50, 50)
    tabStroke.Thickness = 1
    
    -- Tab Icon
    local tabIcon = Instance.new("ImageLabel")
    tabIcon.Size = UDim2.new(0, 20, 0, 20)
    tabIcon.Position = UDim2.new(0, 10, 0.5, 0)
    tabIcon.AnchorPoint = Vector2.new(0, 0.5)
    tabIcon.BackgroundTransparency = 1
    tabIcon.Image = icon
    tabIcon.ImageColor3 = Color3.fromRGB(200, 200, 200)
    tabIcon.Parent = tabButton
    
    -- Tab Label
    local tabLabel = Instance.new("TextLabel")
    tabLabel.Size = UDim2.new(1, -40, 1, 0)
    tabLabel.Position = UDim2.new(0, 35, 0, 0)
    tabLabel.BackgroundTransparency = 1
    tabLabel.Text = name
    tabLabel.Font = Enum.Font.GothamBold
    tabLabel.TextSize = 13
    tabLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    tabLabel.TextXAlignment = Enum.TextXAlignment.Left
    tabLabel.Parent = tabButton
    
    -- Tab Content ScrollingFrame
    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Name = name .. "Content"
    tabContent.Size = UDim2.new(1, -10, 1, -10)
    tabContent.Position = UDim2.new(0, 5, 0, 5)
    tabContent.BackgroundTransparency = 1
    tabContent.BorderSizePixel = 0
    tabContent.ScrollBarThickness = 4
    tabContent.ScrollBarImageColor3 = self.MainColor
    tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabContent.Visible = false
    tabContent.Parent = self.ContentContainer
    
    local contentLayout = Instance.new("UIListLayout", tabContent)
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 8)
    contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    -- Auto-update canvas size
    task.spawn(function()
        while tabContent.Parent do
            tabContent.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 10)
            task.wait(0.1)
        end
    end)
    
    Tab.Content = tabContent
    Tab.Button = tabButton
    Tab.Stroke = tabStroke
    Tab.IconLabel = tabIcon
    Tab.TextLabel = tabLabel
    
    -- Tab Click Handler
    tabButton.MouseButton1Click:Connect(function()
        for _, tab in pairs(self.Tabs) do
            tab.Content.Visible = false
            Tween(tab.Button, {BackgroundColor3 = Color3.fromRGB(30, 30, 30)})
            Tween(tab.Stroke, {Color = Color3.fromRGB(50, 50, 50)})
            tab.IconLabel.ImageColor3 = Color3.fromRGB(200, 200, 200)
            tab.TextLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        
        tabContent.Visible = true
        Tween(tabButton, {BackgroundColor3 = self.MainColor})
        Tween(tabStroke, {Color = Color3.fromRGB(255, 255, 255)})
        tabIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
        tabLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        
        self.CurrentTab = Tab
    end)
    
    -- Hover Effects
    tabButton.MouseEnter:Connect(function()
        if self.CurrentTab ~= Tab then
            Tween(tabButton, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)})
        end
    end)
    
    tabButton.MouseLeave:Connect(function()
        if self.CurrentTab ~= Tab then
            Tween(tabButton, {BackgroundColor3 = Color3.fromRGB(30, 30, 30)})
        end
    end)
    
    table.insert(self.Tabs, Tab)
    
    -- Auto-select first tab
    if #self.Tabs == 1 then
        task.wait()
        tabButton.MouseButton1Click:Fire()
    end
    
    -- ============================================
    -- SECTION CREATION (FOLDERS)
    -- ============================================
    
    function Tab:AddSection(name)
        local Section = {}
        Section.Name = name
        Section.Expanded = false
        Section.Elements = {}
        
        -- Section Frame
        local sectionFrame = Instance.new("Frame")
        sectionFrame.Name = name
        sectionFrame.Size = UDim2.new(0.95, 0, 0, 35)
        sectionFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        sectionFrame.BorderSizePixel = 0
        sectionFrame.Parent = tabContent
        Instance.new("UICorner", sectionFrame).CornerRadius = UDim.new(0, 8)
        
        local sectionStroke = Instance.new("UIStroke", sectionFrame)
        sectionStroke.Color = Color3.fromRGB(60, 60, 60)
        sectionStroke.Thickness = 1
        
        -- Section Button
        local sectionButton = Instance.new("TextButton")
        sectionButton.Size = UDim2.new(1, 0, 0, 35)
        sectionButton.BackgroundTransparency = 1
        sectionButton.Text = ""
        sectionButton.Parent = sectionFrame
        
        -- Section Label
        local sectionLabel = Instance.new("TextLabel")
        sectionLabel.Size = UDim2.new(1, -70, 1, 0)
        sectionLabel.Position = UDim2.new(0, 15, 0, 0)
        sectionLabel.BackgroundTransparency = 1
        sectionLabel.Text = name
        sectionLabel.Font = Enum.Font.GothamBold
        sectionLabel.TextSize = 14
        sectionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
        sectionLabel.Parent = sectionButton
        
        -- Arrow Indicator
        local arrow = Instance.new("TextLabel")
        arrow.Size = UDim2.new(0, 20, 0, 20)
        arrow.Position = UDim2.new(1, -30, 0.5, 0)
        arrow.AnchorPoint = Vector2.new(0, 0.5)
        arrow.BackgroundTransparency = 1
        arrow.Text = "▶"
        arrow.Font = Enum.Font.GothamBold
        arrow.TextSize = 12
        arrow.TextColor3 = self.MainColor
        arrow.Parent = sectionButton
        
        -- Content Container
        local sectionContent = Instance.new("Frame")
        sectionContent.Name = "Content"
        sectionContent.Size = UDim2.new(1, 0, 0, 0)
        sectionContent.Position = UDim2.new(0, 0, 0, 35)
        sectionContent.BackgroundTransparency = 1
        sectionContent.ClipsDescendants = true
        sectionContent.Parent = sectionFrame
        
        local contentPadding = Instance.new("UIPadding", sectionContent)
        contentPadding.PaddingLeft = UDim.new(0, 10)
        contentPadding.PaddingRight = UDim.new(0, 10)
        contentPadding.PaddingTop = UDim.new(0, 5)
        
        local contentList = Instance.new("UIListLayout", sectionContent)
        contentList.SortOrder = Enum.SortOrder.LayoutOrder
        contentList.Padding = UDim.new(0, 6)
        
        Section.Content = sectionContent
        Section.Frame = sectionFrame
        Section.Layout = contentList
        
        -- Toggle Section Expand/Collapse
        sectionButton.MouseButton1Click:Connect(function()
            Section.Expanded = not Section.Expanded
            
            if Section.Expanded then
                arrow.Text = "▼"
                local targetSize = contentList.AbsoluteContentSize.Y + 10
                sectionFrame.Size = UDim2.new(0.95, 0, 0, 35 + targetSize)
                Tween(sectionContent, {Size = UDim2.new(1, 0, 0, targetSize)}, 0.3)
            else
                arrow.Text = "▶"
                sectionFrame.Size = UDim2.new(0.95, 0, 0, 35)
                Tween(sectionContent, {Size = UDim2.new(1, 0, 0, 0)}, 0.3)
            end
        end)
        
        -- Auto-resize section when elements are added
        task.spawn(function()
            while sectionFrame.Parent do
                if Section.Expanded then
                    local targetSize = contentList.AbsoluteContentSize.Y + 10
                    sectionFrame.Size = UDim2.new(0.95, 0, 0, 35 + targetSize)
                    sectionContent.Size = UDim2.new(1, 0, 0, targetSize)
                end
                task.wait(0.1)
            end
        end)
        
        table.insert(Tab.Sections, Section)
        
        -- Continue to Part 3 for UI Components
        return Section
    end
    
    return Tab
end

-- LUNA GUI LIBRARY v2.0 - COMPLETE VERSION
-- Part 3/3: All UI Components (Toggle, Button, Slider, Input, Dropdown, Multi-Dropdown)
-- Paste this after Part 2, inside the Section methods

-- ============================================
-- UI COMPONENT: TOGGLE
-- ============================================

function Section:AddToggle(name, default, callback)
    default = default or false
    
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, 40)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = self.Content
    Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(0, 6)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.65, 0, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleFrame
    
    local switchBg = Instance.new("Frame")
    switchBg.Size = UDim2.new(0, 45, 0, 22)
    switchBg.Position = UDim2.new(1, -55, 0.5, 0)
    switchBg.AnchorPoint = Vector2.new(0, 0.5)
    switchBg.BackgroundColor3 = default and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 60, 60)
    switchBg.BorderSizePixel = 0
    switchBg.Parent = toggleFrame
    Instance.new("UICorner", switchBg).CornerRadius = UDim.new(1, 0)
    
    local switchCircle = Instance.new("Frame")
    switchCircle.Size = UDim2.new(0, 18, 0, 18)
    switchCircle.Position = default and UDim2.new(1, -20, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
    switchCircle.AnchorPoint = Vector2.new(0, 0.5)
    switchCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    switchCircle.BorderSizePixel = 0
    switchCircle.Parent = switchBg
    Instance.new("UICorner", switchCircle).CornerRadius = UDim.new(1, 0)
    
    local isOn = default
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.Text = ""
    button.Parent = toggleFrame
    
    button.MouseButton1Click:Connect(function()
        isOn = not isOn
        
        if isOn then
            Tween(switchCircle, {Position = UDim2.new(1, -20, 0.5, 0)})
            Tween(switchBg, {BackgroundColor3 = Color3.fromRGB(0, 200, 100)})
        else
            Tween(switchCircle, {Position = UDim2.new(0, 2, 0.5, 0)})
            Tween(switchBg, {BackgroundColor3 = Color3.fromRGB(60, 60, 60)})
        end
        
        pcall(callback, isOn)
    end)
    
    return {
        Set = function(value)
            isOn = value
            if isOn then
                switchCircle.Position = UDim2.new(1, -20, 0.5, 0)
                switchBg.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
            else
                switchCircle.Position = UDim2.new(0, 2, 0.5, 0)
                switchBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            end
        end,
        Get = function() return isOn end
    }
end

-- ============================================
-- UI COMPONENT: BUTTON
-- ============================================

function Section:AddButton(name, callback)
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Size = UDim2.new(1, 0, 0, 40)
    buttonFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    buttonFrame.BorderSizePixel = 0
    buttonFrame.Parent = self.Content
    Instance.new("UICorner", buttonFrame).CornerRadius = UDim.new(0, 6)
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 1, -10)
    button.Position = UDim2.new(0, 5, 0, 5)
    button.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    button.Text = name
    button.Font = Enum.Font.GothamBold
    button.TextSize = 12
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Parent = buttonFrame
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 5)
    
    button.MouseButton1Click:Connect(function()
        Tween(button, {BackgroundColor3 = Color3.fromRGB(0, 180, 255)})
        task.wait(0.1)
        Tween(button, {BackgroundColor3 = Color3.fromRGB(0, 150, 255)})
        pcall(callback)
    end)
    
    button.MouseEnter:Connect(function()
        Tween(button, {BackgroundColor3 = Color3.fromRGB(0, 170, 255)})
    end)
    
    button.MouseLeave:Connect(function()
        Tween(button, {BackgroundColor3 = Color3.fromRGB(0, 150, 255)})
    end)
end

-- ============================================
-- UI COMPONENT: SLIDER
-- ============================================

function Section:AddSlider(name, min, max, default, callback)
    default = default or min
    
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, 0, 0, 50)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = self.Content
    Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(0, 6)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 0, 20)
    label.Position = UDim2.new(0, 12, 0, 8)
    label.BackgroundTransparency = 1
    label.Text = name
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sliderFrame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.25, 0, 0, 20)
    valueLabel.Position = UDim2.new(0.7, 0, 0, 8)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 12
    valueLabel.TextColor3 = Color3.fromRGB(0, 150, 255)
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = sliderFrame
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(0.9, 0, 0, 6)
    sliderBg.Position = UDim2.new(0.05, 0, 1, -14)
    sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = sliderFrame
    Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg
    Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)
    
    local sliderBtn = Instance.new("TextButton")
    sliderBtn.Size = UDim2.new(0, 16, 0, 16)
    sliderBtn.Position = UDim2.new((default - min) / (max - min), 0, 0.5, 0)
    sliderBtn.AnchorPoint = Vector2.new(0.5, 0.5)
    sliderBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderBtn.Text = ""
    sliderBtn.Parent = sliderBg
    Instance.new("UICorner", sliderBtn).CornerRadius = UDim.new(1, 0)
    
    local dragging = false
    local currentValue = default
    
    local function updateSlider(input)
        local relativeX = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + (max - min) * relativeX)
        
        sliderBtn.Position = UDim2.new(relativeX, 0, 0.5, 0)
        sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
        valueLabel.Text = tostring(value)
        currentValue = value
        
        pcall(callback, value)
    end
    
    sliderBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    
    sliderBtn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)
    
    return {
        Get = function() return currentValue end,
        Set = function(value)
            local relativeX = (value - min) / (max - min)
            sliderBtn.Position = UDim2.new(relativeX, 0, 0.5, 0)
            sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
            valueLabel.Text = tostring(value)
            currentValue = value
        end
    }
end

-- ============================================
-- UI COMPONENT: INPUT (TEXTBOX)
-- ============================================

function Section:AddInput(name, placeholder, callback)
    placeholder = placeholder or "Enter value..."
    
    local textboxFrame = Instance.new("Frame")
    textboxFrame.Size = UDim2.new(1, 0, 0, 40)
    textboxFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    textboxFrame.BorderSizePixel = 0
    textboxFrame.Parent = self.Content
    Instance.new("UICorner", textboxFrame).CornerRadius = UDim.new(0, 6)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.4, 0, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = textboxFrame
    
    local inputBox = Instance.new("TextBox")
    inputBox.Size = UDim2.new(0.5, 0, 0, 30)
    inputBox.Position = UDim2.new(0.48, 0, 0.5, 0)
    inputBox.AnchorPoint = Vector2.new(0, 0.5)
    inputBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    inputBox.Text = ""
    inputBox.PlaceholderText = placeholder
    inputBox.Font = Enum.Font.Gotham
    inputBox.TextSize = 11
    inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    inputBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    inputBox.ClearTextOnFocus = false
    inputBox.Parent = textboxFrame
    Instance.new("UICorner", inputBox).CornerRadius = UDim.new(0, 5)
    
    local inputStroke = Instance.new("UIStroke", inputBox)
    inputStroke.Color = Color3.fromRGB(60, 60, 60)
    inputStroke.Thickness = 1
    
    inputBox.Focused:Connect(function()
        Tween(inputStroke, {Color = Color3.fromRGB(0, 150, 255)})
    end)
    
    inputBox.FocusLost:Connect(function(enterPressed)
        Tween(inputStroke, {Color = Color3.fromRGB(60, 60, 60)})
        if enterPressed then
            pcall(callback, inputBox.Text)
        end
    end)
    
    return {
        Get = function() return inputBox.Text end,
        Set = function(value) inputBox.Text = value end
    }
end

-- ============================================
-- UI COMPONENT: DROPDOWN (Single Select)
-- ============================================

function Section:AddDropdown(name, options, default, callback)
    default = default or (options[1] or "Select")
    
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Size = UDim2.new(1, 0, 0, 40)
    dropdownFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    dropdownFrame.BorderSizePixel = 0
    dropdownFrame.Parent = self.Content
    Instance.new("UICorner", dropdownFrame).CornerRadius = UDim.new(0, 6)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.4, 0, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = dropdownFrame
    
    local selectedBtn = Instance.new("TextButton")
    selectedBtn.Size = UDim2.new(0.5, 0, 0, 30)
    selectedBtn.Position = UDim2.new(0.48, 0, 0.5, 0)
    selectedBtn.AnchorPoint = Vector2.new(0, 0.5)
    selectedBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    selectedBtn.Text = default
    selectedBtn.Font = Enum.Font.Gotham
    selectedBtn.TextSize = 11
    selectedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    selectedBtn.Parent = dropdownFrame
    Instance.new("UICorner", selectedBtn).CornerRadius = UDim.new(0, 5)
    
    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -20, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.Font = Enum.Font.GothamBold
    arrow.TextSize = 10
    arrow.TextColor3 = Color3.fromRGB(200, 200, 200)
    arrow.Parent = selectedBtn
    
    local dropdownList = Instance.new("Frame")
    dropdownList.Size = UDim2.new(0.5, 0, 0, 0)
    dropdownList.Position = UDim2.new(0.48, 0, 1, 5)
    dropdownList.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    dropdownList.BorderSizePixel = 0
    dropdownList.Visible = false
    dropdownList.ClipsDescendants = true
    dropdownList.Parent = dropdownFrame
    dropdownList.ZIndex = 10
    Instance.new("UICorner", dropdownList).CornerRadius = UDim.new(0, 5)
    
    local listLayout = Instance.new("UIListLayout", dropdownList)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    local currentSelection = default
    
    for _, option in ipairs(options) do
        local optionBtn = Instance.new("TextButton")
        optionBtn.Size = UDim2.new(1, 0, 0, 28)
        optionBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        optionBtn.BorderSizePixel = 0
        optionBtn.Text = option
        optionBtn.Font = Enum.Font.Gotham
        optionBtn.TextSize = 11
        optionBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
        optionBtn.Parent = dropdownList
        
        optionBtn.MouseEnter:Connect(function()
            Tween(optionBtn, {BackgroundColor3 = Color3.fromRGB(60, 60, 60)})
        end)
        
        optionBtn.MouseLeave:Connect(function()
            Tween(optionBtn, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)})
        end)
        
        optionBtn.MouseButton1Click:Connect(function()
            selectedBtn.Text = option
            currentSelection = option
            dropdownList.Visible = false
            arrow.Text = "▼"
            Tween(dropdownList, {Size = UDim2.new(0.5, 0, 0, 0)}, 0.2)
            dropdownFrame.Size = UDim2.new(1, 0, 0, 40)
            pcall(callback, option)
        end)
    end
    
    selectedBtn.MouseButton1Click:Connect(function()
        dropdownList.Visible = not dropdownList.Visible
        
        if dropdownList.Visible then
            arrow.Text = "▲"
            local listHeight = #options * 28
            dropdownFrame.Size = UDim2.new(1, 0, 0, 40 + listHeight + 10)
            Tween(dropdownList, {Size = UDim2.new(0.5, 0, 0, listHeight)}, 0.2)
        else
            arrow.Text = "▼"
            dropdownFrame.Size = UDim2.new(1, 0, 0, 40)
            Tween(dropdownList, {Size = UDim2.new(0.5, 0, 0, 0)}, 0.2)
        end
    end)
    
    return {
        Get = function() return currentSelection end,
        Set = function(value)
            selectedBtn.Text = value
            currentSelection = value
        end
    }
end

-- ============================================
-- UI COMPONENT: MULTI-SELECT DROPDOWN
-- ============================================

function Section:AddMultiDropdown(name, options, defaults, callback)
    defaults = defaults or {}
    local selected = {}
    for _, v in ipairs(defaults) do
        selected[v] = true
    end
    
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Size = UDim2.new(1, 0, 0, 40)
    dropdownFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    dropdownFrame.BorderSizePixel = 0
    dropdownFrame.Parent = self.Content
    Instance.new("UICorner", dropdownFrame).CornerRadius = UDim.new(0, 6)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.4, 0, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = dropdownFrame
    
    local function getSelectedText()
        local count = 0
        for _ in pairs(selected) do count = count + 1 end
        return count == 0 and "None" or count .. " selected"
    end
    
    local selectedBtn = Instance.new("TextButton")
    selectedBtn.Size = UDim2.new(0.5, 0, 0, 30)
    selectedBtn.Position = UDim2.new(0.48, 0, 0.5, 0)
    selectedBtn.AnchorPoint = Vector2.new(0, 0.5)
    selectedBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    selectedBtn.Text = getSelectedText()
    selectedBtn.Font = Enum.Font.Gotham
    selectedBtn.TextSize = 11
    selectedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    selectedBtn.Parent = dropdownFrame
    Instance.new("UICorner", selectedBtn).CornerRadius = UDim.new(0, 5)
    
    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -20, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.Font = Enum.Font.GothamBold
    arrow.TextSize = 10
    arrow.TextColor3 = Color3.fromRGB(200, 200, 200)
    arrow.Parent = selectedBtn
    
    local dropdownList = Instance.new("ScrollingFrame")
    dropdownList.Size = UDim2.new(0.5, 0, 0, 0)
    dropdownList.Position = UDim2.new(0.48, 0, 1, 5)
    dropdownList.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    dropdownList.BorderSizePixel = 0
    dropdownList.Visible = false
    dropdownList.ClipsDescendants = true
    dropdownList.ScrollBarThickness = 4
    dropdownList.CanvasSize = UDim2.new(0, 0, 0, #options * 28)
    dropdownList.Parent = dropdownFrame
    dropdownList.ZIndex = 10
    Instance.new("UICorner", dropdownList).CornerRadius = UDim.new(0, 5)
    
    local listLayout = Instance.new("UIListLayout", dropdownList)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    for _, option in ipairs(options) do
        local optionBtn = Instance.new("TextButton")
        optionBtn.Size = UDim2.new(1, 0, 0, 28)
        optionBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        optionBtn.BorderSizePixel = 0
        optionBtn.Text = (selected[option] and "✓ " or "    ") .. option
        optionBtn.Font = Enum.Font.Gotham
        optionBtn.TextSize = 11
        optionBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
        optionBtn.TextXAlignment = Enum.TextXAlignment.Left
        optionBtn.Parent = dropdownList
        
        optionBtn.MouseEnter:Connect(function()
            Tween(optionBtn, {BackgroundColor3 = Color3.fromRGB(60, 60, 60)})
        end)
        
        optionBtn.MouseLeave:Connect(function()
            Tween(optionBtn, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)})
        end)
        
        optionBtn.MouseButton1Click:Connect(function()
            selected[option] = not selected[option]
            optionBtn.Text = (selected[option] and "✓ " or "    ") .. option
            selectedBtn.Text = getSelectedText()
            
            local selectedList = {}
            for k, v in pairs(selected) do
                if v then table.insert(selectedList, k) end
            end
            pcall(callback, selectedList)
        end)
    end
    
    selectedBtn.MouseButton1Click:Connect(function()
        dropdownList.Visible = not dropdownList.Visible
        
        if dropdownList.Visible then
            arrow.Text = "▲"
            local listHeight = math.min(#options * 28, 150)
            dropdownFrame.Size = UDim2.new(1, 0, 0, 40 + listHeight + 10)
            Tween(dropdownList, {Size = UDim2.new(0.5, 0, 0, listHeight)}, 0.2)
        else
            arrow.Text = "▼"
            dropdownFrame.Size = UDim2.new(1, 0, 0, 40)
            Tween(dropdownList, {Size = UDim2.new(0.5, 0, 0, 0)}, 0.2)
        end
    end)
    
    return {
        Get = function()
            local selectedList = {}
            for k, v in pairs(selected) do
                if v then table.insert(selectedList, k) end
            end
            return selectedList
        end
    }
end

return Library
