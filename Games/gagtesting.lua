-- Load Fluent UI & Addons
local Fluent = loadstring(game:HttpGet("https://github.com/1dontgiveaf/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/1dontgiveaf/Fluent/main/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/1dontgiveaf/Fluent/main/Addons/InterfaceManager.lua"))()

-- Create Fluent UI window
local Window = Fluent:CreateWindow({
    Title = "YouHub | Build an Island v1.0.1",
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
    Crafting = Window:AddTab({ Title = "Crafting", Icon = "hammer" }),
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
- Auto Expand
- Auto Craft Log
- Each one has its own delay slider
- Player Speed Changer

More features are on the way! Stay tuned!
]]
})

Tabs.Main:AddParagraph({
    Title = "YouHub | Build an Island Changelog v1.0.1",
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

-- == AUTO FARM TAB ==
local autoFarmRunning = {
    Hit = false,
    Expand = false,
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

-- Expand Delay
local ExpandSlider = Tabs.AutoFarm:AddSlider("ExpandDelay", {
    Title = "Expand Delay (sec)",
    Min = 0,
    Max = 10,
    Default = 1,
    Rounding = 1
})

Tabs.AutoFarm:AddToggle("AutoExpand", { Title = "Auto Expand", Default = false })
    :OnChanged(function(Value)
        autoFarmRunning.Expand = Value
        task.spawn(function()
            while autoFarmRunning.Expand do
                for _, item in ipairs(game:GetService("ReplicatedStorage").Storage.Items:GetChildren()) do
                    for _, expand in pairs(workspace.Plots[game.Players.LocalPlayer.Name].Expand:GetChildren()) do
                        game:GetService("ReplicatedStorage").Communication.ExpandToExpand:FireServer(expand.Name, item.Name)
                    end
                end
                task.wait(Options.ExpandDelay.Value)
            end
        end)
    end)

-- == CRAFTING TAB ==
local autoCraftingRunning = false

local CraftSlider = Tabs.Crafting:AddSlider("CraftDelay", {
    Title = "Craft Delay (sec)",
    Min = 0,
    Max = 10,
    Default = 1,
    Rounding = 1
})

-- New: Individual toggles for each material
local autoCraftMaterial = {
    Plank = false,
    Brick = false,
    ["Bamboo Plank"] = false,
    ["Cactus Fiber"] = false,
    ["Iron Bar"] = false,
    Magmite = false,
    ["Magma Plank"] = false,
    ["Obsidian Glass"] = false,
    ["Mushroom Plank"] = false
}

local replicatedStorage = game:GetService("ReplicatedStorage")
local player = game.Players.LocalPlayer
local plot = workspace.Plots[player.Name]

local function getMaxAmount(material)
    return tonumber(string.split(material.Amount.Text, "/")[2])
end

local function startAutoCraft(materialName, toggleKey, craftFunc)
    Tabs.Crafting:AddToggle(toggleKey, { Title = "Auto Craft: " .. materialName, Default = false })
        :OnChanged(function(Value)
            autoCraftMaterial[materialName] = Value
            task.spawn(function()
                while autoCraftMaterial[materialName] do
                    craftFunc()
                    task.wait(Options.CraftDelay.Value)
                end
            end)
        end)
end

-- Plank
startAutoCraft("Plank", "AutoCraftPlank", function()
    local material = plot.Land.S13.Crafter.Attachment
    local stock = material.Stock.Value
    local max = getMaxAmount(material)
    if stock < max then
        replicatedStorage.Communication.Craft:FireServer(material)
    end
end)

-- Brick
startAutoCraft("Brick", "AutoCraftBrick", function()
    local material = plot.Land.S24.Crafter.Attachment
    local stock = material.Stock.Value
    local max = getMaxAmount(material)
    if stock < max then
        replicatedStorage.Communication.Craft:FireServer(material)
    end
end)

-- Bamboo Plank
startAutoCraft("Bamboo Plank", "AutoCraftBambooPlank", function()
    local material = plot.Land.S72.Crafter.Attachment
    local stock = material.Stock.Value
    local max = getMaxAmount(material)
    if stock < max then
        replicatedStorage.Communication.Craft:FireServer(material)
    end
end)

-- Cactus Fiber
startAutoCraft("Cactus Fiber", "AutoCraftCactusFiber", function()
    local material = plot.Land.S54.Crafter.Attachment
    local stock = material.Stock.Value
    local max = getMaxAmount(material)
    if stock < max then
        replicatedStorage.Communication.Craft:FireServer(material)
    end
end)

-- Iron Bar
startAutoCraft("Iron Bar", "AutoCraftIronBar", function()
    local material = plot.Land.S23.Crafter.Attachment
    local stock = material.Stock.Value
    local max = getMaxAmount(material)
    if stock < max then
        replicatedStorage.Communication.DoubleCraft:FireServer(material)
    end
end)

-- Magmite
startAutoCraft("Magmite", "AutoCraftMagmite", function()
    local mat23 = plot.Land.S23.Crafter.Attachment
    local mat106 = plot.Land.S106.Crafter.Attachment
    local stock23 = mat23.Stock.Value
    local stock106 = mat106.Stock.Value
    local max23 = getMaxAmount(mat23)
    local max106 = getMaxAmount(mat106)
    if stock23 < max23 then
        replicatedStorage.Communication.DoubleCraft:FireServer(mat23)
    end
    if stock106 < max106 then
        replicatedStorage.Communication.DoubleCraft:FireServer(mat106)
    end
end)

-- Magma Plank
startAutoCraft("Magma Plank", "AutoCraftMagmaPlank", function()
    local material = plot.Land.S108.Crafter.Attachment
    local stock = material.Stock.Value
    local max = getMaxAmount(material)
    if stock < max then
        replicatedStorage.Communication.Craft:FireServer(material)
    end
end)

-- Obsidian Glass
startAutoCraft("Obsidian Glass", "AutoCraftObsidianGlass", function()
    local material = plot.Land.S134.Crafter.Attachment
    local stock = material.Stock.Value
    local max = getMaxAmount(material)
    if stock < max then
        replicatedStorage.Communication.DoubleCraft:FireServer(material)
    end
end)

-- Mushroom Plank
startAutoCraft("Mushroom Plank", "AutoCraftMushroomPlank", function()
    local material = plot.Land.S164.Crafter.Attachment
    local stock = material.Stock.Value
    local max = getMaxAmount(material)
    if stock < max then
        replicatedStorage.Communication.Craft:FireServer(material)
    end
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
