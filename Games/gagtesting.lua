-- Load Fluent UI & Addons
local Fluent = loadstring(game:HttpGet("https://github.com/1dontgiveaf/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/1dontgiveaf/Fluent/main/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/1dontgiveaf/Fluent/main/Addons/InterfaceManager.lua"))()

-- Create Fluent UI window
local Window = Fluent:CreateWindow({
    Title = "YouHub | Build an Island v1.0.1 Testing 1",
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
Toggle.Size = UDim2.new(0, 140, 0, 45)--size of the toggle (increased width)
Toggle.Font = Enum.Font.SourceSans
Toggle.Text = "Close Youhub"
Toggle.TextColor3 = Color3.fromRGB(203, 122, 49)
Toggle.TextSize = 19.000
Toggle.Draggable = true
Toggle.MouseButton1Click:Connect(function()
    IsOpen = not IsOpen

    if IsOpen then
        Toggle.Text = "Close Youhub"
        Fluent.GUI.Enabled = true  -- Show full Fluent UI
		print(Fluent.GUI, Fluent.GUI.ClassName)  -- Should print: Instance and "ScreenGui"
    else
        Toggle.Text = "Open Youhub"
        Fluent.GUI.Enabled = false -- Hide full Fluent UI
    end
end)

local Options = Fluent.Options

-- == MAIN TAB CONTENT ==
Tabs.Main:AddSection("Info")

Tabs.Main:AddParagraph({
    Title = "⚠️ Warnings",
    Content = [[
- Important to read! The ONLY way to open and close the UI is to use the toggle button at the side/bottom. If you click the close button on the header, you won't be able to open the UI again.
]]
})

Tabs.Main:AddParagraph({
    Title = "Build an Island v1.0.1 Testing 1 Opened",
    Content = [[
- Build an Island v1.0.1 Testing 1 will be open 1 day
]]
})

Tabs.Main:AddParagraph({
    Title = "YouHub | Build an Island Functions",
    Content = [[
Current Features:
- Auto Hit Resources
- Auto Expand
- Auto Craft: Log, Brick, Magmite, Magma Plank, Obsidian Glass, Mushroom Plank
- Individual delay sliders for each craftable material
- Player Speed Changer
- Warning and info paragraphs for better user guidance
- Improved toggle button UI and usability

More features are on the way! Stay tuned!
]]
})

Tabs.Main:AddParagraph({
    Title = "YouHub | Build an Island Changelog v1.0.1 Testing 1",
    Content = [[
Current Features:
- Added Crafting Tab
- Added Auto Craft for: Brick, Magmite, Magma Plank, Obsidian Glass, Mushroom Plank
- Added individual delay sliders for each craftable material
- Added warning and important info paragraphs to Main and Crafting tabs
- Improved toggle button UI and usability
- Changed Contribute to Expand logic
- Moved Crafting to Crafting Tab
- Updated UI text and warnings for better clarity

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
            local player = game.Players.LocalPlayer
            local replicatedStorage = game:GetService("ReplicatedStorage")
            local plot = workspace.Plots[player.Name]
            while autoFarmRunning.Expand do
                for _,v in pairs(plot.Expand:GetChildren()) do
                    for _,material in pairs(plot.Expand[v.Name].Top.BillboardGui:GetChildren()) do
                        if replicatedStorage.Storage.Items:FindFirstChild(material.Name) then
                            replicatedStorage.Communication.ContributeToExpand:FireServer(v.Name, material.Name, 1)
                        end
                    end
                end
                task.wait(Options.ExpandDelay.Value)
            end
        end)
    end)

-- == CRAFTING TAB ==
local autoCraftingForExpand = false

-- Individual delay sliders for each craftable material
local CraftDelays = {
    ["Plank"] = 1,
    ["Brick"] = 1,
    ["Bamboo Plank"] = 1,
    ["Cactus Fiber"] = 1,
    ["Iron Bar"] = 1,
    ["Magmite"] = 1,
    ["Magma Plank"] = 1,
    ["Obsidian Glass"] = 1,
    ["Mushroom Plank"] = 1
}

Tabs.Crafting:AddParagraph({
    Title = "Important!",
    Content = [[
For Auto Crafting to work, you need to turn ON Auto Expand in the Auto Farm tab.
]]
})

Tabs.Crafting:AddToggle("AutoCraftForExpand", { Title = "Auto Craft for Expands", Default = false })
    :OnChanged(function(Value)
        autoCraftingForExpand = Value
        task.spawn(function()
            local player = game.Players.LocalPlayer
            local replicatedStorage = game:GetService("ReplicatedStorage")
            local plot = workspace.Plots[player.Name]
            local lastCrafted = {}
            while autoCraftingForExpand do
                for _,v in pairs(plot.Expand:GetChildren()) do
                    for _,material in pairs(plot.Expand[v.Name].Top.BillboardGui:GetChildren()) do
                        local function getMaxAmount(material)
                            return tonumber(string.split(material.Amount.Text, "/")[2])
                        end
                        local now = tick()
                        if material.Name == "Plank" and plot.Land.S13.Crafter.Attachment.Stock.Value < getMaxAmount(material) then
                            if not lastCrafted["Plank"] or now - lastCrafted["Plank"] >= CraftDelays["Plank"] then
                                replicatedStorage.Communication.Craft:FireServer(plot.Land.S13.Crafter.Attachment)
                                lastCrafted["Plank"] = now
                            end
                        elseif material.Name == "Brick" and plot.Land.S24.Crafter.Attachment.Stock.Value < getMaxAmount(material) then
                            if not lastCrafted["Brick"] or now - lastCrafted["Brick"] >= CraftDelays["Brick"] then
                                replicatedStorage.Communication.Craft:FireServer(plot.Land.S24.Crafter.Attachment)
                                lastCrafted["Brick"] = now
                            end
                        elseif material.Name == "Bamboo Plank" and plot.Land.S72.Crafter.Attachment.Stock.Value < getMaxAmount(material) then
                            if not lastCrafted["Bamboo Plank"] or now - lastCrafted["Bamboo Plank"] >= CraftDelays["Bamboo Plank"] then
                                replicatedStorage.Communication.Craft:FireServer(plot.Land.S72.Crafter.Attachment)
                                lastCrafted["Bamboo Plank"] = now
                            end
                        elseif material.Name == "Cactus Fiber" and plot.Land.S54.Crafter.Attachment.Stock.Value < getMaxAmount(material) then
                            if not lastCrafted["Cactus Fiber"] or now - lastCrafted["Cactus Fiber"] >= CraftDelays["Cactus Fiber"] then
                                replicatedStorage.Communication.Craft:FireServer(plot.Land.S54.Crafter.Attachment)
                                lastCrafted["Cactus Fiber"] = now
                            end
                        elseif material.Name == "Iron Bar" and plot.Land.S23.Crafter.Attachment.Stock.Value < getMaxAmount(material) then
                            if not lastCrafted["Iron Bar"] or now - lastCrafted["Iron Bar"] >= CraftDelays["Iron Bar"] then
                                replicatedStorage.Communication.DoubleCraft:FireServer(plot.Land.S23.Crafter.Attachment)
                                lastCrafted["Iron Bar"] = now
                            end
                        elseif material.Name == "Magmite" and plot.Land.S106.Crafter.Attachment.Stock.Value < getMaxAmount(material) then
                            if not lastCrafted["Magmite"] or now - lastCrafted["Magmite"] >= CraftDelays["Magmite"] then
                                replicatedStorage.Communication.DoubleCraft:FireServer(plot.Land.S23.Crafter.Attachment)
                                replicatedStorage.Communication.DoubleCraft:FireServer(plot.Land.S106.Crafter.Attachment)
                                lastCrafted["Magmite"] = now
                            end
                        elseif material.Name == "Magma Plank" and plot.Land.S108.Crafter.Attachment.Stock.Value < getMaxAmount(material) then
                            if not lastCrafted["Magma Plank"] or now - lastCrafted["Magma Plank"] >= CraftDelays["Magma Plank"] then
                                replicatedStorage.Communication.Craft:FireServer(plot.Land.S108.Crafter.Attachment)
                                lastCrafted["Magma Plank"] = now
                            end
                        elseif material.Name == "Obsidian Glass" and plot.Land.S134.Crafter.Attachment.Stock.Value < getMaxAmount(material) then
                            if not lastCrafted["Obsidian Glass"] or now - lastCrafted["Obsidian Glass"] >= CraftDelays["Obsidian Glass"] then
                                replicatedStorage.Communication.DoubleCraft:FireServer(plot.Land.S134.Crafter.Attachment)
                                lastCrafted["Obsidian Glass"] = now
                            end
                        elseif material.Name == "Mushroom Plank" and plot.Land.S164.Crafter.Attachment.Stock.Value < getMaxAmount(material) then
                            if not lastCrafted["Mushroom Plank"] or now - lastCrafted["Mushroom Plank"] >= CraftDelays["Mushroom Plank"] then
                                replicatedStorage.Communication.Craft:FireServer(plot.Land.S164.Crafter.Attachment)
                                lastCrafted["Mushroom Plank"] = now
                            end
                        end
                    end
                end
                task.wait(0.1)
            end
        end)
    end)

local CraftSliders = {}
for material, default in pairs(CraftDelays) do
    CraftSliders[material] = Tabs.Crafting:AddSlider("CraftDelay_"..material:gsub(" ",""), {
        Title = material.." Craft Delay (sec)",
        Min = 0,
        Max = 10,
        Default = default,
        Rounding = 1
    })
    CraftSliders[material]:OnChanged(function(val)
        CraftDelays[material] = val
    end)
end


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
