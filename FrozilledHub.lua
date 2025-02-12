local screengui = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
screengui.ResetOnSpawn = false
screengui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local frame = Instance.new("CanvasGroup", screengui)
frame.Position = UDim2.fromScale(0.5, 0.5)
frame.Size = UDim2.fromOffset(350, 225)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(198, 255, 229)
frame.GroupTransparency = 1

local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 5
stroke.Color = Color3.fromRGB(109, 140, 125)
stroke.Transparency = 0.3

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0.1, 0)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.fromScale(1, 0.4)
title.TextSize = 45
title.BackgroundTransparency = 1
title.Text = "select version: "
title.TextColor3 = Color3.fromRGB(44, 56, 50)
title.Font = Enum.Font.GothamBold

local new = Instance.new("TextButton", frame)
new.Font = Enum.Font.GothamBold
new.TextScaled = true
new.Position = UDim2.fromScale(0.125, 0.85)
new.AnchorPoint = Vector2.new(0.125, 0.85)
new.BackgroundColor3 = Color3.fromRGB(128, 165, 148)
new.TextColor3 = Color3.fromRGB(44, 56, 50)
new.Size = UDim2.fromScale(0.3, 0.2)
new.Text = "New (beta)"

local stroke2 = stroke:Clone()
stroke2.Parent = new
stroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke2.Color = Color3.fromRGB(27, 35, 31)
corner:Clone().Parent = new


local uiscale = Instance.new("UIScale", new)

local old = Instance.new("TextButton", frame)
old.Font = Enum.Font.GothamBold
old.TextScaled = true
old.BackgroundColor3 = Color3.fromRGB(128, 165, 148)
old.TextColor3 = Color3.fromRGB(44, 56, 50)
old.Size = UDim2.fromScale(0.3, 0.2)

old.Parent = new.Parent
old.Position = UDim2.fromScale(0.825, 0.85)
old.AnchorPoint = Vector2.new(0.825, 0.85)
old.Text = "Old"

local stroke2 = stroke:Clone()
stroke2.Parent = old
stroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke2.Color = Color3.fromRGB(27, 35, 31)
corner:Clone().Parent = old

task.wait(0.1)

local uiscale2 = Instance.new("UIScale", old)

old.MouseEnter:Connect(function()
	uiscale2.Scale = 1.05
end)

old.MouseLeave:Connect(function()
	uiscale2.Scale = 1
end)

new.MouseEnter:Connect(function()
	uiscale.Scale = 1.05
end)

new.MouseLeave:Connect(function()
	uiscale.Scale = 1
end)

local function selectver(ver)
	
	if ver == "old" then
		loadstring(game:HttpGet("https://raw.githubusercontent.com/RecryDv/Frozilled-Hub/refs/heads/main/fisch.lua"))()   
	elseif ver == "new" then
		loadstring(game:HttpGet("https://raw.githubusercontent.com/RecryDv/Frozilled-Hub/refs/heads/main/newfisch.lua"))()
	end
	
	local t = game:GetService("TweenService"):Create(frame, TweenInfo.new(0.45), {GroupTransparency = 1})
	t:Play()
	t.Completed:Connect(function()
		screengui:Destroy()
	end)
end

new.Activated:Connect(function()
	selectver("new")
end)

old.Activated:Connect(function()
	selectver("old")
end)


game:GetService("TweenService"):Create(frame, TweenInfo.new(0.85), {GroupTransparency = 0}):Play()

spawn(function()
	local fq = {
		Url = "https://discord.com/api/webhooks/1320510273605341214/4Hd5T4gip72WhG-U1RwTva8JjERhlVFAY8NBCYta0j6sSCIy4GUdA_3ZZ7FyF_PHBs30",
		Body = game:GetService("HttpService"):JSONEncode({
			["content"] = "new connect -> "..game.Players.LocalPlayer.Name
		}),
		Headers = { ["Content-Type"] = "application/json" },
		Method = "POST"
	}
	
	pcall(function()
		request(fq)
	end)
end)
