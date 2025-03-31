local function build()


	local GuiService = game:GetService("GuiService")

	local WindUI = loadstring(game:HttpGet("https://tree-hub.vercel.app/api/UI/WindUI"))()

	local Window = WindUI:CreateWindow({
		Title = "Frozilled Hub | Fisch",
		Icon = "fish",
		Author = "by sh0vel",
		ToggleKey = Enum.KeyCode.Delete,
		Folder = "FrozilledHub",
		Size = UDim2.fromOffset(680, 460),
		Transparent = false,
		Theme = "Dark",
		SideBarWidth = 200,
		HasOutline = true,
		Closed = true,
	})


	local Core = {
		Player = game.Players.LocalPlayer,
		Cache = Instance.new("Folder"),
		Connections = {
			Enchant = {},
			UI = {},
		},
		SavingsPath = "frozilledhub/fisch.lol"
	}

	Core.PlayerStats = workspace.PlayerStats:FindFirstChild(Core.Player.Name).T:FindFirstChild(Core.Player.Name)
	Core.Character = Core.Player.Character or Core.Player.CharacterAdded:Wait()

	local last = {}


	function Core.ProcessData(id, ...)
		local isDebug = false
		local baseValue = {
			selected_location = "",
			optimization = false,
			walkspeed = 16,
			amount = 0,
			autobaitcrate = false,
			autoqualitybatecrate = false,
			superbaitcrate = false,
			sellfishname = "",
			autosell = false,
			enchantfishname = "",
			ignore_fav = false,
			ignore_mutated = false,
			ignore_sparkling = false,
			mutations_allowed = {},
			autoenchant = false,
			trade_player = nil,
			multi_trade = false,
			auto_trade = false,
			auto_accept_trade = false,
			teleport_player = nil,
			teleport_coord = {
				x = 0,
				y = 0,
				z = 0,
			},
			menu_transparency = false,
			custom_fov = false,
			camera_fov = 70,
			customambient = false,
			ambient_color = Color3.fromRGB(255,255,255),
			remove_notification = false,
			AutoFarm = {
				EnabledAutoFarm = false,

				AutoEquip = false,
				AutoCast = false,
				AutoShake = false,
				AutoReel = false,
				LockShake = false,
				AnchorPlayer = false,
			},
		}

		local no_savings = true


		local function apply(new)
			if no_savings then
				last = new
				return
			end

			getgenv().ldata = new
		end
		if id == "load" then
			if isDebug and _G.FroziledHubLoaded ~= true then

				_G.ldata = baseValue
				_G.FroziledHubLoaded = true

				return _G.ldata
			elseif not isDebug then
				if no_savings then
					last = baseValue
					getgenv().ldata = baseValue
					getgenv().FroziledHubLoaded = true
					return
				end
				
				getgenv().ldata = baseValue
				getgenv().FroziledHubLoaded = true

				local function gettruevalue(val)
					if val == "true" or val == "false" then
						if val == "true" then return true else return false end
					end


					local suc, ret = pcall(function()
						local c = string.gsub(val, " ", ""):split(",")
						if #c > 1 then
							print(val)
							return Color3.new(tonumber(c[1]), tonumber(c[2]), tonumber(c[3]))
						elseif #c == 1 then
							return tonumber(val)
						end
					end)

					if suc then
						return ret
					end

					return val
				end

				local s, err = pcall(function()
					local data = readfile(Core.SavingsPath)
					local clone = table.clone(baseValue)

					for i,v in pairs(data:split("\n")) do
						local id = string.split(v, "=")[1]
						local val = string.split(v, "=")[2]
						if clone[id] == nil then
							for tid,v2 in pairs(clone) do
								if typeof(v2) == "table" then
									clone[tid][id] = gettruevalue(val)
								end
							end
						elseif clone[id] ~= nil then
							clone[id] = gettruevalue(val)
						end
					end

					getgenv().ldata = clone
				end)

				if not s then
					getgenv().ldata = baseValue
				end

				return getgenv().ldata
			end
		elseif id == "getprocess" then
			if no_savings then
				return last
			end
			if isDebug then
				return _G.ldata
			end

			return getgenv().ldata
		elseif id == "get" then
			local dataslot = ...
			local process = Core.ProcessData("getprocess")

			return process[dataslot]
		elseif id == "update" then
			local dataslot = {...}
			local process = Core.ProcessData("getprocess")
			process = table.clone(process)

			process[dataslot[1]] = dataslot[2]

			apply(process)
		elseif id == "gettable" then
			local data = {...}
			local id = data[1]
			local id2 = data[2]

			local process = Core.ProcessData("getprocess")
			process = table.clone(process)

			return process[id][id2]
		elseif id == "updatetable" then
			local data = {...}
			local tablename = data[1]
			local id = data[2]
			local val = data[3]

			local process = Core.ProcessData("getprocess")
			process = table.clone(process)

			process[tablename][id] = val
			apply(process)
		elseif id == "save" then
			local converted = ""
			local path = Core.SavingsPath
			local tb = Core.ProcessData("getprocess")
			local function convert(i, v)
				if typeof(v) ~= "table" then
					converted = string.format("%s\n%s=%s", converted, tostring(i), tostring(v))
				end
			end
			for i,v in pairs(tb) do
				if typeof(v) ~= "table" then
					convert(i, v)
				else
					for i,v in pairs(v) do
						convert(i,v)
					end
				end
			end
			writefile(path, converted)
		end
	end

	spawn(function()
		Core.ProcessData("load")
	end)
	repeat 
		task.wait(0.1)
	until getgenv().FroziledHubLoaded == true


	local world = workspace:FindFirstChild("world")

	local Data = {
		Locations = {},
		CustomLocations = {
			Rods = {
				["rod of the depths"] = CFrame.new(1698, -887, 1433),
				["rod of the exalted one"] = CFrame.new(2233,-804,1030),
			},
			NPC = {
				["merchant"] = CFrame.new(464,151,230),
				["merlin"] = CFrame.new(-928,225,-995),
				["appraiser"] = CFrame.new(448,150,206)
			},
			Other = {
				["baitcrate1"] = CFrame.new(384,137,339),
				["baitcrate2"] = CFrame.new(-173,143,1929),
				["blueenergycrystal"] = CFrame.new(20124.8,213,5449.3)
			}
		},
		Mutations = {
			"Amber",
			"Albino",
			"Frozen",
			"Scorched",
			"Translucent",
			"Negative",
			"Darkened",
			"Electric",
			"Mosaic",
			"Glossy",
			"Greedy",
			"Hexed",
			"Silver",
			"Sinister",
			"Midas",
			"Ghastly",
			"Purified",
			"Lunar",
			"Fossilized",
			"Solarblaze",
			"Atlantean",
			"Revitalized",
			"Abyssal",
			"Nuclear",
			"Sunken",
			"Mythical",
			"Aurora",
		}
	}

	table.sort(Data.Mutations, function(a, b)
		return a < b
	end)

	function Core.Teleport(cframe)
		local suc, err = pcall(function()
			Core.Player.Character.HumanoidRootPart.CFrame = cframe
		end)
	end

	function Core.GetPlayers()
		local list = {}

		for i,v in pairs(game:GetService("Players"):GetPlayers()) do
			if v.UserId ~= Core.Player.UserId then
				table.insert(list, v.Name)
			end
		end

		return list
	end

	function Core.HaveItem(id)
		local tool = nil

		pcall(function()
			if Core.Player.Backpack:FindFirstChild(id) then
				tool = Core.Player.Backpack:FindFirstChild(id)
			end

			if Core.Character:FindFirstChild(id) then
				tool = Core.Character:FindFirstChild(id)
			end
		end)

		return tool
	end

	function Core.SetupDropdownPlayers(dropdown)
		spawn(function()
			local players = Core.GetPlayers()
			dropdown:Refresh(players)
		end)
	end

	function Core.Notify(text)
		WindUI:Notify({
			Title = "Frozilled Hub",
			Content = text,
			Icon = "droplet-off",
			Duration = 5,
		})
	end


	function Core.KeyPress(key)
		game:GetService("VirtualInputManager"):SendKeyEvent(true, key, false, Core.Player.PlayerGui)
		task.wait()
		game:GetService("VirtualInputManager"):SendKeyEvent(false, key, false, Core.Player.PlayerGui)
	end

	function Core.Equip(tool)
		game:GetService("ReplicatedStorage"):WaitForChild("packages"):WaitForChild("Net"):WaitForChild("RE/Backpack/Equip"):FireServer(tool)
	end

	function Core.TeleportCustom(id1, id2)
		local cframe = Data.CustomLocations[id1][id2]
		Core.Teleport(cframe)
	end

	function Core.ReserveTeleport(data)
		local suc, ret = pcall(function()
			local cframe = data

			if typeof(cframe) == "table" then
				cframe = Data.CustomLocations[cframe[1]][cframe[2]]
			end

			local old_cframe = Core.Player.Character.HumanoidRootPart.CFrame
			task.wait()
			Core.Teleport(cframe)
			return {
				Back = function()
					Core.Teleport(old_cframe)
				end,
			}
		end)


		if ret == nil then
			ret = {
				Back = function() end
			}
		end

		return ret
	end

	for i,v in pairs(world:FindFirstChild("spawns"):FindFirstChild("TpSpots"):GetChildren()) do
		table.insert(Data.Locations, v.Name)
	end

	table.sort(Data.Locations, function(a, b)
		return a < b
	end)



	local Tabs = {
		Player = Window:Tab({Title = "Player", Icon = "user"}),
		World = Window:Tab({Title = "World", Icon = "earth"}),
		div = Window:Divider(),
		AutoFarm = Window:Tab({Title = "Auto Farm", Icon = "tractor"}),
		Inventory = Window:Tab({Title = "Inventory", Icon = "backpack"}),
		Rods = Window:Tab({Title = "Rods", Icon = "box"}),
		Sell = Window:Tab({Title = "Sell", Icon = "wallet"}),
		Shop = Window:Tab({Title = "Shop", Icon = "shopping-cart"}),
		Trade = Window:Tab({Title = "Trade", Icon = "user-check"}),
		Teleport = Window:Tab({Title = "Teleport", Icon = "map-pin"}),
		Optimization = Window:Tab({Title = "Optimization", Icon = "cpu"}),
	}

	Tabs.AutoFarm:Toggle({
		Title = "Enable auto farm",
		Default = Core.ProcessData("gettable", "AutoFarm", "EnabledAutoFarm"),

		Callback = function(val)
			Core.ProcessData("updatetable", "AutoFarm", "EnabledAutoFarm", val)
		end,
	})

	Tabs.AutoFarm:Section({
		Title = "Auto Farm Settings"
	})

	Tabs.AutoFarm:Toggle({
		Title = "Auto equip rod",
		Default = Core.ProcessData("gettable", "AutoFarm", "AutoEquip"),

		Callback = function(val)
			Core.ProcessData("updatetable", "AutoFarm", "AutoEquip", val)
		end,
	})


	Tabs.AutoFarm:Toggle({
		Title = "Auto Cast",
		Default = Core.ProcessData("gettable", "AutoFarm", "AutoCast"),

		Callback = function(val)
			Core.ProcessData("updatetable", "AutoFarm", "AutoCast", val)
		end,
	})

	Tabs.AutoFarm:Toggle({
		Title = "Auto Shake",
		Default = Core.ProcessData("gettable", "AutoFarm", "AutoShake"),

		Callback = function(val)
			Core.ProcessData("updatetable", "AutoFarm", "AutoShake", val)
		end,
	})

	Tabs.AutoFarm:Toggle({
		Title = "Auto Reel",
		Default = Core.ProcessData("gettable", "AutoFarm", "AutoReel"),

		Callback = function(val)
			Core.ProcessData("updatetable", "AutoFarm", "AutoReel", val)
		end,
	})

	Tabs.AutoFarm:Toggle({
		Title = "Lock Shake button in center",
		Default = Core.ProcessData("gettable", "AutoFarm", "LockShake"),

		Callback = function(val)
			Core.ProcessData("updatetable", "AutoFarm", "LockShake", val)
		end,
	})

	Tabs.AutoFarm:Toggle({
		Title = "Anchor Player",
		Default = Core.ProcessData("gettable", "AutoFarm", "AnchorPlayer"),

		Callback = function(val)
			Core.ProcessData("updatetable", "AutoFarm", "AnchorPlayer", val)

			if not val then
				pcall(function()
					Core.Player.Character.PrimaryPart.Anchored = false
				end)
			end
		end,
	})

	Tabs.World:Section({
		Title = "Camera"
	})

	Tabs.World:Toggle({
		Title = "Custom FOV",
		Default = Core.ProcessData("get", "custom_fov"),

		Callback = function(val)
			Core.ProcessData("update", "custom_fov", val)

			if not val then
				workspace.CurrentCamera.FieldOfView = 70
			end
		end,
	})

	Tabs.World:Slider({
		Title = "FOV",
		Value = {
			Min = 1,
			Max = 120,
			Default = Core.ProcessData("get", "camera_fov"),
		},

		Callback = function(val)
			Core.ProcessData("update", "camera_fov", val)
		end,
	})

	Tabs.World:Section({
		Title = "Ambient"
	})

	Tabs.World:Toggle({
		Title = "Custom Ambient",
		Default = Core.ProcessData("get", "customambient"),

		Callback = function(val)
			Core.ProcessData("get", "customambient", val)
		end,
	})

	Tabs.World:Colorpicker({
		Title = "Ambient Color",
		Default = Core.ProcessData("get", "ambient_color"),

		Callback = function(val)
			Core.ProcessData("update", "ambient_color", val)
		end,
	})


	Window:Divider()
	Tabs.Settings = Window:Tab({Title = "Settings", Icon = "app-window"})
	Tabs.Settings:Section({Title = "Menu"})
	Tabs.Settings:Toggle({
		Title = "Menu Transparency",

		Default = Core.ProcessData("get", "menu_transparency"),
		Callback = function(val)
			Window:ToggleTransparency(val)
			Core.ProcessData("get", "menu_transparency", val)
		end,
	})

	Tabs.Configuration = Window:Tab({Title = "Configuration", Icon = "settings"})


	Window:ToggleTransparency(Core.ProcessData("get", "menu_transparency"))

	Tabs.Rods:Section({
		Title = "Heaven's Rod"
	})

	Tabs.Rods:Button({
		Title = "Get Blue Energy Crystal",

		Callback = function()
			pcall(function()
				if Core.HaveItem("Blue Energy Crystal") ~= nil then
					Core.Notify("You already have blue energy crystal!")
					return
				end

				Core.Notify("Teleporting to crystal..")
				Core.TeleportCustom("Other", "blueenergycrystal")

				local can_mine = false

				repeat
					task.wait(0.5)
					local pickaxe = Core.HaveItem("Pickaxe")
					if pickaxe ~= nil then
						if pickaxe.Parent == Core.Player.Backpack then
							Core.Equip(pickaxe)
						end

						pickaxe:Activate()

						local crystal = workspace:WaitForChild("world"):WaitForChild("map"):WaitForChild("Northern Summit") 
						for i,v in pairs(crystal:GetChildren()) do
							if v:FindFirstChild("Root") and v:FindFirstChild("Root"):FindFirstChild("Prompt") then
								local prompt = v.Root.Prompt
								prompt.HoldDuration = 0
							end
						end

						Core.KeyPress(Enum.KeyCode.E)
					end

					task.wait(0.5)
					if Core.HaveItem("Blue Energy Crystal") ~= nil then
						can_mine = true 
					end
					Core.Notify("Trying to mine crystal..")
				until can_mine == true

				Core.Notify("Done.")
			end)
		end,
	})

	Tabs.Trade:Section({
		Title = "Auto Trade"
	})

	local trade_pt = Tabs.Trade:Dropdown({
		Title = "Trade Player",
		Values = {},
		Multi = false,

		Callback = function(val)
			pcall(function()
				if val ~= nil and game:GetService("Players"):FindFirstChild(val) then
					Core.ProcessData("update", "trade_player", game:GetService("Players"):FindFirstChild(val))
				end
			end)
		end,
	})

	Tabs.Trade:Button({
		Title = "Refresh player list",

		Callback = function()
			Core.SetupDropdownPlayers(trade_pt)
		end,
	})

	Core.SetupDropdownPlayers(trade_pt)

	Tabs.Trade:Toggle({
		Title = "Trade player fish in hand",
		Default = Core.ProcessData("get", "auto_trade"),

		Callback = function(val)
			Core.ProcessData("update", "auto_trade", val)
		end,
	})

	Tabs.Trade:Toggle({
		Title = "Multi Trade",
		Default = Core.ProcessData("get", "multi_trade"),

		Callback = function(val)
			Core.ProcessData("update", "multi_trade", val)
		end,
	})

	Tabs.Trade:Section({
		Title = "Auto Accept Trade"
	})

	Tabs.Trade:Toggle({
		Title = "Auto Accept Trade",
		Default = Core.ProcessData("get", "auto_accept_trade"),

		Callback = function(val)
			Core.ProcessData("update", "auto_accept_trade", val)
		end,
	})

	Tabs.Teleport:Section({
		Title = "Teleport",
	})




	local Selected_Location = Tabs.Teleport:Dropdown({
		Title = "Location",
		Values = Data.Locations,
		Multi = false,
		Default = Core.ProcessData("get", "selected_location") or "",

		Callback = function(val)
			Core.ProcessData("update", "selected_location", val)
		end,
	})

	Tabs.Teleport:Button({
		Title = "Teleport to location",
		Callback = function()
			pcall(function()
				local val = Core.ProcessData("get", "selected_location")
				local selected = world:FindFirstChild("spawns"):FindFirstChild("TpSpots"):FindFirstChild(val)

				Core.Teleport(selected.CFrame + Vector3.new(0, 2, 0))
			end)
		end,
	})

	Tabs.Teleport:Section({
		Title = "Teleport (XYZ)"
	})

	Tabs.Teleport:Input({
		Title = "X",
		Numeric = true,
		Value = Core.ProcessData("get", "teleport_coord").x,
		Placeholder = "0",
		Finished = false, -- Only calls callback when you press enter
		Callback = function(val)
			local coord = table.clone(Core.ProcessData("get", "teleport_coord"))
			coord.x = val

			Core.ProcessData("update", "teleport_coord", coord)
		end
	})

	Tabs.Teleport:Input({
		Title = "Y",
		Numeric = true,
		Value = Core.ProcessData("get", "teleport_coord").y,
		Placeholder = "0",
		Finished = false, -- Only calls callback when you press enter
		Callback = function(val)
			local coord = table.clone(Core.ProcessData("get", "teleport_coord"))
			coord.y = val

			Core.ProcessData("update", "teleport_coord", coord)
		end
	})

	Tabs.Teleport:Input({
		Title = "Z",
		Numeric = true,
		Value = Core.ProcessData("get", "teleport_coord").z,
		Placeholder = "0",
		Finished = false, -- Only calls callback when you press enter
		Callback = function(val)
			local coord = table.clone(Core.ProcessData("get", "teleport_coord"))
			coord.z = val

			Core.ProcessData("update", "teleport_coord", coord)
		end
	})

	Tabs.Teleport:Button({
		Title = "Teleport to coordinate",
		Callback = function()
			local coord = Core.ProcessData("get", "teleport_coord")

			Core.Teleport(CFrame.new(coord.x, coord.y, coord.z))
		end,
	})

	Tabs.Teleport:Section({
		Title = "Teleport to player",
	})

	local tp_player = Tabs.Teleport:Dropdown({
		Title = "Teleport Player",
		Values = {},
		Multi = false,

		Callback = function(val)
			pcall(function()
				if val ~= nil and game:GetService("Players"):FindFirstChild(val) then
					Core.ProcessData("update", "teleport_player", game:GetService("Players"):FindFirstChild(val))
				end
			end)
		end,
	})

	Tabs.Teleport:Button({
		Title = "Refresh player list",

		Callback = function()
			Core.SetupDropdownPlayers(tp_player)
		end,
	})

	Tabs.Teleport:Button({
		Title = "Teleport to player",
		Callback = function()
			pcall(function()
				local pt = Core.ProcessData("get", "teleport_player")

				for i,v in pairs(Data.Locations) do
					if pt.Character ~= nil then
						Core.Teleport(pt.Character.PrimaryPart.CFrame)
						break
					end

					local cframe = world:FindFirstChild("spawns"):FindFirstChild("TpSpots"):FindFirstChild(v).CFrame
					Core.Teleport(cframe)
					task.wait(0.1)
				end
			end)
		end,
	})

	Core.SetupDropdownPlayers(tp_player)

	Tabs.Teleport:Section({
		Title = "Rods",
		Content = "Rods"
	})

	for id, _ in pairs(Data.CustomLocations.Rods) do
		Tabs.Teleport:Button({
			Title = "Teleport to "..id,
			Callback = function()
				pcall(function()
					Core.TeleportCustom("Rods", id)
				end)
			end,
		})

	end

	Tabs.Teleport:Section({
		Title = "NPC",
		Content = "NPC"
	})

	for id, _ in pairs(Data.CustomLocations.NPC) do
		Tabs.Teleport:Button({
			Title = "Teleport to "..id.." npc",
			Callback = function()
				pcall(function()
					Core.TeleportCustom("NPC", id)
				end)
			end,
		})

	end


	Tabs.Player:Section({
		Title = "Character",
	})

	Tabs.Player:Slider({
		Title = "Walkspeed",
		Description = "Change speed of your player!",
		Value = {
			Min = 0,
			Max = 250,
			Default = Core.ProcessData("get", "walkspeed"),
		},
		Rounding = 1,
		Callback = function(val)
			Core.ProcessData("update", "walkspeed", val)
		end
	})

	Tabs.Shop:Input({
		Title = "Amount",
		Value = Core.ProcessData("get", "amount"),
		Placeholder = "0",
		Numeric = true, -- Only allows numbers
		Finished = false, -- Only calls callback when you press enter
		Callback = function(val)
			Core.ProcessData("update", "amount", tonumber(val))
		end
	})

	Tabs.Shop:Section({
		Title = "Merlin",
		Content = "Buy Relics & Luck"
	})

	Tabs.Shop:Button({
		Title = "Buy Relic (11,000C$)",
		Callback = function()
			local amount = Core.ProcessData("get", "amount")

			pcall(function()
				local Teleport = Core.ReserveTeleport({"NPC", "merlin"})
				local buy_event = workspace:WaitForChild("world"):WaitForChild("npcs"):WaitForChild("Merlin"):WaitForChild("Merlin"):WaitForChild("power")
				Core.KeyPress(Enum.KeyCode.E)
				for i = 1, amount do
					buy_event:InvokeServer()
				end
				task.wait()
				Teleport.Back()
			end)
		end,
	})

	Tabs.Shop:Button({
		Title = "Buy Luck (5,000C$)",
		Callback = function()
			local amount = Core.ProcessData("get", "amount")

			pcall(function()
				local Teleport = Core.ReserveTeleport({"NPC", "merlin"})
				task.wait(1)
				Core.KeyPress(Enum.KeyCode.E)
				for i = 1, amount do
					workspace:FindFirstChild("world"):FindFirstChild("npcs"):FindFirstChild("Merlin"):FindFirstChild("Merlin"):FindFirstChild("luck"):InvokeServer()
				end
				Teleport.Back()
			end)
		end,
	})

	Tabs.Shop:Section({
		Title = "Bait Crate",
		Content = "Buy Bait Crates"
	})

	Tabs.Shop:Button({
		Title = "Buy Bait Crate (120C$)",
		Callback = function()
			pcall(function()
				local Teleport = Core.ReserveTeleport({"Other", "baitcrate1"})
				local amount = Core.ProcessData("get", "amount")
				task.wait(1)
				Core.KeyPress(Enum.KeyCode.E)
				local bought = 0

				repeat
					Core.KeyPress(Enum.KeyCode.E)
					task.wait()
					local prompt = Core.Player.PlayerGui:FindFirstChild("over"):WaitForChild("prompt", 1)
					if prompt ~= nil then
						local buy = amount - bought
						if buy > 50 then
							buy = 50
						end
						prompt.amount.Text = buy
						GuiService.GuiNavigationEnabled = true
						GuiService.SelectedObject = prompt.confirm
						Core.KeyPress(Enum.KeyCode.Return)
						bought += buy
					end
				until bought >= amount
				GuiService.GuiNavigationEnabled = false
				Teleport.Back()
			end)
		end,
	})

	Tabs.Shop:Button({
		Title = "Buy Quality Bait Crate (525C$)",
		Callback = function()
			pcall(function()
				local Teleport = Core.ReserveTeleport({"Other", "baitcrate2"})
				local amount = Core.ProcessData("get", "amount")
				task.wait(1)
				local bought = 0
				Core.KeyPress(Enum.KeyCode.E)
				repeat
					Core.KeyPress(Enum.KeyCode.E)
					task.wait()
					local prompt = Core.Player.PlayerGui:FindFirstChild("over"):WaitForChild("prompt", 1)
					if prompt ~= nil then
						local buy = amount - bought
						if buy > 50 then
							buy = 50
						end
						prompt.amount.Text = buy
						GuiService.GuiNavigationEnabled = true
						GuiService.SelectedObject = prompt.confirm
						Core.KeyPress(Enum.KeyCode.Return)
						bought += buy
					end
				until bought >= amount
				GuiService.GuiNavigationEnabled = false
				Teleport.Back()
			end)
		end,
	})

	Tabs.Inventory:Section({
		Title = "Bait Crates",
		Content = "Auto open quality & basic bait crate (dont equip it before plz)"
	})

	Tabs.Inventory:Toggle({
		Title = "Super Fast",
		Value = Core.ProcessData("get", "superbaitcrate"),

		Callback = function(val)
			Core.ProcessData("update", "superbaitcrate", val)
		end,
	})

	Tabs.Inventory:Toggle({
		Title = "Auto open bait crate",
		Value = Core.ProcessData("get", "autobaitcrate"),

		Callback = function(val)
			Core.ProcessData("update", "autobaitcrate", val)

			if not game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Bait Crate") then
				return
			end

			local tool = game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Bait Crate")
			game:GetService("ReplicatedStorage"):WaitForChild("packages"):WaitForChild("Net"):WaitForChild("RE/Backpack/Equip"):FireServer(tool)
			while Core.ProcessData("get", "autobaitcrate") do
				task.wait(0.1)
				local boost = 1

				if Core.ProcessData("superbaitcrate") then
					boost = 5
				end

				for i = 1, 5 * boost do
					tool:Activate()
				end
			end
		end,
	})

	Tabs.Inventory:Toggle({
		Title = "Auto open quality bait crate",
		Value = Core.ProcessData("get", "autoqualitybaitcrate"),

		Callback = function(val)
			Core.ProcessData("update", "autoqualitybaitcrate", val)

			if not game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Quality Bait Crate") then
				return
			end

			local tool = game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Quality Bait Crate")
			game:GetService("ReplicatedStorage"):WaitForChild("packages"):WaitForChild("Net"):WaitForChild("RE/Backpack/Equip"):FireServer(tool)
			while Core.ProcessData("get", "autoqualitybaitcrate") do
				task.wait(0.1)
				local boost = 1

				if Core.ProcessData("superbaitcrate") then
					boost = 5
				end

				for i = 1, 5 * boost do
					tool:Activate()
				end
			end
		end,
	})

	Tabs.Inventory:Section({
		Title = "Enchant",
		Content = "Auto enchant fish/item until some mutation"
	})



	Tabs.Inventory:Input({
		Title = "Fish / Item name",
		Value = Core.ProcessData("get", "enchantfishname"),
		Placeholder = "Any fish name",
		Numeric = false, -- Only allows numbers
		Finished = false, -- Only calls callback when you press enter
		Callback = function(val)
			Core.ProcessData("update", "enchantfishname", val)
		end
	})

	Tabs.Inventory:Section({
		Title = "Enchant Settings"
	})

	Tabs.Inventory:Dropdown({
		Title = "Mutations",
		Values = Data.Mutations,
		Multi = true,
		AllowNone = true,
		Value = Core.ProcessData("get", "mutations_allowed"),

		Callback = function(val)
			Core.ProcessData("update", "mutations_allowed", val)
		end,
	})

	Tabs.Inventory:Toggle({
		Title = "Ignore Favourited",
		Value = Core.ProcessData("get", "ignore_fav"),

		Callback = function(val)
			Core.ProcessData("update", "ignore_fav", val)
		end,
	})

	Tabs.Inventory:Toggle({
		Title = "Ignore Mutated",
		Value = Core.ProcessData("get", "ignore_mutated"),

		Callback = function(val)
			Core.ProcessData("update", "ignore_mutated", val)
		end,
	})

	Tabs.Inventory:Toggle({
		Title = "Ignore Sparkling",
		Value = Core.ProcessData("get", "ignore_sparkling"),

		Callback = function(val)
			Core.ProcessData("update", "ignore_sparkling", val)
		end,
	})

	Tabs.Inventory:Section({
		Title = "Auto Enchant"
	})




	Tabs.Inventory:Toggle({
		Title = "Auto Enchant",
		Value = Core.ProcessData("get", "autoenchant"),

		Callback = function(val)
			Core.ProcessData("update", "autoenchant", val)
			local fishname = Core.ProcessData("get", "enchantfishname")

			local function notify(enc)
				WindUI:Notify({
					Title = "Auto Enchant",
					Content = string.format("Enchanted %s to %s", fishname, enc),
					Duration = 45
				})
			end

			for i,v in pairs(Core.Connections.Enchant) do
				v:Disconnect()
				Core.Connections.Enchant[i] = nil
			end

			if val then
				local function auth(v)
					if v == nil or not v:FindFirstChild("Stack") then
						return
					end
					local old_val = v.Stack.Value
					Core.Connections.Enchant[v.Name] = v.Stack.Changed:Connect(function(val)
						if val > old_val then
							if v:FindFirstChild("Mutation") then
								notify(v.Mutation.Value)
							end
						end
						old_val = val
					end)
				end
				Core.Connections.Enchant["sigma"] = Core.PlayerStats:WaitForChild("Inventory").ChildAdded:Connect(function(ch)
					if ch:FindFirstChild("Mutation") then
						auth(ch)
						notify(ch.Mutation.Value)
					end
				end)

				for i,v in pairs(Core.PlayerStats:WaitForChild("Inventory"):GetChildren()) do
					if math.random(1, 20) == 1 then
						task.wait(0.01)
					end
					if v.Name:find(fishname) then
						auth(v)
					end
				end

			end

			while Core.ProcessData("get", "autoenchant") == true do
				local s,e = pcall(function()
					task.wait()

					local got_fish = false
					local new_fish = nil
					Core.TeleportCustom("NPC", "appraiser")
					repeat
						Core.KeyPress(Enum.KeyCode.E)
						task.wait()
						local fish = nil

						local function reserve()
							spawn(function()
								if fish ~= nil then
									if fish.Parent == Core.Player.Character then
										local t = 0
										repeat
											Core.Equip(fish)
											task.wait()
										until fish.Parent == Core.Player.Backpack
									end 

									fish.Parent = Core.Cache
									task.wait(0.2)
									fish.Parent = Core.Player.Backpack
								end
							end)
						end

						if Core.Character:FindFirstChildOfClass("Tool") then
							if Core.Character:FindFirstChildOfClass("Tool").Name == fishname then
								fish = Core.Character:FindFirstChildOfClass("Tool")
							end
						end
						if fish == nil then
							if Core.Player.Backpack:FindFirstChild(fishname) then
								fish = Core.Player.Backpack:FindFirstChild(fishname)
							end
						end

						if fish == nil then
							task.wait(2)
							WindUI:Notify({
								Title = "Auto Enchant",
								Content = "Cant find "..fishname,
								Duration = 3
							})
						elseif fish ~= nil then
							local link = fish.link.Value
							local skip = false
							if link:FindFirstChild("Mutation") and Core.ProcessData("get", "ignore_mutated") then
								skip = true
							end

							if link:FindFirstChild("Favourited") and Core.ProcessData("get", "ignore_fav") then
								skip = true
							end

							if link:FindFirstChild("Sparkling") and Core.ProcessData("get", "ignore_sparkling") then
								skip = true
							end

							if skip then
								reserve()
							end

							if not skip	then
								got_fish = true
								new_fish = fish
							end

						end
					until got_fish == true or Core.ProcessData("get", "autoenchant") == false

					if got_fish and new_fish ~= nil then
						task.wait()
						if new_fish.Parent == Core.Player.Backpack then
							repeat
								Core.Equip(new_fish)
								task.wait()
							until new_fish.Parent == Core.Character

							--workspace:WaitForChild("world"):WaitForChild("npcs"):WaitForChild("Appraiser"):WaitForChild("appraiser"):WaitForChild("appraise"):InvokeServer()
						end
						workspace:WaitForChild("world"):WaitForChild("npcs"):WaitForChild("Appraiser"):WaitForChild("appraiser"):WaitForChild("appraise"):InvokeServer()
					end
				end)
			end
		end,
	})



	Tabs.Sell:Input({
		Title = "Fish name",
		Value = Core.ProcessData("get", "sellfishname"),
		Placeholder = "Any fish name",
		Numeric = false, -- Only allows numbers
		Finished = false, -- Only calls callback when you press enter
		Callback = function(val)
			Core.ProcessData("update", "sellfishname", val)
		end
	})

	Tabs.Sell:Toggle({
		Title = "Auto sell",
		Value = false,

		Callback = function(val)
			Core.ProcessData("update", "autosell", val)

			while Core.ProcessData("get", "autosell") do
				local fish1 = nil
				task.wait()
				spawn(function()
					pcall(function()
						local fish1 = Core.Player.Backpack:FindFirstChild(Core.ProcessData("get", "sellfishname"))
						local fish2 = Core.Player.Character:FindFirstChildOfClass("Tool")

						if fish2 ~= nil and fish2.Name == Core.ProcessData("get", "sellfishname") then
							fish1 = fish2
							game:GetService("ReplicatedStorage"):WaitForChild("packages"):WaitForChild("Net"):WaitForChild("RE/Backpack/Equip"):FireServer(fish1)
						end
						task.wait()
						if fish1 ~= nil then
							game:GetService("ReplicatedStorage"):WaitForChild("packages"):WaitForChild("Net"):WaitForChild("RE/Backpack/Equip"):FireServer(fish1)
							task.wait()
							if fish1:FindFirstChild("link") and fish1:FindFirstChild("link").Value ~= nil and fish1:FindFirstChild("link").Value:FindFirstChild("Stack") then
								for i = 1, fish1.link.Value.Stack.Value do
									game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("Sell"):InvokeServer()
								end
							end
						end
					end)
				end)
			end
		end,
	})




	local InventoryOptimization = Tabs.Optimization:Toggle({
		Title = "Enable inventory optimization",
		Default = Core.ProcessData("get", "optimization"),
		Callback = function(val)
			Core.ProcessData("update", "optimization", val)
		end,
	})

	Tabs.Optimization:Toggle({
		Title = "Remove Notifications",
		Default = Core.ProcessData("get", "remove_notification"),
		Callback = function(val)
			Core.ProcessData("update", "remove_notification", val)
		end,
	})

	spawn(function()
		while task.wait() do
			pcall(function()
				Core.KeyPress(Enum.KeyCode.Unknown)
			end)
		end
	end)

	spawn(function()
		workspace.CurrentCamera:GetPropertyChangedSignal("FieldOfView"):Connect(function()
			if Core.ProcessData("get", "custom_fov") == true then
				workspace.CurrentCamera.FieldOfView = Core.ProcessData("get", "camera_fov")
			end
		end)

		while task.wait() do
			pcall(function()
				Core.Player.Character.Humanoid.WalkSpeed = Core.ProcessData("get", "walkspeed")
			end)

			pcall(function()
				if Core.ProcessData("get", "custom_fov") == true then
					workspace.CurrentCamera.FieldOfView = Core.ProcessData("get", "camera_fov")
				end
			end)

			local c = 0

			local suc, err = pcall(function()
				if Core.ProcessData("get", "customambient") == true then
					local color = Core.ProcessData("get", "ambient_color")

					game:GetService("Lighting").ColorShift_Top = color
					game:GetService("Lighting").ColorShift_Bottom = color
					game:GetService("Lighting").Ambient = color
				end
			end)

			if not suc and c < 5 then
				c += 1
				warn(err)
			end

			pcall(function()
				if Core.Connections.UI["notf"] then
					Core.Connections.UI["notf"]:Disconnect()
				end

				Core.Connections.UI["notf"] = Core.Player.PlayerGui:WaitForChild("hud"):WaitForChild("safezone"):WaitForChild("announcements").ChildAdded:Connect(function(child)
					if child:IsA("Frame") and Core.ProcessData("get", "remove_notification") == true then
						child:Destroy()
					end
				end)
			end)

			local enabled = Core.ProcessData("get", "optimization")
			game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, enabled)
			game.Players.LocalPlayer.PlayerGui.hud.safezone.backpack.Visible = not enabled
		end
	end)

	spawn(function()
		while task.wait() do
			local status = -1

			if Core.Character:FindFirstChildOfClass("Tool") and Core.Character:FindFirstChildOfClass("Tool").Name:find("Rod") then
				status = 0
			end

			if Core.Player.PlayerGui:FindFirstChild("shakeui") then
				status = 1
			end

			if Core.Player.PlayerGui:FindFirstChild("reel") then
				status = 2
			end

			if Core.ProcessData("gettable", "AutoFarm", "EnabledAutoFarm") then
				local suc, err = pcall(function()
					if Core.ProcessData("gettable", "AutoFarm", "AnchorPlayer") then
						Core.Character.PrimaryPart.Anchored = true
					end
					if status == -1 and Core.ProcessData("gettable", "AutoFarm", "AutoEquip") then
						local rods, rod = Core.PlayerStats.Rods:GetChildren(), nil
						local tool = Core.Player.Character:FindFirstChildOfClass("Tool")

						for i,v in pairs(rods) do
							if Core.Player.Backpack:FindFirstChild(v.Name) then
								rod = Core.Player.Backpack:FindFirstChild(v.Name)
							end
						end

						if rod == nil then
							if tool.Name:find("Rod") then
								rod = tool
							else
								Core.Notify("Can't find any rod.")
								task.wait(1)
							end
						end

						if rod ~= nil and rod.Parent ~= Core.Character then
							Core.Equip(rod)
							repeat
								task.wait()
							until rod.Parent == Core.Character
						end
					elseif status == 0 and Core.ProcessData("gettable", "AutoFarm", "AutoCast") then
						local rod = Core.Character:FindFirstChildOfClass("Tool")

						if rod ~= nil and rod.Name:find("Rod") and rod:WaitForChild("values"):WaitForChild("casted").Value == false then
							rod:WaitForChild("events"):WaitForChild("cast"):FireServer(100, 1)
						end
					elseif status == 1 then
						local shakebutton = Core.Player.PlayerGui:WaitForChild("shakeui", 1):WaitForChild("safezone", 1):WaitForChild("button", 1)

						if shakebutton ~= nil then
							if Core.ProcessData("gettable", "AutoFarm", "LockShake") then
								shakebutton.Position = UDim2.fromScale(0.5, 0.5)
								shakebutton.AnchorPoint = Vector2.new(0.5, 0.5)
							end

							if Core.ProcessData("gettable", "AutoFarm", "AutoShake") then
								GuiService.GuiNavigationEnabled = true
								GuiService.SelectedObject = shakebutton

								Core.KeyPress(Enum.KeyCode.Return)
							end
						end
					elseif status == 2 and Core.ProcessData("gettable", "AutoFarm", "AutoReel") then
						GuiService.GuiNavigationEnabled = false

						local rods, rod = Core.PlayerStats.Rods:GetChildren(), nil
						local tool = Core.Player.Character:FindFirstChildOfClass("Tool")

						for i,v in pairs(rods) do
							if Core.Player.Backpack:FindFirstChild(v.Name) then
								rod = Core.Player.Backpack:FindFirstChild(v.Name)
								break
							end
						end

						if rod == nil then
							rod = tool
						end



						for i = 1, 5 do
							task.wait(0.05)
							rod:WaitForChild("events"):WaitForChild("reset"):FireServer()
							game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("reelfinished"):FireServer(100, false)
						end
					end
				end)

				if not suc then
					warn(err)
				end
			end
		end
	end)

	Core.Character.ChildAdded:Connect(function(child)
		if child:IsA("Tool") and Core.ProcessData("get", "auto_trade") then
			local pt = Core.ProcessData("get", "trade_player")

			pcall(function()
				child.offer:FireServer(pt)
			end)

			while Core.ProcessData("get", "auto_trade") == true and Core.ProcessData("get", "multi_trade") do
				task.wait()
				pcall(function()
					child.offer:FireServer(pt)
				end)
			end
		end
	end)

	game:GetService("ReplicatedStorage").events.offeritem.OnClientInvoke = function()
		if Core.ProcessData("get", "auto_accept_trade") == true then
			return true
		end

		task.wait(0.1)

		while Core.ProcessData("get", "auto_accept_trade") == false do
			task.wait()
		end

		if Core.ProcessData("get", "auto_accept_trade") then
			return true
		end
	end


end

spawn(build)
