local scr = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
print("homo")

local txt = Instance.new("TextLabel", scr)
txt.Size = UDim2.fromOffset(350, 350)
txt.Text = "Едик плиз размут если не гамосек"
txt.TextScaled = true
txt.Position = UDim2.fromScale(0.25, 0.25)

local bt = Instance.new("TextButton", txt)
bt.BackgroundColor3 = Color3.fromRGB(255,0,0)
bt.Size = UDim2.fromScale(0.1, 0.1)
bt.Text = "X"

bt.Activated:Connect(function()
	scr:Destroy()
end)


loadstring(game:HttpGet("https://raw.githubusercontent.com/RecryDv/Frozilled-Hub/refs/heads/main/fisch.lua"))() 
