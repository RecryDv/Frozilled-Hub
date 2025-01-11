
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()



function build()
	local Window = Fluent:CreateWindow({
		Title = "Frozilled Hub [cool vitya petux]",
		SubTitle = "by sh0vel",
		TabWidth = 160,
		Size = UDim2.fromOffset(580, 360),
		Acrylic = true,
		Theme = "Dark",
		MinimizeKey = Enum.KeyCode.LeftControl
	})



	local function data(taskId, id, ...) 	
		local baseval = {
			auto_collect = false,
		}

		if taskId == "load" then

			getgenv().frozilledhub_loaded = true
			getgenv().frozilledhub_data = baseval
		elseif taskId == "get" then
			return getgenv().frozilledhub_data[id]
		elseif taskId == "update" then
			getgenv().frozilledhub_data[id] = ...
		end
	end


	local Options = Fluent.Options

	local Tabs = {
		cool = Window:AddTab({Title = "Cool Functions", Icon = "egg"})
	}
	
	Tabs.cool:AddButton({
		Title = "Unlock all eggs";
		
		Callback = function()
			for i,v in pairs(workspace.Eggs:GetChildren()) do
				v.Area.Value = 1
			end
		end,
	})
	
	local l = Tabs.cool:AddToggle({
		Title = "Auto collect orbs";
		Default = false
	})
	
	l:OnChanged(function(val)
		data("update", "auto_collect", val)
		
		spawn(function()
			while data("get", "auto_collect") do
				task.wait(0.05)
				for i,v in pairs(workspace.Drops:FindFirstChild(game.Players.LocalPlayer.Name)) do
					pcall(function()
						v.CanCollide = false
						v.CFrame = game.Players.LocalPlayer.Character.PrimaryPart.CFrame
					end)
				end
			end
		end)
	end)
	

end

build()
