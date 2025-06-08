local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.Name = "YouHubUI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Drag Function (Supports Mouse and Touch)
local function makeDraggable(frame)
	local dragToggle, dragInput, dragStart, startPos

	local function update(input)
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end

	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragToggle = true
			dragStart = input.Position
			startPos = frame.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragToggle = false
				end
			end)
		end
	end)

	frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	game:GetService("UserInputService").InputChanged:Connect(function(input)
		if input == dragInput and dragToggle then
			update(input)
		end
	end)
end

-- Core UI Structure
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(0, 600, 0, 50)
TopBar.Position = UDim2.new(0.5, -300, 0.1, 0)
TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TopBar.Parent = ScreenGui
TopBar.Active = true
TopBar.Draggable = false
makeDraggable(TopBar)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "YouHub | Pet Simulator 99!"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 22
TitleLabel.Parent = TopBar

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 150, 1, -50)
Sidebar.Position = UDim2.new(0, 0, 0, 50)
Sidebar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Sidebar.Parent = TopBar

local MainContent = Instance.new("Frame")
MainContent.Size = UDim2.new(1, -150, 1, -100)
MainContent.Position = UDim2.new(0, 150, 0, 50)
MainContent.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MainContent.Parent = TopBar

local BottomBar = Instance.new("Frame")
BottomBar.Size = UDim2.new(1, 0, 0, 50)
BottomBar.Position = UDim2.new(0, 0, 1, -50)
BottomBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
BottomBar.Parent = TopBar

local WelcomeLabel = Instance.new("TextLabel")
WelcomeLabel.Size = UDim2.new(1, 0, 1, 0)
WelcomeLabel.BackgroundTransparency = 1
WelcomeLabel.Text = "Welcome, " .. LocalPlayer.Name
WelcomeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
WelcomeLabel.Font = Enum.Font.SourceSans
WelcomeLabel.TextSize = 20
WelcomeLabel.Parent = BottomBar

-- Reusable UI Components
local function createButton(name, parent, pos, text)
	local button = Instance.new("TextButton")
	button.Name = name
	button.Size = UDim2.new(1, -10, 0, 40)
	button.Position = pos
	button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	button.Text = text or name
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Font = Enum.Font.SourceSans
	button.TextSize = 20
	button.Parent = parent
	local corner = Instance.new("UICorner", button)
	corner.CornerRadius = UDim.new(0, 6)
	return button
end

local function createLabel(name, parent, pos, text)
	local label = Instance.new("TextLabel")
	label.Name = name
	label.Size = UDim2.new(1, -10, 0, 30)
	label.Position = pos
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.Font = Enum.Font.SourceSansBold
	label.TextSize = 22
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = parent
	return label
end

local function createParagraph(name, parent, pos, text)
	local paragraph = Instance.new("TextLabel")
	paragraph.Name = name
	paragraph.Size = UDim2.new(1, -10, 0, 60)
	paragraph.Position = pos
	paragraph.BackgroundTransparency = 1
	paragraph.Text = text
	paragraph.TextColor3 = Color3.fromRGB(255, 255, 255)
	paragraph.Font = Enum.Font.SourceSans
	paragraph.TextSize = 18
	paragraph.TextWrapped = true
	paragraph.TextXAlignment = Enum.TextXAlignment.Left
	paragraph.TextYAlignment = Enum.TextYAlignment.Top
	paragraph.Parent = parent
	return paragraph
end

-- Sidebar Buttons
local buttonNames = {
	"Home", "Event", "Webhook", "Optimization",
	"Auto Farm", "Egg", "Quest", "Mailbox", "Main", "Auto"
}

for i, name in ipairs(buttonNames) do
	createButton(name, Sidebar, UDim2.new(0, 5, 0, 5 + (i - 1) * 45), name)
end

-- Main Content
createLabel("CreditsTitle", MainContent, UDim2.new(0, 5, 0, 10), "Credits")
createParagraph("CreditsParagraph", MainContent, UDim2.new(0, 5, 0, 45), "YouHub is made by Chosentechies, the owner of YouHub. Thanks for using this custom GUI!")

local discordBtn = createButton("DiscordButton", MainContent, UDim2.new(0, 5, 0, 120), "Copy Discord Server Invite")
discordBtn.MouseButton1Click:Connect(function()
	setclipboard("https://discord.gg/youhub") -- change if needed
end)

createLabel("PremiumLabel", MainContent, UDim2.new(0, 5, 0, 170), "YouHub Premium")
createParagraph("PremiumParagraph", MainContent, UDim2.new(0, 5, 0, 205), "Premium offers a keyless version of YouHub with OP features.")

local shopBtn = createButton("PremiumShop", MainContent, UDim2.new(0, 5, 0, 280), "Copy Premium Shop Link")
shopBtn.MouseButton1Click:Connect(function()
	setclipboard("https://shop.youhub.xyz") -- change if needed
end)
