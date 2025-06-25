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
Tabs.Crafting = Tabs.FarmSection:Tab({ Title = "Crafting", Icon = "hammer" })
Tabs.Settings = Tabs.SettingsSection:Tab({ Title = "Settings", Icon = "settings" })

-- Main Tab Content
Tabs.Main:Section({ Title = "Info", TextXAlignment = "Left", TextSize = 17 })
Tabs.Main:Paragraph({
    Title = "Build an Island v1.0.2 Testing 1 Opened",
    Desc = [[
- Build an Island v1.0.2 Testing 1 will be open 1 day
    ]],
    Locked = false
})
Tabs.Main:Paragraph({
    Title = "YouHub | Build an Island Functions",
    Desc = [[
Current Features:
- Auto Hit Resources
- Auto Expand
- Auto Craft: Log, Brick, Magmite, Magma Plank, Obsidian Glass, Mushroom Plank
- Individual delay sliders for each craftable material
- Player Speed Changer
- Warning and info paragraphs for better user guidance
- Improved toggle button UI and usability

More features are on the way! Stay tuned!
    ]],
    Locked = false
})
Tabs.Main:Paragraph({
    Title = "Changelog v1.0.2",
    Desc = [[
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
    ]],
    Locked = false
})
Tabs.Main:Section({ Title = "Links", TextXAlignment = "Left", TextSize = 17 })
Tabs.Main:Button({
    Title = "Join our Discord",
    Desc = "Copies our Discord invite link to your clipboard.",
    Locked = false,
    Callback = function()
        setclipboard("https://discord.gg/p65VYjZ9k3")
    end
})
Tabs.Main:Section({ Title = "Credits", TextXAlignment = "Left", TextSize = 17 })
Tabs.Main:Paragraph({
    Title = "Credits",
    Desc = [[
Special Thanks to:
- Chosentechies/Urmoit for creating YouHub.
- Community members for support and feedback.
    ]],
    Locked = false
})
Tabs.Main:Paragraph({
    Title = "Additional Credits",
    Desc = [[
- Script contributors.
- Beta testers for providing feedback.
- Everyone involved in the development and testing process.
    ]],
    Locked = false
})

Tabs.Main:Button({
    Title = "Copy WindUi Docs Link",
    Desc = "Copies WindUI Docs link to your clipboard.",
    Locked = false,
    Callback = function()
        setclipboard("https://footagesus.github.io/WindUI-Docs/docs")
    end
})

-- Auto Farm Tab
Tabs.Farm:Section({ Title = "Auto Farm Controls", TextXAlignment = "Left", TextSize = 17 })
Tabs.Farm:Dropdown({
    Title = "Select Players to break resources",
    Values = { "Category A", "Category B", "Category C" },
    Value = { "Category A" },
    Multi = true,
    AllowNone = true,
    Callback = function(option) 
        print("Categories selected: " .. game:GetService("HttpService"):JSONEncode(option)) 
    end
})
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

Tabs.Farm:Section({ Title = "Coin Farm", TextXAlignment = "Left", TextSize = 17 })

local coinFarmSelectedPlayers = {}
local coinFarmEnabled = false

local function getOtherPlayers()
    local players = {}
    for _, p in ipairs(game.Players:GetPlayers()) do
        if p ~= game.Players.LocalPlayer then
            table.insert(players, p.Name)
        end
    end
    return players
end

Tabs.Farm:Dropdown({
    Title = "Select Players to break resources (Coin Farm)",
    Values = getOtherPlayers(),
    Value = {},
    Multi = true,
    AllowNone = true,
    Callback = function(option)
        coinFarmSelectedPlayers = option
    end
})
Tabs.Farm:Paragraph({
    Title = "Important!",
    Desc = [[
To break resources on another player's island, they must have made you a helper on their plot. Only players who have made you a helper will allow you to break resources on their island.
    ]],
    Color = "Yellow",
    Locked = false
})
Tabs.Farm:Toggle({
    Title = "Enable Coin Farm",
    Desc = "Automatically breaks resources on selected players' islands (if you are a helper).",
    Icon = "coins",
    Type = "Checkbox",
    Default = false,
    Callback = function(Value)
        coinFarmEnabled = Value
        if Value then
            task.spawn(function()
                while coinFarmEnabled do
                    for _, playerName in ipairs(coinFarmSelectedPlayers) do
                        local plot = workspace.Plots:FindFirstChild(playerName)
                        if plot and plot:FindFirstChild("Resources") then
                            for _, resource in pairs(plot.Resources:GetChildren()) do
                                game:GetService("ReplicatedStorage").Communication.HitResource:FireServer(resource)
                            end
                        end
                    end
                    task.wait(autoFarmRunning.HitDelay or 1)
                end
            end)
        end
    end
})

-- Crafting Tab
Tabs.Crafting:Section({ Title = "Crafting Controls", TextXAlignment = "Left", TextSize = 17 })
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
Tabs.Crafting:Paragraph({
    Title = "Important!",
    Desc = [[
For Auto Crafting to work, you need to turn ON Auto Expand in the Auto Farm tab.
    ]],
    Color = "Red",
    Locked = false
})
Tabs.Crafting:Toggle({
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
    Tabs.Crafting:Slider({
        Title = material .. " Craft Delay (sec)",
        Step = 1,
        Value = { Min = 0, Max = 10, Default = default },
        Callback = function(val) CraftDelays[material] = val end
    })
end

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
