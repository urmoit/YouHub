local ScreenGui = Instance.new("ScreenGui")
local TopBar = Instance.new("Frame")
local TitleLabel = Instance.new("TextLabel")
local Sidebar = Instance.new("Frame")
local MainContent = Instance.new("Frame")
local BottomBar = Instance.new("Frame")
local WelcomeLabel = Instance.new("TextLabel")

local function createButton(name, parent, position)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(1, 0, 0, 50)
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.Text = name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.SourceSans
    button.TextSize = 24
    button.Parent = parent
    return button
end

local function createLabel(name, parent, position, text)
    local label = Instance.new("TextLabel")
    label.Name = name
    label.Size = UDim2.new(1, 0, 0, 50)
    label.Position = position
    label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 24
    label.Parent = parent
    return label
end

local function createParagraph(name, parent, position, text)
    local paragraph = Instance.new("TextLabel")
    paragraph.Name = name
    paragraph.Size = UDim2.new(1, 0, 0, 100)
    paragraph.Position = position
    paragraph.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    paragraph.BackgroundTransparency = 1
    paragraph.Text = text
    paragraph.TextColor3 = Color3.fromRGB(255, 255, 255)
    paragraph.Font = Enum.Font.SourceSans
    paragraph.TextSize = 18
    paragraph.TextWrapped = true
    paragraph.Parent = parent
    return paragraph
end

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

TopBar.Size = UDim2.new(1, 0, 0, 50)
TopBar.Position = UDim2.new(0, 0, 0, 0)
TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TopBar.Parent = ScreenGui

TitleLabel.Size = UDim2.new(1, 0, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "ZapHub | Pet Simulator 99!"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 24
TitleLabel.Parent = TopBar

Sidebar.Size = UDim2.new(0, 200, 1, -50)
Sidebar.Position = UDim2.new(0, 0, 0, 50)
Sidebar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Sidebar.Parent = ScreenGui

local buttons = {
    "Home", "Current Event", "Webhook", "Optimization", 
    "Auto Farm", "Egg", "Auto Quest", "Mailbox", 
    "Main", "Automatic"
}

for i, name in ipairs(buttons) do
    createButton(name, Sidebar, UDim2.new(0, 0, 0, (i-1) * 50))
end

MainContent.Size = UDim2.new(1, -200, 1, -50)
MainContent.Position = UDim2.new(0, 200, 0, 50)
MainContent.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MainContent.Parent = ScreenGui

createLabel("CreditsTitle", MainContent, UDim2.new(0, 0, 0, 0), "Credits")
createParagraph("CreditsParagraph", MainContent, UDim2.new(0, 0, 0, 50), "The creators of ZapHub are zap.xyz and t0nit.")
local copyDiscordButton = createButton("CopyDiscordButton", MainContent, UDim2.new(0, 0, 0, 150))
copyDiscordButton.Text = "Copy Discord Server Invite"

createLabel("PremiumTitle", MainContent, UDim2.new(0, 0, 0, 200), "ZapHub Premium")
createParagraph("PremiumParagraph", MainContent, UDim2.new(0, 0, 0, 250), "ZapHub also has a Premium version, which is Keyless and includes extra OP features.")
local copyPremiumButton = createButton("CopyPremiumButton", MainContent, UDim2.new(0, 0, 0, 350))
copyPremiumButton.Text = "Copy ZapHub Premium Shop"

BottomBar.Size = UDim2.new(1, 0, 0, 50)
BottomBar.Position = UDim2.new(0, 0, 1, -50)
BottomBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
BottomBar.Parent = ScreenGui

WelcomeLabel.Size = UDim2.new(1, 0, 1, 0)
WelcomeLabel.BackgroundTransparency = 1
WelcomeLabel.Text = "Welcome, Player_XXXX"
WelcomeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
WelcomeLabel.Font = Enum.Font.SourceSans
WelcomeLabel.TextSize = 24
WelcomeLabel.Parent = BottomBar

-- Add UICorner for rounded corners
local function addUICorner(instance)
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 10)
    uiCorner.Parent = instance
end

addUICorner(TopBar)
addUICorner(Sidebar)
addUICorner(MainContent)
addUICorner(BottomBar)
