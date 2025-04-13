local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "YouHub",
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
-- Home Tab
local homeTab = Window:CreateTab("Home", 4483362458)

-- Information about YouHub
local Paragraph = homeTab:CreateParagraph({
   Title = "YouHub Info",
   Content = [[
YouHub is a hub for multiple game-related scripts and tools. It provides easy access to automation features and other useful functionalities for players looking to enhance their gameplay experience.

Features:
- User-friendly interface.
- Supports multiple games.
- Customizable options to suit your needs.
- Regular updates and new features.
]]
})

-- Supported games list
local Paragraph = homeTab:CreateParagraph({
   Title = "YouHub Supported Games",
   Content = [[
- BGSI (BuggleGum Simulator Infinite) = Up to Date
- Additional games coming soon!
]]
})

-- Adding additional information if needed
local additionalInfo = homeTab:CreateParagraph({
   Title = "More Info",
   Content = [[
For more details about YouHub and its features, please visit our official documentation or join our community.
]]
})


-- Scripts Tab
local scriptsTab = Window:CreateTab("Scripts", 4483362458)

-- Button to execute the script
local Button = scriptsTab:CreateButton({
   Name = "Execute Main Script",
   Callback = function()
      -- Execute the script from the provided URL
      loadstring(game:HttpGet("https://raw.githubusercontent.com/urmoit/YouHub/refs/heads/main/Games/bgsi.lua"))()
   end,
})

-- Credit Tab
local creditTab = Window:CreateTab("credit", 4483362458)

-- Create a paragraph for the credit information
local creditParagraph = creditTab:CreateParagraph({
    Title = "Credits",
    Content = [[
Special Thanks to:

- Chosentechies for creating YouHub.
- Sirius for the Rayfield UI Library.
- The developers of BuggleGum Simulator for the game.
- Community members for support and feedback.
]]
})

-- Optionally, you can also add more specific credits or mention contributors
local additionalCredits = creditTab:CreateParagraph({
    Title = "Additional Credits",
    Content = [[
- Script contributors.
- Beta testers for providing feedback.
- Everyone involved in the development and testing process.
]]
})

-- Button to copy the Rayfield documentation link
local Button = creditTab:CreateButton({
   Name = "Copy Rayfield Docs Link",
   Callback = function()
      -- Copy Rayfield docs link to clipboard
      setclipboard("https://docs.sirius.menu/rayfield")
   end,
})
