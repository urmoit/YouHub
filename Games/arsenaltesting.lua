-- Load Fluent UI & Addons
local Fluent = loadstring(game:HttpGet("https://github.com/1dontgiveaf/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/1dontgiveaf/Fluent/main/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/1dontgiveaf/Fluent/main/Addons/InterfaceManager.lua"))()

-- Create Fluent UI window
local Window = Fluent:CreateWindow({
    Title = "YouHub | Arsenal v1.0.0",
    SubTitle = "by Chosentechies",
    TabWidth = 160,
    Size = UDim2.fromOffset(600, 500),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "info" }),
    Combat = Window:AddTab({ Title = "Combat", Icon = "target" }),
    Movement = Window:AddTab({ Title = "Movement", Icon = "move" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "settings" })
}

local ToggleGui = Instance.new("ScreenGui")
local Toggle = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

local IsOpen = true

--Properties
ToggleGui.Name = "Toggle Gui"
ToggleGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ToggleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ToggleGui.ResetOnSpawn = false

UICorner.Parent = Toggle
Toggle.Name = "Toggle"
Toggle.Parent = ToggleGui
Toggle.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
Toggle.Position = UDim2.new(0, 0, 0.454706937, 0)--position of the toggle
Toggle.Size = UDim2.new(0, 80, 0, 38)--size of the toggle
Toggle.Font = Enum.Font.SourceSans
Toggle.Text = "Close Gui"
Toggle.TextColor3 = Color3.fromRGB(203, 122, 49)
Toggle.TextSize = 19.000
Toggle.Draggable = true
Toggle.MouseButton1Click:Connect(function()
    IsOpen = not IsOpen

    if IsOpen then
        Toggle.Text = "Close Gui"
        Fluent.GUI.Enabled = true  -- Show full Fluent UI
		print(Fluent.GUI, Fluent.GUI.ClassName)  -- Should print: Instance and "ScreenGui"
    else
        Toggle.Text = "Open Gui"
        Fluent.GUI.Enabled = false -- Hide full Fluent UI
    end
end)

local Options = Fluent.Options

-- == MAIN TAB CONTENT ==
Tabs.Main:AddSection("Info")

Tabs.Main:AddParagraph({
    Title = "YouHub | Arsenal Functions",
    Content = [[
Current Features:
- Auto Hit Resources
- Auto Expand
- Auto Craft Log
- Each one has its own delay slider
- Player Speed Changer

More features are on the way! Stay tuned!
]]
})

Tabs.Main:AddParagraph({
    Title = "YouHub | Arsenal Changelog v1.0.0",
    Content = [[
Current Features:
- Added Crafting Tab
- Added Auto Craft Brick
- Changed Contribute to Expand
- Moved Crafting to Crafting Tab

More features are on the way! Stay tuned!
]]
})

Tabs.Main:AddSection("Links")

Tabs.Main:AddButton({
    Title = "Join our Discord",
    Description = "Copies our Discord invite link to your clipboard.",
    Callback = function()
        setclipboard("https://discord.gg/p65VYjZ9k3")
        Fluent:Notify({
            Title = "Copied",
            Content = "✅ Discord invite link copied to clipboard!",
            Duration = 5
        })
    end
})

Tabs.Main:AddSection("Credits")

Tabs.Main:AddParagraph({
    Title = "Credits",
    Content = [[
Special Thanks to:

- Chosentechies/Urmoit for creating YouHub.
- Community members for support and feedback.
]]
})

Tabs.Main:AddParagraph({
    Title = "Additional Credits",
    Content = [[
- Script contributors.
- Beta testers for providing feedback.
- Everyone involved in the development and testing process.
]]
})

Tabs.Main:AddButton({
    Title = "Copy Fluent Docs Link",
    Description = "Copies Fluent UI documentation link.",
    Callback = function()
        setclipboard("https://idontgiveaf.gitbook.io/fluent")
        Fluent:Notify({
            Title = "Copied",
            Content = "📘 Fluent UI docs link copied!",
            Duration = 5
        })
    end
})

-- == PLAYER TAB ==
local player = game.Players.LocalPlayer

-- Walk Speed
local SpeedSlider = Tabs.Movement:AddSlider("PlayerSpeedValue", {
    Title = "Walk Speed",
    Description = "Controls how fast your character moves.",
    Min = 16,
    Max = 100,
    Default = 16,
    Rounding = 0
})

Tabs.Movement:AddToggle("PlayerSpeedToggle", {
    Title = "Enable Speed Changer",
    Default = false
}):OnChanged(function(enabled)
    if enabled then
        task.spawn(function()
            while Options.PlayerSpeedToggle.Value do
                local character = player.Character or player.CharacterAdded:Wait()
                local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = Options.PlayerSpeedValue.Value
                end
                task.wait(0.1)
            end
        end)
    else
        local character = player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 16
        end
    end
end)

SpeedSlider:OnChanged(function(speed)
    if Options.PlayerSpeedToggle.Value then
        local character = player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = speed
        end
    end
end)

-- == SETTINGS TAB ==
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("YouHub")
SaveManager:SetFolder("YouHub/GrowAGarden")
InterfaceManager:BuildInterfaceSection(Tabs.Misc)
SaveManager:BuildConfigSection(Tabs.Misc)

-- == COMBAT TAB ==
-- ESP & Tracers (with team check)
-- (ESP code from before, but use Tabs.Combat instead of Tabs.ESP)
local espEnabled = false
local tracerEnabled = false
local espObjects = {}

local function clearESP()
    for _,v in pairs(espObjects) do
        if v.Box then v.Box:Remove() end
        if v.Tracer then v.Tracer:Remove() end
    end
    espObjects = {}
end

local function createESP(player)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    if espObjects[player] then return end
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = Color3.fromRGB(255, 0, 0)
    box.Thickness = 2
    box.Filled = false
    local tracer = Drawing.new("Line")
    tracer.Visible = false
    tracer.Color = Color3.fromRGB(255, 0, 0)
    tracer.Thickness = 2
    espObjects[player] = {Box = box, Tracer = tracer}
end

local function removeESP(player)
    if espObjects[player] then
        if espObjects[player].Box then espObjects[player].Box:Remove() end
        if espObjects[player].Tracer then espObjects[player].Tracer:Remove() end
        espObjects[player] = nil
    end
end

local function updateESP()
    if not (espEnabled or tracerEnabled) then clearESP() return end
    local camera = workspace.CurrentCamera
    local localPlayer = game.Players.LocalPlayer
    for _,player in pairs(game.Players:GetPlayers()) do
        if player ~= localPlayer and player.Team ~= localPlayer.Team and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChildOfClass("Humanoid") and player.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
            if not espObjects[player] then createESP(player) end
            local hrp = player.Character.HumanoidRootPart
            local pos, onScreen = camera:WorldToViewportPoint(hrp.Position)
            if onScreen then
                -- Box
                if espEnabled then
                    local size = Vector3.new(2, 5, 1.5) * player.Character.HumanoidRootPart.Size.Magnitude/2
                    local top = camera:WorldToViewportPoint(hrp.Position + Vector3.new(0, size.Y, 0))
                    local bottom = camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, size.Y, 0))
                    local box = espObjects[player].Box
                    box.Size = Vector2.new(math.abs(top.X - bottom.X), math.abs(top.Y - bottom.Y))
                    box.Position = Vector2.new(pos.X - box.Size.X/2, pos.Y - box.Size.Y/2)
                    box.Visible = true
                else
                    espObjects[player].Box.Visible = false
                end
                -- Tracer
                if tracerEnabled then
                    local tracer = espObjects[player].Tracer
                    tracer.From = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y)
                    tracer.To = Vector2.new(pos.X, pos.Y)
                    tracer.Visible = true
                else
                    espObjects[player].Tracer.Visible = false
                end
            else
                if espObjects[player].Box then espObjects[player].Box.Visible = false end
                if espObjects[player].Tracer then espObjects[player].Tracer.Visible = false end
            end
        else
            removeESP(player)
        end
    end
end

local runService = game:GetService("RunService")
local espConnection

Tabs.Combat:AddToggle("EnableESP", { Title = "Enable ESP", Default = false })
    :OnChanged(function(val)
        espEnabled = val
        if espEnabled or tracerEnabled then
            if not espConnection then
                espConnection = runService.RenderStepped:Connect(updateESP)
            end
        else
            if espConnection then espConnection:Disconnect() espConnection = nil end
            clearESP()
        end
    end)

Tabs.Combat:AddToggle("EnableTracers", { Title = "Enable Tracers", Default = false })
    :OnChanged(function(val)
        tracerEnabled = val
        if espEnabled or tracerEnabled then
            if not espConnection then
                espConnection = runService.RenderStepped:Connect(updateESP)
            end
        else
            if espConnection then espConnection:Disconnect() espConnection = nil end
            clearESP()
        end
    end)

game.Players.PlayerRemoving:Connect(removeESP)

-- Aimbot
local aimbotEnabled = false
local aimbotFOV = 100
local aimbotKey = Enum.UserInputType.MouseButton2
Tabs.Combat:AddToggle("AimbotEnabled", { Title = "Enable Aimbot", Default = false }):OnChanged(function(val) aimbotEnabled = val end)
Tabs.Combat:AddSlider("AimbotFOV", { Title = "Aimbot FOV", Min = 10, Max = 360, Default = 100, Rounding = 0 }):OnChanged(function(val) aimbotFOV = val end)
Tabs.Combat:AddDropdown("AimbotKey", { Title = "Aimbot Key", Values = {"Right Mouse Button", "Left Mouse Button", "E", "Q"}, Default = "Right Mouse Button" }):OnChanged(function(val)
    if val == "Right Mouse Button" then aimbotKey = Enum.UserInputType.MouseButton2
    elseif val == "Left Mouse Button" then aimbotKey = Enum.UserInputType.MouseButton1
    elseif val == "E" then aimbotKey = Enum.KeyCode.E
    elseif val == "Q" then aimbotKey = Enum.KeyCode.Q end
end)

-- Expand Hitboxes
local hitboxExpandEnabled = false
local hitboxSize = 5
local originalSizes = {}

Tabs.Combat:AddToggle("HitboxExpandEnabled", { Title = "Expand Enemy Hitboxes", Default = false }):OnChanged(function(val)
    hitboxExpandEnabled = val
    if not hitboxExpandEnabled then
        -- Restore original sizes
        for player, size in pairs(originalSizes) do
            if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.Size = size
                player.Character.HumanoidRootPart.Massless = false
            end
        end
        originalSizes = {}
    end
end)

Tabs.Combat:AddSlider("HitboxSize", { Title = "Hitbox Size", Min = 5, Max = 500, Default = 5, Rounding = 0 }):OnChanged(function(val)
    hitboxSize = val
end)

-- Hitbox expander logic
local function updateHitboxes()
    local localPlayer = game.Players.LocalPlayer
    for _,player in pairs(game.Players:GetPlayers()) do
        if player ~= localPlayer and player.Team ~= localPlayer.Team and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            if hitboxExpandEnabled then
                if not originalSizes[player] then
                    originalSizes[player] = hrp.Size
                end
                hrp.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                hrp.Massless = true
            else
                if originalSizes[player] then
                    hrp.Size = originalSizes[player]
                    hrp.Massless = false
                end
            end
        end
    end
end

game:GetService("RunService").RenderStepped:Connect(function()
    if hitboxExpandEnabled then
        updateHitboxes()
    end
end)

-- Kill All
Tabs.Combat:AddButton({
    Title = "Kill All Enemies",
    Description = "Teleports all enemies to you and kills them (if possible)",
    Callback = function()
        -- Kill all logic stub
    end
})

-- == MOVEMENT TAB ==
local infJumpEnabled = false
local noclipEnabled = false
local jumpPower = 50
Tabs.Movement:AddToggle("InfJumpEnabled", { Title = "Infinite Jump", Default = false }):OnChanged(function(val) infJumpEnabled = val end)
Tabs.Movement:AddToggle("NoclipEnabled", { Title = "Noclip", Default = false }):OnChanged(function(val) noclipEnabled = val end)
Tabs.Movement:AddSlider("JumpPower", { Title = "Jump Power", Min = 50, Max = 200, Default = 50, Rounding = 0 }):OnChanged(function(val) jumpPower = val end)
Tabs.Movement:AddSlider("PlayerSpeedValue", { Title = "Walk Speed", Min = 16, Max = 100, Default = 16, Rounding = 0 }):OnChanged(function(speed)
    if Options.PlayerSpeedToggle and Options.PlayerSpeedToggle.Value then
        local character = player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = speed
        end
    end
end)
Tabs.Movement:AddToggle("PlayerSpeedToggle", { Title = "Enable Speed Changer", Default = false }):OnChanged(function(enabled)
    if enabled then
        task.spawn(function()
            while Options.PlayerSpeedToggle.Value do
                local character = player.Character or player.CharacterAdded:Wait()
                local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = Options.PlayerSpeedValue.Value
                end
                task.wait(0.1)
            end
        end)
    else
        local character = player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 16
        end
    end
end)

-- Bunny Hop
local bunnyHopEnabled = false
Tabs.Movement:AddToggle("BunnyHopEnabled", { Title = "Bunny Hop", Default = false }):OnChanged(function(val) bunnyHopEnabled = val end)

-- No Fall Damage
local noFallDamageEnabled = false
Tabs.Movement:AddToggle("NoFallDamageEnabled", { Title = "No Fall Damage", Default = false }):OnChanged(function(val) noFallDamageEnabled = val end)

-- == MISC TAB ==
local antiAFKEnabled = false
Tabs.Misc:AddToggle("AntiAFKEnabled", { Title = "Anti-AFK", Default = false }):OnChanged(function(val) antiAFKEnabled = val end)

Window:SelectTab(1)
Fluent:Notify({
    Title = "YouHub | Grow a Garden",
    Content = "Script loaded with full Fluent UI integration.",
    Duration = 6
})

SaveManager:LoadAutoloadConfig()
