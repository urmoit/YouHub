local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ModernGUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

-- Main frame (window)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 400)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

-- Draggable support (Mobile + PC)
local dragInput, dragStart, startPos
local dragging = false

local function updateInput(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(
			mainFrame.Position.X.Scale,
			startPos.X.Offset + delta.X,
			mainFrame.Position.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end

mainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

mainFrame.InputChanged:Connect(updateInput)
game:GetService("UserInputService").InputChanged:Connect(updateInput)

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
header.Parent = mainFrame

-- Header Gradient
local headerGradient = Instance.new("UIGradient")
headerGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 25)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 60, 60))
}
headerGradient.Parent = header

-- Header label
local headerLabel = Instance.new("TextLabel")
headerLabel.Text = "Youhub UI Test"
headerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
headerLabel.BackgroundTransparency = 1
headerLabel.Font = Enum.Font.GothamBold
headerLabel.TextSize = 20
headerLabel.Size = UDim2.new(1, -40, 1, 0)
headerLabel.TextXAlignment = Enum.TextXAlignment.Left
headerLabel.Position = UDim2.new(0, 10, 0, 0)
headerLabel.Parent = header

-- Collapse Arrow button
local collapseArrow = Instance.new("TextButton")
collapseArrow.Size = UDim2.new(0, 30, 0, 30)
collapseArrow.Position = UDim2.new(1, -35, 0, 5)
collapseArrow.Text = "▼"
collapseArrow.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
collapseArrow.TextColor3 = Color3.fromRGB(255, 255, 255)
collapseArrow.Font = Enum.Font.GothamBold
collapseArrow.TextSize = 20
collapseArrow.Parent = header
collapseArrow.AutoButtonColor = false

-- Scrollable content frame
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -10, 1, -50)
scrollFrame.Position = UDim2.new(0, 5, 0, 45)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 6
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.Parent = mainFrame
scrollFrame.Visible = true

-- Layout inside scrollFrame
local contentLayout = Instance.new("UIListLayout")
contentLayout.Padding = UDim.new(0, 10)
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
contentLayout.Parent = scrollFrame

-- Auto update scroll height
scrollFrame.ChildAdded:Connect(function()
	task.wait()
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y)
end)

-- Example toggles
for i = 1, 5 do
	local cb = Instance.new("TextButton")
	cb.Size = UDim2.new(1, 0, 0, 40)
	cb.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	cb.TextColor3 = Color3.fromRGB(255, 255, 255)
	cb.Font = Enum.Font.Gotham
	cb.TextSize = 18
	cb.AutoButtonColor = false
	cb.Text = "Toggle Option " .. i
	cb.Parent = scrollFrame

	local toggled = false
	cb.MouseButton1Click:Connect(function()
		toggled = not toggled
		cb.BackgroundColor3 = toggled and Color3.fromRGB(70, 120, 70) or Color3.fromRGB(50, 50, 50)
		cb.Text = toggled and ("Toggle Option " .. i .. " ✔") or ("Toggle Option " .. i)
	end)
end

-- Collapse animation logic
local tweenService = game:GetService("TweenService")
local collapsed = false

collapseArrow.MouseButton1Click:Connect(function()
	collapsed = not collapsed
	collapseArrow.Text = collapsed and "▲" or "▼"

	local newHeight = collapsed and 40 or 400
	tweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, 250, 0, newHeight)
	}):Play()

	scrollFrame.Visible = not collapsed
end)

-- Show GUI button if collapsed
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 160, 0, 40)
toggleButton.Position = UDim2.new(0, 20, 0, 20)
toggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 18
toggleButton.Text = "Show GUI"
toggleButton.Parent = playerGui
toggleButton.Visible = false
toggleButton.AutoButtonColor = false

toggleButton.MouseEnter:Connect(function()
	toggleButton.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
end)
toggleButton.MouseLeave:Connect(function()
	toggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
end)

toggleButton.MouseButton1Click:Connect(function()
	screenGui.Enabled = true
	toggleButton.Visible = false
end)

-- Fully close GUI
header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton2 then
		screenGui.Enabled = false
		toggleButton.Visible = true
	end
end)
