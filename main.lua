local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()



function build()
	local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()


	local Window = Fluent:CreateWindow({
		Title = "Frozilled Hub [IQ Test]",
		SubTitle = "by sh0vel",
		TabWidth = 160,
		Size = UDim2.fromOffset(580, 360),
		Acrylic = true,
		Theme = "Dark",
		MinimizeKey = Enum.KeyCode.LeftControl
	})
	
	
	
	local function data(taskId, id, ...) 	
		local baseval = {
			
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
	
	data("load")
	
	local Options = Fluent.Options
	
	local Tabs = {
		Games = Window:AddTab({ Title = "Games", Icon = "gamepad-2"}),
		Links = Window:AddTab({Title = "Links", Icon = "link"})
	}
	
	Tabs.Games:AddButton({
		Title = "Frozilled Hub for game 'IQ Test 🧠'";
		
		Callback = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/RecryDv/Frozilled-Hub/refs/heads/main/iqtestscript.lua"))()
		end,
	})
	
	
	Tabs.Links:AddButton({
		Title = "Copy discord server link";
		
		Callback = function()
			setclipboard("https://discord.gg/4BwEb2HN2U")
			
			Fluent:Notify({
				Title = "Frozilled Hub",
				Content = "Link copied to your clipboard!",
				SubContent = "", -- Optional
				Duration = 2.5 -- Set to nil to make the notification not disappear
			})

		end,
	})
	
	

	
	


	
	
	Window:SelectTab(1)
end

build()

