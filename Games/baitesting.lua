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

Tabs.Main:Section({ Title = "What's New in v1.0.2", TextXAlignment = "Left", TextSize = 17 })
Tabs.Main:Paragraph({
    Title = "Changelog v1.0.2",
    Desc = [[
- Added Coin Farm section: select other players (not yourself),
info paragraph about helper requirement, and toggle to enable
breaking resources on their islands
- Added Coin Farm Delay slider to Coin Farm section
- Added Coin Farm Toggle to Coin Farm section
- Added Coin Farm Dropdown to Coin Farm section
- Changed the library from Fluent to WindUI for cleaner look
and better mobile support

More features are on the way! Stay tuned!
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
local speedToggle = false

local speedSlider = Tabs.Player:Slider({
    Title = "Walk Speed",
    Step = 1,
    Value = { Min = 16, Max = 100, Default = 16 },
    Callback = function(speed)
        if speedToggle and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
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
        speedToggle = enabled
        if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            if enabled then
                player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = speedSlider:GetValue()
            else
                player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
            end
        end
    end
})

-- Auto Farm Tab
Tabs.Farm:Section({ Title = "Auto Farm Controls", TextXAlignment = "Left", TextSize = 17 })
local autoFarmRunning = { Hit = false, Expand = false, Craft = false, HitDelay = 1, ExpandDelay = 1 }

local hitDelaySlider = Tabs.Farm:Slider({
    Title = "Hit Delay (sec)",
    Step = 1,
    Value = { Min = 0, Max = 10, Default = 1 },
    Callback = function(val) 
        autoFarmRunning.HitDelay = val 
    end
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
                while autoFarmRunning.Hit and task.wait(autoFarmRunning.HitDelay or 1) do
                    local plot = workspace.Plots:FindFirstChild(player.Name)
                    if plot and plot:FindFirstChild("Resources") then
                        for _, resource in pairs(plot.Resources:GetChildren()) do
                            pcall(function()
                                game:GetService("ReplicatedStorage").Communication.HitResource:FireServer(resource)
                            end)
                        end
                    end
                end
            end)
        end
    end
})

local expandDelaySlider = Tabs.Farm:Slider({
    Title = "Expand Delay (sec)",
    Step = 1,
    Value = { Min = 0, Max = 10, Default = 1 },
    Callback = function(val) 
        autoFarmRunning.ExpandDelay = val 
    end
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
                local replicatedStorage = game:GetService("ReplicatedStorage")
                while autoFarmRunning.Expand and task.wait(autoFarmRunning.ExpandDelay or 1) do
                    local plot = workspace.Plots:FindFirstChild(player.Name)
                    if plot and plot:FindFirstChild("Expand") then
                        for _,v in pairs(plot.Expand:GetChildren()) do
                            if v:FindFirstChild("Top") and v.Top:FindFirstChild("BillboardGui") then
                                for _,material in pairs(v.Top.BillboardGui:GetChildren()) do
                                    if replicatedStorage.Storage.Items:FindFirstChild(material.Name) then
                                        pcall(function()
                                            replicatedStorage.Communication.ContributeToExpand:FireServer(v.Name, material.Name, 1)
                                        end)
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
})

Tabs.Farm:Paragraph({ Title = "Coin Farm", TextSize = 17, Color = "Accent" })

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

Tabs.Farm:Paragraph({
    Title = "Important!",
    Desc = [[
To break resources on another player's island, they must have made you a helper on their plot. Only players who have made you a helper will allow you to break resources on their island.
    ]],
    Color = "Yellow",
    Locked = false
})

coinFarmDropdown = Tabs.Farm:Dropdown({
    Title = "Select Players to break resources (Coin Farm)",
    Values = getOtherPlayers(),
    Value = {},
    Multi = true,
    AllowNone = true,
    Callback = function(option)
        coinFarmSelectedPlayers = option
    end
})

Tabs.Farm:Button({
    Title = "Refresh Player List",
    Callback = function()
        local players = getOtherPlayers()
        coinFarmDropdown:Refresh(players)
        if #players == 0 then
            WindUI:Notify({
                Title = "Coin Farm",
                Content = "No other players available to select!",
                Duration = 4
            })
        end
    end
})

local coinFarmDelaySlider = Tabs.Farm:Slider({
    Title = "Coin Farm Delay (sec)",
    Step = 1,
    Value = { Min = 0, Max = 10, Default = 1 },
    Callback = function(val) 
        coinFarmDelay = val 
    end
})

Tabs.Farm:Toggle({
    Title = "Enable Coin Farm",
    Desc = "Automatically breaks resources on selected players' islands (if you are a helper).",
    Icon = "coins",
    Type = "Checkbox",
    Default = false,
    Callback = function(Value)
        if Value and coinFarmLoopRunning then
            WindUI:Notify({
                Title = "Coin Farm",
                Content = "Coin Farm is already running!",
                Duration = 3
            })
            return
        end
        
        coinFarmEnabled = Value
        if Value then
            coinFarmLoopRunning = true
            task.spawn(function()
                while coinFarmEnabled and task.wait(coinFarmDelay or 1) do
                    for _, playerName in ipairs(coinFarmSelectedPlayers) do
                        local plot = workspace.Plots:FindFirstChild(playerName)
                        if plot and plot:FindFirstChild("Resources") then
                            for _, resource in pairs(plot.Resources:GetChildren()) do
                                pcall(function()
                                    game:GetService("ReplicatedStorage").Communication.HitResource:FireServer(resource)
                                end)
                            end
                        end
                    end
                end
                coinFarmLoopRunning = false
            end)
        else
            coinFarmLoopRunning = false
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
                local replicatedStorage = game:GetService("ReplicatedStorage")
                local lastCrafted = {}
                
                while autoCraftingForExpand and task.wait(0.1) do
                    local plot = workspace.Plots:FindFirstChild(player.Name)
                    if plot and plot:FindFirstChild("Expand") and plot:FindFirstChild("Land") then
                        for _,v in pairs(plot.Expand:GetChildren()) do
                            if v:FindFirstChild("Top") and v.Top:FindFirstChild("BillboardGui") then
                                for _,material in pairs(v.Top.BillboardGui:GetChildren()) do
                                    local function getMaxAmount(material)
                                        local text = material.Amount.Text
                                        local parts = string.split(text, "/")
                                        if #parts >= 2 then
                                            return tonumber(parts[2]) or 0
                                        end
                                        return 0
                                    end
                                    
                                    local now = tick()
                                    local maxAmount = getMaxAmount(material)
                                    
                                    if material.Name == "Plank" and plot.Land:FindFirstChild("S13") and 
                                       plot.Land.S13:FindFirstChild("Crafter") and 
                                       plot.Land.S13.Crafter:FindFirstChild("Attachment") and
                                       plot.Land.S13.Crafter.Attachment:FindFirstChild("Stock") and
                                       plot.Land.S13.Crafter.Attachment.Stock.Value < maxAmount then
                                        if not lastCrafted["Plank"] or now - lastCrafted["Plank"] >= CraftDelays["Plank"] then
                                            pcall(function()
                                                replicatedStorage.Communication.Craft:FireServer(plot.Land.S13.Crafter.Attachment)
                                            end)
                                            lastCrafted["Plank"] = now
                                        end
                                    elseif material.Name == "Brick" and plot.Land:FindFirstChild("S24") and 
                                           plot.Land.S24:FindFirstChild("Crafter") and 
                                           plot.Land.S24.Crafter:FindFirstChild("Attachment") and
                                           plot.Land.S24.Crafter.Attachment:FindFirstChild("Stock") and
                                           plot.Land.S24.Crafter.Attachment.Stock.Value < maxAmount then
                                        if not lastCrafted["Brick"] or now - lastCrafted["Brick"] >= CraftDelays["Brick"] then
                                            pcall(function()
                                                replicatedStorage.Communication.Craft:FireServer(plot.Land.S24.Crafter.Attachment)
                                            end)
                                            lastCrafted["Brick"] = now
                                        end
                                    elseif material.Name == "Bamboo Plank" and plot.Land:FindFirstChild("S72") and 
                                               plot.Land.S72:FindFirstChild("Crafter") and 
                                               plot.Land.S72.Crafter:FindFirstChild("Attachment") and
                                               plot.Land.S72.Crafter.Attachment:FindFirstChild("Stock") and
                                               plot.Land.S72.Crafter.Attachment.Stock.Value < maxAmount then
                                        if not lastCrafted["Bamboo Plank"] or now - lastCrafted["Bamboo Plank"] >= CraftDelays["Bamboo Plank"] then
                                            pcall(function()
                                                replicatedStorage.Communication.Craft:FireServer(plot.Land.S72.Crafter.Attachment)
                                            end)
                                            lastCrafted["Bamboo Plank"] = now
                                        end
                                    elseif material.Name == "Cactus Fiber" and plot.Land:FindFirstChild("S54") and 
                                                   plot.Land.S54:FindFirstChild("Crafter") and 
                                                   plot.Land.S54.Crafter:FindFirstChild("Attachment") and
                                                   plot.Land.S54.Crafter.Attachment:FindFirstChild("Stock") and
                                                   plot.Land.S54.Crafter.Attachment.Stock.Value < maxAmount then
                                        if not lastCrafted["Cactus Fiber"] or now - lastCrafted["Cactus Fiber"] >= CraftDelays["Cactus Fiber"] then
                                            pcall(function()
                                                replicatedStorage.Communication.Craft:FireServer(plot.Land.S54.Crafter.Attachment)
                                            end)
                                            lastCrafted["Cactus Fiber"] = now
                                        end
                                    elseif material.Name == "Iron Bar" and plot.Land:FindFirstChild("S23") and 
                                                       plot.Land.S23:FindFirstChild("Crafter") and 
                                                       plot.Land.S23.Crafter:FindFirstChild("Attachment") and
                                                       plot.Land.S23.Crafter.Attachment:FindFirstChild("Stock") and
                                                       plot.Land.S23.Crafter.Attachment.Stock.Value < maxAmount then
                                        if not lastCrafted["Iron Bar"] or now - lastCrafted["Iron Bar"] >= CraftDelays["Iron Bar"] then
                                            pcall(function()
                                                replicatedStorage.Communication.DoubleCraft:FireServer(plot.Land.S23.Crafter.Attachment)
                                            end)
                                            lastCrafted["Iron Bar"] = now
                                        end
                                    elseif material.Name == "Magmite" and plot.Land:FindFirstChild("S106") and 
                                                           plot.Land.S106:FindFirstChild("Crafter") and 
                                                           plot.Land.S106.Crafter:FindFirstChild("Attachment") and
                                                           plot.Land.S106.Crafter.Attachment:FindFirstChild("Stock") and
                                                           plot.Land.S106.Crafter.Attachment.Stock.Value < maxAmount then
                                        if not lastCrafted["Magmite"] or now - lastCrafted["Magmite"] >= CraftDelays["Magmite"] then
                                            pcall(function()
                                                if plot.Land:FindFirstChild("S23") and plot.Land.S23:FindFirstChild("Crafter") and 
                                                   plot.Land.S23.Crafter:FindFirstChild("Attachment") then
                                                    replicatedStorage.Communication.DoubleCraft:FireServer(plot.Land.S23.Crafter.Attachment)
                                                end
                                                replicatedStorage.Communication.DoubleCraft:FireServer(plot.Land.S106.Crafter.Attachment)
                                            end)
                                            lastCrafted["Magmite"] = now
                                        end
                                    elseif material.Name == "Magma Plank" and plot.Land:FindFirstChild("S108") and 
                                                               plot.Land.S108:FindFirstChild("Crafter") and 
                                                               plot.Land.S108.Crafter:FindFirstChild("Attachment") and
                                                               plot.Land.S108.Crafter.Attachment:FindFirstChild("Stock") and
                                                               plot.Land.S108.Crafter.Attachment.Stock.Value < maxAmount then
                                        if not lastCrafted["Magma Plank"] or now - lastCrafted["Magma Plank"] >= CraftDelays["Magma Plank"] then
                                            pcall(function()
                                                replicatedStorage.Communication.Craft:FireServer(plot.Land.S108.Crafter.Attachment)
                                            end)
                                            lastCrafted["Magma Plank"] = now
                                        end
                                    elseif material.Name == "Obsidian Glass" and plot.Land:FindFirstChild("S134") and 
                                                                   plot.Land.S134:FindFirstChild("Crafter") and 
                                                                   plot.Land.S134.Crafter:FindFirstChild("Attachment") and
                                                                   plot.Land.S134.Crafter.Attachment:FindFirstChild("Stock") and
                                                                   plot.Land.S134.Crafter.Attachment.Stock.Value < maxAmount then
                                        if not lastCrafted["Obsidian Glass"] or now - lastCrafted["Obsidian Glass"] >= CraftDelays["Obsidian Glass"] then
                                            pcall(function()
                                                replicatedStorage.Communication.DoubleCraft:FireServer(plot.Land.S134.Crafter.Attachment)
                                            end)
                                            lastCrafted["Obsidian Glass"] = now
                                        end
                                    elseif material.Name == "Mushroom Plank" and plot.Land:FindFirstChild("S164") and 
                                                                       plot.Land.S164:FindFirstChild("Crafter") and 
                                                                       plot.Land.S164.Crafter:FindFirstChild("Attachment") and
                                                                       plot.Land.S164.Crafter.Attachment:FindFirstChild("Stock") and
                                                                       plot.Land.S164.Crafter.Attachment.Stock.Value < maxAmount then
                                        if not lastCrafted["Mushroom Plank"] or now - lastCrafted["Mushroom Plank"] >= CraftDelays["Mushroom Plank"] then
                                            pcall(function()
                                                replicatedStorage.Communication.Craft:FireServer(plot.Land.S164.Crafter.Attachment)
                                            end)
                                            lastCrafted["Mushroom Plank"] = now
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
})

-- Create sliders for each craft delay
for material, default in pairs(CraftDelays) do
    Tabs.Crafting:Slider({
        Title = material .. " Craft Delay (sec)",
        Step = 1,
        Value = { Min = 0, Max = 10, Default = default },
        Callback = function(val) 
            CraftDelays[material] = val 
        end
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
if not isfolder(folderPath) then
    makefolder(folderPath)
end

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
    return nil
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
local fileNameInputElement = Tabs.Settings:Input({
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
            SaveFile(fileNameInput, { 
                Transparent = WindUI:GetTransparency(), 
                Theme = WindUI:GetCurrentTheme(),
                WalkSpeed = speedSlider:GetValue(),
                SpeedToggle = speedToggle,
                AutoHit = autoFarmRunning.Hit,
                HitDelay = autoFarmRunning.HitDelay,
                AutoExpand = autoFarmRunning.Expand,
                ExpandDelay = autoFarmRunning.ExpandDelay,
                CoinFarmEnabled = coinFarmEnabled,
                CoinFarmDelay = coinFarmDelay,
                CoinFarmPlayers = coinFarmSelectedPlayers,
                AutoCraft = autoCraftingForExpand,
                CraftDelays = CraftDelays
            })
            WindUI:Notify({
                Title = "Settings Saved",
                Content = "Settings saved to " .. fileNameInput .. ".json",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "Error",
                Content = "Please enter a file name first",
                Duration = 3
            })
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
        fileNameInputElement:SetValue(selectedFile)
    end
})

Tabs.Settings:Button({
    Title = "Load File",
    Callback = function()
        if fileNameInput ~= "" then
            local data = LoadFile(fileNameInput)
            if data then
                -- Apply settings
                if data.Transparent ~= nil then 
                    Window:ToggleTransparency(data.Transparent)
                    ToggleTransparency:SetValue(data.Transparent)
                end
                if data.Theme then WindUI:SetTheme(data.Theme) end
                if data.WalkSpeed then speedSlider:SetValue(data.WalkSpeed) end
                if data.SpeedToggle ~= nil then 
                    Tabs.Player:GetElement("Enable Speed Changer"):SetValue(data.SpeedToggle)
                end
                if data.AutoHit ~= nil then 
                    Tabs.Farm:GetElement("Auto Hit Resources"):SetValue(data.AutoHit)
                    autoFarmRunning.Hit = data.AutoHit
                end
                if data.HitDelay then 
                    hitDelaySlider:SetValue(data.HitDelay)
                    autoFarmRunning.HitDelay = data.HitDelay
                end
                if data.AutoExpand ~= nil then 
                    Tabs.Farm:GetElement("Auto Expand"):SetValue(data.AutoExpand)
                    autoFarmRunning.Expand = data.AutoExpand
                end
                if data.ExpandDelay then 
                    expandDelaySlider:SetValue(data.ExpandDelay)
                    autoFarmRunning.ExpandDelay = data.ExpandDelay
                end
                if data.CoinFarmEnabled ~= nil then 
                    Tabs.Farm:GetElement("Enable Coin Farm"):SetValue(data.CoinFarmEnabled)
                    coinFarmEnabled = data.CoinFarmEnabled
                end
                if data.CoinFarmDelay then 
                    coinFarmDelaySlider:SetValue(data.CoinFarmDelay)
                    coinFarmDelay = data.CoinFarmDelay
                end
                if data.CoinFarmPlayers then 
                    coinFarmSelectedPlayers = data.CoinFarmPlayers
                    coinFarmDropdown:SetValue(data.CoinFarmPlayers)
                end
                if data.AutoCraft ~= nil then 
                    Tabs.Crafting:GetElement("Auto Craft for Expands"):SetValue(data.AutoCraft)
                    autoCraftingForExpand = data.AutoCraft
                end
                if data.CraftDelays then 
                    for material, delay in pairs(data.CraftDelays) do
                        if CraftDelays[material] then
                            CraftDelays[material] = delay
                            local slider = Tabs.Crafting:GetElement(material .. " Craft Delay (sec)")
                            if slider then
                                slider:SetValue(delay)
                            end
                        end
                    end
                end
                
                WindUI:Notify({
                    Title = "Settings Loaded",
                    Content = "Settings loaded from " .. fileNameInput,
                    Duration = 3
                })
            else
                WindUI:Notify({
                    Title = "Error",
                    Content = "Failed to load settings from " .. fileNameInput,
                    Duration = 3
                })
            end
        else
            WindUI:Notify({
                Title = "Error",
                Content = "Please select a file first",
                Duration = 3
            })
        end
    end
})

Tabs.Settings:Button({
    Title = "Overwrite File",
    Callback = function()
        if fileNameInput ~= "" then
            SaveFile(fileNameInput, { 
                Transparent = WindUI:GetTransparency(), 
                Theme = WindUI:GetCurrentTheme(),
                WalkSpeed = speedSlider:GetValue(),
                SpeedToggle = speedToggle,
                AutoHit = autoFarmRunning.Hit,
                HitDelay = autoFarmRunning.HitDelay,
                AutoExpand = autoFarmRunning.Expand,
                ExpandDelay = autoFarmRunning.ExpandDelay,
                CoinFarmEnabled = coinFarmEnabled,
                CoinFarmDelay = coinFarmDelay,
                CoinFarmPlayers = coinFarmSelectedPlayers,
                AutoCraft = autoCraftingForExpand,
                CraftDelays = CraftDelays
            })
            WindUI:Notify({
                Title = "Settings Saved",
                Content = "Settings overwritten in " .. fileNameInput .. ".json",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "Error",
                Content = "Please select a file first",
                Duration = 3
            })
        end
    end
})

Tabs.Settings:Button({
    Title = "Refresh List",
    Callback = function()
        files = ListFiles()
        filesDropdown:Refresh(files)
        if #files == 0 then
            WindUI:Notify({
                Title = "Info",
                Content = "No saved settings files found",
                Duration = 3
            })
        end
    end
})

Window:SelectTab(1)
WindUI:Notify({
    Title = "YouHub | Build an Island",
    Content = "Script loaded with full WindUI integration.",
    Duration = 6
})
