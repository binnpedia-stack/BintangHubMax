-- ==========================================
-- BINTANGHUB REBUILD (VIOLENCE DISTRICT)
-- NO KEY SYSTEM, NO REMOTES, FREE ALL.
-- TESTED & PATCHED
-- ==========================================

_G.BintangHub_Active = true
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local PathfindingService = game:GetService("PathfindingService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Bypass Premium
local function hasPremiumAccess(featureName) return true end

-- Cleanup old instances
pcall(function()
    local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if playerGui then
        for _, name in ipairs({"BintangHub", "JLXHelperGui", "VD_MobileHUD", "VD_MobileAimbotGui"}) do
            local gui = playerGui:FindFirstChild(name)
            if gui then gui:Destroy() end
        end
    end
    if CoreGui then
        for _, name in ipairs({"BintangHub", "JLXHelperGui"}) do
            local gui = CoreGui:FindFirstChild(name)
            if gui then gui:Destroy() end
        end
    end
end)

-- UI Variables
local UI = {
    Bg = Color3.fromRGB(13, 14, 17),
    Sidebar = Color3.fromRGB(10, 11, 14),
    Card = Color3.fromRGB(17, 18, 23),
    CardHover = Color3.fromRGB(24, 25, 33),
    Elevated = Color3.fromRGB(22, 23, 29),
    Stroke = Color3.fromRGB(32, 34, 43),
    StrokeDim = Color3.fromRGB(24, 25, 33),
    Text = Color3.fromRGB(255, 255, 255),
    TextSub = Color3.fromRGB(123, 126, 140),
    Muted = Color3.fromRGB(75, 78, 90),
    Accent = Color3.fromRGB(255, 255, 255),
    AccentCyan = Color3.fromRGB(240, 242, 250),
    AccentGreen = Color3.fromRGB(34, 197, 94),
    Danger = Color3.fromRGB(239, 68, 68),
    Radius = 12,
    CardRadius = 8,
    MainW = 720,
    MainH = 470,
    TitleH = 38,
}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BintangHub"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 99999
pcall(function() screenGui.Parent = CoreGui end)
if not screenGui.Parent then screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, UI.MainW, 0, UI.MainH)
mainFrame.Position = UDim2.new(0.5, -UI.MainW / 2, 0.5, -UI.MainH / 2)
mainFrame.BackgroundColor3 = UI.Bg
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Active = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, UI.Radius)

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, UI.TitleH)
titleBar.BackgroundColor3 = UI.Sidebar
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, UI.Radius)

local titleLogo = Instance.new("TextLabel")
titleLogo.Size = UDim2.new(0, 250, 1, 0)
titleLogo.Position = UDim2.new(0, 16, 0, 0)
titleLogo.BackgroundTransparency = 1
titleLogo.RichText = true
titleLogo.Text = "<b>BintangHub</b> <font color='#7b7e8c'><font size='10'>v2.0 Free</font></font>"
titleLogo.TextColor3 = UI.Text
titleLogo.Font = Enum.Font.GothamBold
titleLogo.TextSize = 13.5
titleLogo.TextXAlignment = Enum.TextXAlignment.Left
titleLogo.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Position = UDim2.new(1, -32, 0.5, -12)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "X"
closeBtn.TextColor3 = UI.TextSub
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.Parent = titleBar
closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 50, 1, -UI.TitleH)
sidebar.Position = UDim2.new(0, 0, 0, UI.TitleH)
sidebar.BackgroundColor3 = UI.Sidebar
sidebar.BorderSizePixel = 0
sidebar.Parent = mainFrame
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, UI.Radius)

local sidebarScroll = Instance.new("ScrollingFrame")
sidebarScroll.Size = UDim2.new(1, 0, 1, -8)
sidebarScroll.Position = UDim2.new(0, 0, 0, 4)
sidebarScroll.BackgroundTransparency = 1
sidebarScroll.BorderSizePixel = 0
sidebarScroll.ScrollBarThickness = 0
sidebarScroll.Parent = sidebar
local sideList = Instance.new("UIListLayout")
sideList.Padding = UDim.new(0, 4)
sideList.HorizontalAlignment = Enum.HorizontalAlignment.Center
sideList.Parent = sidebarScroll

local navigationContainer = Instance.new("Frame")
navigationContainer.Size = UDim2.new(1, -58, 1, -UI.TitleH - 12)
navigationContainer.Position = UDim2.new(0, 54, 0, UI.TitleH + 6)
navigationContainer.BackgroundTransparency = 1
navigationContainer.Parent = mainFrame

local contentFolder = Instance.new("Folder")
contentFolder.Name = "Tabs"
contentFolder.Parent = navigationContainer

local tabButtons, tabContainers, activeTab = {}, {}, nil

local function switchTab(tabId)
    if activeTab == tabId then return end
    for id, btn in pairs(tabButtons) do
        local icon = btn:FindFirstChild("Icon")
        if id == tabId then
            btn.BackgroundColor3 = UI.Card
            btn.BackgroundTransparency = 0.5
            if icon then icon.TextColor3 = UI.Text end
        else
            btn.BackgroundColor3 = UI.Bg
            btn.BackgroundTransparency = 1
            if icon then icon.TextColor3 = UI.TextSub end
        end
    end
    for id, frame in pairs(tabContainers) do
        frame.Visible = (id == tabId)
    end
    activeTab = tabId
end

local function createTab(tabId, title, iconChar)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 36, 0, 36)
    btn.BackgroundColor3 = UI.Bg
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.Parent = sidebarScroll
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    local label = Instance.new("TextLabel")
    label.Name = "Icon"
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = iconChar
    label.TextColor3 = UI.TextSub
    label.Font = Enum.Font.GothamBold
    label.TextSize = 16
    label.Parent = btn

    btn.MouseButton1Click:Connect(function() switchTab(tabId) end)
    tabButtons[tabId] = btn

    local container = Instance.new("ScrollingFrame")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.ScrollBarThickness = 2
    container.Visible = false
    container.Parent = contentFolder
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 4)
    padding.PaddingBottom = UDim.new(0, 20)
    padding.Parent = container
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.Parent = container

    tabContainers[tabId] = container
    return container
end

local function createSection(container, title)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 22)
    frame.BackgroundTransparency = 1
    frame.Parent = container
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Position = UDim2.new(0, 4, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = string.upper(title)
    label.TextColor3 = UI.TextSub
    label.Font = Enum.Font.GothamBold
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
end

local function createToggle(container, label, initial, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 32)
    frame.BackgroundColor3 = UI.Card
    frame.BackgroundTransparency = 0.5
    frame.Parent = container
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, UI.CardRadius)

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 16, 0, 16)
    btn.Position = UDim2.new(0, 10, 0.5, -8)
    btn.BackgroundColor3 = initial and UI.Text or UI.Elevated
    btn.Text = ""
    btn.Parent = frame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -50, 1, 0)
    lbl.Position = UDim2.new(0, 34, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = UI.Text
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame

    local state = initial
    local function toggle()
        state = not state
        btn.BackgroundColor3 = state and UI.Text or UI.Elevated
        if callback then callback(state) end
    end
    btn.MouseButton1Click:Connect(toggle)
    local clickArea = Instance.new("TextButton")
    clickArea.Size = UDim2.new(1, 0, 1, 0)
    clickArea.BackgroundTransparency = 1
    clickArea.Text = ""
    clickArea.Parent = frame
    clickArea.MouseButton1Click:Connect(toggle)
end

-- ==========================================
-- FEATURES SETUP (UI & LOGIC)
-- ==========================================

local tabHome = createTab("Home", "Home", "H")
local tabSurvivor = createTab("Survivor", "Survivor", "S")
local tabKiller = createTab("Killer", "Killer", "K")
local tabESP = createTab("ESP", "ESP", "E")
local tabMisc = createTab("Misc", "Misc", "M")

-- Home
createSection(tabHome, "Welcome")
createToggle(tabHome, "Unlocked Premium (Free)", true, function() end)

-- Survivor Logic
local autoSkillCheckEnabled = false
local parryEnabled = false
local lastSkillCheckTime = 0

createSection(tabSurvivor, "Automation")
createToggle(tabSurvivor, "Auto Skill Check", false, function(state) autoSkillCheckEnabled = state end)
createToggle(tabSurvivor, "Auto Parry (Killer)", false, function(state) parryEnabled = state end)

-- Auto Skill Check Logic
local function getSkillCheckGui()
    local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if not pg then return nil end
    local gui1 = pg:FindFirstChild("SkillCheckPromptGui") or pg:FindFirstChild("SkillCheckPromptGui-con")
    if gui1 then local c = gui1:FindFirstChild("Check"); if c and c.Visible then return gui1 end end
    return nil
end

local function fireSkillCheck()
    pcall(function()
        local vim = game:GetService("VirtualInputManager")
        if UserInputService.TouchEnabled then
            local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
            local sm = pg and (pg:FindFirstChild("Survivor-mob") or pg:FindFirstChild("Survivor"))
            local act = sm and sm:FindFirstChild("Controls") and sm.Controls:FindFirstChild("action")
            if act and firesignal then firesignal(act.MouseButton1Down); firesignal(act.MouseButton1Click) end
        else
            vim:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
            task.wait(0.02)
            vim:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
        end
    end)
end

RunService.RenderStepped:Connect(function()
    if not autoSkillCheckEnabled then return end
    local gui1 = getSkillCheckGui()
    if not gui1 then return end
    local check = gui1:FindFirstChild("Check")
    local line = check and check:FindFirstChild("Line")
    local zone = check and (check:FindFirstChild("TrapPerfect") or check:FindFirstChild("Goal"))
    if not line or not zone then return end
    
    local rot = line.Rotation % 360
    local zRot = zone.Rotation % 360
    if rot < 0 then rot = rot + 360 end
    if zRot < 0 then zRot = zRot + 360 end
    
    local minR, maxR = (zRot + 104) % 360, (zRot + 114) % 360
    local inZone = false
    if minR > maxR then inZone = rot >= minR or rot <= maxR else inZone = rot >= minR and rot <= maxR end
    
    -- Patch: Debounce biar ga spam 60x per detik
    if inZone and tick() - lastSkillCheckTime > 0.15 then 
        lastSkillCheckTime = tick()
        fireSkillCheck() 
    end
end)

-- Auto Parry Logic
local parryAnimations = {
    ["71008020992570"] = true, ["72742711718023"] = true, ["72908958549833"] = true,
    ["73681849513551"] = true, ["73923929500477"] = true, ["74968262036854"] = true,
    ["75857500533792"] = true, ["76385865186777"] = true, ["76503974441748"] = true,
    ["76744850905644"] = true, ["77081789642514"] = true, ["78432063483146"] = true,
    ["78935059863801"] = true, ["79935565590141"] = true, ["79965656177566"] = true,
    ["80411309607666"] = true, ["82666958311998"] = true, ["83873880822918"] = true,
}
local lastParry = 0
local function doParry()
    local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    local sm = pg and (pg:FindFirstChild("Survivor-mob") or pg:FindFirstChild("Survivor"))
    local act = sm and sm:FindFirstChild("Controls") and (sm.Controls:FindFirstChild("Gui-mob") or sm.Controls:FindFirstChild("action"))
    if act then
        if firesignal then firesignal(act.MouseButton1Down) end
        if getconnections then for _, c in ipairs(getconnections(act.MouseButton1Down)) do pcall(function() c:Fire() end) end end
    end
end

workspace.DescendantAdded:Connect(function(part)
    if not parryEnabled then return end
    if part:IsA("BasePart") and (part.Name:lower():find("hitbox") or part.Name:lower():find("slash")) then
        local model = part:FindFirstAncestorOfClass("Model")
        if model and model ~= LocalPlayer.Character then
            local killerHrp = model:FindFirstChild("HumanoidRootPart")
            local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if killerHrp and myHrp then
                local dist = (killerHrp.Position - myHrp.Position).Magnitude
                if dist <= 14 and tick() - lastParry > 0.2 then
                    lastParry = tick()
                    doParry()
                end
            end
        end
    end
end)

-- ESP Logic
local espEnabled = false
createToggle(tabESP, "Enable ESP", false, function(s) espEnabled = s end)

local espObjects = {}
RunService.RenderStepped:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if espEnabled and hrp then
                if not espObjects[char] or not espObjects[char].Parent then
                    local hl = Instance.new("Highlight")
                    hl.FillColor = Color3.fromRGB(255, 0, 0)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.Parent = char
                    espObjects[char] = hl
                end
            else
                if espObjects[char] then espObjects[char]:Destroy(); espObjects[char] = nil end
            end
        end
    end
end)

-- Misc Logic (Patch: Nyimpen settingan awal biar ga rusak pas dimatiin)
local origBrightness = Lighting.Brightness
local origAmbient = Lighting.Ambient
local origOutdoor = Lighting.OutdoorAmbient

createToggle(tabMisc, "Full Bright", false, function(s)
    if s then
        Lighting.Brightness = 2
        Lighting.Ambient = Color3.new(1,1,1)
        Lighting.OutdoorAmbient = Color3.new(1,1,1)
    else
        Lighting.Brightness = origBrightness
        Lighting.Ambient = origAmbient
        Lighting.OutdoorAmbient = origOutdoor
    end
end)

-- Draggable logic
local dragging, dragStart, startPos
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

switchTab("Home")
