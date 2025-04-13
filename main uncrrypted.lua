local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "YouHub | BuggleGum Simulator Infinite",
   Icon = 0,
   LoadingTitle = "YouHub is loading...",
   LoadingSubtitle = "by Chosentechies",
   Theme = "Default",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "Big Hub"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = false,
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"Hello"}
   }
})

-- Home Tab
local homeTab = Window:CreateTab("Home", 4483362458)
local Paragraph = homeTab:CreateParagraph({
   Title = "YouHub | BuggleGum Simulator Infinite Functions",
   Content = [[
- Auto Chew
- Auto Chew Fast
- Auto Sell 2x Prize

More functions coming soon!
]]
})

-- Auto Farm Tab
local autofarmTab = Window:CreateTab("Auto Farm", 4483362458)

-- Auto Chew Toggle
autofarmTab:CreateToggle({
    Name = "Auto Chew",
    CurrentValue = false,
    Flag = "AutoChewToggle",
    Callback = function(Value)
        if Value then
            -- Loop for Auto Chew
            task.spawn(function()
                while true do
                    task.wait(1)
                    local args = {
                        "BlowBubble"
                    }
                    game:GetService("ReplicatedStorage")
                        :WaitForChild("Shared")
                        :WaitForChild("Framework")
                        :WaitForChild("Network")
                        :WaitForChild("Remote")
                        :WaitForChild("Event"):FireServer(unpack(args))
                end
            end)
        end
    end,
})

-- Auto Chew Fast Toggle
autofarmTab:CreateToggle({
    Name = "Auto Chew Fast",
    CurrentValue = false,
    Flag = "AutoChewFastToggle",
    Callback = function(Value)
        if Value then
            -- Loop for Auto Chew Fast
            task.spawn(function()
                while true do
                    task.wait(0.1)
                    local args = {
                        "BlowBubble"
                    }
                    game:GetService("ReplicatedStorage")
                        :WaitForChild("Shared")
                        :WaitForChild("Framework")
                        :WaitForChild("Network")
                        :WaitForChild("Remote")
                        :WaitForChild("Event"):FireServer(unpack(args))
                end
            end)
        end
    end,
})

-- Auto Sell 2x Prize Toggle
autofarmTab:CreateToggle({
    Name = "Auto sell 2x prize",
    CurrentValue = false,
    Flag = "AutoSell2xToggle",
    Callback = function(Value)
        if Value then
            -- Loop for auto sell
            task.spawn(function()
                while true do
                    task.wait(1)
                    local args = {
                        "SellBubble"
                    }
                    game:GetService("ReplicatedStorage")
                        :WaitForChild("Shared")
                        :WaitForChild("Framework")
                        :WaitForChild("Network")
                        :WaitForChild("Remote")
                        :WaitForChild("Event"):FireServer(unpack(args))
                end
            end)
        end
    end,
})

-- teleport Tab
local teleportTab = Window:CreateTab("Teleport", 4483362458)
local Label = teleportTab:CreateLabel("Teleport Coming Soon", 4483362458, Color3.fromRGB(0, 0, 0), false) -- Title, Icon, Color, IgnoreTheme

-- Credit Tab
local creditTab = Window:CreateTab("credit", 4483362458)
