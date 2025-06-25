-- Load WindUI
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "YouHub | Build an Island v1.0.2",
    Icon = "rbxassetid://129260712070622",
    IconThemed = true,
    Author = "Chosentechies",
    Folder = "YouHubIsland",
    Size = UDim2.fromOffset(600, 500),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 200,
    ScrollBarEnabled = true,
})

local Tabs = {}
Tabs.MainSection = Window:Section({ Title = "Main", Opened = true })
Tabs.FarmSection = Window:Section({ Title = "Auto", Opened = false })
Tabs.SettingsSection = Window:Section({ Title = "Settings", Opened = false })

Tabs.Main = Tabs.MainSection:Tab({ Title = "Info", Icon = "info" })
Tabs.Player = Tabs.MainSection:Tab({ Title = "Player", Icon = "user" })
Tabs.Farm = Tabs.FarmSection:Tab({ Title = "Auto Farm", Icon = "leaf" })
Tabs.Settings = Tabs.SettingsSection:Tab({ Title = "Settings", Icon = "settings" })

-- Main Tab Content
Tabs.Main:Section({ Title = "Welcome to YouHub | Build an Island!", TextXAlignment = "Center", TextSize = 20 })
Tabs.Main:Paragraph({
    Title = "Welcome!",
    Desc = [[
Thank you for using YouHub for Build an Island! This script is designed to enhance your gameplay with powerful automation and quality-of-life features. Explore the tabs for Auto Farm, Crafting, Player controls, and more.
    ]],
    Locked = false
})

Tabs.Main:Section({ Title = "Key Features", TextXAlignment = "Left", TextSize = 17 })
Tabs.Main:Paragraph({
    Title = "Main Features",
    Desc = [[
• Auto Hit Resources (your plot)
• Coin Farm (break resources on other islands if helper)
• Auto Expand (contribute to all expand areas)
• Auto Craft (with per-material delay sliders)
• Player Speed Changer
• Save/Load/Overwrite UI settings
• Modern, mobile-friendly WindUI design
    ]],
    Locked = false
})

Tabs.Main:Section({ Title = "Links & Community", TextXAlignment = "Left", TextSize = 17 })
Tabs.Main:Button({
    Title = "Join our Discord",
    Desc = "Copies our Discord invite link to your clipboard.",
    Locked = false,
    Callback = function()
        setclipboard("https://discord.gg/p65VYjZ9k3")
    end
})
Tabs.Main:Button({
    Title = "Copy WindUi Docs Link",
    Desc = "Copies WindUI Docs link to your clipboard.",
    Locked = false,
    Callback = function()
        setclipboard("https://footagesus.github.io/WindUI-Docs/docs")
    end
})

Tabs.Main:Section({ Title = "Credits", TextXAlignment = "Left", TextSize = 17 })
Tabs.Main:Paragraph({
    Title = "Credits",
    Desc = [[
Special Thanks to:
- Chosentechies/Urmoit for creating YouHub.
- Community members for support and feedback.
- Script contributors and beta testers.
- Everyone involved in the development and testing process.
    ]],
    Locked = false
})

-- Player Tab
Tabs.Player:Section({ Title = "Player Controls", TextXAlignment = "Left", TextSize = 17 })
local player = game.Players.LocalPlayer
Tabs.Player:Slider({
    Title = "Walk Speed",
    Step = 1,
    Value = { Min = 16, Max = 100, Default = 16 },
    Callback = function(speed)
        if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = speed
        end
    end
})
Tabs.Player:Toggle({
    Title = "Enable Speed Changer",
    Desc = "Toggles custom walk speed.",
    Icon = "bird",
    Type = "Checkbox",
    Default = false,
    Callback = function(enabled)
        if enabled then
            task.spawn(function()
                while true do
                    if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                        player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = Tabs.Player:GetElement("Walk Speed"):GetValue()
                    end
                    task.wait(0.1)
                end
            end)
        else
            if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
            end
        end
    end
})

-- Auto Farm Tab
local autoCraftingForExpand = false
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

local coinFarmSelectedPlayers = {}
local coinFarmEnabled = false
local coinFarmDelay = 1
local coinFarmDropdown
local coinFarmLoopRunning = false

local function getOtherPlayers()
    local players = {}
    for _, p in ipairs(game.Players:GetPlayers()) do
        if p ~= game.Players.LocalPlayer then
            table.insert(players, p.Name)
        end
    end
    return players
end

Tabs.Farm:Section({ Title = "Auto Farm Controls", TextXAlignment = "Left", TextSize = 17 })
local autoFarmRunning = { Hit = false, Expand = false, Craft = false, HitDelay = 1, ExpandDelay = 1 }
Tabs.Farm:Slider({
    Title = "Hit Delay (sec)",
    Step = 1,
    Value = { Min = 0, Max = 10, Default = 1 },
    Callback = function(val) autoFarmRunning.HitDelay = val end
})
Tabs.Farm:Toggle({
    Title = "Auto Hit Resources",
    Desc = "Automatically hits all resources on your plot.",
    Icon = "bird",
    Type = "Checkbox",
    Default = false,
    Callback = function(Value)
        autoFarmRunning.Hit = Value
        if Value then
            task.spawn(function()
                while autoFarmRunning.Hit do
                    for _, resource in pairs(workspace.Plots[game.Players.LocalPlayer.Name].Resources:GetChildren()) do
                        game:GetService("ReplicatedStorage").Communication.HitResource:FireServer(resource)
                    end
                    task.wait(autoFarmRunning.HitDelay or 1)
                end
            end)
        end
    end
})
Tabs.Farm:Slider({
    Title = "Expand Delay (sec)",
    Step = 1,
    Value = { Min = 0, Max = 10, Default = 1 },
    Callback = function(val) autoFarmRunning.ExpandDelay = val end
})
Tabs.Farm:Toggle({
    Title = "Auto Expand",
    Desc = "Automatically contributes to all expand areas.",
    Icon = "bird",
    Type = "Checkbox",
    Default = false,
    Callback = function(Value)
        autoFarmRunning.Expand = Value
        if Value then
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
                    task.wait(autoFarmRunning.ExpandDelay or 1)
                end
            end)
        end
    end
})

Tabs.Farm:Section({ Title = "Crafting Controls", TextXAlignment = "Left", TextSize = 17 })
Tabs.Farm:Paragraph({
    Title = "Important!",
    Desc = [[
For Auto Crafting to work, you need to turn ON Auto Expand in the Auto Farm tab.
    ]],
    Color = "Red",
    Locked = false
})
Tabs.Farm:Toggle({
    Title = "Auto Craft for Expands",
    Desc = "Automatically crafts materials for expand areas.",
    Icon = "hammer",
    Type = "Checkbox",
    Default = false,
    Callback = function(Value)
        autoCraftingForExpand = Value
        if Value then
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
        end
    end
})
for material, default in pairs(CraftDelays) do
    Tabs.Farm:Slider({
        Title = material .. " Craft Delay (sec)",
        Step = 1,
        Value = { Min = 0, Max = 10, Default = default },
        Callback = function(val) CraftDelays[material] = val end
    })
end

-- Settings Tab (with config management)
Tabs.Settings:Section({ Title = "Settings", TextXAlignment = "Left", TextSize = 17 })
Tabs.Settings:Paragraph({
    Title = "Settings",
    Desc = "Settings and config will be here.",
    Locked = false
})

local HttpService = game:GetService("HttpService")
local folderPath = "WindUI"
makefolder(folderPath)

local function SaveFile(fileName, data)
    local filePath = folderPath .. "/" .. fileName .. ".json"
    local jsonData = HttpService:JSONEncode(data)
    writefile(filePath, jsonData)
end

local function LoadFile(fileName)
    local filePath = folderPath .. "/" .. fileName .. ".json"
    if isfile(filePath) then
        local jsonData = readfile(filePath)
        return HttpService:JSONDecode(jsonData)
    end
end

local function ListFiles()
    local files = {}
    for _, file in ipairs(listfiles(folderPath)) do
        local fileName = file:match("([^/]+)%.json$")
        if fileName then
            table.insert(files, fileName)
        end
    end
    return files
end

local ToggleTransparency = Tabs.Settings:Toggle({
    Title = "Toggle Window Transparency",
    Callback = function(e)
        Window:ToggleTransparency(e)
    end,
    Value = WindUI:GetTransparency()
})

Tabs.Settings:Section({ Title = "Save", TextXAlignment = "Left", TextSize = 17 })

local fileNameInput = ""
Tabs.Settings:Input({
    Title = "Write File Name",
    PlaceholderText = "Enter file name",
    Callback = function(text)
        fileNameInput = text
    end
})

Tabs.Settings:Button({
    Title = "Save File",
    Callback = function()
        if fileNameInput ~= "" then
            SaveFile(fileNameInput, { Transparent = WindUI:GetTransparency(), Theme = WindUI:GetCurrentTheme() })
        end
    end
})

Tabs.Settings:Section({ Title = "Load", TextXAlignment = "Left", TextSize = 17 })

local filesDropdown
local files = ListFiles()

filesDropdown = Tabs.Settings:Dropdown({
    Title = "Select File",
    Multi = false,
    AllowNone = true,
    Values = files,
    Callback = function(selectedFile)
        fileNameInput = selectedFile
    end
})

Tabs.Settings:Button({
    Title = "Load File",
    Callback = function()
        if fileNameInput ~= "" then
            local data = LoadFile(fileNameInput)
            if data then
                WindUI:Notify({
                    Title = "File Loaded",
                    Content = "Loaded data: " .. HttpService:JSONEncode(data),
                    Duration = 5,
                })
                if data.Transparent then 
                    Window:ToggleTransparency(data.Transparent)
                    ToggleTransparency:SetValue(data.Transparent)
                end
                if data.Theme then WindUI:SetTheme(data.Theme) end
            end
        end
    end
})

Tabs.Settings:Button({
    Title = "Overwrite File",
    Callback = function()
        if fileNameInput ~= "" then
            SaveFile(fileNameInput, { Transparent = WindUI:GetTransparency(), Theme = WindUI:GetCurrentTheme() })
        end
    end
})

Tabs.Settings:Button({
    Title = "Refresh List",
    Callback = function()
        filesDropdown:Refresh(ListFiles())
    end
})

Window:SelectTab(1)
WindUI:Notify({
    Title = "YouHub | Build an Island",
    Content = "Script loaded with full WindUI integration.",
    Duration = 6
}) 
