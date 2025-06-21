local KeyGuardLibrary = loadstring(game:HttpGet("https://cdn.keyguardian.org/library/v1.0.0.lua"))()
local trueData = "103a48c0ad684b8581516178b4fb682b"
local falseData = "56fb167d53c6485f95a51ef50c77ab26"

KeyGuardLibrary.Set({
	publicToken = "50f9992d281641e980d5c85634a35d12",
	privateToken = "6906f5b7ea034a0192d3911e232c5d2c",
	trueData = trueData,
	falseData = falseData,
})

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local key = "40b98905d74a450fb205f0f8ff2fd788"

local Window = Fluent:CreateWindow({
		Title = "Key System",
		SubTitle = "youhub keysys",
		TabWidth = 160,
		Size = UDim2.fromOffset(580, 340),
		Acrylic = false,
		Theme = "Dark",
		MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
		KeySys = Window:AddTab({ Title = "Key System", Icon = "key" }),
}

local Entkey = Tabs.KeySys:AddInput("Input", {
		Title = "Enter Key",
		Description = "Enter Key Here",
		Default = "",
		Placeholder = "Enter key…",
		Numeric = false,
		Finished = false,
		Callback = function(Value)
				key = Value
		end
})

local Checkkey = Tabs.KeySys:AddButton({
		Title = "Check Key",
		Description = "Enter Key before pressing this button",
		Callback = function()
				local response = KeyGuardLibrary.validateDefaultKey(key)
				if response == trueData then
						print("Key is valid")
						-- Your code here
				else
						print("Key is invalid")
				end
		end
})

local Getkey = Tabs.KeySys:AddButton({
		Title = "Get Key",
		Description = "Get Key here",
		Callback = function()
				setclipboard(KeyGuardLibrary.getLink())
		end
})

Window:SelectTab(1)
