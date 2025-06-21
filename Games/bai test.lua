-- Load Fluent UI & Addons
local Fluent = loadstring(game:HttpGet("https://github.com/1dontgiveaf/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/1dontgiveaf/Fluent/main/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/1dontgiveaf/Fluent/main/Addons/InterfaceManager.lua"))()

-- Create Fluent UI window
local Window = Fluent:CreateWindow({
    Title = "YouHub | Build an Island",
    SubTitle = "by Chosentechies",
    TabWidth = 160,
    Size = UDim2.fromOffset(600, 500),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "info" }),
    AutoFarm = Window:AddTab({ Title = "Auto Farm", Icon = "leaf" }),
    Player = Window:AddTab({ Title = "Player", Icon = "user" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
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
    Title = "YouHub | Build an Island Functions",
    Content = [[
Current Features:
- Auto Hit Resources
- Auto Contribute\Expand
- Auto Craft Log
- Each one has its own delay slider
- Player Speed Changer

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

-- == AUTO FARM TAB ==
local autoFarmRunning = {
    Hit = false,
    Contribute = false,
    Craft = false
}

-- Hit Delay
local HitSlider = Tabs.AutoFarm:AddSlider("HitDelay", {
    Title = "Hit Delay (sec)",
    Min = 0,
    Max = 10,
    Default = 1,
    Rounding = 1
})

Tabs.AutoFarm:AddToggle("AutoHitResources", { Title = "Auto Hit Resources", Default = false })
    :OnChanged(function(Value)
        autoFarmRunning.Hit = Value
        task.spawn(function()
            while autoFarmRunning.Hit do
                for _, resource in pairs(workspace.Plots[game.Players.LocalPlayer.Name].Resources:GetChildren()) do
                    game:GetService("ReplicatedStorage").Communication.HitResource:FireServer(resource)
                end
                task.wait(Options.HitDelay.Value)
            end
        end)
    end)

-- Contribute Delay
local ContributeSlider = Tabs.AutoFarm:AddSlider("ContributeDelay", {
    Title = "Contribute Delay (sec)",
    Min = 0,
    Max = 10,
    Default = 1,
    Rounding = 1
})

Tabs.AutoFarm:AddToggle("AutoContribute", { Title = "Auto Contribute", Default = false })
    :OnChanged(function(Value)
        autoFarmRunning.Contribute = Value
        task.spawn(function()
            while autoFarmRunning.Contribute do
                for _, item in ipairs(game:GetService("ReplicatedStorage").Storage.Items:GetChildren()) do
                    for _, expand in pairs(workspace.Plots[game.Players.LocalPlayer.Name].Expand:GetChildren()) do
                        game:GetService("ReplicatedStorage").Communication.ContributeToExpand:FireServer(expand.Name, item.Name)
                    end
                end
                task.wait(Options.ContributeDelay.Value)
            end
        end)
    end)

-- Craft Delay
local CraftSlider = Tabs.AutoFarm:AddSlider("CraftDelay", {
    Title = "Craft Delay (sec)",
    Min = 0,
    Max = 10,
    Default = 1,
    Rounding = 1
})

Tabs.AutoFarm:AddToggle("AutoCraftLogs", { Title = "Auto Craft: Log", Default = false })
    :OnChanged(function(Value)
        autoFarmRunning.Craft = Value
        task.spawn(function()
            while autoFarmRunning.Craft do
                local ItemCraft = "Log, hay"
                for _, craft in pairs(workspace.Plots[game.Players.LocalPlayer.Name].Land:GetChildren()) do
                    if craft:IsA("Model") then
                        for _, vv in pairs(craft:GetChildren()) do
                            if vv:IsA("Part") and vv.Name == "Crafter" then
                                vv.Attachment:SetAttribute("CraftTime", 0)
                                if vv.Attachment:GetAttribute("Item1") == ItemCraft then
                                    game:GetService("ReplicatedStorage").Communication.Craft:FireServer(vv.Attachment)
                                end
                            end
                        end
                    end
                end
                task.wait(Options.CraftDelay.Value)
            end
        end)
    end)

-- == PLAYER TAB ==
local player = game.Players.LocalPlayer

-- Walk Speed
local SpeedSlider = Tabs.Player:AddSlider("PlayerSpeedValue", {
    Title = "Walk Speed",
    Description = "Controls how fast your character moves.",
    Min = 16,
    Max = 100,
    Default = 16,
    Rounding = 0
})

Tabs.Player:AddToggle("PlayerSpeedToggle", {
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
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)
Fluent:Notify({
    Title = "YouHub | Grow a Garden",
    Content = "Script loaded with full Fluent UI integration.",
    Duration = 6
})

SaveManager:LoadAutoloadConfig()
